<template>
  <div class="seven-designer">
    <div class="card border-0 shadow-sm mb-3">
      <div class="card-body px-4 py-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
          <div class="d-flex align-items-center gap-2">
            <span class="fs-4">🎨</span>
            <h5 class="mb-0 fw-bold">Seven Designer</h5>
            <span class="badge bg-warning text-dark">NOVO</span>
          </div>
          <small class="text-muted">Clique diretamente nos elementos do cartaz para editar.</small>
        </div>
        <strong class="small">Story 1080 × 1920</strong>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-xl-3 col-lg-4">
        <div class="card border-0 shadow-sm designer-sidebar-sticky">
          <div class="card-body p-3">
            <div class="designer-sidebar-section">
              <strong class="d-block mb-2">Ferramentas</strong>
              <button class="btn btn-dark w-100 fw-bold mb-2"
                      type="button"
                      @click.stop="menuAdicionarTexto = !menuAdicionarTexto">
                T＋ Adicionar texto
              </button>
              <div v-if="menuAdicionarTexto" class="sidebar-text-menu" @click.stop>
                <button @click="adicionarTextoLivre('titulo')"><b>Título</b><small>Destaque principal</small></button>
                <button @click="adicionarTextoLivre('subtitulo')"><b>Subtítulo</b><small>Informação secundária</small></button>
                <button @click="adicionarTextoLivre('texto')"><b>Texto</b><small>Texto livre</small></button>
              </div>
            </div>

            <div class="designer-sidebar-section">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <strong>Fundo do cartaz</strong>
                <small class="text-muted">{{ backgroundAtualNome }}</small>
              </div>
              <div class="sidebar-backgrounds">
                <button v-for="bg in backgrounds"
                        :key="bg.id"
                        type="button"
                        class="sidebar-bg-choice"
                        :class="{ active: backgroundId === bg.id }"
                        @click="backgroundId = bg.id">
                  <span v-if="bg.tipo === 'procedural'" class="sidebar-procedural-thumb"></span>
                  <img v-else :src="bg.src" :alt="bg.nome" />
                  <small>{{ bg.nome }}</small>
                </button>
              </div>
            </div>

            <div class="designer-sidebar-section uploads-section">
              <div class="d-flex justify-content-between align-items-start mb-2">
              <div>
                <strong class="d-block">Meus uploads</strong>
                <small class="text-muted">Fotos, logos e imagens.</small>
              </div>
              <span class="badge bg-light text-dark border">{{ usados }}/{{ limite }}</span>
            </div>

            <input ref="inputUpload" type="file" class="d-none"
                   accept="image/png,image/jpeg,image/webp" @change="enviarUpload" />
            <input ref="inputFotoArtista" type="file" class="d-none"
                   accept="image/png,image/jpeg,image/webp" @change="enviarFotoArtista" />

            <button class="btn btn-warning w-100 fw-bold mb-3"
                    :disabled="enviando || !podeEnviar"
                    @click="$refs.inputUpload?.click()">
              {{ enviando ? "Enviando..." : "+ Enviar nova imagem" }}
            </button>

            <div v-if="erroUploads" class="alert alert-danger py-2 small">{{ erroUploads }}</div>
            <div v-if="carregando" class="text-muted small text-center py-3">Carregando...</div>

            <div v-else class="uploads-grid">
              <div v-for="asset in assets" :key="asset.id" class="upload-item">
                <button class="upload-thumb" @click="adicionarAoCartaz(asset)" title="Adicionar ao cartaz">
                  <img :src="urlAsset(asset.originalUrl)" :alt="asset.originalFileName" />
                  <span>+ Cartaz</span>
                </button>
                <button class="upload-delete" @click.stop="excluirUpload(asset)" title="Excluir upload">×</button>
              </div>
            </div>

            <div v-if="assets.length === 0 && !carregando" class="empty-box">
              Envie a primeira foto ou logo.
            </div>
            <div v-if="!podeEnviar" class="alert alert-warning py-2 small mt-2 mb-0">
              Limite atingido. Exclua um upload para liberar espaço.
            </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-xl-9 col-lg-8">
        <div class="card border-0 shadow-sm">
          <div class="card-body p-3 p-md-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div>
                <small class="text-muted fw-bold">EDITOR VISUAL</small>
                <h6 class="fw-bold mb-0 mt-1">Seu cartaz</h6>
              </div>
              <span class="badge bg-light text-muted border">Sertanejo Sunset</span>
            </div>

            <div v-if="selecionado" class="designer-floating-toolbar" @click.stop>
              <template v-if="selecionado.tipo === 'texto'">
                <input
                  v-model="selecionado.texto"
                  class="form-control floating-text-input"
                  title="Texto selecionado"
                  @input="sincronizarTexto"
                />

                <div class="font-picker">
                  <button
                    type="button"
                    class="font-picker-button"
                    :style="{ fontFamily: fonteSelecionada?.family || 'Arial' }"
                    @click.stop="fontMenuAberto = !fontMenuAberto; posicaoMenuAberto = false"
                  >
                    <span>{{ fonteSelecionada?.nome || "Fonte" }}</span>
                    <span class="font-picker-arrow">⌄</span>
                  </button>

                  <div v-if="fontMenuAberto" class="font-picker-menu">
                    <button
                      v-for="fonte in fontes"
                      :key="fonte.id"
                      type="button"
                      class="font-option"
                      :class="{ active: selecionado.fontId === fonte.id }"
                      :style="{ fontFamily: fonte.family }"
                      @click.stop="selecionarFonte(fonte)"
                    >
                      <span class="font-option-preview">Aa</span>
                      <span>{{ fonte.nome }}</span>
                    </button>
                  </div>
                </div>

                <label class="floating-color" title="Cor do texto">
                  <span class="floating-color-letter">A</span>
                  <input v-model="selecionado.corTexto" type="color" @input="sincronizarTexto" />
                </label>

                <label v-if="selecionado.temFundo" class="floating-color" title="Cor do fundo">
                  <span>▰</span>
                  <input v-model="selecionado.corFundo" type="color" @input="sincronizarTexto" />
                </label>

                <div class="position-picker">
                  <button
                    type="button"
                    class="toolbar-action"
                    @click.stop="alternarMenuPosicao"
                  >
                    <span class="toolbar-icon">▱</span>
                    Posição
                  </button>

                  <div v-if="posicaoMenuAberto" class="position-menu">
                    <div class="position-title">Camadas</div>
                    <button @click="executarPosicao('top')"><span>▣</span> Trazer para frente</button>
                    <button @click="executarPosicao('up')"><span>↑</span> Avançar uma camada</button>
                    <button @click="executarPosicao('down')"><span>↓</span> Recuar uma camada</button>
                    <button @click="executarPosicao('bottom')"><span>▤</span> Enviar para trás</button>

                    <div class="position-separator"></div>
                    <div class="position-title">Alinhar no cartaz</div>
                    <div class="align-grid">
                      <button title="Esquerda" @click="alinharSelecionado('left')">⇤</button>
                      <button title="Centro horizontal" @click="alinharSelecionado('center')">↔</button>
                      <button title="Direita" @click="alinharSelecionado('right')">⇥</button>
                      <button title="Topo" @click="alinharSelecionado('top')">⇡</button>
                      <button title="Centro vertical" @click="alinharSelecionado('middle')">↕</button>
                      <button title="Base" @click="alinharSelecionado('bottom')">⇣</button>
                    </div>
                  </div>
                </div>

                <button class="toolbar-action toolbar-danger" @click="excluirSelecionado">
                  🗑 Excluir
                </button>
              </template>

              <template v-else-if="selecionado.tipo === 'imagem'">
                <span class="selected-image-name">{{ selecionado.nome }}</span>

                <button
                  v-if="!selecionado.backgroundRemovedSrc"
                  class="toolbar-action toolbar-dark"
                  :disabled="removendoBackground"
                  @click="removerFundoSelecionada"
                >
                  {{ removendoBackground ? "Processando..." : "✨ Remover fundo" }}
                </button>
                <template v-else>
                  <button class="toolbar-action" @click="usarOriginal">Original</button>
                  <button class="toolbar-action" @click="usarSemFundo">Sem fundo</button>
                </template>

                <select v-model="intensidadeRecorte" class="form-select recorte-select" title="Preservação do recorte">
                  <option value="objeto">Preservar instrumento</option>
                  <option value="suave">Recorte suave</option>
                  <option value="normal">Recorte normal</option>
                  <option value="forte">Recorte forte</option>
                </select>

                <button class="toolbar-action" @click="duplicarImagem">⧉ Duplicar</button>

                <div class="position-picker">
                  <button
                    type="button"
                    class="toolbar-action"
                    @click.stop="alternarMenuPosicao"
                  >
                    <span class="toolbar-icon">▱</span>
                    Posição
                  </button>

                  <div v-if="posicaoMenuAberto" class="position-menu">
                    <div class="position-title">Camadas</div>
                    <button @click="executarPosicao('top')"><span>▣</span> Trazer para frente</button>
                    <button @click="executarPosicao('up')"><span>↑</span> Avançar uma camada</button>
                    <button @click="executarPosicao('down')"><span>↓</span> Recuar uma camada</button>
                    <button @click="executarPosicao('bottom')"><span>▤</span> Enviar para trás</button>

                    <div class="position-separator"></div>
                    <div class="position-title">Alinhar no cartaz</div>
                    <div class="align-grid">
                      <button title="Esquerda" @click="alinharSelecionado('left')">⇤</button>
                      <button title="Centro horizontal" @click="alinharSelecionado('center')">↔</button>
                      <button title="Direita" @click="alinharSelecionado('right')">⇥</button>
                      <button title="Topo" @click="alinharSelecionado('top')">⇡</button>
                      <button title="Centro vertical" @click="alinharSelecionado('middle')">↕</button>
                      <button title="Base" @click="alinharSelecionado('bottom')">⇣</button>
                    </div>
                  </div>
                </div>

                <button class="toolbar-action toolbar-danger" @click="removerImagemCartaz">
                  🗑 Excluir
                </button>

                <div v-if="removendoBackground" class="remove-bg-progress" title="Removendo fundo">
                  <div class="remove-bg-progress-bar" :style="{ width: progressoBackground + '%' }"></div>
                  <small>{{ etapaBackground || "Processando" }} · {{ Math.round(progressoBackground) }}%</small>
                </div>
              </template>
            </div>

            <div v-if="erroBackground" class="alert alert-danger py-2 small">{{ erroBackground }}</div>

            <div :class="{ 'designer-processing': removendoBackground }"><DesignerCanvas
              ref="canvas"
              :dados="cartaz"
              :imagens="imagensCartaz"
              :estilos="estilosTexto"
              :textos-livres="textosLivres"
              :background-id="backgroundId"
              @selecionar="selecionar"
              @atualizar-imagem="atualizarImagem"
              @atualizar-texto-layout="atualizarTextoLayout"
              @editar-texto="editarTextoDireto"
              @remover-imagem="removerImagemPorId"
              @pedir-upload="$refs.inputFotoArtista?.click()"
            /></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DesignerCanvas from "./DesignerCanvas.vue";
