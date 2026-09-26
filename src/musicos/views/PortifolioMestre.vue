<!-- eslint-disable vue/no-unused-components -->
<template>
  <div class="container-fluid py-4 font-monospace">
    
    <!-- BARRA SUPERIOR: TÍTULO E BOTOES ADAPTADOS AO PADRÃO DO PAINEL -->
    <div class="d-flex flex-column flex-sm-row align-items-start align-items-sm-center justify-content-between mb-4 gap-3 animate__animated animate__fadeIn">
      <div class="text-start">
        <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase px-3 py-2 rounded-2 fs-12 mb-2 font-monospace" style="letter-spacing: 0.5px;">
          🚀 Vitrine Pública
        </span>
        <h3 class="fw-bold mb-1 text-uppercase fs-22" style="letter-spacing: -0.5px; color: var(--vz-heading-color);">Gestão do Perfil Artístico</h3>
        <p class="text-muted small mb-0 fs-13">Configure suas fotos, vídeos e textos comerciais para atrair contratantes corporativos.</p>
      </div>

      <!-- 👁️ BOTÃO DE PRÉ-VISUALIZAÇÃO PÚBLICA INTEGRADO AO PAINEL -->
      <a
        :href="`/artista/${artistSlug}`"
        target="_blank"
        rel="noopener noreferrer"
        class="btn btn-outline-primary fw-bold px-4 text-uppercase fs-13 d-flex align-items-center justify-content-center gap-2 rounded-3 shadow-sm"
        style="height: 40px; transition: all 0.3s ease;"
      >
        <i class="ri-eye-line fs-16"></i> Ver Minha Página Pública
      </a>
    </div>

    <!-- 🛠️ CORREÇÃO E INTUIÇÃO: Abas transformadas em botões pílula bem definidos acima do card -->
    <div class="row mb-4">
      <div class="col-12 text-start">
        <ul class="nav nav-pills nav-pills-custom gap-2" role="tablist">
          <li class="nav-item" role="presentation">
            <a class="nav-link active fw-bold py-2 px-4 fs-14 shadow-sm border text-uppercase" data-bs-toggle="tab" href="#aba-portfolio" role="tab">
              <i class="ri-image-line me-2 align-middle fs-16"></i> 1. Fotos e Vídeos
            </a>
          </li>
          <li class="nav-item" role="presentation">
            <a class="nav-link fw-bold py-2 px-4 fs-14 shadow-sm border text-uppercase" data-bs-toggle="tab" href="#aba-marketing" role="tab">
              <i class="ri-flashlight-line me-2 align-middle fs-16"></i> 2. Textos e Divulgação
            </a>
          </li>
        </ul>
      </div>
    </div>

    <!-- CARD MESTRE: INTEGRADO NATIVAMENTE AO LOOK & FEEL DO PAINEL DO VELZON -->
    <div class="card shadow-sm border-0 rounded-3">
      <div class="card-body p-4">
        <div class="tab-content">
          
          <!-- SUB-ABA 1: COMPONENTE DE FOTOS EXISTENTE -->
          <div class="tab-pane active" id="aba-portfolio" role="tabpanel">
            <PortifolioComponente />
          </div>

          <!-- SUB-ABA 2: FORMULÁRIO COMPLEMENTAR DE MARKETING -->
          <div class="tab-pane" id="aba-marketing" role="tabpanel">
            <VitrineComponente ref="filhoMarketing" />
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
// IMPORTAÇÕES DOS COMPONENTES E LÓGICA DE DADOS PRESERVADOS
import PortifolioComponente from "./Portfolio.vue";
import VitrineComponente from "./VitrineView.vue";
import axios from "axios";

export default {
  name: "PortifolioMestre",
  components: {
    PortifolioComponente,
    VitrineComponente
  },
  data() {
    return {
      artistSlug: ""
    };
  },
  methods: {
    async carregarSlugUsuario() {
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/me`); 
        if (response.data && response.data.slug) {
          // Preenche apenas a variável que o botão superior usa para abrir a página pública
          this.artistSlug = response.data.slug;
        }
      } catch (error) {
        console.error("Não foi possível carregar o slug do artista para a pré-visualização:", error);
      }
    }
  },
  mounted() {
    this.carregarSlugUsuario();
  }
};
</script>

<style scoped>
/* 🎨 ESTILIZAÇÃO DO MENU DE ABAS EM BOTÕES COMPACTOS PREMIUM */
.nav-pills-custom .nav-link {
  color: var(--vz-body-color) !important;
  background-color: var(--vz-card-bg-custom, #ffffff);
  border-color: rgba(0, 0, 0, 0.1) !important;
  transition: all 0.2s ease;
}
.nav-pills-custom .nav-link:hover {
  background-color: rgba(var(--vz-primary-rgb), 0.05);
  color: var(--vz-primary) !important;
}
.nav-pills-custom .nav-link.active {
  background-color: var(--vz-primary) !important;
  border-color: var(--vz-primary) !important;
  color: #ffffff !important;
}
</style>

<style scoped>
@media (max-width: 767.98px) {
  .container-fluid {
    padding: 12px 0 20px !important;
    width: calc(100% + 12px);
    max-width: none;
    margin-left: -6px;
    margin-right: -6px;
  }
  .container-fluid > .d-flex:first-child { align-items: center !important; text-align: center; margin-bottom: 14px !important; gap: 10px !important; }
  .container-fluid > .d-flex:first-child .text-start { text-align: center !important; width: 100%; }
  .container-fluid > .d-flex:first-child h3 { font-size: 18px !important; line-height: 1.15; margin-bottom: 6px !important; }
  .container-fluid > .d-flex:first-child p { font-size: 12px !important; line-height: 1.45; max-width: 330px; margin-left: auto; margin-right: auto; }
  .container-fluid > .d-flex:first-child .badge { font-size: 10px !important; padding: 6px 10px !important; }
  .container-fluid > .d-flex:first-child > a, .container-fluid > .d-flex:first-child > span { width: 100%; min-height: 44px; }
  .row.mb-4 { margin: 0 0 12px !important; }
  .row.mb-4 > .col-12 { padding-left: 0 !important; padding-right: 0 !important; }
  .nav-pills-custom { display: grid; grid-template-columns: 1fr 1fr; width: 100%; gap: 8px !important; }
  .nav-pills-custom .nav-item { width: 100%; }
  .nav-pills-custom .nav-link { width: 100%; padding: 10px 6px !important; font-size: 11px !important; text-align: center; min-height: 44px; display: flex; align-items: center; justify-content: center; }
  .card.shadow-sm.border-0.rounded-3 > .card-body { padding: 0 !important; }
}
</style>
