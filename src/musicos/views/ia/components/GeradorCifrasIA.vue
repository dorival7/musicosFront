<template>
  <div class="card cifra-main-card border border-light shadow-sm text-start bg-white mt-4">
    <!-- ========================================================= -->
    <!-- CABEÇALHO -->
    <!-- ========================================================= -->
    <div class="cifra-header">
      <div>
        <h5 class="text-dark fw-bold font-monospace text-uppercase mb-1 fs-15" style="letter-spacing: 0.5px;">
          <span class="header-guitar">🎸</span>
          Gerador & Transpositor de Cifras Inteligente
        </h5>

        <p class="text-muted small mb-0 font-monospace fs-12">
          Busque qualquer música e mude o tom de forma automática e
          instantânea com a inteligência do Seven Shows
        </p>
      </div>

      <span
        class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-20 font-monospace px-3 py-1 fs-11 rounded-pill live-badge">
        LIVE REQUERIMENTO / IA
      </span>
    </div>


    <!-- ========================================================= -->
    <!-- PAINEL DE CONTROLE -->
    <!-- ========================================================= -->
    <div class="control-panel">

      <div class="row g-3 align-items-end">

        <!-- NOME DA MÚSICA -->
        <div class="col-lg-4 col-md-6">
          <label class="control-label">
            Nome da Música
          </label>

          <input type="text" class="form-control control-input" v-model="form.nomeMusica"
            placeholder="Ex: Rumo a Goiânia" @keyup.enter="gerarCifraMusicaReal" />
        </div>


        <!-- CANTOR / BANDA -->
        <div class="col-lg-4 col-md-6">
          <label class="control-label">
            Cantor / Banda

            <span class="text-muted fw-normal">
              (Opcional)
            </span>
          </label>

          <input type="text" class="form-control control-input" v-model="form.nomeArtista"
            placeholder="Ex: Leandro e Leonardo" @keyup.enter="gerarCifraMusicaReal" />
        </div>


        <!-- BOTÃO BUSCAR -->
        <div class="col-lg-4 col-md-12">
          <button type="button" @click="gerarCifraMusicaReal" class="btn btn-primary search-button w-100"
            :disabled="loadingCifra">
            <span v-if="loadingCifra && !carregandoRelacionada" class="spinner-border spinner-border-sm me-2"
              role="status"></span>

            <i v-else class="ri-music-fill me-2"></i>

            {{
              loadingCifra && !carregandoRelacionada
                ? 'Buscando Cifra...'
                : 'Buscar Música'
            }}
          </button>
        </div>

      </div>


      <!-- ======================================================= -->
      <!-- TRANSPOSITOR -->
      <!-- ======================================================= -->
      <div class="transpose-panel">

        <div class="transpose-info">
          <div>
            <div class="control-label mb-1">
              Tom desejado para cantar
            </div>

            <div class="transpose-description">
              <template v-if="cifraResultado">
                Clique em um tom para transpor a cifra
              </template>

              <template v-else>
                Os tons serão habilitados após carregar uma cifra
              </template>
            </div>
          </div>

          <div v-if="cifraResultado && form.tomDesejado" class="current-tone-info">
            <span class="current-tone-label">
              TOM ATUAL
            </span>

            <span class="current-tone-value">
              {{ form.tomDesejado }}
            </span>
          </div>
        </div>


        <!-- 12 TONS -->
        <div class="tone-grid">
          <button type="button" v-for="tom in listaTonsDisponiveis" :key="tom" @click="transporCifraTomIa(tom)"
            class="tone-button" :class="{
              'tone-button-active':
                normalizarTomParaBotao(form.tomDesejado) === tom
            }" :disabled="!podeTranspor || loadingCifra">
            {{ tom }}
          </button>
        </div>

      </div>

    </div>


    <!-- ========================================================= -->
    <!-- MÚSICAS RELACIONADAS -->
    <!-- ========================================================= -->
    <div v-if="
      cifraResultado &&
      cifraResultado.relacionadas &&
      cifraResultado.relacionadas.length > 0
    " class="related-section">
      <div class="related-header">
        <div>
          <div class="related-title">
            <i class="ri-play-list-add-line me-2"></i>
            Músicas relacionadas
          </div>

          <div class="related-subtitle">
            Clique para abrir outra cifra diretamente
          </div>
        </div>

        <div class="related-count">
          {{ cifraResultado.relacionadas.length }}
          sugestões
        </div>
      </div>


      <!-- FAIXA HORIZONTAL -->
      <div class="related-scroll">

        <button v-for="(item, index) in cifraResultado.relacionadas" :key="item.url || index" type="button"
          class="related-song-card" :class="{
            'related-song-disabled': loadingCifra
          }" @click="carregarMusicaRelacionada(item)" :disabled="loadingCifra">
          <div class="related-song-content">

            <div class="related-song-text">
              <div class="related-song-name">
                {{ item.titulo }}
              </div>

              <div class="related-song-artist">
                {{ item.artista }}
              </div>
            </div>

            <div class="related-song-arrow">
              <i class="ri-arrow-right-s-line"></i>
            </div>

          </div>
        </button>

      </div>
    </div>


    <!-- ========================================================= -->
    <!-- ÁREA DA CIFRA -->
    <!-- ========================================================= -->
    <div class="cifra-area">

      <!-- ======================================================= -->
      <!-- ESTADO INICIAL -->
      <!-- ======================================================= -->
      <div v-if="!cifraResultado && !loadingCifra" class="empty-state">
        <div class="empty-icon">
          <i class="ri-file-music-line"></i>
        </div>

        <div class="empty-title">
          Pronto para buscar uma cifra
        </div>

        <div class="empty-description">
          Digite o nome da música e clique em
          <strong>Buscar Música</strong>.
        </div>
      </div>


      <!-- ======================================================= -->
      <!-- CARREGAMENTO -->
      <!-- ======================================================= -->
      <div v-if="loadingCifra" class="loading-state">
        <div class="spinner-border mb-3" role="status" style="color: #ff6c22;"></div>

        <div class="loading-title">
          {{
            carregandoRelacionada
              ? 'Carregando música relacionada...'
              : 'Conectando ao Maestro do Seven Shows...'
          }}
        </div>

        <div class="loading-description">
          {{
            carregandoRelacionada
              ? 'Acessando a cifra diretamente no catálogo.'
              : 'Localizando a música e preparando a cifra.'
          }}
        </div>
      </div>


      <!-- ======================================================= -->
      <!-- CIFRA CARREGADA -->
      <!-- ======================================================= -->
      <div v-if="cifraResultado && !loadingCifra" class="cifra-document animate__animated animate__fadeIn">

        <!-- CABEÇALHO DA MÚSICA -->
        <div class="song-header">

          <div class="song-identification">
            <h4 class="song-title">
              {{ cifraResultado.musica }}
            </h4>

            <div class="song-artist">
              <i class="ri-user-voice-line me-1"></i>

              Artista Original:

              <strong>
                {{ cifraResultado.artista }}
              </strong>
            </div>
          </div>


          <div class="song-tone-badge">
            <i class="ri-music-2-line me-1"></i>

            TOM:
            {{ cifraResultado.tomOriginal }}
          </div>

        </div>


        <!-- ===================================================== -->
        <!-- CIFRA -->
        <!-- ===================================================== -->
        <div class="cifra-scroll">

          <pre class="cifra-pre">{{ cifraResultado.cifraCompleta }}</pre>

        </div>

      </div>

    </div>

  </div>
