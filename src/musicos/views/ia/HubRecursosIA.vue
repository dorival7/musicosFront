<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="page-content" style="background-color: #f3f3f9 !important; min-height: 100vh; padding: 24px;">
    <div class="container-fluid">
      
      <!-- CABEÇALHO DO HUB DE IA (PADRÃO VELZON CLARO) -->
      <div class="row mb-4 text-start">
        <div class="col-12">
          <div class="d-flex align-items-center gap-2 mb-1">
            <h4 class="text-dark fw-bold font-monospace text-uppercase mb-0 fs-16" style="letter-spacing: 0.5px;">
              🧠 Central de Inteligência Artificial SevenShows
            </h4>
            <span class="badge bg-danger text-uppercase font-monospace fs-10 px-2 py-1 rounded" style="background-color: #ff6c22 !important;">PREMIUM</span>
          </div>
          <p class="text-muted small mb-0 font-monospace fs-13">Explore as ferramentas de IA integradas para acelerar e otimizar a sua carreira musical profissional.</p>
        </div>
      </div>

      <!-- 🆕 ABAS DE NAVEGAÇÃO INTERNAS (TABS PADRÃO LIGHT VELZON) -->
      <div class="row mb-3">
        <div class="col-12">
          <ul class="nav nav-tabs-custom rounded card-header-tabs border-bottom-0 d-flex gap-2 text-start" role="tablist" style="padding-left: 0;">
            <li class="nav-item" role="presentation">
              <button 
                type="button" 
                class="nav-link font-monospace text-uppercase fw-bold fs-12 py-2 px-4 position-relative border-0"
                :class="{ 'active text-primary bg-white shadow-sm rounded-top': abaAtiva === 'repertorio' }"
                @click="abaAtiva = 'repertorio'"
                style="transition: all 0.2s ease; color: abaAtiva === 'repertorio' ? '#ff6c22' : '#6c757d';"
              >
                🎸 Otimizar Repertório
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button 
                type="button" 
                class="nav-link font-monospace text-uppercase fw-bold fs-12 py-2 px-4 position-relative border-0"
                :class="{ 'active text-primary bg-white shadow-sm rounded-top': abaAtiva === 'cifras' }"
                @click="abaAtiva = 'cifras'"
                style="transition: all 0.2s ease; color: abaAtiva === 'cifras' ? '#ff6c22' : '#6c757d';"
              >
                🎼 Gerador de Cifras
              </button>
            </li>
          </ul>
        </div>
      </div>

      <!-- EXIBIÇÃO DINÂMICA DO RECURSO SELECIONADO -->
      <div class="row">
        <div class="col-12">
          
          <!-- ABRA 1: OTIMIZADOR DE REPERTÓRIO (ATIVO POR PADRÃO) -->
          <div v-if="abaAtiva === 'repertorio'" class="animate__animated animate__fadeIn">
            <SetlistOptimizerIA />
          </div>

          <!-- ABA 2: GERADOR E TRANSPOSITOR DE CIFRAS SMART -->
          <div v-if="abaAtiva === 'cifras'" class="animate__animated animate__fadeIn">
            <GeradorCifrasIA />
          </div>

        </div>
      </div>

    </div>
  </div>
</template>

<script>
// IMPORTAÇÃO DOS COMPONENTES MUSICAIS EXCLUSIVOS DE IA
import SetlistOptimizerIA from "./components/SetlistOptimizerIA.vue";
import GeradorCifrasIA from "./components/GeradorCifrasIA.vue";

export default {
  name: "HubRecursosIA",
  components: { 
    SetlistOptimizerIA, 
    GeradorCifrasIA 
  },
  data() {
    return {
      // 🎯 DEFINE O REPERTÓRIO COMO ATIVO PADRÃO LOGO NA INICIALIZAÇÃO DO HUB
      abaAtiva: "repertorio"
    };
  }
};
</script>

<style scoped>
/* Ajuste fino para dar o destaque de sotaque laranja comercial do Velzon nas abas ativas */
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
