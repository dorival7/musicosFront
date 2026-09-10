<script>
import axios from 'axios';

export default {
  name: "ArtistPackagesManager",
  data() {
    return {
      loading: true,
      submittingAction: false,
      successMessage: null,
      errorMessage: null,

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
      isEditing: false
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
      this.successMessage = null;
      this.errorMessage = null;
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
        this.errorMessage = "Falha ao sincronizar formatos de shows com o servidor.";
        console.error("Erro no carregamento de pacotes:", error);
      }
    },

    // 2. SUBMIT UNIFICADO: Criação (POST) ou Edição (PUT) dependendo do estado do ID
    async handleSubmit() {
      this.successMessage = null;
      this.errorMessage = null;
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
          this.successMessage = "Formato de show updated com sucesso!";
        } else {
          await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/packages`, payload, config);
          this.successMessage = "Novo formato de show cadastrado com sucesso!";
        }

        this.resetForm();
        await this.loadPackagesData();
        this.submittingAction = false;
      } catch (error) {
        this.submittingAction = false;
        this.errorMessage = error.response?.data || error.response?.data?.message || "Erro ao salvar formato de show.";
      }
    },

    editPackage(item) {
      this.form.id = item.id;
      this.form.title = item.title;
      this.form.durationMinutes = item.durationMinutes;
      this.form.basePrice = item.basePrice;
      this.form.description = item.description || "";
      this.isEditing = true;
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },

    // 3. DELETE: Remove o formato de show fisicamente da tabela MySQL
    async deletePackage(id) {
      if (!confirm("Tem certeza que deseja remover este formato de show do seu catálogo?")) return;
      
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/tenants/packages/${id}`, config);
        this.successMessage = "Formato de show removido do catálogo público.";
        
        if (this.form.id === id) this.resetForm();
        await this.loadPackagesData();
      } catch (error) {
        this.errorMessage = "Falha ao excluir formato de show.";
      }
    },

    resetForm() {
      this.form.id = null;
      this.form.title = "";
      this.form.durationMinutes = 60;
      this.form.basePrice = 0;
      this.form.description = "";
      this.isEditing = false;
    }
  },

  mounted() {
    this.loadPackagesData();
  }
};
</script>


<template>
  <div>
    <!-- CABEÇALHO DA TELA PREMIUM VELZON -->
    <div class="row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary uppercase fw-bold tracking-wider fs-13">Gerenciar Meus Pacotes de Shows</h4>
          <div class="page-title-right">
            <!-- BADGE SUPERIOR TOTALMENTE DINÂMICO -->
            <span class="badge bg-primary px-3 py-2 fs-12 font-monospace shadow-sm">
              {{ currentPackagesCount }} de {{ totalPackagesPermitidos }} Limite do Plano utilizado
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- ALERTAS REATIVOS DE FEEDBACK -->
    <div v-if="successMessage" class="alert alert-success border-0 shadow-sm text-start mb-3" role="alert">
      <i class="ri-checkbox-circle-line me-2 align-middle fs-16"></i> {{ successMessage }}
    </div>

    <div v-if="errorMessage" class="alert alert-danger border-0 shadow-sm text-start mb-3" role="alert">
      <i class="ri-error-warning-line me-2 align-middle fs-16"></i> {{ errorMessage }}
    </div>

    <!-- SINALIZADOR DE REDE -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status"></div>
      <p class="text-muted mt-2 fs-13">Sincronizando catálogo comercial com o MariaDB...</p>
    </div>

    <div v-else class="row text-start animate__animated animate__fadeIn">
      <!-- COLUNA DA ESQUERDA: LISTAGEM DE FORMATOS CADASTRADOS -->
      <div class="col-xl-7">
        <h6 class="text-muted text-uppercase fw-bold fs-11 tracking-wider mb-3">Formatos de Apresentação Ativos</h6>
        
        <div class="vstack gap-3">
          <div v-if="packages.length === 0" class="card border border-dashed text-center p-4">
            <p class="text-muted mb-0 fs-13">Nenhum formato de show cadastrado ainda. Use o formulário ao lado para iniciar sua vitrine!</p>
          </div>

          <!-- CARDS DE SHOWS EM LAÇO V-FOR -->
          <div 
            class="card border border-start border-3 h-100 shadow-sm transition-all"
            v-for="item in packages" 
            :key="item.id"
            :class="form.id === item.id ? 'border-primary' : 'border-success'"
          >
            <div class="card-body p-4">
              <div class="d-flex justify-content-between align-items-start">
                <div class="flex-grow-1">
                  <h5 class="fw-bold text-dark mb-1">{{ item.title }}</h5>
                  <p class="text-muted small mb-2"><i class="ri-time-line me-1"></i> Duração: {{ item.durationMinutes }} minutos</p>
                </div>
                <div class="text-end">
                  <h4 class="fw-bold text-success font-monospace mb-0">{{ formatMoney(item.basePrice) }}</h4>
                  <small class="text-muted d-block">Preço Base</small>
                </div>
              </div>

              <div class="p-3 bg-light rounded border border-light my-3" v-if="item.description">
                <p class="text-muted mb-0 font-monospace fs-12 lh-base" style="white-space: pre-line;">{{ item.description }}</p>
              </div>

              <div class="d-flex justify-content-end gap-2 mt-2">
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

      <!-- COLUNA DA DIREITA: FORMULÁRIO DINÂMICO ADAPTATIVO -->
      <div class="col-xl-5">
        <h6 class="text-muted text-uppercase fw-bold fs-11 tracking-wider mb-3">
          {{ isEditing ? 'Editar Formato Selecionado' : 'Adicionar Novo Formato' }}
        </h6>

        <!-- BOX REATIVO DE ALERTA DE LIMITE (EXIBE 100% BASEADO NO LIMITE DO BANCO - NESTE CASO 5) -->
        <div v-if="isLimitReached && !isEditing" class="alert alert-warning border-0 shadow-sm p-3 mb-4 animate__animated animate__fadeIn">
          <h6 class="fw-bold text-warning mb-1 d-flex align-items-center gap-2 fs-13">
            <i class="ri-error-warning-fill fs-16"></i> Limite Máximo Atingido
          </h6>
          <p class="text-muted small mb-0 lh-base">
            Seu plano atual limita seu catálogo a <strong class="text-dark">{{ totalPackagesPermitidos }}</strong> formatos de shows ativos. Remova ou edite um formato ao lado.
          </p>
        </div>

        <!-- FORMULÁRIO DE CADASTRO -->
        <div class="card border-0 shadow-sm" :style="isLimitReached && !isEditing ? 'opacity: 0.65; cursor: not-allowed;' : ''">
          <div class="card-body p-4">
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
                  <label class="form-label fw-semibold text-dark fs-12">Preço Base do Cachê (R\$)</label>
                  <input type="number" class="form-control font-monospace" v-model="form.basePrice" step="0.01" min="0" required :disabled="isLimitReached && !isEditing">
                </div>
              </div>

              <div class="mb-4">
                <label class="form-label fw-semibold text-dark fs-12">Descrição Técnica / O que está incluso?</label>
                <textarea class="form-control font-monospace fs-12" rows="4" placeholder="Detalhes de sonorização, rider técnico básico e formação..." v-model="form.description" :disabled="isLimitReached && !isEditing"></textarea>
              </div>

              <div class="d-flex gap-2">
                <button v-if="isEditing" type="button" class="btn btn-light fw-bold flex-grow-1" @click="resetForm" :disabled="submittingAction">
                  Cancelar
                </button>
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
.transition-all {
  transition: all 0.2s ease;
}
.border-dashed {
  border-style: dashed !important;
}
</style>