</template>


<script>
import axios from "axios";

export default {
  name: "GeradorCifrasIA",

  data() {
    return {
      loadingCifra: false,

      carregandoRelacionada: false,

      podeTranspor: false,

      cifraResultado: null,

      listaTonsDisponiveis: [
        "C",
        "C#",
        "D",
        "D#",
        "E",
        "F",
        "F#",
        "G",
        "G#",
        "A",
        "A#",
        "B"
      ],

      form: {
        nomeMusica: "",
        nomeArtista: "",
        tomDesejado: ""
      }
    };
  },


  methods: {

    // ==============================================================
    // URL BASE DA API
    // ==============================================================

    obterBaseUrl() {
      let baseUrl =
        process.env.VUE_APP_API_BASE_URL ||
        "http://localhost:5297";

      if (baseUrl.endsWith("/")) {
        baseUrl =
          baseUrl.slice(
            0,
            -1
          );
      }

      return baseUrl;
    },


    // ==============================================================
    // CONFIGURAÇÃO DE AUTENTICAÇÃO
    // ==============================================================

    obterConfigAxios() {
      const token =
        localStorage.getItem("jwt");

      if (!token) {
        return null;
      }

      return {
        headers: {
          Authorization:
            "Bearer " + token,

          "Content-Type":
            "application/json"
        }
      };
    },


    // ==============================================================
    // APLICA RESULTADO DA CIFRA
    // ==============================================================

    aplicarResultadoCifra(dados) {
      this.cifraResultado =
        dados;

      if (
        dados &&
        dados.tomOriginal
      ) {
        this.form.tomDesejado =
          dados.tomOriginal;

        this.podeTranspor =
          true;
      } else {
        this.form.tomDesejado =
          "";

        this.podeTranspor =
          false;
      }
    },


    // ==============================================================
    // BUSCA NORMAL
    //
    // Vue
    // ↓
    // generate-cifra
    // ↓
    // Tavily
    // ↓
    // Cifra Club
    // ==============================================================

    async gerarCifraMusicaReal() {
      if (
        !this.form.nomeMusica ||
        this.form.nomeMusica.trim() === ""
      ) {
        alert(
          "⚠️ Por favor, digite o nome da música para realizar a busca."
        );

        return;
      }

      const config =
        this.obterConfigAxios();

      if (!config) {
        alert(
          "⚠️ Token de autenticação não localizado. Por favor, faça login novamente."
        );

        return;
      }

      this.loadingCifra =
        true;

      this.carregandoRelacionada =
        false;

      this.cifraResultado =
        null;

      this.podeTranspor =
        false;

      try {
        const baseUrl =
          this.obterBaseUrl();

        const urlFinal =
          baseUrl +
          "/artists/ia/generate-cifra";

        const payload = {
          nomeMusica:
            this.form.nomeMusica,

          nomeArtista:
            this.form.nomeArtista
        };

        console.log(
          "🚀 [CIFRAS] Busca normal via Tavily:",
          urlFinal
        );

        const response =
          await axios.post(
            urlFinal,
            payload,
            config
          );

        console.log(
          "🎵 [CIFRAS] Resultado:",
          response.data
        );

        this.aplicarResultadoCifra(
          response.data
        );

      } catch (error) {
        console.error(
          "🚨 [CIFRAS] Erro na busca:",
          error
        );

        const statusErro =
          error.response
            ? error.response.status
            : "LOCAL_REDE";

        if (
          error.response &&
          error.response.data &&
          error.response.data.mensagem
        ) {
          alert(
            "❌ Erro da IA: " +
            error.response.data.mensagem
          );

        } else if (
          statusErro === 401
        ) {
          alert(
            "❌ Falha de autenticação (Erro 401). O seu token 'jwt' pode ter expirado no servidor."
          );

        } else {
          alert(
            "❌ Falha técnica de rede (Status HTTP: " +
            statusErro +
            "). Verifique o console ou a aba Network."
          );
        }

      } finally {
        this.loadingCifra =
          false;
      }
    },


    // ==============================================================
    // MÚSICA RELACIONADA
    //
    // NÃO USA TAVILY
    //
    // item.url
    // ↓
    // generate-cifra-related
    // ↓
    // Cifra Club diretamente
    // ==============================================================

    async carregarMusicaRelacionada(item) {
      if (this.loadingCifra) {
        return;
      }

      if (
        !item ||
        !item.url
      ) {
        console.error(
          "🚨 Música relacionada sem URL:",
          item
        );

        alert(
          "❌ Esta música relacionada não possui uma URL válida."
        );

        return;
      }

      const config =
        this.obterConfigAxios();

      if (!config) {
        alert(
          "⚠️ Token de autenticação não localizado. Faça login novamente."
        );

        return;
      }

      this.loadingCifra =
        true;

      this.carregandoRelacionada =
        true;

      this.podeTranspor =
        false;

      try {
        const baseUrl =
          this.obterBaseUrl();

        const urlFinal =
          baseUrl +
          "/artists/ia/generate-cifra-related";

        const payload = {
          url:
            item.url
        };

        console.log(
          "⚡ [RELACIONADA] Acesso direto:",
          item.url
        );

        console.log(
          "⚡ [RELACIONADA] Endpoint:",
          urlFinal
        );

        const response =
          await axios.post(
            urlFinal,
            payload,
            config
          );

        console.log(
          "🎵 [RELACIONADA] Resultado:",
          response.data
        );

        this.form.nomeMusica =
          response.data.musica ||
          item.titulo ||
          "";

        this.form.nomeArtista =
          response.data.artista ||
          item.artista ||
          "";

        this.aplicarResultadoCifra(
          response.data
        );

      } catch (error) {
        console.error(
          "🚨 [RELACIONADA] Falha ao carregar:",
          error
        );

        const statusErro =
          error.response
            ? error.response.status
            : "LOCAL_REDE";

        const mensagem =
          error.response?.data?.mensagem ||
          error.response?.data?.erro;

        if (mensagem) {
          alert(
            "❌ " + mensagem
          );

        } else if (
          statusErro === 401
        ) {
          alert(
            "❌ Falha de autenticação (Erro 401). Faça login novamente."
          );

        } else {
          alert(
            "❌ Não foi possível carregar a música relacionada. Status HTTP: " +
            statusErro
          );
        }

      } finally {
        this.loadingCifra =
          false;

        this.carregandoRelacionada =
          false;
      }
    },


    // ==============================================================
    // TRANSPOSIÇÃO LOCAL
    // ==============================================================

    async transporCifraTomIa(tomAlvo) {
      if (
        !this.cifraResultado ||
        !this.cifraResultado.htmlEstruturado
      ) {
        alert(
          "❌ O HTML estruturado da cifra não está disponível."
        );

        return;
      }

      if (
        this.form.tomDesejado ===
        tomAlvo
      ) {
        return;
      }

      this.loadingCifra =
        true;

      const tomOrigemAtual =
        this.form.tomDesejado;

      try {
        const baseUrl =
          this.obterBaseUrl();

        const urlFinal =
          baseUrl +
          "/artists/ia/transpose-cifra";

        // ============================================================
        // NÃO COMPACTAR ESPAÇOS.
        //
        // Os espaços determinam a posição horizontal dos acordes.
        // ============================================================

        let htmlEstruturado =
          this.cifraResultado
            .htmlEstruturado;

        htmlEstruturado =
          htmlEstruturado.replace(
            /\sdata-chord-(index|scope-id|original-text)="[^"]*"/g,
            ""
          );

        const payload = {
          htmlEstruturado:
            htmlEstruturado,

          tomOriginal:
            tomOrigemAtual,

          tomDesejado:
            tomAlvo
        };

        const config =
          this.obterConfigAxios();

        if (!config) {
          alert(
            "⚠️ Token de autenticação não localizado. Faça login novamente."
          );

          return;
        }

        console.log(
          "🎸 [TRANSPOSIÇÃO LOCAL] " +
          tomOrigemAtual +
          " → " +
          tomAlvo
        );

        const response =
          await axios.post(
            urlFinal,
            payload,
            config
          );

        console.log(
          "🎸 [TRANSPOSIÇÃO LOCAL] Resposta:",
          response.data
        );

        // ============================================================
        // TEXTO VISUAL
        // ============================================================

        this.cifraResultado.cifraCompleta =
          response.data.cifraTransposta;


        // ============================================================
        // HTML TRANSPOSICIONADO
        // ============================================================

        if (
          response.data.htmlEstruturado
        ) {
          this.cifraResultado
            .htmlEstruturado =
            response.data
              .htmlEstruturado;
        }


        // ============================================================
        // TOM ATUAL
        // ============================================================

        this.form.tomDesejado =
          tomAlvo;

        this.cifraResultado.tomOriginal =
          tomAlvo;

      } catch (error) {
        console.error(
          "🚨 [TRANSPOSIÇÃO LOCAL] Falha:",
          error
        );

        const mensagem =
          error.response?.data?.mensagem ||
          error.response?.data?.erro ||
          "Não foi possível transpor a música.";

        alert(
          "❌ " + mensagem
        );

        this.form.tomDesejado =
          tomOrigemAtual;

      } finally {
        this.loadingCifra =
          false;
      }
    },
    normalizarTomParaBotao(tom) {
      if (!tom) {
        return "";
      }

      const equivalencias = {
        "Db": "C#",
        "Eb": "D#",
        "Gb": "F#",
        "Ab": "G#",
        "Bb": "A#",

        "C#": "C#",
        "D#": "D#",
        "F#": "F#",
        "G#": "G#",
        "A#": "A#",

        "C": "C",
        "D": "D",
        "E": "E",
        "F": "F",
        "G": "G",
        "A": "A",
        "B": "B"
      };

      return equivalencias[tom] || tom;
    },
  }
};
</script>

