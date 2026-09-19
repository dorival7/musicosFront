<template>
  <div class="sr-wrap">
    <template v-if="!repertorioAtivo">
      <div class="sr-top">
        <div><h5>🎵 Seven Repertório</h5><p>Crie repertórios e salve cada cifra exatamente no tom que será usado no show.</p></div>
        <button class="btn-primary-action" @click="abrirModalCriar">+ Criar Repertório</button>
      </div>

      <div class="sr-grid">
        <button v-for="r in repertorios" :key="r.id" class="rep-card" @click="abrir(r.id)">
          <strong>{{ r.nome }}</strong><span>{{ r.quantidadeMusicas }} música(s)</span><small v-if="r.descricao">{{ r.descricao }}</small>
        </button>
        <div v-if="!carregando && !repertorios.length" class="empty">Você ainda não possui repertórios. Clique em <b>+ Criar Repertório</b>.</div>
      </div>
    </template>

    <template v-else>
      <div class="editor-head">
        <button class="btn-light" @click="fechar">← Meus Repertórios</button>
        <div class="editor-context">
          <div class="context-label">REPERTÓRIO ATUAL</div>
          <h4>🎵 {{ repertorioAtivo.nome }}</h4>
          <p v-if="repertorioAtivo.descricao">{{ repertorioAtivo.descricao }}</p>
          <span>{{ musicas.length }} música(s)</span>
        </div>
        <div class="editor-actions">
          <button class="btn-light" @click="abrirModalEditar">✏️ Editar</button>
          <button class="btn-pdf" :disabled="!musicas.length" @click="exportarRepertorioPdf">📄 Exportar PDF</button>
          <button class="btn-danger-soft" @click="removerRepertorio">Excluir</button>
        </div>
      </div>

      <div class="search-box">
        <h6>Adicionar música</h6>
        <div class="search-row">
          <input v-model="busca.nomeMusica" placeholder="Nome da música" @keyup.enter="buscarCifra" />
          <input v-model="busca.nomeArtista" placeholder="Artista (opcional)" @keyup.enter="buscarCifra" />
          <button class="btn-primary-action" :disabled="buscando" @click="buscarCifra">{{ buscando ? 'Buscando...' : 'Buscar cifra' }}</button>
        </div>
      </div>

      <div v-if="cifra" class="cifra-card">
        <div class="cifra-head">
          <div><h5>{{ cifra.musica }}</h5><span>{{ cifra.artista }}</span></div>
          <div class="cifra-actions-top">
            <div class="tone">TOM: {{ tomAtual }}</div>
            <button class="btn-primary-action" :disabled="salvando" @click="salvarNoRepertorio">{{ salvando ? 'Salvando...' : '+ Adicionar ao Repertório' }}</button>
          </div>
        </div>
        <div class="tons">
          <button v-for="tom in tons" :key="tom" :class="{ ativo: tom === tomAtual }" @click="transpor(tom)">{{ tom }}</button>
        </div>
        <pre>{{ cifra.cifraCompleta }}</pre>
      </div>

      <div class="songs">
        <div class="songs-title"><h6>Músicas do repertório</h6><span>A ordem abaixo será a ordem do Palco 7 e do PDF.</span></div>
        <div v-for="(m, i) in musicas" :key="m.id" class="song-row">
          <div class="order">{{ i + 1 }}</div>
          <div class="song-info"><strong>{{ m.musica }}</strong><span>{{ m.artista }}</span></div>
          <div class="song-tone">{{ m.tomEscolhido }}</div>
          <div class="song-actions">
            <button :disabled="i === 0" @click="mover(i, -1)">↑</button><button :disabled="i === musicas.length - 1" @click="mover(i, 1)">↓</button><button class="trash" @click="removerMusica(m)">×</button>
          </div>
        </div>
        <div v-if="!musicas.length" class="empty small-empty">Pesquise uma cifra acima e adicione a primeira música.</div>
      </div>
    </template>

    <div v-if="modalRepertorio.aberto" class="modal-backdrop-custom" @mousedown.self="fecharModal">
      <div class="rep-modal" role="dialog" aria-modal="true" :aria-label="modalRepertorio.modo === 'editar' ? 'Editar repertório' : 'Criar novo repertório'">
        <div class="modal-head">
          <div><span class="modal-kicker">SEVEN REPERTÓRIO</span><h5>{{ modalRepertorio.modo === 'editar' ? 'Editar repertório' : 'Criar novo repertório' }}</h5></div>
          <button class="modal-close" type="button" @click="fecharModal">×</button>
        </div>
        <form @submit.prevent="salvarModalRepertorio">
          <label>Nome do repertório <b>*</b></label>
          <input ref="nomeRepertorioInput" v-model="modalRepertorio.nome" maxlength="120" placeholder="Ex.: Show de sábado" @keydown.esc.prevent="fecharModal" />
          <label>Descrição <span>(opcional)</span></label>
          <textarea v-model="modalRepertorio.descricao" maxlength="500" rows="3" placeholder="Ex.: Repertório sertanejo para o show de sábado" @keydown.esc.prevent="fecharModal"></textarea>
          <div class="modal-actions">
            <button type="button" class="btn-light" @click="fecharModal">Cancelar</button>
            <button type="submit" class="btn-primary-action" :disabled="modalRepertorio.salvando || !modalRepertorio.nome.trim()">{{ modalRepertorio.salvando ? 'Salvando...' : (modalRepertorio.modo === 'editar' ? 'Salvar alterações' : 'Criar Repertório') }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { listarRepertorios, obterRepertorio, criarRepertorio, atualizarRepertorio, excluirRepertorio, adicionarMusica, excluirMusica, reordenarMusicas } from "./services/repertoriosService";

export default {
  name: "SevenRepertorio",
  data() { return { repertorios: [], repertorioAtivo: null, musicas: [], carregando: false, buscando: false, salvando: false, cifra: null, tomAtual: "", tomOriginalBusca: "", busca: { nomeMusica: "", nomeArtista: "" }, modalRepertorio: { aberto: false, modo: "criar", nome: "", descricao: "", salvando: false }, tons: ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"] }; },
  mounted() { this.carregar(); },
  methods: {
    base() { return (process.env.VUE_APP_API_BASE_URL || "http://localhost:5297").replace(/\/$/, ""); },
    config() { const token = localStorage.getItem("jwt"); return { headers: { Authorization: `Bearer ${String(token || "").replace(/^Bearer\s+/i, "")}`, "Content-Type": "application/json" } }; },
    async carregar() { this.carregando = true; try { this.repertorios = await listarRepertorios(); } catch (e) { this.erro(e); } finally { this.carregando = false; } },
    abrirModalCriar() { this.modalRepertorio = { aberto: true, modo: "criar", nome: "", descricao: "", salvando: false }; this.$nextTick(() => this.$refs.nomeRepertorioInput?.focus()); },
    abrirModalEditar() { this.modalRepertorio = { aberto: true, modo: "editar", nome: this.repertorioAtivo?.nome || "", descricao: this.repertorioAtivo?.descricao || "", salvando: false }; this.$nextTick(() => this.$refs.nomeRepertorioInput?.focus()); },
    fecharModal() { if (this.modalRepertorio.salvando) return; this.modalRepertorio.aberto = false; },
    async salvarModalRepertorio() {
      const nome = this.modalRepertorio.nome.trim();
      if (!nome) return;
      this.modalRepertorio.salvando = true;
      try {
        const payload = { nome, descricao: this.modalRepertorio.descricao.trim() || null };
        if (this.modalRepertorio.modo === "editar") {
          await atualizarRepertorio(this.repertorioAtivo.id, payload);
          await this.abrir(this.repertorioAtivo.id);
          await this.carregar();
        } else {
          const novo = await criarRepertorio(payload);
          await this.carregar();
          await this.abrir(novo.id);
        }
        this.modalRepertorio.aberto = false;
      } catch (e) { this.erro(e); } finally { this.modalRepertorio.salvando = false; }
    },
    async abrir(id) { try { const r = await obterRepertorio(id); this.repertorioAtivo = r; this.musicas = r.musicas || []; this.cifra = null; } catch (e) { this.erro(e); } },
    fechar() { this.repertorioAtivo = null; this.musicas = []; this.cifra = null; this.carregar(); },
    async removerRepertorio() { if (!confirm(`Excluir o repertório "${this.repertorioAtivo.nome}"?`)) return; try { await excluirRepertorio(this.repertorioAtivo.id); this.fechar(); } catch (e) { this.erro(e); } },
    async buscarCifra() { if (!this.busca.nomeMusica.trim()) return alert("Informe o nome da música."); this.buscando = true; this.cifra = null; try { const r = await axios.post(`${this.base()}/artists/ia/generate-cifra`, { nomeMusica: this.busca.nomeMusica, nomeArtista: this.busca.nomeArtista }, this.config()); this.cifra = r.data; this.tomAtual = r.data.tomOriginal || ""; this.tomOriginalBusca = r.data.tomOriginal || ""; } catch (e) { this.erro(e); } finally { this.buscando = false; } },
    async transpor(tom) { if (!this.cifra || !this.cifra.htmlEstruturado || tom === this.tomAtual) return; this.buscando = true; try { const html = this.cifra.htmlEstruturado.replace(/\sdata-chord-(index|scope-id|original-text)="[^"]*"/g, ""); const r = await axios.post(`${this.base()}/artists/ia/transpose-cifra`, { htmlEstruturado: html, tomOriginal: this.tomAtual, tomDesejado: tom }, this.config()); this.cifra.cifraCompleta = r.data.cifraTransposta; if (r.data.htmlEstruturado) this.cifra.htmlEstruturado = r.data.htmlEstruturado; this.tomAtual = tom; } catch (e) { this.erro(e); } finally { this.buscando = false; } },
    async salvarNoRepertorio() { if (!this.cifra) return; this.salvando = true; try { await adicionarMusica(this.repertorioAtivo.id, { musica: this.cifra.musica, artista: this.cifra.artista, tomOriginal: this.tomOriginalBusca || this.cifra.tomOriginal || this.tomAtual, tomEscolhido: this.tomAtual, cifraCompleta: this.cifra.cifraCompleta, htmlEstruturado: this.cifra.htmlEstruturado }); await this.abrir(this.repertorioAtivo.id); this.busca = { nomeMusica: "", nomeArtista: "" }; } catch (e) { this.erro(e); } finally { this.salvando = false; } },
    async removerMusica(m) { if (!confirm(`Remover "${m.musica}" deste repertório?`)) return; try { await excluirMusica(this.repertorioAtivo.id, m.id); await this.abrir(this.repertorioAtivo.id); } catch (e) { this.erro(e); } },
    exportarRepertorioPdf() {
      if (!this.repertorioAtivo || !this.musicas.length) return alert("Adicione músicas ao repertório antes de exportar.");

      const esc = v => String(v ?? "").replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#039;");
      const nome = esc(this.repertorioAtivo.nome || "Repertório");
      const descricao = esc(this.repertorioAtivo.descricao || "");

      const indice = this.musicas.map((m,i) => `<div class="indice-item"><span class="indice-num">${String(i+1).padStart(2,"0")}</span><div><strong>${esc(m.musica)}</strong><small>${esc(m.artista)} · Tom ${esc(m.tomEscolhido || m.tomOriginal || "-")}</small></div></div>`).join("");

      // A cifra é enviada integralmente para a página. O ajuste de 1/2 colunas é
      // feito depois que o navegador conhece a altura REAL disponível no A4.
      const paginas = this.musicas.map((m,i) => `<section class="musica"><header><div><div class="numero">${String(i+1).padStart(2,"0")}</div><h1>${esc(m.musica)}</h1><p>Cantor: <strong>${esc(m.artista)}</strong></p></div><div class="tom">TOM: ${esc(m.tomEscolhido || m.tomOriginal || "-")}</div></header><div class="cifra-area"><pre class="cifra-source">${esc(String(m.cifraCompleta ?? "").replace(/\r\n/g,"\n"))}</pre></div></section>`).join("");

      const janela = window.open("","_blank","width=1100,height=850");
      if (!janela) return alert("O navegador bloqueou a pré-visualização. Permita pop-ups para o Seven Shows.");
      janela.document.open();
      janela.document.write(`<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><title>${nome} - Seven Shows</title><style>
@page{size:A4 portrait;margin:0}*{box-sizing:border-box}html,body{margin:0;padding:0;background:#eef1f5;color:#15171a;font-family:Arial,Helvetica,sans-serif}.toolbar{position:sticky;top:0;z-index:10;display:flex;justify-content:center;gap:10px;padding:12px;background:#20242a;box-shadow:0 2px 10px #0003}.toolbar button{border:0;border-radius:7px;padding:10px 18px;font-weight:800;cursor:pointer}.print{background:#198754;color:#fff}.close{background:#fff;color:#333}.sheet,.musica{width:210mm;height:297mm;margin:18px auto;background:#fff;padding:14mm 13mm 12mm;box-shadow:0 4px 22px #0002;overflow:hidden}.capa{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center}.brand{font-size:16px;font-weight:900;letter-spacing:3px;color:#ff6c22}.capa h1{font-size:34px;margin:22px 0 8px;text-transform:uppercase}.capa p{color:#667085}.count{margin-top:28px;border:1px solid #d9dde4;border-radius:20px;padding:8px 16px;font-weight:800}.indice h1{margin:0 0 6px;font-size:25px}.indice>p{margin:0 0 25px;color:#667085}.indice-item{display:flex;gap:14px;padding:11px 0;border-bottom:1px solid #eceff3}.indice-num{font:800 12px "Courier New",monospace;color:#ff6c22;padding-top:2px}.indice-item div{display:flex;flex-direction:column}.indice-item strong{font-size:12px}.indice-item small{font-size:9px;color:#667085;margin-top:3px}.musica{display:flex;flex-direction:column;page-break-before:always;break-before:page}.musica header{flex:0 0 auto;display:flex;justify-content:space-between;gap:18px;align-items:flex-start;padding-bottom:7px;margin-bottom:8px;border-bottom:1px solid #cfd4d8}.musica h1{font-size:16px;margin:2px 0 3px;text-transform:uppercase}.musica p{font-size:9px;margin:0;color:#444}.numero{font:800 9px "Courier New",monospace;color:#ff6c22}.tom{border:1px solid #333;border-radius:4px;padding:5px 9px;font:700 10px "Courier New",monospace;white-space:nowrap}.cifra-area{flex:1 1 auto;min-height:0;overflow:hidden}.musica pre{margin:0;padding:0;white-space:pre;overflow:visible;font-family:"Courier New",Courier,monospace;font-size:8.5pt;font-weight:400;line-height:1.03;tab-size:4;color:#000}.cifra-duas{height:100%;display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:6mm;align-items:start}.cifra-duas pre{min-width:0}.layout-info{position:absolute;left:-99999px}
@media print{html,body{background:#fff}.toolbar{display:none!important}.sheet,.musica{margin:0!important;box-shadow:none!important;width:210mm!important;height:297mm!important;page-break-after:always;break-after:page}.sheet:last-child,.musica:last-child{page-break-after:auto}.musica{page-break-before:auto;break-before:auto}}
</style></head><body><div class="toolbar"><button class="print" onclick="window.print()">🖨 Imprimir / Salvar PDF</button><button class="close" onclick="window.close()">Fechar</button></div><section class="sheet capa"><div class="brand">SEVEN SHOWS</div><h1>${nome}</h1>${descricao?`<p>${descricao}</p>`:""}<div class="count">${this.musicas.length} música(s)</div></section><section class="sheet indice"><h1>Índice</h1><p>${nome}</p>${indice}</section>${paginas}<script>
(function(){
  function melhorCorte(linhas){
    var meio=Math.ceil(linhas.length/2), corte=meio, dist=999999;
    for(var i=Math.max(1,meio-10);i<=Math.min(linhas.length-1,meio+10);i++){
      if(linhas[i].trim()==="" && Math.abs(i-meio)<dist){corte=i+1;dist=Math.abs(i-meio);}
    }
    return corte;
  }
  function cabe(area, pres){
    return pres.every(function(pre){return pre.scrollHeight<=area.clientHeight+1 && pre.scrollWidth<=pre.clientWidth+1;});
  }
  function ajustar(sec){
    var area=sec.querySelector('.cifra-area');
    var original=sec.querySelector('.cifra-source');
    var texto=original.textContent.replace(/\\r\\n/g,'\\n');
    var linhas=texto.split('\\n');
    var tamanhos=[8.5,8,7.5,7,6.5];

    // 1) tenta uma coluna, medindo a folha A4 real.
    for(var a=0;a<tamanhos.length;a++){
      original.style.fontSize=tamanhos[a]+'pt';
      if(cabe(area,[original])) return;
    }

    // 2) se não couber, divide somente ENTRE linhas completas.
    var corte=melhorCorte(linhas);
    area.innerHTML='<div class="cifra-duas"><pre></pre><pre></pre></div>';
    var pres=area.querySelectorAll('pre');
    pres[0].textContent=linhas.slice(0,corte).join('\\n');
    pres[1].textContent=linhas.slice(corte).join('\\n');
    for(var b=0;b<tamanhos.length;b++){
      pres[0].style.fontSize=tamanhos[b]+'pt';
      pres[1].style.fontSize=tamanhos[b]+'pt';
      if(cabe(area,[pres[0],pres[1]])) return;
    }

    // 3) último ajuste: mantém duas colunas e usa o menor tamanho legível.
    pres[0].style.fontSize='6.5pt'; pres[1].style.fontSize='6.5pt';
  }
  function executar(){document.querySelectorAll('.musica').forEach(ajustar);}
  if(document.fonts && document.fonts.ready){document.fonts.ready.then(executar);}else{setTimeout(executar,50);}
})();
${"<" + "/script>"}</body></html>`);
      janela.document.close();
    },
    async mover(index, delta) { const destino = index + delta; if (destino < 0 || destino >= this.musicas.length) return; const copia = [...this.musicas]; [copia[index], copia[destino]] = [copia[destino], copia[index]]; this.musicas = copia; try { await reordenarMusicas(this.repertorioAtivo.id, copia.map(x => x.id)); } catch (e) { this.erro(e); await this.abrir(this.repertorioAtivo.id); } },
    erro(e) { console.error(e); alert(e.response?.data?.message || e.response?.data?.mensagem || e.message || "Ocorreu um erro."); }
  }
};
</script>

<style scoped>
.sr-wrap{font-family:monospace;color:#263238}.sr-top,.cifra-head,.songs-title{display:flex;align-items:center;justify-content:space-between;gap:16px}.sr-top{background:#fff;border:1px solid #e5e7eb;border-radius:14px;padding:20px;margin-bottom:18px}.sr-top h5,.cifra-head h5{margin:0;font-weight:800}.sr-top p{margin:5px 0 0;color:#7a8290}.btn-primary-action{border:0;border-radius:8px;background:#4f46e5;color:#fff;font-weight:800;padding:11px 18px;transition:.18s}.btn-primary-action:hover:not(:disabled){background:#4338ca;transform:translateY(-1px)}.btn-primary-action:disabled{opacity:.55;cursor:not-allowed}.sr-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:14px}.rep-card{background:#fff;border:1px solid #e3e6ec;border-radius:12px;padding:18px;text-align:left;display:flex;flex-direction:column;gap:7px;transition:.18s}.rep-card:hover{border-color:#6366f1;box-shadow:0 5px 15px rgba(79,70,229,.08);transform:translateY(-1px)}.rep-card strong{font-size:15px}.rep-card span{color:#4f46e5;font-weight:800}.rep-card small{color:#7a8290}.empty{grid-column:1/-1;background:#fff;border:1px dashed #cfd5df;border-radius:12px;padding:35px;text-align:center;color:#7a8290}.editor-head{display:grid;grid-template-columns:minmax(145px,1fr) minmax(260px,2fr) minmax(320px,1fr);align-items:center;gap:18px;background:#fff;border:1px solid #e3e6ec;border-radius:14px;padding:16px 18px;margin-bottom:16px}.editor-context{text-align:center}.editor-context .context-label{font-size:10px;font-weight:900;letter-spacing:1px;color:#6366f1;margin-bottom:4px}.editor-context h4{margin:0;font-size:20px;font-weight:900}.editor-context p{margin:5px 0 2px;color:#667085;font-size:12px}.editor-context span{color:#7a8290;font-size:12px}.editor-actions{display:flex;justify-content:flex-end;gap:8px;align-items:center}.btn-pdf{border:1px solid #198754;background:#198754;color:#fff;border-radius:8px;padding:9px 12px;font-weight:800}.btn-pdf:disabled{opacity:.45;cursor:not-allowed}.btn-light,.btn-danger-soft{border:1px solid #dfe3e8;background:#fff;border-radius:8px;padding:9px 12px;font-weight:700}.btn-light:hover{background:#f8f9fc}.btn-danger-soft{color:#c0392b}.btn-danger-soft:hover{background:#fff5f4;border-color:#f2c6c1}.search-box,.cifra-card,.songs{background:#fff;border:1px solid #e3e6ec;border-radius:12px;padding:18px;margin-bottom:16px}.search-box h6,.songs-title h6{margin:0 0 10px}.search-row{display:grid;grid-template-columns:1fr 1fr auto;gap:10px}.search-row input{border:1px solid #d9dee7;border-radius:8px;padding:10px 12px}.cifra-actions-top{display:flex;align-items:center;gap:10px}.tone,.song-tone{background:#edf8ef;color:#198754;border-radius:7px;padding:7px 10px;font-weight:900}.tons{display:flex;flex-wrap:wrap;gap:6px;margin:14px 0}.tons button{border:1px solid #dfe3e8;background:#fff;border-radius:6px;padding:6px 9px}.tons button.ativo{background:#198754;color:#fff;border-color:#198754}.cifra-card pre{white-space:pre;overflow:auto;font-family:"Courier New",monospace;font-size:14px;line-height:1.25;background:#fafafa;border-radius:8px;padding:16px}.songs-title{margin-bottom:12px}.songs-title span{font-size:11px;color:#7a8290}.song-row{display:grid;grid-template-columns:44px 1fr 70px auto;align-items:center;gap:10px;border-top:1px solid #eef0f3;padding:11px 4px}.order{font-weight:900;color:#8a919d}.song-info{display:flex;flex-direction:column}.song-info span{font-size:11px;color:#7a8290}.song-actions{display:flex;gap:5px}.song-actions button{border:1px solid #dfe3e8;background:#fff;border-radius:6px;min-width:32px;height:32px}.song-actions button:hover:not(:disabled){background:#f8f9fc}.song-actions .trash{color:#c0392b}.song-actions .trash:hover{background:#fff5f4}.small-empty{padding:22px}.modal-backdrop-custom{position:fixed;inset:0;z-index:10550;background:rgba(15,23,42,.56);display:flex;align-items:center;justify-content:center;padding:20px}.rep-modal{width:min(520px,100%);background:#fff;border-radius:16px;box-shadow:0 24px 70px rgba(15,23,42,.25);padding:22px}.modal-head{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:18px}.modal-head h5{margin:3px 0 0;font-weight:900}.modal-kicker{font-size:10px;color:#6366f1;font-weight:900;letter-spacing:1px}.modal-close{border:0;background:#f3f4f6;border-radius:8px;width:34px;height:34px;font-size:22px;line-height:1}.rep-modal form{display:flex;flex-direction:column;gap:8px}.rep-modal label{font-weight:800;font-size:12px;margin-top:4px}.rep-modal label b{color:#c0392b}.rep-modal label span{font-weight:400;color:#7a8290}.rep-modal input,.rep-modal textarea{width:100%;border:1px solid #d9dee7;border-radius:9px;padding:11px 12px;outline:none}.rep-modal input:focus,.rep-modal textarea:focus{border-color:#6366f1;box-shadow:0 0 0 3px rgba(99,102,241,.12)}.rep-modal textarea{resize:vertical;min-height:84px}.modal-actions{display:flex;justify-content:flex-end;gap:9px;margin-top:12px}
@media(max-width:1000px){.editor-head{grid-template-columns:1fr}.editor-context{text-align:left}.editor-actions{justify-content:flex-start;flex-wrap:wrap}}@media(max-width:768px){.sr-top,.cifra-head{align-items:stretch;flex-direction:column}.search-row{grid-template-columns:1fr}.cifra-actions-top{align-items:stretch;flex-direction:column}.song-row{grid-template-columns:32px 1fr 55px}.song-actions{grid-column:2/4;justify-content:flex-end}.cifra-card pre{font-size:12px}.modal-actions{flex-direction:column-reverse}.modal-actions button{width:100%}}
</style>
