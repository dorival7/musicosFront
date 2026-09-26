<script>
import axios from 'axios';
import Swal from 'sweetalert2';

export default {
  name: "ArtistPackagesManager",
  data() {
    return {
      loading: true,
      submittingAction: false,
      pendingSuccessMessage: null,

      // Matriz de pacotes lidos dinamicamente da tabela artist_packages
      packages: [],

      // Métricas e cotas móveis lidas do endpoint GetDashboardMetrics()
      currentPackagesCount: 0,
      totalPackagesPermitidos: 3, // Inicializa com fallback, mas é sobrescrito pela API

      // Estado do formulário de cadastro/edição
      form: {
        id: null,
        title: "",
        durationMinutes: 60,
        basePrice: 0,
        description: ""
      },
      isEditing: false,
      mobileFormOpen: false,
      expandedDescriptions: {}
    };
  },

  // 🆕 CHAVE UNIFICADA: Centraliza todas as propriedades calculadas em um único bloco limpo
  computed: {
    // TRAVA REATIVA ELÁSTICA: O botão só bloqueia se atingir o novo limite do BD (Agora 5)
    isLimitReached() {
      return this.currentPackagesCount >= this.totalPackagesPermitidos;
    },
    formatMoney() {
      return (val) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(val || 0);
    }
  },

  methods: {
    // 1. CARREGAMENTO CONCORRENTE: Busca o inventário e sincroniza os limites dinâmicos do MariaDB
    async loadPackagesData() {
      this.loading = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        const responseList = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/packages`, config);
        const responseMetrics = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/dashboard-metrics`, config);

        this.packages = responseList.data || [];
        
        // SINCRONIZAÇÃO ELÁSTICA: Herda as cotas reais configuradas na tabela saasplans
        this.currentPackagesCount = responseMetrics.data.pacotesCriados || 0;
        this.totalPackagesPermitidos = responseMetrics.data.totalPacotesPermitidos || responseMetrics.data.totalPacotesPermitidosNoPlano || 3;

        this.loading = false;
      } catch (error) {
        this.loading = false;
        console.error("Erro no carregamento de pacotes:", error);
        this.showVelzonAlert("error", "Falha na sincronização", "Falha ao sincronizar formatos de shows com o servidor.");
      }
    },

    // 2. SUBMIT UNIFICADO: Criação (POST) ou Edição (PUT) dependendo do estado do ID
    async handleSubmit() {
      this.submittingAction = true;

      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        
        const payload = {
          title: this.form.title,
          durationMinutes: parseInt(this.form.durationMinutes),
          basePrice: parseFloat(this.form.basePrice),
          description: this.form.description
        };

        if (this.isEditing) {
          await axios.put(`${process.env.VUE_APP_API_BASE_URL}/tenants/packages/${this.form.id}`, payload, config);
          this.pendingSuccessMessage = "Formato de show atualizado com sucesso!";
        } else {
          await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/packages`, payload, config);
          this.pendingSuccessMessage = "Novo formato de show cadastrado com sucesso!";
        }

        this.resetForm();
        await this.loadPackagesData();
        this.submittingAction = false;
        this.showVelzonAlert("success", "Tudo certo!", this.pendingSuccessMessage);
        this.pendingSuccessMessage = null;
      } catch (error) {
        this.submittingAction = false;
        const message = error.response?.data?.message || (typeof error.response?.data === "string" ? error.response.data : null) || "Erro ao salvar formato de show.";
        this.showVelzonAlert("error", "Não foi possível salvar", message);
      }
    },

    formatCurrencyInput(value) {
      const digits = String(value ?? "").replace(/\D/g, "");
      const cents = Number(digits || 0);
      return new Intl.NumberFormat("pt-BR", {
        style: "currency",
        currency: "BRL",
        minimumFractionDigits: 2
      }).format(cents / 100);
    },

    handleBasePriceInput(event) {
      const masked = this.formatCurrencyInput(event.target.value);
      event.target.value = masked;
      const digits = masked.replace(/\D/g, "");
      this.form.basePrice = Number(digits || 0) / 100;
    },

    basePriceDisplay() {
      const cents = Math.round((Number(this.form.basePrice) || 0) * 100);
      return this.formatCurrencyInput(String(cents));
    },

    toggleDescription(id) {
      this.expandedDescriptions = {
        ...this.expandedDescriptions,
        [id]: !this.expandedDescriptions[id]
      };
    },

    openNewPackageForm() {
      if (this.isLimitReached) return;
      this.resetForm();
      this.mobileFormOpen = true;
      this.$nextTick(() => {
        const form = this.$refs.packageForm;
        if (form && window.innerWidth < 768) {
          form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    },

    editPackage(item) {
      this.form.id = item.id;
      this.form.title = item.title;
      this.form.durationMinutes = item.durationMinutes;
      this.form.basePrice = item.basePrice;
      this.form.description = item.description || "";
      this.isEditing = true;
      this.mobileFormOpen = true;
      this.$nextTick(() => {
        const form = this.$refs.packageForm;
        if (form && window.innerWidth < 768) {
          form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }
      });
    },

    // 3. DELETE: Remove o formato de show fisicamente da tabela MySQL
    async deletePackage(id) {
      const result = await Swal.fire({
        title: "Excluir formato?",
        text: "Este formato será removido do seu catálogo público.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Sim, excluir",
        cancelButtonText: "Cancelar",
        confirmButtonColor: "#f06548",
        cancelButtonColor: "#878a99",
        reverseButtons: true
      });

      if (!result.isConfirmed) return;

      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/tenants/packages/${id}`, config);

        if (this.form.id === id) this.resetForm();
        await this.loadPackagesData();
        this.showVelzonAlert("success", "Formato excluído", "Formato de show removido do catálogo público.");
      } catch (error) {
        this.showVelzonAlert("error", "Não foi possível excluir", "Falha ao excluir formato de show.");
      }
    },

    showVelzonAlert(icon, title, text) {
      return Swal.fire({
        title,
        text,
        icon,
        confirmButtonText: "Fechar",
        confirmButtonColor: icon === "error" ? "#f06548" : "#0ab39c",
        customClass: { popup: "rounded-3" }
      });
    },

    resetForm() {
      this.form.id = null;
      this.form.title = "";
      this.form.durationMinutes = 60;
      this.form.basePrice = 0;
      this.form.description = "";
      this.isEditing = false;
      this.mobileFormOpen = false;
    }
  },

  mounted() {
    this.loadPackagesData();
  }
};
</script>


