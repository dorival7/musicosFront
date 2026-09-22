<!-- eslint-disable vue/no-parsing-error -->
<template>
  <section class="section pb-0 position-relative overflow-visible" id="hero"
    style="padding-top: 140px; padding-bottom: 60px; background-color: #0a0b10 !important; z-index: 20;">
    <!-- PADRÃO DE FUNDO SUTIL DO VELZON -->
    <div class="bg-overlay bg-overlay-pattern opacity-25"></div>

    <div class="container position-relative z-1">
      <div class="row justify-content-center text-center">
        <div class="col-lg-10 col-sm-12">

          <!-- BRANDING & SLOGAN DE CONVERSÃO PREMIUM -->
          <div class="mt-2 animate__animated animate__fadeIn">
            <span
              class="badge border border-primary border-opacity-20 text-primary fw-bold text-uppercase px-3 py-2 rounded-pill fs-13 mb-3 font-monospace"
              style="background-color: rgba(255, 108, 34, 0.05) !important; letter-spacing: 1px;">
              ⚡ ENCONTRE • COMPARE • CONTRATE COM SEGURANÇA
            </span>
            <h1 class="display-4 fw-bold text-white mb-3 lh-base font-monospace text-uppercase"
              style="letter-spacing: -1px;">
              ENCONTRE O ARTISTA CERTO. <br />
              <span class="text-primary">VEJA A DISPONIBILIDADE. CONTRATE.</span>
            </h1>
            <p class="lead text-muted lh-base mx-auto mb-5 fs-18 fw-medium"
              style="max-width: 800px; color: #d1d5db !important;">
              Encontre músicos e bandas para seu evento, consulte disponibilidade, calcule o deslocamento e feche tudo online — com agenda integrada, contrato digital e pagamento protegido.
            </p>
          </div>

          <!-- ==================================================================== -->
          <!-- 🗺️ CONTAINER DE BUSCA MONOLÍTICA CALIBRADO COM AUTOCOMPLETE ASSÍNCRONO-->
          <!-- ==================================================================== -->
          <div class="row justify-content-center mt-4 mb-5 pb-4">
            <div class="col-lg-8 col-md-10 col-12">

              <!-- 🔥 TEXTO DE DESTAQUE RECONECTADO SOBRE A BARRA -->
              <div class="mb-3 animate__animated animate__fadeIn">
                <h4 class="text-white fs-15 text-uppercase font-monospace fw-bold mb-1" style="letter-spacing: 1.5px; color: #ffffff !important;">
                  <span style="color: #ff6c22;">🔥</span> AQUI VOCÊ ENCONTRA OS MELHORES ARTISTAS E BANDAS DO BRASIL!
                </h4>
                <p class="text-muted small mb-0 fs-12 font-monospace" style="color: #9ca3af !important;">
                  Pesquise pela cidade do evento e descubra artistas prontos para transformar sua data em um grande show.
                </p>
              </div>

              <!-- CONTAINER DA BARRA MONOLÍTICA FLUTUANTE -->
              <div class="sevenshows-search-monolith d-flex align-items-center mt-3 position-relative">

                <!-- ÍCONE LARANJA DO PIN GEOGRÁFICO -->
                <div class="sevenshows-icon-box">
                  <i class="ri-map-pin-2-line"></i>
                </div>

                <!-- CAMPO DE TEXTO UNIFICADO VINCULADO AO MÓDULO JS -->
                <div class="flex-grow-1 h-100 position-relative">
                  <input 
                    type="text" 
                    class="sevenshows-input-field" 
                    v-model="inputCidadeUf"
                    autocomplete="off"
                    placeholder="Onde será o seu evento? (Digite 3 letras... Ex: Santo Antônio...)" 
                    @input="onInputTeclado"
                    @keyup.enter="executarBuscaGeografica" 
                    @focus="mostrarSugestoes = true"
                    @blur="ocultarSugestoesComDelay"
                  />

                  <!-- CAIXA FLUTUANTE DE AUTOCOMPLETE SMART -->
                  <div v-if="mostrarSugestoes && cidadesFiltradas.length > 0" class="sevenshows-autocomplete-dropdown">
                    <div 
                      v-for="cidade in cidadesFiltradas" 
                      :key="cidade" 
                      class="autocomplete-item"
                      @mousedown="selecionarCidade(cidade)"
                    >
                      <!-- 🛠️ CORREÇÃO CIRÚRGICA: Alterado de {{ city }} para {{ cidade }} -->
                      <i class="ri-map-pin-line text-primary me-2"></i> {{ cidade }}
                    </div>
                  </div>
                </div>

                <!-- ENVELOPE DO BOTÃO DE BUSCA PREMIUM -->
                <div class="sevenshows-btn-box">
                  <button type="button" @click="executarBuscaGeografica" class="sevenshows-submit-btn">
                    <i class="ri-search-line me-1"></i> BUSCAR ARTISTAS
                  </button>
                </div>

              </div>

            </div>
          </div>

        </div>
      </div>
    </div>

    <!-- CURVA DE FECHAMENTO GEOMÉTRICA ORIGINAL -->
    <div class="position-absolute start-0 end-0 bottom-0 hero-shape-svg z-0 opacity-5" style="margin-bottom: -1px;">
      <svg xmlns="http://w3.org" version="1.1" viewBox="0 0 1440 120" style="display: block; width: 100%; height: auto;">
        <g fill="none">
          <path d="M 0,118 C 288,98.6 1152,40.4 1440,21L1440 140L0 140z" fill="#ffffff"></path>
        </g>
      </svg>
    </div>
  </section>
