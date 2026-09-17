<!-- eslint-disable vue/no-parsing-error -->

<template>
  <div
    class="card p-4 border border-light shadow-sm text-start bg-white mt-4"
    style="border-radius: 12px !important;"
  >
    <!-- CABEÇALHO -->
    <div
      class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2"
    >
      <div>
        <h5
          class="text-dark fw-bold font-monospace text-uppercase mb-1 fs-15"
          style="letter-spacing: 0.5px;"
        >
          <span style="color: #ff6c22;">🎸</span>
          Otimizador de Repertório (Setlist Smart)
        </h5>

        <p class="text-muted small mb-0 font-monospace fs-12">
          Monte um show estratégico considerando público, estilo,
          época e origem do repertório.
        </p>
      </div>

      <span
        class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-20 font-monospace px-3 py-1 fs-11 rounded-pill"
      >
        LIVE API / GROQ
      </span>
    </div>

    <div class="row g-4">

      <!-- ===================================================== -->
      <!-- COLUNA ESQUERDA -->
      <!-- ===================================================== -->
      <div class="col-lg-5">

        <!-- ESTILOS -->
        <div class="mb-3">
          <label
            class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-2"
          >
            Selecione até 3 Estilos Musicais
            ({{ estilosSelecionados.length }}/3)
          </label>

          <div class="d-flex flex-wrap gap-2">
            <button
              type="button"
              v-for="estilo in listaEstilosDisponiveis"
              :key="estilo"
              @click="alternarSelecaoEstilo(estilo)"
              class="btn btn-sm font-monospace text-uppercase fs-11 py-1 px-3 fw-medium"
              :class="
                estilosSelecionados.includes(estilo)
                  ? 'btn-primary'
                  : 'btn-light border border-light text-muted'
              "
              style="border-radius: 20px !important;"
              :disabled="
                !estilosSelecionados.includes(estilo) &&
                estilosSelecionados.length >= 3
              "
            >
              {{ estilo }}
            </button>
          </div>
        </div>

        <!-- PERFIL -->
        <div class="mb-3">
          <label
            class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1"
          >
            Perfil do Público / Conceito do Evento
          </label>

          <textarea
            class="form-control bg-light border-light text-dark font-monospace fs-13"
            v-model="form.perfilPublico"
            rows="3"
            placeholder="Ex: Festa de aniversário de 40 anos, público que gosta de clássicos nacionais e internacionais e músicas para dançar..."
          ></textarea>
        </div>

        <!-- TIPO DE REPERTÓRIO -->
        <div class="mb-3">
          <label
            class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-2"
          >
            Origem do Repertório
          </label>

          <div class="setlist-choice-grid">
            <button
              type="button"
              v-for="tipo in listaTiposRepertorio"
              :key="tipo"
              class="setlist-choice-button"
              :class="{
                'setlist-choice-active':
                  form.tipoRepertorio === tipo
              }"
              @click="form.tipoRepertorio = tipo"
            >
              {{ tipo }}
            </button>
          </div>
        </div>

        <!-- ÉPOCA -->
        <div class="mb-3">
          <label
            class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1"
          >
            Época Preferida
          </label>

          <select
            class="form-select bg-light border-light text-dark font-monospace fs-13 py-2"
            v-model="form.epoca"
          >
            <option value="Livre">
              Livre / Melhor para o público
            </option>

            <option value="Atual">
              Atual
            </option>

            <option value="Anos 2000">
              Anos 2000
            </option>

            <option value="Anos 80/90">
              Anos 80 / 90
            </option>

            <option value="Clássicos">
              Clássicos
            </option>
          </select>
        </div>

        <!-- QUANTIDADE -->
        <div class="mb-4">
          <label
            class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1"
          >
            Quantidade de Músicas Desejada
          </label>

          <select
            class="form-select bg-light border-light text-dark font-monospace fs-13 py-2"
            v-model="form.qtdMusicas"
          >
            <option :value="10">
              10 Músicas (Show Pocket)
            </option>

            <option :value="15">
              15 Músicas (Show Padrão 1h)
            </option>

            <option :value="20">
              20 Músicas (Show Estendido 1h30)
            </option>

            <option :value="25">
              25 Músicas (Show Completo)
            </option>

            <option :value="30">
              30 Músicas (Show Longo)
            </option>
          </select>
        </div>

        <!-- RESUMO DOS FILTROS -->
        <div class="setlist-filter-summary mb-3">
          <div>
            <span>🌎</span>
            {{ form.tipoRepertorio }}
          </div>

          <div>
            <span>📻</span>
            {{ form.epoca }}
          </div>

          <div>
            <span>🎵</span>
            {{ form.qtdMusicas }} músicas
          </div>
        </div>

        <!-- BOTÃO -->
        <div class="d-grid">
          <button
            type="button"
            @click="gerarSetlistComIAReal"
            class="btn btn-primary fw-bold font-monospace text-uppercase fs-13"
            style="
              height: 46px;
              background-color: #ff6c22 !important;
              border-color: #ff6c22 !important;
              box-shadow: 0 4px 12px rgba(255,108,34,0.15);
            "
            :disabled="loadingSetlist"
          >
            <i class="ri-pulse-line me-1"></i>

            {{
              loadingSetlist
                ? 'Montando repertório estratégico...'
                : 'Gerar Repertório via IA'
            }}
          </button>
        </div>

      </div>

      <!-- ===================================================== -->
      <!-- COLUNA DIREITA -->
      <!-- ===================================================== -->
      <div class="col-lg-7">

        <div
          class="p-3 border border-light rounded-3 bg-light setlist-result-container"
        >

          <!-- VAZIO -->
          <div
            v-if="!setlistResultado && !loadingSetlist"
            class="d-flex flex-column align-items-center justify-content-center text-center h-100 py-5"
          >
            <i
              class="ri-music-2-line text-muted display-6 mb-2 opacity-30"
            ></i>

            <p
              class="text-muted font-monospace fs-12 mb-0"
            >
              Configure o perfil do show e deixe o Seven Shows
              montar a curva estratégica do repertório.
            </p>
          </div>

          <!-- LOADING -->
          <div
            v-if="loadingSetlist"
            class="d-flex flex-column align-items-center justify-content-center text-center h-100 py-5"
          >
            <div
              class="spinner-border text-primary mb-3"
              role="status"
              style="color: #ff6c22 !important;"
            ></div>

            <p
              class="text-dark fw-bold font-monospace fs-13 mb-1 text-uppercase"
            >
              Construindo o show...
            </p>

            <p
              class="text-muted font-monospace fs-11 mb-0"
            >
              Selecionando músicas, eliminando repetições e
              equilibrando a curva de energia.
            </p>
          </div>

          <!-- RESULTADO -->
          <div
            v-if="setlistResultado && !loadingSetlist"
            class="animate__animated animate__fadeIn text-start"
          >

            <!-- DIRETRIZ -->
            <div
              class="alert alert-info border-0 p-3 mb-3 bg-primary bg-opacity-10 text-primary font-monospace fs-12 rounded"
            >
              💡
              <strong>Diretriz Estratégica:</strong>

              {{ setlistResultado.resumoEstrategico }}
            </div>

            <!-- CONTADOR -->
            <div
              class="setlist-result-header mb-3"
            >
              <div>
                <strong>
                  🎵 REPERTÓRIO GERADO
                </strong>
              </div>

              <span>
                {{ quantidadeGerada }}
                /
                {{ form.qtdMusicas }}
                músicas
              </span>
            </div>

            <!-- TIMELINE -->
            <div
              class="timeline-setlist d-flex flex-column gap-3"
            >
              <div
                v-for="item in setlistResultado.sugestaoSetlist"
                :key="`${item.ordem}-${item.titulo}-${item.artistaOriginal}`"
                class="setlist-song-card p-3 bg-white border border-light rounded shadow-sm"
              >
                <div
                  class="d-flex justify-content-between align-items-start mb-1 gap-2"
                >
                  <div>
                    <span
                      class="badge bg-dark font-monospace me-2 text-white fs-11"
                      style="background-color: #161925 !important;"
                    >
                      #{{ item.ordem }}
                    </span>

                    <strong
                      class="text-dark fs-14 font-monospace text-uppercase"
                    >
                      {{ item.titulo }}
                    </strong>

                    <span
                      class="text-muted font-monospace small d-block mt-1"
                    >
                      Por: {{ item.artistaOriginal }}
                    </span>
                  </div>

                  <span
                    class="energy-badge"
                    :class="classeEnergia(item.curvaEnergia)"
                  >
                    {{ iconeEnergia(item.curvaEnergia) }}
                    {{ item.curvaEnergia }}
                  </span>
                </div>

                <p
                  class="text-muted mb-0 font-monospace fs-11 lh-base mt-2 border-top border-light pt-2"
                >
                  🎯
                  <strong>Estratégia:</strong>

                  {{ item.justificativaIA }}
                </p>
              </div>
            </div>

          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "SetlistOptimizerIA",

  data() {
    return {
      loadingSetlist: false,

      setlistResultado: null,

      estilosSelecionados: [],

      listaEstilosDisponiveis: [
        "Pop Rock",
        "Sertanejo",
        "Pagode / Samba",
        "MPB",
        "Axé",
        "Forró",
        "Reggae",
        "Indie / Folk",
        "Flashback"
      ],

      listaTiposRepertorio: [
        "Brasileiro",
        "Internacional",
        "Misto"
      ],

      form: {
        perfilPublico: "",
        qtdMusicas: 15,
        tipoRepertorio: "Misto",
        epoca: "Livre"
      }
    };
  },

  computed: {
    quantidadeGerada() {
      if (
        !this.setlistResultado ||
        !Array.isArray(
          this.setlistResultado.sugestaoSetlist
        )
      ) {
        return 0;
      }

      return this.setlistResultado
        .sugestaoSetlist.length;
    }
  },

  methods: {
    alternarSelecaoEstilo(estilo) {
      if (
        this.estilosSelecionados.includes(estilo)
      ) {
        this.estilosSelecionados =
          this.estilosSelecionados.filter(
            item => item !== estilo
          );

        return;
      }

      if (
        this.estilosSelecionados.length < 3
      ) {
        this.estilosSelecionados.push(estilo);
      }
    },

    classeEnergia(curva) {
      const valor =
        String(curva || "").toLowerCase();

      if (valor === "abertura")
        return "energy-opening";

      if (valor === "crescimento")
        return "energy-growth";

      if (valor === "respiro")
        return "energy-breath";

      if (valor === "pico")
        return "energy-peak";

      if (valor === "final")
        return "energy-final";

      return "energy-default";
    },

    iconeEnergia(curva) {
      const valor =
        String(curva || "").toLowerCase();

      if (valor === "abertura")
        return "🎬";

      if (valor === "crescimento")
        return "📈";

      if (valor === "respiro")
        return "🎶";

      if (valor === "pico")
        return "🔥";

      if (valor === "final")
        return "🏁";

      return "🎵";
    },

    async gerarSetlistComIAReal() {
      if (
        this.estilosSelecionados.length === 0
      ) {
        alert(
          "Selecione pelo menos um estilo musical."
        );

        return;
      }

      if (
        !this.form.perfilPublico.trim()
      ) {
        alert(
          "Informe o perfil do público ou conceito do evento."
        );

        return;
      }

      this.loadingSetlist = true;
      this.setlistResultado = null;

      try {
        const urlFinal =
          `${process.env.VUE_APP_API_BASE_URL}` +
          `/artists/ia/optimize-setlist`;

        const payload = {
          estilos:
            this.estilosSelecionados,

          perfilPublico:
            this.form.perfilPublico.trim(),

          qtdMusicas:
            Number(this.form.qtdMusicas),

          tipoRepertorio:
            this.form.tipoRepertorio,

          epoca:
            this.form.epoca
        };

        const tokenBruto =
          localStorage.getItem("jwt");

        if (!tokenBruto) {
          alert(
            "Sessão não localizada. Faça login novamente."
          );

          return;
        }

        const configHeaders = {
          headers: {
            Authorization:
              `Bearer ${tokenBruto}`
          }
        };

        const response =
          await axios.post(
            urlFinal,
            payload,
            configHeaders
          );

        if (
          !response.data ||
          !Array.isArray(
            response.data.sugestaoSetlist
          )
        ) {
          throw new Error(
            "O servidor retornou um repertório inválido."
          );
        }

        this.setlistResultado =
          response.data;

      } catch (error) {
        console.error(
          "Erro ao gerar repertório:",
          error
        );

        if (
          error.response &&
          error.response.data
        ) {
          const mensagem =
            error.response.data.mensagem ||
            "Não foi possível gerar o repertório.";

          const detalhe =
            error.response.data.erro || "";

          console.error(
            "DETALHE DO BACKEND:",
            detalhe
          );

          if (detalhe) {
            alert(
              `${mensagem}\n\nDetalhe técnico:\n${detalhe}`
            );
            return;
          }

          const solicitada =
            error.response.data
              .quantidadeSolicitada;

          const obtida =
            error.response.data
              .quantidadeObtida;

          if (
            solicitada !== undefined &&
            obtida !== undefined
          ) {
            alert(
              `${mensagem}\n\n` +
              `Solicitadas: ${solicitada}\n` +
              `Obtidas: ${obtida}`
            );
          } else {
            alert(mensagem);
          }

          return;
        }

        if (error.request) {
          alert(
            "O servidor não respondeu. Verifique a conexão e tente novamente."
          );

          return;
        }

        alert(
          error.message ||
          "Falha ao gerar o repertório."
        );

      } finally {
        this.loadingSetlist = false;
      }
    }
  }
};
</script>