<template>
  <div class="packages-page">
    <div class="row packages-title-row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between packages-title-box">
          <h4 class="mb-sm-0 text-primary uppercase fw-bold tracking-wider fs-13 packages-page-title">Gerenciar Meus Pacotes de Shows</h4>
          <div class="page-title-right packages-title-actions">
            <button
              v-if="!isLimitReached"
              type="button"
              class="btn btn-primary btn-sm fw-bold mobile-new-package-btn"
              @click="openNewPackageForm"
            >
              <i class="ri-add-line me-1"></i> Novo formato
            </button>
            <span class="badge bg-primary px-3 py-2 fs-12 font-monospace shadow-sm package-limit-badge">
              {{ currentPackagesCount }} de {{ totalPackagesPermitidos }} Limite do Plano utilizado
            </span>
          </div>
        </div>
      </div>
    </div>

    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status"></div>
      <p class="text-muted mt-2 fs-13">Sincronizando catálogo comercial com o MariaDB...</p>
    </div>

    <div v-else class="row text-start animate__animated animate__fadeIn packages-content-row">
      <div class="col-xl-7 packages-list-column">
        <h6 class="text-muted text-uppercase fw-bold fs-11 tracking-wider mb-3 section-label">Formatos de Apresentação Ativos</h6>

        <div class="vstack gap-3 package-stack">
          <div v-if="packages.length === 0" class="card border border-dashed text-center p-4">
            <p class="text-muted mb-0 fs-13">Nenhum formato de show cadastrado ainda. Use o botão “Novo formato” para iniciar sua vitrine.</p>
          </div>

          <div
            class="card border border-start border-3 h-100 shadow-sm transition-all package-card"
            v-for="item in packages"
            :key="item.id"
            :class="form.id === item.id ? 'border-primary' : 'border-success'"
          >
            <div class="card-body p-4 package-card-body">
              <div class="d-flex justify-content-between align-items-start package-summary">
                <div class="flex-grow-1 package-main-info">
                  <h5 class="fw-bold text-dark mb-1 package-name">{{ item.title }}</h5>
                  <p class="text-muted small mb-0 package-duration"><i class="ri-time-line me-1"></i> {{ item.durationMinutes }} minutos</p>
                </div>
                <div class="text-end package-price-wrap">
                  <h4 class="fw-bold text-success font-monospace mb-0 package-price">{{ formatMoney(item.basePrice) }}</h4>
                  <small class="text-muted d-block">Preço Base</small>
                </div>
              </div>

              <button
                v-if="item.description"
                type="button"
                class="btn package-details-toggle d-md-none"
                @click="toggleDescription(item.id)"
              >
                <span><i class="ri-file-list-3-line me-1"></i> Detalhes do formato</span>
                <i :class="expandedDescriptions[item.id] ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
              </button>

              <div
                class="p-3 bg-light rounded border border-light my-3 package-description"
                :class="{ 'mobile-description-open': expandedDescriptions[item.id] }"
                v-if="item.description"
              >
                <p class="text-muted mb-0 font-monospace fs-12 lh-base" style="white-space: pre-line;">{{ item.description }}</p>
              </div>

              <div class="d-flex justify-content-end gap-2 mt-2 package-actions">
                <button type="button" class="btn btn-sm btn-soft-info fw-bold" @click="editPackage(item)">
                  <i class="ri-edit-box-line me-1"></i> Editar
                </button>
                <button type="button" class="btn btn-sm btn-soft-danger fw-bold" @click="deletePackage(item.id)">
                  <i class="ri-delete-bin-line me-1"></i> Excluir
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-xl-5 package-form-column" ref="packageForm" :class="{ 'mobile-form-open': mobileFormOpen || isEditing }">
        <div class="package-form-heading">
          <h6 class="text-muted text-uppercase fw-bold fs-11 tracking-wider mb-3">
            {{ isEditing ? 'Editar Formato Selecionado' : 'Adicionar Novo Formato' }}
          </h6>
          <button v-if="mobileFormOpen || isEditing" type="button" class="btn btn-sm btn-light d-md-none" @click="resetForm">
            <i class="ri-close-line"></i>
          </button>
        </div>

        <div v-if="isLimitReached && !isEditing" class="alert alert-warning border-0 shadow-sm p-3 mb-4 animate__animated animate__fadeIn">
          <h6 class="fw-bold text-warning mb-1 d-flex align-items-center gap-2 fs-13">
            <i class="ri-error-warning-fill fs-16"></i> Limite Máximo Atingido
          </h6>
          <p class="text-muted small mb-0 lh-base">
            Seu plano atual limita seu catálogo a <strong class="text-dark">{{ totalPackagesPermitidos }}</strong> formatos de shows ativos. Remova ou edite um formato.
          </p>
        </div>

        <div class="card border-0 shadow-sm package-form-card" :style="isLimitReached && !isEditing ? 'opacity: 0.65; cursor: not-allowed;' : ''">
          <div class="card-body p-4 package-form-body">
            <form @submit.prevent="handleSubmit">
              <div class="mb-3">
                <label class="form-label fw-semibold text-dark fs-12">Título do Formato / Nome do Show</label>
                <input type="text" class="form-control" placeholder="Ex: Show Acústico Voz e Violão" v-model="form.title" required :disabled="isLimitReached && !isEditing">
              </div>
              <div class="row g-3 mb-3">
                <div class="col-sm-6">
                  <label class="form-label fw-semibold text-dark fs-12">Duração (Minutos)</label>
                  <input type="number" class="form-control font-monospace" v-model="form.durationMinutes" min="15" required :disabled="isLimitReached && !isEditing">
                </div>
                <div class="col-sm-6">
                  <label class="form-label fw-semibold text-dark fs-12">Preço Base do Cachê (R$)</label>
                  <input
                    type="text"
                    class="form-control font-monospace"
                    :value="basePriceDisplay()"
                    @input="handleBasePriceInput"
                    inputmode="numeric"
                    autocomplete="off"
                    required
                    :disabled="isLimitReached && !isEditing"
                  >
                </div>
              </div>
              <div class="mb-4">
                <label class="form-label fw-semibold text-dark fs-12">Descrição Técnica / O que está incluso?</label>
                <textarea class="form-control font-monospace fs-12" rows="4" placeholder="Detalhes de sonorização, rider técnico básico e formação..." v-model="form.description" :disabled="isLimitReached && !isEditing"></textarea>
              </div>
              <div class="d-flex gap-2">
                <button v-if="isEditing" type="button" class="btn btn-light fw-bold flex-grow-1" @click="resetForm" :disabled="submittingAction">Cancelar</button>
                <button type="submit" class="btn fw-bold flex-grow-1 text-white shadow-sm" :class="isEditing ? 'btn-info' : 'btn-primary'" :disabled="(isLimitReached && !isEditing) || submittingAction">
                  <i class="ri-save-line me-1" v-if="!submittingAction"></i>
                  {{ submittingAction ? 'Salvando...' : (isEditing ? 'Salvar Alterações' : 'Cadastrar Formato') }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.transition-all { transition: all 0.2s ease; }
.border-dashed { border-style: dashed !important; }
.mobile-new-package-btn { display: none; }
.package-details-toggle { display: none; }

@media (max-width: 767.98px) {
  .packages-page { margin-left: -12px; margin-right: -12px; }
  .packages-title-row, .packages-content-row { margin-left: 0; margin-right: 0; }
  .packages-title-row > .col-12, .packages-list-column, .package-form-column { padding-left: 6px; padding-right: 6px; }
  .packages-title-box { padding: 12px 6px 10px; margin-bottom: 10px; display: block !important; }
  .packages-page-title { text-align: center; font-size: 13px !important; margin-bottom: 10px !important; }
  .packages-title-actions { display: flex; flex-wrap: wrap; justify-content: center; gap: 8px; }
  .mobile-new-package-btn { display: inline-flex; align-items: center; justify-content: center; min-height: 40px; padding: 8px 14px; border-radius: 7px; }
  .package-limit-badge { display: inline-flex; align-items: center; justify-content: center; min-height: 40px; }
  .section-label { margin: 4px 6px 10px !important; font-size: 11px !important; }
  .package-stack { gap: 10px !important; }
  .package-card { margin: 0; border-width: 1px !important; border-left-width: 3px !important; }
  .package-card-body { padding: 14px !important; }
  .package-summary { gap: 10px; }
  .package-name { font-size: 15px; line-height: 1.15; margin-bottom: 5px !important; }
  .package-duration { font-size: 11px !important; }
  .package-price-wrap { flex: 0 0 auto; }
  .package-price { font-size: 17px !important; }
  .package-price-wrap small { font-size: 10px; }
  .package-details-toggle { display: flex; width: 100%; align-items: center; justify-content: space-between; margin-top: 12px; padding: 9px 11px; background: #eef7f8; border: 1px solid #d9e8ea; color: #087f83; font-weight: 700; font-size: 12px; border-radius: 6px; }
  .package-description { display: none; margin: 8px 0 0 !important; padding: 11px !important; }
  .package-description.mobile-description-open { display: block; }
  .package-description p { font-size: 11px !important; }
  .package-actions { margin-top: 12px !important; }
  .package-actions .btn { min-height: 38px; padding-left: 14px; padding-right: 14px; }
  .package-form-column { display: none; margin-top: 12px; scroll-margin-top: 80px; }
  .package-form-column.mobile-form-open { display: block; }
  .package-form-heading { display: flex; align-items: center; justify-content: space-between; padding: 0 6px; }
  .package-form-heading h6 { margin-bottom: 8px !important; }
  .package-form-card { margin-bottom: 8px; }
  .package-form-body { padding: 14px !important; }
  .package-form-body .form-control { min-height: 46px; font-size: 14px; }
  .package-form-body textarea.form-control { min-height: 110px; }
  .package-form-body .form-label { font-size: 12px !important; margin-bottom: 6px; }
  .package-form-body .btn { min-height: 44px; }
}
</style>
