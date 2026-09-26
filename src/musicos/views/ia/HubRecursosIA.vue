<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div
    class="page-content"
    style="
      background-color: #f3f3f9 !important;
      min-height: 100vh;
    "
  >
    <div class="container-fluid ia-page">

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
          <ul class="nav ia-tool-tabs text-start" role="tablist">
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12" :class="{ active: abaAtiva === 'designer' }" @click="abaAtiva = 'designer'">🎨 Gerador de Cartazes</button>
            </li>
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12" :class="{ active: abaAtiva === 'cifras' }" @click="abaAtiva = 'cifras'">🎼 Gerador de Cifras</button>
            </li>
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12" :class="{ active: abaAtiva === 'seven-repertorio' }" @click="abaAtiva = 'seven-repertorio'">🎵 Seven Repertório</button>
            </li>
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12" :class="{ active: abaAtiva === 'palco-7' }" @click="abaAtiva = 'palco-7'">🎤 Palco 7</button>
            </li>
            <li class="nav-item" role="presentation">
              <button type="button" class="nav-link ia-tool-tab font-monospace text-uppercase fw-bold fs-12" :class="{ active: abaAtiva === 'repertorio' }" @click="abaAtiva = 'repertorio'">🎸 Setlist Inteligente</button>
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
      abaAtiva: "designer"
    };
  }
};
</script>

<style scoped>
.ia-tool-tabs {
  padding: 6px;
  display: flex;
  flex-wrap: nowrap !important;
  gap: 6px;
  margin: 0;
  border: 1px solid #e3e6ec;
  border-radius: 12px;
  background: #ffffff;
  box-shadow: 0 3px 12px rgba(15, 23, 42, 0.05);
}

.ia-tool-tabs .nav-item {
  flex: 1 1 0;
  min-width: 0;
}