<style scoped>
.setlist-choice-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.setlist-choice-button {
  border: 1px solid #e8ebef;
  background: #f7f9fa;
  color: #6c757d;
  border-radius: 9px;
  padding: 9px 6px;
  font-family: monospace;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  transition: all 0.18s ease;
}

.setlist-choice-button:hover {
  border-color: #ff6c22;
  color: #ff6c22;
}

.setlist-choice-active {
  background: #fff3ec;
  border-color: #ff6c22;
  color: #ff6c22;
  box-shadow: 0 3px 8px rgba(255, 108, 34, 0.10);
}

.setlist-filter-summary {
  display: flex;
  flex-wrap: wrap;
  gap: 7px;
}

.setlist-filter-summary > div {
  background: #f5f8f9;
  border: 1px solid #e8edef;
  border-radius: 20px;
  padding: 5px 10px;
  color: #667078;
  font-family: monospace;
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
}

.setlist-result-container {
  min-height: 480px;
  max-height: 650px;
  overflow-y: auto;
}

.setlist-result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
  font-family: monospace;
  font-size: 11px;
  color: #68727a;
}

.setlist-result-header strong {
  color: #20252a;
}

.setlist-result-header span {
  background: #eaf8f4;
  color: #178566;
  border: 1px solid #cdece2;
  border-radius: 20px;
  padding: 5px 10px;
  font-weight: 700;
}

