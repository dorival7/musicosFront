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
            class="nav nav-tabs-custom rounded card-header-tabs border-bottom-0 d-flex gap-2 text-start"
            role="tablist"
            style="padding-left: 0;"
          >
            <!-- REPERTÓRIO -->
            <li class="nav-item" role="presentation">
              <button
                type="button"
                class="nav-link font-monospace text-uppercase fw-bold fs-12 py-2 px-4 position-relative border-0"
                :class="{
                  'active text-primary bg-white shadow-sm rounded-top':
                    abaAtiva === 'repertorio'
                }"
                @click="abaAtiva = 'repertorio'"
              >
                🎸 Otimizar Repertório
              </button>
            </li>

            <!-- CIFRAS -->
            <li class="nav-item" role="presentation">
              <button
                type="button"
                class="nav-link font-monospace text-uppercase fw-bold fs-12 py-2 px-4 position-relative border-0"
                :class="{
                  'active text-primary bg-white shadow-sm rounded-top':
                    abaAtiva === 'cifras'
                }"
                @click="abaAtiva = 'cifras'"
              >
                🎼 Gerador de Cifras
              </button>
            </li>

            <!-- SEVEN DESIGNER -->
            <li class="nav-item" role="presentation">
              <button
                type="button"
                class="nav-link font-monospace text-uppercase fw-bold fs-12 py-2 px-4 position-relative border-0"
                :class="{
                  'active text-primary bg-white shadow-sm rounded-top':
                    abaAtiva === 'designer'
                }"
                @click="abaAtiva = 'designer'"
              >
                🎨 Criar Cartaz
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

export default {
  name: "HubRecursosIA",

  components: {
    SetlistOptimizerIA,
    GeradorCifrasIA,
    SevenDesigner
  },

  data() {
    return {
      abaAtiva: "repertorio"
    };
  }
};
</script>

<style scoped>
.nav-tabs-custom .nav-link {
  color: #6c757d !important;
  transition: all 0.2s ease;
}

.nav-tabs-custom .nav-link.active {
  color: #ff6c22 !important;
  border-top: 2px solid #ff6c22 !important;
}

.nav-tabs-custom .nav-link:not(.active):hover {
  color: #495057 !important;
  background-color: rgba(0, 0, 0, 0.02);
  border-radius: 4px 4px 0 0;
}
</style>