.ia-tool-tab {
  width: 100%;
  min-height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  padding: 10px 8px !important;
  white-space: nowrap;
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

/* MOBILE: exatamente o padrão estrutural da Agenda aprovada.
   O Velzon já fornece o padding externo; compensamos 12px como em .agenda-page. */
@media (max-width: 767.98px) {
  .page-content {
    padding-left: 0 !important;
    padding-right: 0 !important;
  }

  .ia-page {
    margin-left: -12px !important;
    margin-right: -12px !important;
    width: auto !important;
    max-width: none !important;
    padding-left: 0 !important;
    padding-right: 0 !important;
  }

  .ia-page > .row {
    margin-left: 0 !important;
    margin-right: 0 !important;
  }

  .ia-page > .row > [class*="col-"] {
    min-width: 0;
    padding-left: 0 !important;
    padding-right: 0 !important;
  }

  /* Cabeçalho mantém respiro próprio; cards/conteúdo usam toda a largura útil. */
  .ia-page > .row:first-child > .col-12 {
    padding-left: 12px !important;
    padding-right: 12px !important;
  }
}


/* MOBILE ONLY — menu compacto em grade, sem slide e sem alterar funcionalidade. */
@media (max-width: 767.98px) {
  .ia-tool-tabs {
    display: grid !important;
    grid-template-columns: repeat(6, minmax(0, 1fr));
    gap: 6px !important;
    padding: 6px !important;
    overflow: visible !important;
  }

  .ia-tool-tabs > .nav-item {
    width: auto !important;
    min-width: 0;
    margin: 0 !important;
  }

  /* Primeira linha: 2 opções */
  .ia-tool-tabs > .nav-item:nth-child(1),
  .ia-tool-tabs > .nav-item:nth-child(2) {
    grid-column: span 3;
  }

  /* Segunda linha: 3 opções */
  .ia-tool-tabs > .nav-item:nth-child(3),
  .ia-tool-tabs > .nav-item:nth-child(4),
  .ia-tool-tabs > .nav-item:nth-child(5) {
    grid-column: span 2;
  }

  .ia-tool-tab {
    width: 100% !important;
    min-height: 58px;
    height: 100%;
    padding: 7px 5px !important;
    display: flex !important;
    flex-direction: column;
    align-items: center !important;
    justify-content: center !important;
    gap: 4px !important;
    text-align: center !important;
    white-space: normal !important;
    line-height: 1.15;
    font-size: 9px !important;
    border: 1px solid #e4e8ee !important;
    border-radius: 8px !important;
    background: #fff;
  }

  .ia-tool-tab.active {
    border-color: #ff6b25 !important;
    background: #ff6b25 !important;
    color: #fff !important;
    box-shadow: 0 4px 10px rgba(255, 107, 37, .18);
  }

  .ia-tool-tab span:first-child,
  .ia-tool-tab i {
    font-size: 15px;
    line-height: 1;
  }
}


/* MOBILE ONLY — cabeçalho compacto e copy específica para celular. */
@media (max-width: 767.98px) {
  .ia-page > .row:first-child {
    margin-top: 0 !important;
    margin-bottom: 8px !important;
  }

  .ia-page > .row:first-child > .col-12 {
    padding-top: 0 !important;
  }

  .ia-page > .row:first-child h4 {
    margin-top: 0 !important;
    margin-bottom: 4px !important;
    font-size: 0 !important;
    line-height: 1.25;
  }

  .ia-page > .row:first-child h4::after {
    content: "🧠 CENTRAL DE IA SEVENSHOWS";
    font-size: 13px;
    font-weight: 700;
    letter-spacing: .35px;
  }

  .ia-page > .row:first-child p {
    margin: 0 !important;
    font-size: 0 !important;
    line-height: 1.35;
  }

  .ia-page > .row:first-child p::after {
    content: "Ferramentas inteligentes para músicos.";
    font-size: 10px;
  }

  .ia-page > .row:first-child .d-flex {
    align-items: center !important;
  }
}


/* MOBILE ONLY — remove o vazio vertical herdado do Velzon e normaliza a leitura. */
@media (max-width: 767.98px) {
  .page-content {
    padding-top: 10px !important;
  }

  .ia-page {
    padding-top: 0 !important;
  }

  .ia-page > .row:first-child {
    padding-top: 0 !important;
    margin-top: 0 !important;
    margin-bottom: 10px !important;
  }

  .ia-page > .row:first-child > .col-12 {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }

  .ia-page > .row:first-child h4 {
    margin: 0 0 5px !important;
  }

  .ia-page > .row:first-child h4::after {
    font-size: 14px !important;
    line-height: 1.25;
  }

  .ia-page > .row:first-child p {
    margin: 0 !important;
  }

  .ia-page > .row:first-child p::after {
    font-size: 12px !important;
    line-height: 1.4;
  }
}


/* MOBILE ONLY — refinamento visual do header e menu. */
@media (max-width: 767.98px) {
  /* Header: conteúdo centralizado horizontal e verticalmente. */
  .ia-page > .row:first-child > .col-12 {
    display: flex !important;
    flex-direction: column;
    align-items: center !important;
    justify-content: center !important;
    text-align: center !important;
  }

  .ia-page > .row:first-child .d-flex {
    width: 100%;
    justify-content: center !important;
    align-items: center !important;
    gap: 8px !important;
  }

  .ia-page > .row:first-child h4,
  .ia-page > .row:first-child p {
    text-align: center !important;
  }

  /* Card do menu: mais respiro em cima e embaixo. */
  .ia-tool-tabs {
    padding-top: 10px !important;
    padding-bottom: 10px !important;
  }

  /* Títulos dos botões em negrito. */
  .ia-tool-tab {
    font-weight: 700 !important;
  }
}


/* MOBILE ONLY — reduz somente o espaço superior do header. */
@media (max-width: 767.98px) {
  .page-content {
    padding-top: 0 !important;
  }

  .ia-page > .row:first-child {
    padding-top: 0 !important;
    margin-top: -8px !important;
  }

  .ia-page > .row:first-child > .col-12 {
    padding-top: 0 !important;
  }
}


/* MOBILE ONLY — títulos dos botões com leitura confortável. */
@media (max-width: 767.98px) {
  .ia-tool-tab {
    font-size: 11px !important;
    font-weight: 700 !important;
    line-height: 1.2 !important;
  }
}

</style>