</template>
<script>
import axios from "axios";

export default {
  name: "HeroPublic",
  data() {
    return {
      inputCidadeUf: "",
      cidadesFiltradas: [],
      mostrarSugestoes: false,
      loadingCidades: false,
      debounceTimer: null
    };
  },
  methods: {
    // ⏳ TEMPORIZADOR ANTI-ESTOURO: Aguarda o contratante parar de digitar por 300ms
    onInputTeclado() {
      clearTimeout(this.debounceTimer);
      const termo = this.inputCidadeUf.trim();
      
      if (termo.length < 3) {
        this.cidadesFiltradas = [];
        return;
      }

      this.debounceTimer = setTimeout(() => {
        this.consultarMunicipiosApi(termo);
      }, 300);
    },

    // 📡 CONSUMO DINÂMICO INDEXADO: Puxa o autocomplete nacional do .NET 10
    async consultarMunicipiosApi(termo) {
      this.loadingCidades = true;
      try {
        // 🎯 AJUSTE CIRÚRGICO: Adicionado /artists/ no meio do caminho HTTP
        const url = `${process.env.VUE_APP_API_BASE_URL}/public/artists/cities/autocomplete?termo=${encodeURIComponent(termo)}`;
        const response = await axios.get(url);
        this.cidadesFiltradas = response.data || [];
        this.mostrarSugestoes = true;
      } catch (error) {
        console.error("Falha ao varrer rota de autocomplete:", error);
      } {
        this.loadingCidades = false;
      }
    },

    // 🎯 CORREÇÃO CIRÚRGICA DE VARIÁVEL (Sincronizado de city para cidade para matar o erro no ESLint)
    selecionarCidade(cidade) {
      this.inputCidadeUf = cidade;
      this.cidadesFiltradas = [];
      this.mostrarSugestoes = false;
      this.executarBuscaGeografica(); // Dispara o catálogo na hora ao clicar na sugestão!
    },

    ocultarSugestoesComDelay() {
      // Pequeno atraso para permitir que o clique do mouse (mousedown) registre antes da perda de foco
      setTimeout(() => {
        this.mostrarSugestoes = false;
      }, 200);
    },

    // 🧠 MOTOR DE DESPACHO GEOGRÁFICO: Quebra a string e envia parâmetros limpos para /artistas
    executarBuscaGeografica() {
      if (!this.inputCidadeUf || !this.inputCidadeUf.trim()) {
        this.$router.push({ path: '/artistas' });
        return;
      }

      const termoCompleto = this.inputCidadeUf.trim();
      const parametrosRota = {};

      if (termoCompleto.includes(" - ")) {
        const partes = termoCompleto.split(" - ");
        if (partes.length === 2) {
          parametrosRota.cidade = partes[0].trim();
          parametrosRota.uf = partes[1].toUpperCase().trim();
        }
      } else {
        parametrosRota.cidade = termoCompleto;
        parametrosRota.uf = "PR"; 
      }

      console.log("🚀 [HERO BUSCA] Enviando parâmetros para a vitrine:", JSON.stringify(parametrosRota));
      this.$router.push({ path: '/artistas', query: parametrosRota });
    }
  }
};
</script>