<style scoped>
/* ================================================================ */
/* CARD PRINCIPAL */
/* ================================================================ */

.cifra-main-card {
  border-radius: 16px !important;
  overflow: hidden;

  background:
    linear-gradient(180deg,
      #ffffff 0%,
      #fbfcfd 100%) !important;

  border: 1px solid #e6eaee !important;

  box-shadow:
    0 10px 35px rgba(31, 41, 55, 0.07) !important;
}


/* ================================================================ */
/* CABEÇALHO */
/* ================================================================ */

.cifra-header {
  padding: 25px 28px 21px;

  display: flex;
  justify-content: space-between;
  align-items: center;

  gap: 20px;

  background:
    linear-gradient(90deg,
      #ffffff 0%,
      #fff8f4 52%,
      #f2fbfc 100%);

  border-bottom: 1px solid #edf0f2;
}


.cifra-header h5 {
  font-size: 17px !important;

  color: #182230 !important;

  letter-spacing: 0.7px !important;
}


.cifra-header p {
  margin-top: 5px;

  color: #667085 !important;

  font-size: 13px !important;

  line-height: 1.5;
}


.header-guitar {
  display: inline-flex;

  align-items: center;
  justify-content: center;

  width: 31px;
  height: 31px;

  margin-right: 5px;

  background: #fff0e8;

  border-radius: 8px;

  color: #ff6c22;

  font-size: 18px;
}


.live-badge {
  flex-shrink: 0;

  padding: 7px 15px !important;

  background: #ecfbfc !important;

  border-color: #00a6b2 !important;

  color: #008b95 !important;

  font-size: 11px !important;

  font-weight: 700;

  box-shadow:
    0 2px 7px rgba(0, 166, 178, 0.08);
}


/* ================================================================ */
/* PAINEL DE CONTROLE */
/* ================================================================ */

.control-panel {
  margin: 20px 28px 0;

  padding: 21px;

  background:
    linear-gradient(135deg,
      #f7fafb 0%,
      #f1f8f9 100%);

  border: 1px solid #dfe8eb;

  border-radius: 12px;

  box-shadow:
    0 3px 12px rgba(31, 41, 55, 0.035);
}


.control-label {
  display: block;

  margin-bottom: 8px;

  color: #344054;

  font-family: monospace;

  font-size: 12px;

  font-weight: 800;

  text-transform: uppercase;

  letter-spacing: 0.4px;
}


.control-label::first-letter {
  color: #ff6c22;
}


.control-input {
  height: 46px;

  padding-left: 14px;
  padding-right: 14px;

  background: #ffffff !important;

  border: 1px solid #dbe4e7 !important;

  color: #182230 !important;

  font-family: monospace;

  font-size: 13px;

  font-weight: 500;

  border-radius: 8px !important;

  transition:
    border-color 0.15s ease,
    box-shadow 0.15s ease;
}


.control-input::placeholder {
  color: #98a2b3;

  opacity: 1;
}


.control-input:hover {
  border-color: #c8d6da !important;
}


.control-input:focus {
  border-color: #ff8a50 !important;

  box-shadow:
    0 0 0 3px rgba(255, 108, 34, 0.10) !important;
}


/* ================================================================ */
/* BOTÃO BUSCAR */
/* ================================================================ */

.search-button {
  height: 46px;

  background:
    linear-gradient(135deg,
      #ff742f,
      #ff5f14) !important;

  border-color: #ff6c22 !important;

  color: white !important;

  border-radius: 8px !important;

  font-family: monospace;

  font-size: 13px;

  font-weight: 800;

  text-transform: uppercase;

  letter-spacing: 0.2px;

  box-shadow:
    0 6px 15px rgba(255, 108, 34, 0.20);

  transition:
    transform 0.15s ease,
    box-shadow 0.15s ease,
    filter 0.15s ease;
}


.search-button:hover:not(:disabled) {
  filter: brightness(1.03);

  transform: translateY(-1px);

  box-shadow:
    0 8px 18px rgba(255, 108, 34, 0.27);
}


.search-button:active:not(:disabled) {
  transform: translateY(0);
}


/* ================================================================ */
/* TRANSPOSITOR */
/* ================================================================ */

.transpose-panel {
  margin-top: 19px;

  padding: 17px 17px 16px;

  background: #ffffff;

  border: 1px solid #e3eaed;

  border-radius: 9px;
}


.transpose-info {
  display: flex;

  justify-content: space-between;

  align-items: flex-end;

  gap: 15px;

  margin-bottom: 13px;
}


.transpose-description {
  color: #7c8798;

  font-family: monospace;

  font-size: 11px;

  line-height: 1.4;
}


.current-tone-info {
  display: flex;

  align-items: center;

  gap: 8px;

  font-family: monospace;
}


.current-tone-label {
  color: #7c8798;

  font-size: 10px;

  font-weight: 700;
}


.current-tone-value {
  min-width: 38px;

  padding: 6px 10px;

  background: #eefafa;

  border: 1px solid #00a6b2;

  color: #008d97;

  text-align: center;

  font-size: 12px;

  font-weight: 800;

  border-radius: 6px;
}


/* ================================================================ */
/* 12 TONS */
/* ================================================================ */

.tone-grid {
  display: grid;

  grid-template-columns:
    repeat(12, minmax(44px, 1fr));

  gap: 7px;
}


.tone-button {
  height: 39px;

  padding: 0 7px;

  border: 1px solid #dce5e8;

  background: #f9fbfc;

  color: #475467;

  border-radius: 7px;

  font-family: monospace;

  font-size: 12px;

  font-weight: 700;

  box-shadow:
    0 1px 3px rgba(16, 24, 40, 0.035);

  transition:
    background-color 0.15s ease,
    border-color 0.15s ease,
    color 0.15s ease,
    transform 0.15s ease,
    box-shadow 0.15s ease;
}


.tone-button:hover:not(:disabled) {
  background: #eefafa;

  border-color: #00a6b2;

  color: #008b95;

  transform: translateY(-2px);

  box-shadow:
    0 4px 8px rgba(0, 166, 178, 0.12);
}


.tone-button-active {
  background:
    linear-gradient(135deg,
      #00aab6,
      #00959f) !important;

  border-color: #009ca7 !important;

  color: #ffffff !important;

  box-shadow:
    0 4px 10px rgba(0, 166, 178, 0.25) !important;

  transform: translateY(-1px);
}


.tone-button:disabled {
  cursor: default;

  opacity: 0.50;
}


/* ================================================================ */
/* MÚSICAS RELACIONADAS */
/* ================================================================ */

.related-section {
  margin: 18px 28px 0;

  padding: 17px 18px 15px;

  border: 1px solid #e1e7ea;

  border-radius: 11px;

  background:
    linear-gradient(135deg,
      #fffaf7 0%,
      #ffffff 42%,
      #f5fbfc 100%);

  box-shadow:
    0 3px 11px rgba(31, 41, 55, 0.035);
}


.related-header {
  display: flex;

  justify-content: space-between;

  align-items: center;

  gap: 15px;

  margin-bottom: 13px;
}


.related-title {
  color: #263445;

  font-family: monospace;

  font-size: 13px;

  font-weight: 800;

  text-transform: uppercase;

  letter-spacing: 0.3px;
}


.related-title i {
  color: #ff6c22;

  font-size: 16px;
}


.related-subtitle {
  margin-top: 4px;

  color: #7c8798;

  font-family: monospace;

  font-size: 10px;
}


.related-count {
  padding: 5px 9px;

  background: #f2f5f6;

  border-radius: 20px;

  color: #667085;

  font-family: monospace;

  font-size: 10px;

  font-weight: 600;

  white-space: nowrap;
}


/* ================================================================ */
/* SCROLL HORIZONTAL DAS RELACIONADAS */
/* ================================================================ */

.related-scroll {
  display: flex;

  gap: 10px;

  overflow-x: auto;

  overflow-y: hidden;

  padding: 2px 1px 8px;

  scroll-behavior: smooth;

  scrollbar-width: thin;

  scrollbar-color:
    #aebbc0 #edf2f3;
}


.related-scroll::-webkit-scrollbar {
  height: 7px;
}


.related-scroll::-webkit-scrollbar-track {
  background: #edf2f3;

  border-radius: 10px;
}


.related-scroll::-webkit-scrollbar-thumb {
  background: #aebbc0;

  border-radius: 10px;
}


.related-scroll::-webkit-scrollbar-thumb:hover {
  background: #8d9da3;
}


.related-song-card {
  flex: 0 0 250px;

  min-width: 250px;

  padding: 12px 13px;

  border: 1px solid #dfe7ea;

  background: #ffffff;

  border-radius: 8px;

  text-align: left;

  cursor: pointer;

  box-shadow:
    0 2px 5px rgba(16, 24, 40, 0.035);

  transition:
    background-color 0.15s ease,
    border-color 0.15s ease,
    transform 0.15s ease,
    box-shadow 0.15s ease;
}


.related-song-card:nth-child(3n + 1) {
  border-top: 3px solid #ff7a38;
}


.related-song-card:nth-child(3n + 2) {
  border-top: 3px solid #00a6b2;
}


.related-song-card:nth-child(3n + 3) {
  border-top: 3px solid #55a06b;
}


.related-song-card:hover:not(:disabled) {
  background: #fffdfc;

  border-color: #ff9b69;

  transform: translateY(-2px);

  box-shadow:
    0 6px 14px rgba(31, 41, 55, 0.09);
}


.related-song-content {
  display: flex;

  justify-content: space-between;

  align-items: center;

  gap: 10px;
}


.related-song-text {
  min-width: 0;

  flex: 1;
}


.related-song-name {
  overflow: hidden;

  color: #1d2939;

  font-family: monospace;

  font-size: 12px;

  font-weight: 800;

  white-space: nowrap;

  text-overflow: ellipsis;
}


.related-song-artist {
  margin-top: 5px;

  overflow: hidden;

  color: #7c8798;

  font-family: monospace;

  font-size: 10px;

  font-weight: 500;

  white-space: nowrap;

  text-overflow: ellipsis;
}


.related-song-arrow {
  flex-shrink: 0;

  width: 27px;
  height: 27px;

  display: flex;

  align-items: center;
  justify-content: center;

  background: #f1f5f6;

  border-radius: 50%;

  color: #829097;

  font-size: 18px;

  transition:
    background-color 0.15s ease,
    color 0.15s ease;
}


.related-song-card:hover .related-song-arrow {
  background: #fff0e8;

  color: #ff6c22;
}


.related-song-disabled {
  opacity: 0.55;

  pointer-events: none;
}


/* ================================================================ */
/* ÁREA DA CIFRA */
/* ================================================================ */

.cifra-area {
  margin: 18px 28px 28px;

  min-height: 440px;

  padding: 13px;

  border: 1px solid #dce6e9;

  border-radius: 12px;

  background:
    linear-gradient(145deg,
      #eaf4f6 0%,
      #f3f8f9 100%);

  overflow: hidden;

  box-shadow:
    inset 0 1px 3px rgba(31, 41, 55, 0.025);
}


/* ================================================================ */
/* ESTADO VAZIO / CARREGAMENTO */
/* ================================================================ */

.empty-state,
.loading-state {
  min-height: 420px;

  display: flex;

  flex-direction: column;

  justify-content: center;

  align-items: center;

  padding: 35px;

  text-align: center;
}


.empty-icon {
  width: 65px;
  height: 65px;

  display: flex;

  align-items: center;
  justify-content: center;

  margin-bottom: 14px;

  background: #ffffff;

  border: 1px solid #e1e8ea;

  border-radius: 50%;

  color: #ff6c22;

  font-size: 31px;

  box-shadow:
    0 5px 15px rgba(31, 41, 55, 0.06);
}


.empty-title,
.loading-title {
  margin-bottom: 7px;

  color: #263445;

  font-family: monospace;

  font-size: 14px;

  font-weight: 800;

  text-transform: uppercase;
}


.empty-description,
.loading-description {
  color: #7c8798;

  font-family: monospace;

  font-size: 11px;
}


/* ================================================================ */
/* DOCUMENTO DA CIFRA */
/* ================================================================ */

.cifra-document {
  margin: 0;

  background: #ffffff;

  border: 1px solid #dfe6e9;

  border-radius: 9px;

  box-shadow:
    0 4px 13px rgba(16, 24, 40, 0.055);

  overflow: hidden;
}


/* ================================================================ */
/* CABEÇALHO DA MÚSICA */
/* ================================================================ */

.song-header {
  display: flex;

  justify-content: space-between;

  align-items: center;

  gap: 20px;

  padding: 17px 20px;

  background:
    linear-gradient(90deg,
      #ffffff 0%,
      #ffffff 70%,
      #f4fbf8 100%);

  border-bottom: 1px solid #e1e7e9;
}


.song-identification {
  min-width: 0;
}


.song-title {
  margin: 0 0 6px;

  overflow: hidden;

  color: #111827;

  font-family: monospace;

  font-size: 18px;

  font-weight: 900;

  text-transform: uppercase;

  letter-spacing: 0.5px;

  white-space: nowrap;

  text-overflow: ellipsis;
}


.song-title::first-letter {
  color: #ff6c22;
}


.song-artist {
  color: #667085;

  font-family: monospace;

  font-size: 11px;
}


.song-artist i {
  color: #00a6b2;

  font-size: 13px;
}


.song-artist strong {
  margin-left: 4px;

  color: #263445;

  font-weight: 800;
}


.song-tone-badge {
  flex-shrink: 0;

  padding: 10px 16px;

  background:
    linear-gradient(135deg,
      #1b925c,
      #137c4d);

  color: #ffffff;

  border-radius: 7px;

  font-family: monospace;

  font-size: 12px;

  font-weight: 800;

  text-transform: uppercase;

  box-shadow:
    0 4px 10px rgba(25, 135, 84, 0.20);
}


/* ================================================================ */
/* CIFRA */
/* ================================================================ */

.cifra-scroll {
  max-height: 650px;

  overflow: auto;

  background:
    linear-gradient(180deg,
      #f1f8f9 0%,
      #edf6f7 100%);

  scrollbar-width: thin;

  scrollbar-color:
    #8f9fa4 #dfeaec;
}


.cifra-scroll::-webkit-scrollbar {
  width: 9px;
  height: 9px;
}


.cifra-scroll::-webkit-scrollbar-track {
  background: #dfeaec;
}


.cifra-scroll::-webkit-scrollbar-thumb {
  background: #8f9fa4;

  border-radius: 10px;

  border: 2px solid #dfeaec;
}


.cifra-pre {
  min-width: max-content;

  margin: 0;

  padding: 27px 29px 38px;

  border: 0;

  background: transparent;

  color: #111827;

  font-family: monospace;

  /*
   * AUMENTAMOS SOMENTE O TAMANHO DA FONTE.
   *
   * NÃO ALTERAR white-space / line-height.
   * Eles preservam o alinhamento dos acordes.
   */
  font-size: 14px;

  font-weight: 500;

  white-space: pre;

  line-height: 1.0;

  letter-spacing: 0.5px;

  overflow: visible;
}


/* ================================================================ */
/* TABLET */
/* ================================================================ */

@media (max-width: 991.98px) {

  .cifra-header {
    padding:
      20px;
  }


  .control-panel,
  .related-section,
  .cifra-area {
    margin-left:
      20px;

    margin-right:
      20px;
  }


  .tone-grid {
    grid-template-columns:
      repeat(6, 1fr);
  }


  .related-song-card {
    flex-basis:
      225px;

    min-width:
      225px;
  }


  .cifra-pre {
    font-size:
      13.5px;
  }

}


/* ================================================================ */
/* CELULAR */
/* ================================================================ */

@media (max-width: 575.98px) {

  .cifra-header {
    flex-direction:
      column;

    align-items:
      flex-start;

    gap:
      12px;

    padding:
      17px;
  }


  .cifra-header h5 {
    font-size:
      15px !important;
  }


  .cifra-header p {
    font-size:
      11px !important;
  }


  .live-badge {
    align-self:
      flex-start;
  }


  .control-panel,
  .related-section,
  .cifra-area {
    margin-left:
      12px;

    margin-right:
      12px;
  }


  .control-panel {
    padding:
      15px;
  }


  .transpose-info {
    align-items:
      flex-start;

    flex-direction:
      column;
  }


  .tone-grid {
    grid-template-columns:
      repeat(4, 1fr);
  }


  .tone-button {
    height:
      39px;

    font-size:
      12px;
  }


  .related-header {
    align-items:
      flex-start;
  }


  .related-count {
    display:
      none;
  }


  .related-song-card {
    flex-basis:
      205px;

    min-width:
      205px;
  }


  .song-header {
    align-items:
      flex-start;

    flex-direction:
      column;
  }


  .song-title {
    font-size:
      16px;

    white-space:
      normal;
  }


  .song-tone-badge {
    align-self:
      flex-start;
  }


  .cifra-area {
    padding:
      7px;
  }


  .cifra-pre {
    padding:
      20px 18px 30px;

    font-size:
      13px;

    /*
     * CONTINUA 1.0 TAMBÉM NO CELULAR
     */
    line-height:
      1.0;
  }

}
</style>