import backgrounds from "./backgrounds/backgrounds";
import fonts from "./fonts/fonts";
import { removerBackground, liberarBackgroundUrl } from "./services/backgroundRemovalService";
import {
  listarDesignerAssets, enviarDesignerAsset, excluirDesignerAsset, urlDesignerAsset
} from "./services/designerAssetsService";

const DEFAULTS = {
  data: { fontId:"bebas-neue", corTexto:"#FFE000", corFundo:"#000000", temFundo:false },
  weekday: { fontId:"oswald", corTexto:"#111111", corFundo:"#FFE000", temFundo:true },
  chamada: { fontId:"pacifico", corTexto:"#FFFFFF", corFundo:"#000000", temFundo:false },
  showLabel: { fontId:"permanent-marker", corTexto:"#FFFFFF", corFundo:"#000000", temFundo:true },
  artista: { fontId:"permanent-marker", corTexto:"#FFFFFF", corFundo:"#000000", temFundo:true },
  estabelecimento: { fontId:"oswald", corTexto:"#FFFFFF", corFundo:"#4A2818", temFundo:true },
  cidadeHorario: { fontId:"oswald", corTexto:"#FFFFFF", corFundo:"#000000", temFundo:false },
  extra: { fontId:"bangers", corTexto:"#FFFFFF", corFundo:"#ED1C24", temFundo:true }
};

