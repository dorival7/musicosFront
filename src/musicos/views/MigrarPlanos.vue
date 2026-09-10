<script>
import axios from 'axios';

export default {
  name: "ArtistPlanMigration",
  data() {
    return {
      loading: true,
      submittingAction: false,
      successMessage: null,
      errorMessage: null,

      // ID e Nome do plano atual guardados de forma segura em RAM para realce visual
      userCurrentSaaSPlanId: "",
      userCurrentPlanName: "",

      // Matriz dinâmica lida da tabela saasplans
      availablePlans: [],

      // Inventário real do músico coletado concorrentemente do MariaDB
      currentInventory: {
        photosCount: 0,
        videosCount: 0,
        packagesCount: 0
      },

      // Controle reativo do Modal Educativo de Bloqueio do Velzon
      downgradeModal: {
        show: false,
        targetPlanName: "",
        restrictionsList: []
      }
    };
  },

  computed: {
    formatMoney() {
      return (val) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(val || 0);
    },

    // Devolve o nome do plano ativo para o banner de cabeçalho
    currentPlanName() {
      if (this.userCurrentPlanName) return this.userCurrentPlanName;
      if (!this.availablePlans || this.availablePlans.length === 0) return "Carregando...";
      const planoEncontrado = this.availablePlans.find(p => this.isCurrentPlan(p));
      return planoEncontrado ? planoEncontrado.name : "Plano Bronze";
    }
  },

  methods: {
    // Função mestre de checagem tipada segura contra flutuações da API
    isCurrentPlan(plan) {
      if (!plan) return false;
      const matchId = this.userCurrentSaaSPlanId && 
                      String(plan.id).trim().toLowerCase() === String(this.userCurrentSaaSPlanId).trim().toLowerCase();
      const matchNome = this.userCurrentPlanName && 
                        String(plan.name).trim().toLowerCase() === String(this.userCurrentPlanName).trim().toLowerCase();
      return !!(matchId || matchNome);
    },

    // 1. CARREGAMENTO DOS ENDPOINTS DO .NET 10 E CENTRALIZAÇÃO DO INVENTÁRIO
    async loadMigrationDashboard() {
      this.loading = true;
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        const responsePlans = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/saas-products`);
        const responseMe = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/me`, config);
        const responseMetrics = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/dashboard-metrics`, config);

        this.availablePlans = responsePlans.data || [];
        
        // Mapeamento de chaves vindas do DTO em C#
        this.userCurrentSaaSPlanId = responseMe.data.saasPlanId || responseMe.data.saaSPlanId || responseMe.data.plan?.id || "";
        this.userCurrentPlanName = responseMe.data.plan?.name || responseMe.data.saasPlanName || "";

        // ALIMENTAÇÃO DO INVENTÁRIO: Extrai os volumes físicos reais salvos no banco
        const totalFotosPermitidas = responseMetrics.data.totalFotosPermitidasNoPlano || 5;
        const fotosRestantes = responseMetrics.data.fotosRestantesDisponiveis || 0;
        
        this.currentInventory.photosCount = Math.max(totalFotosPermitidas - fotosRestantes, 0);
        this.currentInventory.packagesCount = responseMetrics.data.pacotesCriados || 0;
        this.currentInventory.videosCount = responseMetrics.data.videosCriados || 0;

        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.errorMessage = "Falha ao ler o catálogo dinâmico de planos do servidor.";
        console.error("Erro no carregamento de migração:", error);
      }
    },

    // 2. DISPARO DA MIGRAÇÃO CONDICIONADA À AUDITORIA DE DOWNGRADE COM BLINDAGEM DE NULOS
    async handleMigratePlan(plan) {
      if (!plan || !plan.id || this.isCurrentPlan(plan)) return;

      this.successMessage = null;
      this.errorMessage = null;

      // 🛠️ BLINDAGEM DE VALORES AUSENTES: Extrai as propriedades aplicando o curto-circuito fallback do JavaScript
      const targetMaxPhotos = plan.maxPhotosCount !== undefined ? plan.maxPhotosCount : (plan.maxPhotosLimit || 999);
      const targetMaxVideos = plan.maxVideosCount !== undefined ? plan.maxVideosCount : (plan.maxVideosLimit || 999);
      const targetMaxPackages = plan.maxShowsPerMonth !== undefined ? plan.maxShowsPerMonth : (plan.maxPackagesLimit || 999);

      this.downgradeModal.restrictionsList = [];
      
      // Validação 1: Fotos excedentes
      if (this.currentInventory.photosCount > targetMaxPhotos) {
        this.downgradeModal.restrictionsList.push({
          label: `Fotos no Portfólio`,
          atual: this.currentInventory.photosCount,
          limite: targetMaxPhotos,
          excesso: this.currentInventory.photosCount - targetMaxPhotos,
          acao: "excluir"
        });
      }

      // Validação 2: Vídeos excedentes
      if (this.currentInventory.videosCount > targetMaxVideos) {
        this.downgradeModal.restrictionsList.push({
          label: `Vídeos Integrados`,
          atual: this.currentInventory.videosCount,
          limite: targetMaxVideos,
          excesso: this.currentInventory.videosCount - targetMaxVideos,
          acao: "remover"
        });
      }

      // Validação 3: Formatos de shows excedentes
      if (this.currentInventory.packagesCount > targetMaxPackages) {
        this.downgradeModal.restrictionsList.push({
          label: `Formatos de Shows`,
          atual: this.currentInventory.packagesCount,
          limite: targetMaxPackages,
          excesso: this.currentInventory.packagesCount - targetMaxPackages,
          acao: "deletar ou desativar"
        });
      }

      // SE HOUVER BLOQUEIO LEGÍTIMO DE VOLUME, ABRE O MODAL E PARALISA
      if (this.downgradeModal.restrictionsList.length > 0) {
        this.downgradeModal.targetPlanName = plan.name;
        this.downgradeModal.show = true;
        return;
      }

      // DISPARO SEGURO CONTRA A REDE: Se passou na auditoria, executa o POST do upgrade
      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        const payload = { newSaaSPlanId: plan.id };
        
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/me/migrate-plan`, payload, config);

        this.successMessage = "Plano atualizado com sucesso! Sincronizando novos limites e redirecionando...";
        localStorage.setItem('profileStatus', 'Active');

        setTimeout(() => {
          this.submittingAction = false;
          this.$router.push("/musicos/dashboard");
        }, 2000);

      } catch (error) {
        this.submittingAction = false;
        this.errorMessage = error.response?.data?.message || "Erro ao processar a migração do plano no servidor backend.";
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },

    closeDowngradeModal() {
      this.downgradeModal.show = false;
    }
  },

  mounted() {
    this.loadMigrationDashboard();
  }
};
</script>


