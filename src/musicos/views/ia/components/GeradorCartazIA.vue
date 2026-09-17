<!-- eslint-disable vue/no-parsing-error -->
<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="card p-4 border border-light shadow-sm text-start bg-white" style="border-radius: 12px !important;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h5 class="text-dark fw-bold font-monospace text-uppercase mb-1 fs-15" style="letter-spacing: 0.5px;">
          <span style="color: #ff6c22;">🎨</span> Diretor de Arte Promocional (IA Avançada)
        </h5>
        <p class="text-muted small mb-0 font-monospace fs-12">Transforme dados de shows e fotos de bandas em cartazes de alto impacto com fusão de camadas</p>
      </div>
      <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-20 font-monospace px-3 py-1 fs-11 rounded-pill">
        GROQ / LLAMA 3
      </span>
    </div>

    <div class="row g-4">
      <!-- COLUNA DA ESQUERDA: ENTRADA DE DADOS COM UPLOAD -->
      <div class="col-lg-5">
        
        <!-- 🆕 NOVO: SELETOR DE IMAGEM PROFISSIONAL PARA TESTE DE ARTE -->
        <div class="mb-3">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">📸 Foto da Banda ou Músico (Com fundo escuro/limpo)</label>
          <div class="input-group">
            <input type="file" class="form-control bg-light border-light text-dark font-monospace fs-13" id="upload-foto-artista" accept="image/*" @change="carregarImagemMúsicoLocal" />
          </div>
          <small class="text-muted font-monospace fs-11 mt-1 d-block">Dica: Fotos com boa resolução e fundos neutros geram artes absurdamente superiores.</small>
        </div>

        <div class="mb-3">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">Título ou Nome do Evento</label>
          <input type="text" class="form-control bg-light border-light text-dark font-monospace fs-13 py-2" v-model="form.nomeEvento" placeholder="Ex: Grande Show de Pop Rock" @input="solicitarRedesenhoCanvas" />
        </div>

        <div class="mb-3">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">Data e Horário</label>
          <input type="text" class="form-control bg-light border-light text-dark font-monospace fs-13 py-2" v-model="form.dataHora" placeholder="Ex: Sábado, 19 de Setembro às 22h" @input="solicitarRedesenhoCanvas" />
        </div>

        <div class="mb-3">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">Local do Show</label>
          <input type="text" class="form-control bg-light border-light text-dark font-monospace fs-13 py-2" v-model="form.localShow" placeholder="Ex: Arena Maringá - PR" @input="solicitarRedesenhoCanvas" />
        </div>

        <!-- SELEÇÃO DE TOM DE CORES EM CHECKBOXES/BOTÕES -->
        <div class="mb-4">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-2">Estilo de Arte e Paleta</label>
          <div class="d-flex flex-wrap gap-2">
            <button 
              type="button" 
              v-for="tom in opcoesTons" 
              :key="tom.id" 
              @click="selecionarTomCor(tom.id)"
              class="btn btn-sm font-monospace text-uppercase fs-11 py-1 px-3 fw-medium"
              :class="form.tomSelecionado === tom.id ? 'btn-primary' : 'btn-light border border-light text-muted'"
              style="border-radius: 20px !important;"
            >
              {{ tom.nome }}
            </button>
          </div>
        </div>

        <!-- BOTÕES DE DISPARO E DOWNLOADS -->
        <div class="d-grid gap-2 mb-4">
          <button type="button" @click="processarDesignComIA" class="btn btn-primary fw-bold font-monospace text-uppercase fs-13" style="height: 44px; background-color: #ff6c22 !important; border-color: #ff6c22 !important; box-shadow: 0 4px 12px rgba(255,108,34,0.15);" :disabled="loadingIA">
            <i class="ri-magic-line me-1"></i> {{ loadingIA ? 'IA Executando Direção de Arte...' : 'Gerar Arte com Inteligência Artificial' }}
          </button>
          
          <div class="row g-2 mt-1" v-if="designGerado">
            <div class="col-6">
              <button type="button" @click="baixarCartaz('feed')" class="btn btn-success fw-bold font-monospace text-uppercase fs-12 w-100 py-2">
                <i class="ri-instagram-line me-1"></i> Baixar Feed
              </button>
            </div>
            <div class="col-6">
              <button type="button" @click="baixarCartaz('story')" class="btn btn-info fw-bold font-monospace text-uppercase fs-12 w-100 py-2 text-white">
                <i class="ri-whatsapp-line me-1"></i> Baixar Story
              </button>
            </div>
          </div>
        </div>

        <!-- DISPLAY DE COPY/LEGENDA IA -->
        <div v-if="legendaGerada" class="mt-3 animate__animated animate__fadeIn">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">📝 Legenda Otimizada para Redes Sociais</label>
          <div class="p-3 bg-light rounded border border-light position-relative" style="background-color: #f8f9fa !important;">
            <pre class="mb-0 font-sans-serif text-dark small" style="white-space: pre-wrap; font-size: 13px; font-family: inherit;">{{ legendaGerada }}</pre>
            <button class="btn btn-sm btn-link position-absolute top-0 end-0 m-1 font-monospace text-uppercase text-primary fs-11" @click="copiarTextoLegenda">
              <i class="ri-file-copy-line"></i> Copiar
            </button>
          </div>
        </div>
      </div>

      <!-- COLUNA DA DIREITA: PREVIEW DO CANVAS AVANÇADO (MESA DE EDIÇÃO GRAPHIC) -->
      <div class="col-lg-7 d-flex justify-content-center align-items-center">
        <div class="canvas-preview-container p-3 border border-light rounded-3 d-flex justify-content-center align-items-center" style="width: 100%; min-height: 440px; max-height: 520px; overflow: hidden; background-color: #f3f3f9 !important;">
          <canvas ref="canvasCartaz" style="max-width: 100%; max-height: 460px; box-shadow: 0 12px 30px rgba(0,0,0,0.3); background-color: #0b0c10; display: block; border-radius: 6px;"></canvas>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "GeradorCartazIA",
  props: {
    idEvent: { type: String, default: null }
  },
  data() {
    return {
      loadingIA: false,
      designGerado: true,
      legendaGerada: "",
      imagemArtistaObjeto: null, // Guarda o bitmap da foto do músico em RAM
      opcoesTons: [
        { id: "laranja", nome: "🔥 Glow Neon Laranja" },
        { id: "rock", nome: "🎸 Grunge Rock Roxo" },
        { id: "premium", nome: "💎 Cyber Emerald Premium" }
      ],
      form: { nomeEvento: "", dataHora: "", localShow: "", tomSelecionado: "laranja" },
      layout: {
        bgColorInicio: "#07080d", bgColorFim: "#161925", accentColor: "#ff6c22",
        iluminacaoBrilho: "rgba(255, 108, 34, 0.2)", modoMesclagem: "multiply",
        filtroFoto: "grayscale(100%) contrast(125%) brightness(105%)",
        fraseChamada: "PREPARE-SE PARA UM SHOW INESQUECÍVEL!"
      }
    };
  },
  methods: {
    // 📸 LEITURA DE ARQUIVO: Converte o upload local em um objeto Image do HTML5
    carregarImagemMúsicoLocal(event) {
      const arquivo = event.target.files[0];
      if (!arquivo) return;
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          this.imagemArtistaObjeto = img;
          this.solicitarRedesenhoCanvas();
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(arquivo);
    },

    selecionarTomCor(idTom) {
      this.form.tomSelecionado = idTom;
      if (idTom === "laranja") {
        this.layout.bgColorInicio = "#07080d"; this.layout.bgColorFim = "#161925";
        this.layout.accentColor = "#ff6c22"; this.layout.iluminacaoBrilho = "rgba(255, 108, 34, 0.25)";
        this.layout.modoMesclagem = "multiply";
      }
      if (idTom === "rock") {
        this.layout.bgColorInicio = "#0b0512"; this.layout.bgColorFim = "#1a0b2e";
        this.layout.accentColor = "#a855f7"; this.layout.iluminacaoBrilho = "rgba(168, 85, 247, 0.4)";
        this.layout.modoMesclagem = "screen";
      }
      if (idTom === "premium") {
        this.layout.bgColorInicio = "#030c14"; this.layout.bgColorFim = "#061f2d";
        this.layout.accentColor = "#02c39a"; this.layout.iluminacaoBrilho = "rgba(10, 179, 156, 0.35)";
        this.layout.modoMesclagem = "overlay";
      }
      this.solicitarRedesenhoCanvas();
    },

    // 🎨 PIPELINE GRÁFICO AVANÇADO EM CAMADAS (PHOTOSHOP STYLE)
    solicitarRedesenhoCanvas() {
      const canvas = this.$refs.canvasCartaz;
      if (!canvas) return;
      const ctx = canvas.getContext("2d");
      canvas.width = 1080; canvas.height = 1080;

      // Camada 1: Gradiente de Fundo Linear Profundo
      const gradFundo = ctx.createLinearGradient(0, 0, 0, 1080);
      gradFundo.addColorStop(0, this.layout.bgColorInicio);
      gradFundo.addColorStop(1, this.layout.bgColorFim);
      ctx.fillStyle = gradFundo; ctx.fillRect(0, 0, 1080, 1080);

      // Camada 2: Backlight (Holofote Radial por trás do Artista)
      const gradLuz = ctx.createRadialGradient(540, 450, 50, 540, 450, 500);
      gradLuz.addColorStop(0, this.layout.iluminacaoBrilho);
      gradLuz.addColorStop(1, "transparent");
      ctx.fillStyle = gradLuz; ctx.fillRect(0, 0, 1080, 1080);

      // Camada 3: Renderização da Foto com Máscara Enfeitiçada (Fade Out)
      if (this.imagemArtistaObjeto) {
        ctx.save();
        ctx.filter = this.layout.filtroFoto;
        const escala = Math.min(800 / this.imagemArtistaObjeto.width, 700 / this.imagemArtistaObjeto.height);
        const wN = this.imagemArtistaObjeto.width * escala;
        const hN = this.imagemArtistaObjeto.height * escala;
        const xP = (1080 - wN) / 2; const yP = 180;

        ctx.drawImage(this.imagemArtistaObjeto, xP, yP, wN, hN);
        ctx.globalCompositeOperation = this.layout.modoMesclagem;
        ctx.fillStyle = this.layout.accentColor;
        ctx.globalAlpha = 0.25;
        ctx.fillRect(xP, yP, wN, hN);
        ctx.restore();
        
        // Aplica o esfumaçado na base da foto fundindo o corpo do músico na escuridão
        ctx.save();
        const mFade = ctx.createLinearGradient(0, yP + hN - 220, 0, yP + hN);
        mFade.addColorStop(0, "rgba(0,0,0,0)"); mFade.addColorStop(1, this.layout.bgColorFim);
        ctx.fillStyle = mFade; ctx.fillRect(xP - 10, yP + hN - 230, wN + 20, hN);
        ctx.restore();
      } else {
        ctx.strokeStyle = "rgba(0,0,0,0.08)"; ctx.strokeRect(240, 250, 600, 400);
        ctx.textAlign = "center"; ctx.fillStyle = "#adb5bd"; ctx.font = "20px monospace";
        ctx.fillText("[ CLIQUE AO LADO PARA SUBIR A FOTO DA BANDA ]", 540, 460);
      }

      // Camada 4: Tipografia de Acabamento com Sombra Projetada
      ctx.textAlign = "center"; ctx.fillStyle = this.layout.accentColor;
      ctx.font = "bold 26px monospace"; ctx.fillText(this.layout.fraseChamada.toUpperCase(), 540, 120);

      ctx.save(); ctx.shadowColor = "rgba(0, 0, 0, 0.7)"; ctx.shadowBlur = 12;
      ctx.fillStyle = "#ffffff"; ctx.font = "bold 66px monospace";
      ctx.fillText((this.form.nomeEvento || "NOME DO SHOW / EVENTO").toUpperCase(), 540, 700);
      ctx.restore();

      ctx.fillStyle = "rgba(0, 0, 0, 0.35)"; ctx.fillRect(100, 760, 880, 190);
      ctx.fillStyle = this.layout.accentColor; ctx.font = "bold 32px monospace";
      ctx.fillText(this.form.dataHora || "DATA E HORÁRIO DO EVENTO", 540, 835);

      ctx.fillStyle = "#495057"; ctx.font = "26px monospace";
      ctx.fillText(this.form.localShow || "LOCAL / CIDADE - UF", 540, 910);

      ctx.fillStyle = "rgba(0,0,0,0.25)"; ctx.font = "bold 16px monospace";
      ctx.fillText("✨ EXCLUSIVO VIA SEVENSHOWS.COM.BR ✨", 540, 1020);
    },
// 🧠 DISPARADOR DO MOCK GROQ: Simula o recebimento do JSON de Direção de Arte do Llama 3
    async processarDesignComIA() {
      if (!this.form.nomeEvento || this.form.nomeEvento.trim() === "") {
        alert("⚠️ Por favor, digite o Nome do Evento antes de otimizar com a IA.");
        return;
      }

      this.loadingIA = true;
      
      // Delay simulado de latência de rede da inteligência artificial
      await new Promise(resolve => setTimeout(resolve, 900));

      try {
        // O payload dinâmico que o Groq/Llama 3 devolverá para cada estilo de checkbox
        let mockGroqResponseJson = {};

        if (this.form.tomSelecionado === "laranja") {
          mockGroqResponseJson = {
            "fraseChamadaMarketing": "🔥 PREPARE-SE PARA UMA NOITE HISTÓRICA DE ENERGIA MÁXIMA! 🔥",
            "legendaInstagram": `📢 SEGURA ESSA BRABA! Show confirmadíssimo na área! 🚨\n\nA contagem regressiva começou e a estrutura está sendo montada para entregar o espetáculo do ano. Junte sua galera, sinta a vibração e venha fazer história com a gente! 🎸🎤\n\n📍 Onde: ${this.form.localShow || 'Arena Principal'}\n📅 Quando: ${this.form.dataHora || 'Confira no cartaz'}\n\n#SevenShows #ShowConfirmado #GlowNeon #MusicaAoVivo #ContrateBandas`,
            "layoutConfig": {
              "bgColorInicio": "#050608", "bgColorFim": "#120e09", "accentColor": "#ff6c22",
              "iluminacaoBrilho": "rgba(255, 108, 34, 0.35)", "filtroFoto": "grayscale(100%) contrast(140%) brightness(100%)", "modoMesclagem": "multiply"
            }
          };
        } else if (this.form.tomSelecionado === "rock") {
          mockGroqResponseJson = {
            "fraseChamadaMarketing": "🎸 O SUBTERRÂNEO VAI TREMER! SINTA O PESO DO ROCK! 🎸",
            "legendaInstagram": `⚡ REVIRE O REVOLT! O verdadeiro Rock 'n' Roll tem data e local para incendiar o palco! ☠️🔥\n\nDistorção no talo, solos avassaladores e aquela vibe insana que só quem é fã de verdade entende.\n\n📍 Palco: ${this.form.localShow || 'Subterrâneo Underground'}\n📅 Cronograma: ${this.form.dataHora || 'Veja os detalhes na arte'}\n\n#SevenShows #RockIndependent #GrungeVibe #GuitarSolo #LiveMusic`,
            "layoutConfig": {
              "bgColorInicio": "#0a0310", "bgColorFim": "#1c0c2e", "accentColor": "#b55fe6",
              "iluminacaoBrilho": "rgba(168, 85, 247, 0.4)", "filtroFoto": "grayscale(100%) contrast(150%) brightness(95%)", "modoMesclagem": "screen"
            }
          };
        } else {
          mockGroqResponseJson = {
            "fraseChamadaMarketing": "💎 EXCLUSIVIDADE, REQUINTE E UMA ATMOSFERA PREMIUM VIBRANTE! 💎",
            "legendaInstagram": `✨ UMA NOITE DE GALA E ALTO PADRÃO! ✨\n\nSeja bem-vindo ao evento mais sofisticado e VIP da temporada. Uma curadoria musical cirúrgica, ambiente selecionado e experiências inesquecíveis aguardam por você. Garanta seu nome na lista! 🥂🍾\n\n📍 Lounge: ${this.form.localShow || 'Lounge Privilège'}\n📅 Agenda: ${this.form.dataHora || 'Reserva Confirmada'}\n\n#SevenShows #BaladaPremium #VipExperience #CyberEmerald #NightlifeElite`,
            "layoutConfig": {
              "bgColorInicio": "#020910", "bgColorFim": "#051f26", "accentColor": "#02c39a",
              "iluminacaoBrilho": "rgba(10, 179, 156, 0.35)", "filtroFoto": "grayscale(50%) contrast(120%) brightness(105%)", "modoMesclagem": "overlay"
            }
          };
        }

        // Aplica a direção de arte da IA do Groq sobre as configurações do Canvas
        this.layout.fraseChamada = mockGroqResponseJson.fraseChamadaMarketing;
        this.layout.bgColorInicio = mockGroqResponseJson.layoutConfig.bgColorInicio;
        this.layout.bgColorFim = mockGroqResponseJson.layoutConfig.bgColorFim;
        this.layout.accentColor = mockGroqResponseJson.layoutConfig.accentColor;
        this.layout.iluminacaoBrilho = mockGroqResponseJson.layoutConfig.iluminacaoBrilho;
        this.layout.filtroFoto = mockGroqResponseJson.layoutConfig.filtroFoto;
        this.layout.modoMesclagem = mockGroqResponseJson.layoutConfig.modoMesclagem;
        this.legendaGerada = mockGroqResponseJson.legendaInstagram;

        this.solicitarRedesenhoCanvas();
      } catch (e) {
        console.error("Falha técnica na esteira de IA do Groq:", e);
      } finally {
        this.loadingIA = false;
      }
    },

    baixarCartaz(formato) {
      const canvas = this.$refs.canvasCartaz;
      if (!canvas) return;
      
      const link = document.createElement("a");
      link.download = `cartaz-sevenshows-${formato}.png`;
      link.href = canvas.toDataURL("image/png");
      link.click();
    },

    copiarTextoLegenda() {
      if (!this.legendaGerada) return;
      navigator.clipboard.writeText(this.legendaGerada);
      alert("📋 Legenda copiada para a área de transferência com sucesso!");
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.solicitarRedesenhoCanvas();
    });
  }
};
</script>
