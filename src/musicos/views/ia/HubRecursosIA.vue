<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div
    class="page-content"
    style="
      background-color: #f3f3f9 !important;
      min-height: 100vh;
      padding: 24px;
    "
  >
    <div class="container-fluid">

      <!-- CABEÇALHO -->
      <div class="row mb-4 text-start">
        <div class="col-12">
          <div class="d-flex align-items-center gap-2 mb-1">
            <h4
              class="text-dark fw-bold font-monospace text-uppercase mb-0 fs-16"
              style="letter-spacing: 0.5px;"
            >
              🧠 Central de Inteligência Artificial SevenShows
            </h4>

            <span
              class="badge bg-danger text-uppercase font-monospace fs-10 px-2 py-1 rounded"
              style="background-color: #ff6c22 !important;"
            >
              PREMIUM
            </span>
          </div>

          <p class="text-muted small mb-0 font-monospace fs-13">
            Ferramentas inteligentes para facilitar a preparação,
            divulgação e organização dos seus shows.
          </p>
        </div>
      </div>

      <!-- ABAS -->
      <div class="row mb-3">
        <div class="col-12">
          <ul
            class="nav ia-tool-tabs d-flex gap-2 text-start"
            role="tablist"
          >
            <!-- REPERTÓRIO -->
            <li class="nav-item" role="presentation">
              <button
                type="button"
                class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12"
                :class="{
                  'active':
                    abaAtiva === 'repertorio'
                }"
                @click="abaAtiva = 'repertorio'"
              >
                🎸 Otimizador de Repertório
              </button>
            </li>

            <!-- CIFRAS -->
            <li class="nav-item" role="presentation">
              <button
                type="button"
                class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12"
                :class="{
                  'active':
                    abaAtiva === 'cifras'
                }"
                @click="abaAtiva = 'cifras'"
              >
                🎼 Gerador de Cifras
              </button>
            </li>

            <!-- SEVEN REPERTÓRIO -->
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12"
                :class="{ 'active': abaAtiva === 'seven-repertorio' }" @click="abaAtiva = 'seven-repertorio'">
                🎵 Seven Repertório
              </button>
            </li>

            <!-- PALCO 7 -->
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12"
                :class="{ 'active': abaAtiva === 'palco-7' }" @click="abaAtiva = 'palco-7'">
                🎤 Palco 7
              </button>
            </li>

            <!-- SEVEN DESIGNER -->
            <li class="nav-item" role="presentation">
              <button
                type="button"
                class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12"
                :class="{
                  'active':
                    abaAtiva === 'designer'
                }"
                @click="abaAtiva = 'designer'"
              >
                🎨 Gerador de Cartazes
              </button>
            </li>
          </ul>
        </div>
      </div>

      <!-- CONTEÚDO -->
      <div class="row">
        <div class="col-12">

          <!-- REPERTÓRIO -->
          <div
            v-if="abaAtiva === 'repertorio'"
            class="animate__animated animate__fadeIn"
          >
            <SetlistOptimizerIA />
          </div>

          <!-- CIFRAS -->
          <div
            v-if="abaAtiva === 'cifras'"
            class="animate__animated animate__fadeIn"
          >
            <GeradorCifrasIA />
          </div>

          <!-- SEVEN REPERTÓRIO -->
          <div v-if="abaAtiva === 'seven-repertorio'" class="animate__animated animate__fadeIn">
            <SevenRepertorio />
          </div>

          <!-- PALCO 7 -->
          <div v-if="abaAtiva === 'palco-7'" class="animate__animated animate__fadeIn">
            <Palco7 />
          </div>

          <!-- SEVEN DESIGNER -->
          <div
            v-if="abaAtiva === 'designer'"
            class="animate__animated animate__fadeIn"
          >
            <SevenDesigner />
          </div>

        </div>
      </div>

    </div>
  </div>
</template>

<script>
import SetlistOptimizerIA from "./components/SetlistOptimizerIA.vue";
import GeradorCifrasIA from "./components/GeradorCifrasIA.vue";

import SevenDesigner from
  "./components/seven-designer/SevenDesigner.vue";
import SevenRepertorio from "./components/seven-repertorio/SevenRepertorio.vue";
import Palco7 from "./components/palco-7/Palco7.vue";

export default {
  name: "HubRecursosIA",

  components: {
    SetlistOptimizerIA,
    GeradorCifrasIA,
    SevenDesigner,
    SevenRepertorio,
    Palco7
  },

  data() {
    return {
      abaAtiva: "repertorio"
    };
  }
};
</script>

<style scoped>
.ia-tool-tabs {
  padding: 6px;
  margin: 0;
  border: 1px solid #e3e6ec;
  border-radius: 12px;
  background: #ffffff;
  box-shadow: 0 3px 12px rgba(15, 23, 42, 0.05);
}

.ia-tool-tabs .nav-item {
  flex: 1 1 0;
  min-width: 190px;
}

.ia-tool-tab {
  width: 100%;
  min-height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  padding: 10px 18px !important;
  border: 1px solid transparent !important;
  border-radius: 8px !important;
  color: #667085 !important;
  background: transparent !important;
  transition:
    color 0.18s ease,
    background-color 0.18s ease,
    border-color 0.18s ease,
    box-shadow 0.18s ease,
    transform 0.18s ease;
  cursor: pointer;
}

.ia-tool-tab:hover:not(.active) {
  color: #344054 !important;
  background: #f8f9fc !important;
  border-color: #e4e7ec !important;
  transform: translateY(-1px);
}

.ia-tool-tab.active {
  color: #ffffff !important;
  background: #ff6c22 !important;
  border-color: #ff6c22 !important;
  box-shadow: 0 5px 12px rgba(255, 108, 34, 0.22);
}

.ia-tool-tab:focus-visible {
  outline: 3px solid rgba(255, 108, 34, 0.22);
  outline-offset: 2px;
}

@media (max-width: 767.98px) {
  .ia-tool-tabs {
    flex-direction: column;
  }

  .ia-tool-tabs .nav-item {
    width: 100%;
    min-width: 0;
  }
}
</style>