.setlist-song-card {
  transition:
    transform 0.15s ease,
    box-shadow 0.15s ease;
}

.setlist-song-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 5px 15px rgba(20, 30, 40, 0.07) !important;
}

.energy-badge {
  white-space: nowrap;
  border-radius: 20px;
  padding: 4px 8px;
  font-family: monospace;
  font-size: 9px;
  font-weight: 700;
  text-transform: uppercase;
  border: 1px solid transparent;
}

.energy-opening {
  background: #eef6ff;
  color: #3478b9;
  border-color: #d8e9fa;
}

.energy-growth {
  background: #eefaf6;
  color: #238368;
  border-color: #d5eee5;
}

.energy-breath {
  background: #f4f2ff;
  color: #6c5bb3;
  border-color: #e5e0fa;
}

.energy-peak {
  background: #fff0e8;
  color: #e45c18;
  border-color: #ffd9c6;
}

.energy-final {
  background: #fff0f1;
  color: #c94c57;
  border-color: #f7d5d8;
}

.energy-default {
  background: #f4f5f6;
  color: #6c757d;
  border-color: #e7e8e9;
}

@media (max-width: 767px) {
  .setlist-choice-grid {
    grid-template-columns: 1fr;
  }

  .setlist-result-container {
    max-height: none;
  }

  .setlist-result-header {
    align-items: flex-start;
    flex-direction: column;
  }

  .energy-badge {
    font-size: 8px;
  }
}
</style>