<style scoped>
.sevenshows-search-monolith {
  background-color: #161925 !important;
  border: 1px solid rgba(255, 255, 255, 0.08) !important;
  border-radius: 50px !important;
  height: 64px !important;
  padding: 6px !important;
  display: flex !important;
  align-items: center !important;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3) !important;
  transition: all 0.3s ease;
  width: 100% !important;
}

.sevenshows-search-monolith:focus-within {
  border-color: #ff6c22 !important;
  box-shadow: 0 10px 30px rgba(255, 108, 34, 0.15) !important;
}

.sevenshows-icon-box {
  padding-left: 20px !important;
  padding-right: 10px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

.sevenshows-icon-box i {
  color: #ff6c22 !important;
  font-size: 24px !important;
}

.sevenshows-input-field {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  color: #ffffff !important;
  font-family: monospace !important;
  font-size: 14px !important;
  height: 100% !important;
  outline: none !important;
  padding: 0 15px !important;
  width: 100% !important;
}

.sevenshows-input-field::placeholder {
  color: rgba(255, 255, 255, 0.4) !important;
}

.sevenshows-btn-box {
  height: 100% !important;
  display: flex !important;
  align-items: center !important;
}

.sevenshows-submit-btn {
  background-color: #ff6c22 !important;
  border: none !important;
  border-radius: 40px !important;
  color: #ffffff !important;
  cursor: pointer !important;
  font-family: monospace !important;
  font-size: 13px !important;
  font-weight: 700 !important;
  height: 52px !important;
  letter-spacing: 0.5px !important;
  padding: 0 35px !important;
  transition: all 0.2s ease !important;
  white-space: nowrap !important;
  box-shadow: 0 4px 12px rgba(255, 108, 34, 0.25) !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

.sevenshows-submit-btn:hover {
  background-color: #e55b13 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 6px 15px rgba(255, 108, 34, 0.35) !important;
}

/* 🎯 INTERFACE DO DROPDOWN FLUTUANTE ASSÍNCORNO PREMIUM */
.sevenshows-autocomplete-dropdown {
  position: absolute !important;
  top: 55px !important;
  left: 0 !important;
  width: 100% !important;
  background-color: #161925 !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 12px !important;
  box-shadow: 0 10px 25px rgba(0,0,0,0.5) !important;
  z-index: 9999 !important;
  max-height: 280px !important;
  overflow-y: auto !important;
  padding: 5px 0 !important;
}

.autocomplete-item {
  padding: 12px 20px !important;
  color: #ced4da !important;
  font-family: monospace !important;
  font-size: 13px !important;
  cursor: pointer !important;
  text-align: left !important;
  transition: all 0.15s ease !important;
}

.autocomplete-item:hover {
  background-color: rgba(255, 108, 34, 0.1) !important;
  color: #ffffff !important;
}
</style>