<template>
  <div>
    <!-- 1. CABEÇALHO DA TELA NATIVO DO VELZON -->
    <div class="row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary">Alterar Plano de Assinatura</h4>
          <div class="page-title-right">
            <button type="button" class="btn btn-sm btn-light fw-bold shadow-sm" @click="goBackToBilling" :disabled="submittingAction">
              <i class="ri-arrow-left-line me-1 align-middle"></i> Voltar ao Financeiro
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- CENTRAL DE BALÕES DE ALERTAS E FEEDBACKS REATIVOS -->
    <div v-if="successMessage" class="alert alert-success border-0 shadow-sm text-start animate__animated animate__fadeIn" role="alert">
      <i class="ri-checkbox-circle-line me-2 align-middle fs-16"></i>
      {{ successMessage }}
    </div>

    <div v-if="errorMessage" class="alert alert-danger alert-dismissible fade show border-0 shadow-sm text-start animate__animated animate__shakeX" role="alert">
      <i class="ri-error-warning-line me-2 align-middle fs-16"></i>
      {{ errorMessage }}
      <button type="button" class="btn-close" @click="errorMessage = null" aria-label="Close"></button>
    </div>

    <!-- SINALIZADOR DE CARREGAMENTO INICIAL -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status"></div>
      <p class="text-muted mt-2 fs-13">Buscando tabelas de planos e cotas no MariaDB...</p>
    </div>

    <div v-else class="animate__animated animate__fadeIn">
      <!-- 2. PRESENTATION PREMIUM DO TEXTO ENVELOPADO COM SINALIZAÇÃO DE PLANO ATUAL -->
      <div class="row justify-content-center mb-4">
        <div class="col-xl-8">
          <div class="alert alert-info border-0 shadow-sm rounded-3 p-3 text-start d-flex align-items-start gap-3 animate__animated animate__fadeIn">
            <div class="avatar-xs flex-shrink-0">
              <span class="avatar-title bg-soft-info text-info rounded-circle fs-16">
                <i class="ri-vip-crown-2-line"></i>
              </span>
            </div>
            <div class="flex-grow-1">
              <h6 class="fw-bold text-info mb-1 fs-13">
                Seu Plano Ativo: <span class="badge bg-info text-white font-monospace ms-1 px-2 py-1 fs-11 fw-bold">{{ currentPlanName }}</span>
              </h6>
              <p class="text-muted fs-13 mb-0 lh-base">
                Escolha o plano ideal para o momento da sua carreira. Ao migrar de categoria, seus novos limites de armazenamento para fotos e vídeos são liberados instantaneamente, e o sistema atualiza automaticamente suas mensalidades de forma proporcional para você focar apenas no que importa: o seu show.
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- 3. CARDS DE PREÇOS DINÂMICOS EM LAÇO V-FOR COM DUPLA VALIDAÇÃO -->
      <div class="row justify-content-center g-4">
        <div 
          class="col-xl-4 col-md-6" 
          v-for="plan in availablePlans" 
          :key="plan.id"
        >
          <!-- ELEVAÇÃO ESTÉTICA BLINDADA: Passa o objeto completo do plano para o método seguro -->
          <div 
            class="card pricing-box border h-100 shadow-sm transition-all"
            :class="isCurrentPlan(plan) ? 'border-success border-2 bg-soft-success-subtle' : 'border-light bg-white'"
          >
            <div class="card-body p-4 text-center d-flex flex-column justify-content-between">
              <div>
                <!-- ETIQUETA VISUAL NO TOPO DO CARD ATIVO -->
                <div class="text-end mb-2" style="min-height: 24px;">
                  <span 
                    v-if="isCurrentPlan(plan)" 
                    class="badge bg-success px-2 py-1 fs-10 rounded font-monospace fw-bold shadow-sm"
                  >
                    <i class="ri-check-line me-1"></i> SEU PLANO ATUAL
                  </span>
                </div>

                <!-- CABEÇALHO DO PRODUTO DINÂMICO -->
                <div class="mb-4">
                  <h4 class="fw-bold text-dark mb-1">{{ plan.name }}</h4>
                  <p class="text-muted small mb-0">{{ plan.description }}</p>
                </div>

                <!-- VALOR DO PRODUTO ORIUNDO DO BANCO DE DADOS -->
                <div class="p-3 rounded border mb-4" :class="isCurrentPlan(plan) ? 'bg-white border-success-subtle' : 'bg-light border-light'">
                  <h1 class="fw-bold text-primary mb-0 font-monospace fs-28">
                    {{ formatMoney(plan.monthlyFee) }}<span class="fs-13 text-muted fw-normal">/mês</span>
                  </h1>
                </div>

                <!-- LISTAGEM DE LIMITES MÓVEIS REAIS E EXPLICATIVOS -->
                <ul class="list-unstyled text-start vstack gap-3 text-muted fs-13 mb-4 ps-1">
                  <li class="d-flex align-items-center gap-2">
                    <i class="ri-checkbox-circle-fill text-success fs-15"></i>
                    <span>Até <strong class="text-dark font-monospace">{{ plan.maxPhotosCount }}</strong> fotos na galeria pública</span>
                  </li>
                  <li class="d-flex align-items-center gap-2">
                    <i class="ri-checkbox-circle-fill text-success fs-15"></i>
                    <span>Até <strong class="text-dark font-monospace">{{ plan.maxVideosCount }}</strong> vídeos integrados do YouTube</span>
                  </li>
                  <li class="d-flex align-items-center gap-2">
                    <i class="ri-checkbox-circle-fill text-success fs-15"></i>
                    <span>Até <strong class="text-dark font-monospace">{{ plan.maxShowsPerMonth }}</strong> formatos de shows cadastrados na vitrine</span>
                  </li>
                  <li class="d-flex align-items-center gap-2">
                    <i class="ri-checkbox-circle-fill text-success fs-15"></i>
                    <span>Taxa operacional padrão de intermediação: <strong class="text-dark font-monospace">{{ plan.defaultTakeRatePercent }}%</strong></span>
                  </li>
                </ul>
              </div>
              <!-- BOTÃO DE AÇÃO DO RODAPÉ COM TRAVA DE SEGURANÇA CORRIGIDA -->
              <div>
                <!-- Se for o plano atual detetado por nome/id, vira o selo "Plano Ativo" desabilitado -->
                <button 
                  v-if="isCurrentPlan(plan)"
                  type="button" 
                  class="btn btn-success w-100 fw-bold p-2 text-white shadow-none" 
                  style="cursor: not-allowed; opacity: 0.95;"
                  disabled
                >
                  <i class="ri-checkbox-circle-line me-1"></i> Plano Ativo
                </button>
                
                <!-- Outros Planos: Liberado para Upgrade / Auditoria preventiva de Downgrade -->
                <button 
                  v-else
                  type="button" 
                  class="btn btn-outline-primary w-100 fw-bold p-2 shadow-sm"
                  :disabled="submittingAction"
                  @click="handleMigratePlan(plan)"
                >
                  <i class="ri-shuffle-line me-1" v-if="!submittingAction"></i>
                  {{ submittingAction ? "Migrando no Asaas..." : "Migrar para este Plano" }}
                </button>
              </div>

            </div>
          </div>
        </div>
      </div>

      <!-- 4. MODAL EDUCATIVO DE RESTRIÇÃO DE DOWNGRADE (PROATIVO) -->
      <div v-if="downgradeModal.show" class="modal fade show d-block" tabindex="-1" style="background: rgba(0, 0, 0, 0.5); z-index: 1060;">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content border-0 shadow animate__animated animate__zoomIn animate__fast">
            
            <div class="modal-header bg-soft-warning border-0 p-3 align-items-center">
              <h5 class="modal-title text-warning fw-bold d-flex align-items-center gap-2 fs-15">
                <i class="ri-alert-line fs-18"></i> Ajuste de Inventário Necessário
              </h5>
              <button type="button" class="btn-close" @click="closeDowngradeModal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4 text-start">
              <p class="text-muted fs-13 mb-3">
                Para migrar o seu perfil para o plano <strong class="text-dark">{{ downgradeModal.targetPlanName }}</strong>, você precisa primeiro adequar os volumes antigos ou novos do seu portfólio aos limites permitidos da nova categoria.
              </p>

              <h6 class="fw-bold text-dark fs-12 text-uppercase mb-2 font-monospace">Pendências Detectadas em RAM:</h6>
              
              <div class="vstack gap-2">
                <div 
                  class="p-3 border rounded border-dashed border-danger bg-soft-danger-subtle d-flex align-items-center gap-3"
                  v-for="(item, index) in downgradeModal.restrictionsList" 
                  :key="index"
                >
                  <div class="avatar-xs flex-shrink-0">
                    <span class="avatar-title bg-danger text-white rounded-circle fs-14">
                      <i class="ri-close-line"></i>
                    </span>
                  </div>
                  <div class="flex-grow-1 fs-13">
                    <h6 class="fw-bold text-danger mb-0 fs-13">{{ item.label }}</h6>
                    <small class="text-muted d-block mt-0.5">
                      Você possui <strong class="text-dark font-monospace">{{ item.atual }}</strong> itens cadastrados, mas o limite é <strong class="text-dark font-monospace">{{ item.limite }}</strong>.
                    </small>
                    <span class="badge bg-soft-danger text-danger fs-11 mt-1 font-monospace">
                      Ação: É necessário {{ item.acao }} {{ item.excesso }} {{ item.excesso === 1 ? 'item' : 'itens' }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div class="modal-footer bg-light border-0 p-3 justify-content-between">
              <p class="text-muted fs-11 mb-0 flex-grow-1 pe-2">
                Acesse as abas específicas no menu lateral esquerdo para efetuar as limpezas.
              </p>
              <button type="button" class="btn btn-light fw-bold shadow-sm px-4 btn-sm" @click="closeDowngradeModal">
                Entendido
              </button>
            </div>

          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<style scoped>
.pricing-box {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.pricing-box:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.08) !important;
}
.bg-soft-success-subtle {
  background-color: rgba(25, 135, 84, 0.03) !important;
}
</style>