export default {
  name: "SevenDesigner",
  components: { DesignerCanvas },

  data() {
    return {
      fontes: fonts,
      backgrounds,
      backgroundId: "show-luzes-01",
      cartaz: {
        artista:"Banda Quatro", data:"2026-09-18", horario:"20:30",
        local:"Fazenda Monte Belo", cidade:"Maringá - PR",
        chamada:"Música boa é aqui!", extra:"Show ao vivo"
      },
      estilosTexto: JSON.parse(JSON.stringify(DEFAULTS)),
      assets: [], usados:0, limite:10, podeEnviar:true,
      carregando:false, enviando:false, erroUploads:null,
      imagensCartaz: [],
      selecionado:null,
      fontMenuAberto:false,
      posicaoMenuAberto:false,
      removendoBackground:false,
      progressoBackground:0,
      erroBackground:null,
      textosLivres:[],
      menuAdicionarTexto:false,
      intensidadeRecorte:"objeto",
      etapaBackground:""
    };
  },

  computed: {
    fonteSelecionada() {
      if (!this.selecionado || this.selecionado.tipo !== "texto") return null;
      return this.fontes.find(f => f.id === this.selecionado.fontId) || null;
    },
    backgroundAtualNome() {
      return this.backgrounds.find(b => b.id === this.backgroundId)?.nome || "";
    }
  },

  mounted() {
    this.carregarUploads();
    document.addEventListener("click", this.fecharMenusContextuais);
  },

  beforeUnmount() {
    document.removeEventListener("click", this.fecharMenusContextuais);
    this.imagensCartaz.forEach(i => {
      if (i.backgroundRemovedSrc?.startsWith("blob:")) liberarBackgroundUrl(i.backgroundRemovedSrc);
    });
  },

  methods: {
    urlAsset(url) { return urlDesignerAsset(url); },

    fecharMenusContextuais() {
      this.fontMenuAberto = false;
      this.posicaoMenuAberto = false;
      this.menuAdicionarTexto = false;
    },

    selecionarFonte(fonte) {
      if (!this.selecionado || this.selecionado.tipo !== "texto") return;
      this.selecionado.fontId = fonte.id;
      this.fontMenuAberto = false;
      this.sincronizarTexto();
    },

    alternarMenuPosicao() {
      this.posicaoMenuAberto = !this.posicaoMenuAberto;
      this.fontMenuAberto = false;
    },

    executarPosicao(direcao) {
      this.moverSelecionado(direcao);
      this.posicaoMenuAberto = false;
    },

    alinharSelecionado(alinhamento) {
      this.$refs.canvas?.alinharSelecionado?.(alinhamento);
      this.posicaoMenuAberto = false;
    },

    async carregarUploads() {
      this.carregando = true; this.erroUploads = null;
      try {
        const r = await listarDesignerAssets();
        this.assets = r?.items || [];
        this.usados = Number(r?.used || 0);
        this.limite = Number(r?.limit || 0);
        this.podeEnviar = Boolean(r?.canUpload);
      } catch(e) { this.erroUploads = e?.message || "Erro ao carregar uploads."; }
      finally { this.carregando = false; }
    },

    async enviarUpload(e) {
      const file=e.target.files?.[0]; e.target.value="";
      if(!file) return;
      this.enviando=true; this.erroUploads=null;
      try { await enviarDesignerAsset(file); await this.carregarUploads(); }
      catch(err){ this.erroUploads=err?.message || "Erro no upload."; }
      finally { this.enviando=false; }
    },

    async enviarFotoArtista(e) {
      const file = e.target.files?.[0];
      e.target.value = "";
      if (!file) return;

      this.enviando = true;
      this.erroUploads = null;

      try {
        const enviado = await enviarDesignerAsset(file);
        await this.carregarUploads();

        // O endpoint pode retornar o asset diretamente ou embrulhado.
        const asset =
          enviado?.item ||
          enviado?.asset ||
          enviado ||
          this.assets.find(a => a.originalFileName === file.name) ||
          this.assets[0];

        if (asset?.id) {
          this.adicionarAoCartaz(asset, { fotoPrincipal: true });
        }
      } catch (err) {
        this.erroUploads = err?.message || "Erro ao enviar a foto do artista.";
      } finally {
        this.enviando = false;
      }
    },

    async excluirUpload(asset) {
      if(this.imagensCartaz.some(i=>i.assetId===asset.id)){
        alert("Remova primeiro essa imagem do cartaz."); return;
      }
      if(!confirm(`Excluir "${asset.originalFileName}" dos uploads?`)) return;
      try { await excluirDesignerAsset(asset.id); await this.carregarUploads(); }
      catch(e){ this.erroUploads=e?.message || "Erro ao excluir."; }
    },

    adicionarAoCartaz(asset, options = {}) {
      if(this.imagensCartaz.length>=5){ alert("Máximo de 5 imagens no cartaz nesta versão."); return; }
      const n=this.imagensCartaz.length;
      const fotoPrincipal = Boolean(options.fotoPrincipal);
      const id=`img-${Date.now()}-${Math.random().toString(16).slice(2)}`;
      const item={
        elementId:id, tipo:"imagem", assetId:asset.id, nome:asset.originalFileName,
        originalSrc:this.urlAsset(asset.originalUrl),
        backgroundRemovedSrc:asset.backgroundRemovedUrl ? this.urlAsset(asset.backgroundRemovedUrl) : null,
        src:this.urlAsset(asset.backgroundRemovedUrl || asset.originalUrl),
        usarSemFundo:Boolean(asset.backgroundRemovedUrl),
        x: fotoPrincipal ? 110 : 110+n*35,
        y: fotoPrincipal ? 300 : 300+n*35,
        width: fotoPrincipal ? 860 : (n===0?860:520),
        height: fotoPrincipal ? 920 : (n===0?920:620),
        rotation:0
      };
      this.imagensCartaz.push(item);
      this.selecionado=item;
      this.$nextTick(()=>this.$refs.canvas?.selecionarExterno?.(id,"imagem"));
    },

    selecionar(payload) {
      this.fontMenuAberto = false;
      this.posicaoMenuAberto = false;

      if (!payload?.id || !payload?.tipo) {
        this.selecionado = null;
        return;
      }

      if (payload.tipo === "imagem") {
        this.selecionado =
          this.imagensCartaz.find(i => i.elementId === payload.id) || null;
        return;
      }

      const estilo = this.estilosTexto[payload.id];
      if (!estilo) {
        this.selecionado = null;
        return;
      }

      this.selecionado = {
        tipo: "texto",
        id: payload.id,
        texto: payload.texto,
        fontId: estilo.fontId,
        corTexto: estilo.corTexto,
        corFundo: estilo.corFundo,
        temFundo: estilo.temFundo
      };
    },

    editarTextoDireto(payload) {
      if (!payload?.id || payload.cancelado) return;

      this.selecionar({
        id: payload.id,
        tipo: "texto",
        texto: payload.texto
      });

      if (this.selecionado?.tipo === "texto") {
        this.selecionado.texto = payload.texto;
        this.sincronizarTexto();
      }
    },

    removerImagemPorId(elementId) {
      this.imagensCartaz =
        this.imagensCartaz.filter(i => i.elementId !== elementId);

      if (this.selecionado?.elementId === elementId) {
        this.selecionado = null;
      }
    },

    sincronizarTexto() {
      const s = this.selecionado;
      if (!s || s.tipo !== "texto") return;

      const estilo = this.estilosTexto[s.id];
      if (!estilo) return;

      estilo.fontId = s.fontId;
      estilo.corTexto = s.corTexto;
      estilo.corFundo = s.corFundo;

      // Data é estrutural: nunca gravar "18/09" sobre YYYY-MM-DD.
      if (s.id === "data") {
        // Apenas estilo/layout da data é editável aqui.
      } else if (s.id === "weekday") {
        // O dia continua derivado da data. Só cria override se o usuário
        // realmente alterar o texto mostrado.
        const derivado = this.$refs.canvas?.weekday;
        if (s.texto && s.texto !== derivado) estilo.textoOverride = s.texto;
      } else if (s.id === "chamada") this.cartaz.chamada = s.texto;
      else if (s.id === "showLabel") estilo.textoOverride = s.texto;
      else if (s.id === "artista") this.cartaz.artista = s.texto;
      else if (s.id === "estabelecimento") this.cartaz.local = s.texto;
      else if (s.id === "cidadeHorario") estilo.textoOverride = s.texto;
      else if (s.id === "extra") this.cartaz.extra = s.texto;
      else if (s.id.startsWith("livre-")) {
        const livre = this.textosLivres.find(t => t.id === s.id);
        if (livre) livre.texto = s.texto;
        estilo.textoOverride = s.texto;
      }

      this.$forceUpdate();
    },

    atualizarTextoLayout(p){ this.estilosTexto[p.id]={...this.estilosTexto[p.id],...p.layout}; },

    atualizarImagem(p){
      const i=this.imagensCartaz.findIndex(x=>x.elementId===p.elementId);
      if(i<0)return;
      this.imagensCartaz[i]={...this.imagensCartaz[i],...p};
      if(this.selecionado?.elementId===p.elementId) this.selecionado=this.imagensCartaz[i];
    },

    async obterArquivo(imagem){
      const r=await fetch(imagem.originalSrc);
      if(!r.ok) throw new Error("Não foi possível carregar a imagem original.");
      const blob=await r.blob();
      return new File([blob],imagem.nome||"imagem.jpg",{type:blob.type||"image/jpeg"});
    },

    async removerFundoSelecionada(){
      const i=this.selecionado;
      if(!i||i.tipo!=="imagem"||this.removendoBackground)return;

      this.removendoBackground=true;
      this.progressoBackground=0;
      this.etapaBackground="Preparando";
      this.erroBackground=null;

      try{
        const file=await this.obterArquivo(i);
        const r=await removerBackground(file,{
          intensidade:this.intensidadeRecorte,
          onProgress:(p)=>{
            const valor=Number(p?.progress ?? 0);
            this.progressoBackground=Math.max(0,Math.min(100,valor<=1?valor*100:valor));
            this.etapaBackground=p?.etapa || this.etapaBackground;
          }
        });
        this.atualizarImagem({
          elementId:i.elementId,
          backgroundRemovedSrc:r.url,
          src:r.url,
          usarSemFundo:true
        });
      }catch(e){
        this.erroBackground=e?.message||"Erro ao remover fundo.";
      }finally{
        this.removendoBackground=false;
        this.etapaBackground="";
      }
    },

    usarOriginal(){const i=this.selecionado;if(i?.tipo==="imagem")this.atualizarImagem({elementId:i.elementId,src:i.originalSrc,usarSemFundo:false});},
    usarSemFundo(){const i=this.selecionado;if(i?.backgroundRemovedSrc)this.atualizarImagem({elementId:i.elementId,src:i.backgroundRemovedSrc,usarSemFundo:true});},

    duplicarImagem(){
      const i=this.selecionado;if(!i||i.tipo!=="imagem")return;
      const c={...i,elementId:`img-${Date.now()}`,x:i.x+45,y:i.y+45};
      this.imagensCartaz.push(c);this.selecionado=c;
      this.$nextTick(()=>this.$refs.canvas?.selecionarExterno?.(c.elementId,"imagem"));
    },

    moverSelecionado(direcao){
      this.$refs.canvas?.moverSelecionado?.(direcao);
    },

    adicionarTextoLivre(tipo = "texto") {
      this.menuAdicionarTexto = false;
      const id = `livre-${Date.now()}`;
      const fonte = this.fontes[0]?.id || null;
      const presets = {
        titulo: { texto: "Novo título", size: 84, w: 620, h: 120 },
        subtitulo: { texto: "Novo subtítulo", size: 58, w: 560, h: 100 },
        texto: { texto: "Novo texto", size: 42, w: 500, h: 90 }
      };
      const preset = presets[tipo] || presets.texto;

      this.estilosTexto[id] = {
        fontId: fonte,
        corTexto: "#ffffff",
        corFundo: "#000000",
        temFundo: false,
        textoOverride: preset.texto,
        layout: { x: 270, y: 900, w: preset.w, h: preset.h, size: preset.size, align: "center", rotation: 0 }
      };

      this.textosLivres.push({ id, texto: preset.texto });
      this.$forceUpdate();

      this.$nextTick(() => {
        this.$refs.canvas?.selecionarExterno?.(id, "texto");
        this.selecionar({ id, tipo: "texto", texto: preset.texto });
        this.$nextTick(() => this.$refs.canvas?.iniciarEdicaoInline?.(id));
      });
    },

    excluirSelecionado() {
      const s = this.selecionado;
      if (!s) return;

      if (s.tipo === "imagem") {
        this.removerImagemCartaz();
        return;
      }

      if (s.tipo === "texto") {
        // Elementos do template são ocultados; textos livres são removidos.
        if (s.id.startsWith("livre-")) {
          this.textosLivres = this.textosLivres.filter(t => t.id !== s.id);
          delete this.estilosTexto[s.id];
        } else {
          this.estilosTexto[s.id].oculto = true;
        }

        this.selecionado = null;
        this.$forceUpdate();
        this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(null, null));
      }
    },

    removerImagemCartaz(){
      const i=this.selecionado;if(!i||i.tipo!=="imagem")return;
      this.imagensCartaz=this.imagensCartaz.filter(x=>x.elementId!==i.elementId);
      this.selecionado=null;
      this.$nextTick(()=>this.$refs.canvas?.limparSelecao?.());
    }
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Bangers&family=Bebas+Neue&family=Black+Ops+One&family=Oswald:wght@400;700&family=Pacifico&family=Permanent+Marker&family=Righteous&family=Rock+Salt&display=swap');

.uploads-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:9px}
.upload-item{position:relative}.upload-thumb{width:100%;aspect-ratio:1;border:1px solid #dee2e6;border-radius:10px;padding:0;overflow:hidden;position:relative;background:#f8f9fa}
.upload-thumb img{width:100%;height:100%;object-fit:cover}.upload-thumb span{position:absolute;left:5px;right:5px;bottom:5px;background:rgba(0,0,0,.7);color:#fff;border-radius:5px;font-size:10px;padding:3px}
.upload-delete{position:absolute;right:-5px;top:-5px;width:24px;height:24px;border:2px solid #fff;border-radius:50%;background:#dc3545;color:#fff;font-weight:bold}
.empty-box{padding:25px 8px;text-align:center;border:1px dashed #ced4da;border-radius:8px;color:#6c757d;font-size:12px}
.context-toolbar{display:flex;gap:8px;align-items:center;flex-wrap:wrap;padding:10px;border:1px solid #dee2e6;border-radius:10px;background:#f8f9fa}
.context-text{flex:1 1 240px}.context-font{width:auto;min-width:190px}.color-control{display:flex;align-items:center;gap:4px;border:1px solid #ced4da;background:#fff;border-radius:6px;padding:4px 7px;font-weight:bold}
.layer-controls{display:flex;gap:4px;align-items:center}
.color-control input{width:28px;height:28px;border:0;padding:0;background:transparent}

.designer-preview-column{
  position:relative;
}
.designer-floating-toolbar{
  position:sticky;
  top:68px;
  z-index:120;
  display:flex;
  align-items:center;
  justify-content:center;
  gap:7px;
  flex-wrap:wrap;
  width:max-content;
  max-width:calc(100% - 24px);
  min-height:48px;
  margin:0 auto -56px auto;
  transform:translateY(10px);
  padding:6px 8px;
  border:1px solid rgba(208,213,221,.95);
  border-radius:13px;
  background:rgba(255,255,255,.98);
  box-shadow:0 8px 24px rgba(16,24,40,.18);
  backdrop-filter:blur(12px);
}
.floating-text-input{
  width:165px;
  min-width:125px;
  height:36px;
  border-radius:8px;
  font-size:13px;
}
.font-picker,.position-picker{position:relative}
.font-picker-button,.toolbar-action{
  height:36px;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:7px;
  border:1px solid #d0d5dd;
  border-radius:9px;
  padding:0 11px;
  background:#fff;
  color:#20242b;
  font-weight:700;
  white-space:nowrap;
}
.font-picker-button{min-width:170px;justify-content:space-between;font-size:17px}
.font-picker-arrow{font-family:Arial,sans-serif;color:#667085}
.font-picker-menu{
  position:absolute;
  top:44px;
  left:0;
  z-index:250;
  width:250px;
  max-height:360px;
  overflow:auto;
  padding:7px;
  border:1px solid #e4e7ec;
  border-radius:12px;
  background:#fff;
  box-shadow:0 16px 38px rgba(16,24,40,.20);
}
.font-option{
  width:100%;
  display:flex;
  align-items:center;
  gap:12px;
  padding:9px 10px;
  border:0;
  border-radius:8px;
  background:transparent;
  text-align:left;
  font-size:18px;
}
.font-option:hover,.font-option.active{background:#f2efff}
.font-option.active{outline:1px solid #8b5cf6}
.font-option-preview{
  width:44px;
  flex:0 0 44px;
  text-align:center;
  font-size:24px;
}
.floating-color{
  height:36px;
  display:flex;
  align-items:center;
  gap:5px;
  padding:0 8px;
  border:1px solid #d0d5dd;
  border-radius:9px;
  background:#fff;
  font-weight:800;
}
.floating-color input{
  width:25px;
  height:25px;
  padding:0;
  border:0;
  background:transparent;
}
.floating-color-letter{text-decoration:underline;text-decoration-thickness:3px}
.toolbar-dark{background:#25272b;color:#fff;border-color:#25272b}
.toolbar-danger{color:#b42318;border-color:#f3b7b2}
.toolbar-danger:hover{background:#fff1f0}
.toolbar-action:hover,.font-picker-button:hover{background:#f7f7f9}
.selected-image-name{
  max-width:170px;
  overflow:hidden;
  text-overflow:ellipsis;
  white-space:nowrap;
  font-weight:700;
  color:#475467;
}
.position-menu{
  position:absolute;
  top:44px;
  right:0;
  z-index:250;
  width:245px;
  padding:8px;
  border:1px solid #e4e7ec;
  border-radius:12px;
  background:#fff;
  box-shadow:0 16px 38px rgba(16,24,40,.20);
}
.position-title{
  padding:5px 8px;
  color:#667085;
  font-size:11px;
  font-weight:800;
  text-transform:uppercase;
  letter-spacing:.05em;
}
.position-menu>button{
  width:100%;
  display:flex;
  align-items:center;
  gap:10px;
  padding:8px 9px;
  border:0;
  border-radius:8px;
  background:transparent;
  text-align:left;
  font-weight:600;
}
.position-menu>button:hover,.align-grid button:hover{background:#f2efff}
.position-separator{height:1px;background:#eaecf0;margin:7px 2px}
.align-grid{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:5px;
  padding:4px;
}
.align-grid button{
  height:36px;
  border:1px solid #eaecf0;
  border-radius:8px;
  background:#fff;
  font-size:18px;
}
@media(max-width:768px){
  .designer-floating-toolbar{
    top:62px;
    width:calc(100% - 12px);
    max-width:calc(100% - 12px);
    justify-content:flex-start;
    flex-wrap:nowrap;
    overflow-x:auto;
    overflow-y:visible;
    margin-bottom:-54px;
  }
  .floating-text-input{width:145px;min-width:145px}
  .font-picker-button{min-width:145px}
}


.designer-add-text-btn{
  position:sticky;
  top:68px;
  z-index:119;
  float:right;
  margin:10px 12px -48px 0;
  height:36px;
  padding:0 12px;
  border:1px solid #d0d5dd;
  border-radius:9px;
  background:#fff;
  font-weight:800;
  box-shadow:0 5px 16px rgba(16,24,40,.12);
}
.remove-bg-progress{
  position:absolute;
  left:12px;
  right:12px;
  bottom:-28px;
  height:20px;
  display:flex;
  align-items:center;
  gap:8px;
  padding:3px 7px;
  border-radius:8px;
  background:#fff;
  box-shadow:0 4px 12px rgba(16,24,40,.14);
}
.remove-bg-progress::before{
  content:"";
  position:absolute;
  left:7px; right:42px; top:8px;
  height:5px;
  border-radius:99px;
  background:#eaecf0;
}
.remove-bg-progress-bar{
  position:relative;
  z-index:1;
  max-width:calc(100% - 42px);
  height:5px;
  border-radius:99px;
  background:#7c3aed;
}
.remove-bg-progress small{margin-left:auto;position:relative;z-index:1;font-weight:800}


.designer-add-menu{position:relative;z-index:118}
.designer-add-text-popup{
  position:sticky;
  top:110px;
  z-index:220;
  float:right;
  clear:right;
  width:245px;
  margin:4px 12px -170px 0;
  padding:7px;
  border:1px solid #e4e7ec;
  border-radius:12px;
  background:#fff;
  box-shadow:0 14px 34px rgba(16,24,40,.20);
}
.designer-add-text-popup button{
  width:100%;display:flex;align-items:center;gap:12px;
  border:0;background:transparent;border-radius:8px;padding:9px;text-align:left;
}
.designer-add-text-popup button:hover{background:#f2efff}
.designer-add-text-popup strong{font-size:24px;width:32px;text-align:center}
.designer-add-text-popup span{display:flex;flex-direction:column}
.designer-add-text-popup small{color:#667085}
.recorte-select{width:auto;min-width:140px;height:36px;font-size:12px;font-weight:700}
.designer-processing,.designer-processing *{cursor:progress !important}
.remove-bg-progress small{white-space:nowrap}


.designer-sidebar-sticky{
  position:sticky;
  top:72px;
  max-height:calc(100vh - 88px);
  overflow-y:auto;
  scrollbar-width:thin;
}
.designer-sidebar-section{
  position:relative;
  padding-bottom:14px;
  margin-bottom:14px;
  border-bottom:1px solid #eaecf0;
}
.designer-sidebar-section:last-child{border-bottom:0;margin-bottom:0}
.sidebar-text-menu{
  position:absolute;
  left:0;
  right:0;
  top:43px;
  z-index:230;
  padding:6px;
  border:1px solid #e4e7ec;
  border-radius:10px;
  background:#fff;
  box-shadow:0 12px 30px rgba(16,24,40,.18);
}
.sidebar-text-menu button{
  width:100%;
  display:flex;
  flex-direction:column;
  border:0;
  border-radius:8px;
  padding:8px 10px;
  background:transparent;
  text-align:left;
}
.sidebar-text-menu button:hover{background:#f2efff}
.sidebar-text-menu small{color:#667085}
.sidebar-backgrounds{
  display:grid;
  grid-template-columns:repeat(2,minmax(0,1fr));
  gap:8px;
}
.sidebar-bg-choice{
  display:flex;
  flex-direction:column;
  gap:5px;
  align-items:center;
  border:2px solid transparent;
  border-radius:10px;
  padding:5px;
  background:#fff;
  font-weight:700;
}
.sidebar-bg-choice.active{border-color:#f5b400;background:#fffaf0}
.sidebar-bg-choice img,.sidebar-procedural-thumb{
  display:block;
  width:100%;
  height:82px;
  object-fit:cover;
  border-radius:7px;
}
.sidebar-procedural-thumb{
  background:linear-gradient(#2b160f,#8a4322,#120b09);
}
@media(max-width:991px){
  .designer-sidebar-sticky{
    position:relative;
    top:auto;
    max-height:none;
    overflow:visible;
  }
}

</style>

