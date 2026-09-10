<script>
import axios from 'axios';

export default {
  name: "ArtistWalletManager",
  data() {
    return {
      loading: true,
      submittingAction: false,
      successMessage: null,
      errorMessage: null,
      walletId: "",          
      accountStatus: "",     
      onboardingLink: "",    
      personType: "Physical", 
      walletTransactions: [],
      kycFiles: { identity: null, address: null, selfie: null, business: null },
      filters: { type: "ALL", status: "ALL", period: "TOTAL" }
    };
  },
  computed: {
    identityFileName() { return this.kycFiles.identity ? this.kycFiles.identity.name : null; },
    addressFileName() { return this.kycFiles.address ? this.kycFiles.address.name : null; },
    selfieFileName() { return this.kycFiles.selfie ? this.kycFiles.selfie.name : null; },
    businessFileName() { return this.kycFiles.business ? this.kycFiles.business.name : null; },
    saldoDisponivel() {
      const entradas = this.walletTransactions.filter(t => t.type === 'Receivable' && t.isReleased).reduce((s, t) => s + t.value, 0);
      const saques = this.walletTransactions.filter(t => t.type === 'Payout').reduce((s, t) => s + t.value, 0);
      return Math.max(entradas - saques, 0);
    },
    cachesAReceber() {
      return this.walletTransactions.filter(t => t.type === 'Receivable' && !t.isReleased).reduce((s, t) => s + t.value, 0);
    },
    transacoesFiltradas() {
      const hoje = new Date(); hoje.setHours(23, 59, 59, 999);
      return this.walletTransactions.filter(t => {
        if (this.filters.type !== "ALL" && t.type !== this.filters.type) return false;
        if (this.filters.status !== "ALL" && (t.isReleased ? "LIBERADO" : "RETIDO") !== this.filters.status) return false;
        if (this.filters.period !== "TOTAL" && t.createdAt) {
          const dt = new Date(t.createdAt);
          if (this.filters.period === "MONTH" && (dt.getMonth() !== hoje.getMonth() || dt.getFullYear() !== hoje.getFullYear())) return false;
          if (this.filters.period === "30_DAYS" && dt < new Date(hoje.setDate(hoje.getDate() - 30))) return false;
        }
        return true;
      });
    }
  },
  methods: {
    async loadWalletCompliance() {
      this.loading = true; this.successMessage = null; this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/me`, config);
        this.walletId = response.data.asaasWalletId || "";
        this.accountStatus = response.data.asaasAccountStatus || "NOT_CREATED";
        this.onboardingLink = response.data.onboardingLink || "";
        this.personType = response.data.personType || "Physical";
        if (this.accountStatus === 'APPROVED') await this.loadWalletTransactions();
        this.loading = false;
      } catch (e) { this.loading = false; this.errorMessage = "Falha ao ler status da carteira."; }
    },
    async loadWalletTransactions() {
      try {
        const token = localStorage.getItem('jwt');
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/transactions`, { headers: { Authorization: `Bearer ${token}` } });
        this.walletTransactions = response.data || [];
      } catch (e) { console.error(e); }
    },
    onFileSelected(event, key) {
      if (event.target.files && event.target.files.length > 0) this.kycFiles[key] = event.target.files[0];
      else this.kycFiles[key] = null;
    },
    async handleUploadKYCDocuments() {
      this.successMessage = null; this.errorMessage = null;
      if (!this.kycFiles.identity || !this.kycFiles.address) { this.errorMessage = "Selecione os documentos obrigatórios."; return; }
      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const formData = new FormData();
        formData.append("identityFile", this.kycFiles.identity);
        formData.append("addressFile", this.kycFiles.address);
        if (this.personType === 'Physical') formData.append("selfieFile", this.kycFiles.selfie);
        else formData.append("businessFile", this.kycFiles.business);
        const res = await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/upload-documents`, formData, { headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'multipart/form-data' } });
        this.successMessage = res.data.message; this.accountStatus = "PENDING";
        this.kycFiles = { identity: null, address: null, selfie: null, business: null };
      } catch (e) { this.errorMessage = "Erro no upload."; } finally { this.submittingAction = false; }
    },
    async handleConnectWallet() {
      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const res = await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/connect`, {}, { headers: { Authorization: `Bearer ${token}` } });
        this.walletId = res.data.walletId; this.accountStatus = "PENDING";
      } catch (e) { this.errorMessage = "Erro ao conectar."; } finally { this.submittingAction = false; }
    },
    async handleSimulateApproval() {
      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/simulate-kyc-approval`, {}, { headers: { Authorization: `Bearer ${token}` } });
        this.accountStatus = "APPROVED"; await this.loadWalletTransactions();
      } catch (e) { this.errorMessage = "Falha na simulação."; } finally { this.submittingAction = false; }
    },
    formatCurrency(v) { return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0); }
  },
  mounted() { this.loadWalletCompliance(); }
};
</script>
<template>
  <div class="container-fluid text-start">
    <div class="row mb-4">
      <div class="col-12 d-flex justify-content-between align-items-center">
        <h4 class="text-primary fw-bold mb-0">Minha Carteira Digital</h4>
        <span v-if="accountStatus === 'APPROVED'" class="badge bg-success-subtle text-success px-3 py-2 fs-12">
          <i class="ri-checkbox-circle-fill me-1"></i> Conta Pronta
        </span>
      </div>
    </div>

    <div v-if="successMessage" class="alert alert-success border-0 shadow-sm mb-3">
      <i class="ri-checkbox-circle-line me-2 fs-16 align-middle"></i> {{ successMessage }}
    </div>
    <div v-if="errorMessage" class="alert alert-danger border-0 shadow-sm mb-3">
      <i class="ri-error-warning-line me-2 fs-16 align-middle"></i> {{ errorMessage }}
    </div>

    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status"></div>
      <p class="text-muted mt-2 small">Sincronizando custódia...</p>
    </div>

    <div v-else>
      <div v-if="accountStatus === 'NOT_CREATED'" class="card border-0 shadow-sm text-center p-5">
        <div class="avatar-lg bg-soft-primary text-primary rounded-circle mx-auto mb-4 d-flex align-items-center justify-content-center" style="width:60px; height:70px;">
          <i class="ri-wallet-3-line fs-32"></i>
        </div>
        <h5 class="fw-bold text-dark">Ative sua Carteira de Recebimentos</h5>
        <p class="text-muted small mx-auto mb-4" style="max-width: 550px;">
          Para começar a vender seus shows, precisamos criar sua subconta digital de segurança.
        </p>
        <button type="button" class="btn btn-success fw-bold px-4 mx-auto" @click="handleConnectWallet" :disabled="submittingAction">
          Ativar Minha Carteira Digital
        </button>
      </div>
      <div v-else-if="accountStatus === 'PENDING'" class="row">
        <div class="col-xl-9 mx-auto">
          <div class="card border-warning border border-dashed mb-4">
            <div class="card-body p-4 text-center">
              <i class="ri-shield-user-line text-warning fs-32"></i>
              <h5 class="fw-bold text-dark mt-2 mb-1">Onboarding de Segurança Requerido</h5>
              <p class="text-muted small mb-0">Sua vitrine está online, mas o botão de contratação direta ficará suspenso até que a documentação seja avaliada.</p>
            </div>
          </div>

          <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white border-0 py-3">
              <h6 class="card-title fw-bold text-dark mb-0">Enviar Arquivos de Verificação Cadastral</h6>
            </div>
            <div class="card-body p-4 pt-0">
              <form @submit.prevent="handleUploadKYCDocuments">
                <div class="row g-4">
                  <div class="col-md-6">
                    <label class="form-label fw-semibold text-dark small mb-1">1. Documento de Identificação Oficial</label>
                    <div class="dropzone-box" :class="identityFileName ? 'border-success bg-soft-success-subtle' : ''">
                      <i :class="identityFileName ? 'ri-checkbox-circle-fill text-success' : 'ri-file-text-line text-muted'" class="fs-24"></i>
                      <p class="small fw-medium mb-1 mt-1">{{ identityFileName ? 'Anexo Carregado' : 'Frente e Verso' }}</p>
                      <span class="badge bg-light text-primary text-truncate d-block mx-auto mb-2 font-monospace fs-11" style="max-width:180px;" v-if="identityFileName">{{ identityFileName }}</span>
                      <label class="btn btn-sm btn-primary fw-bold mb-0">
                        Selecionar Arquivo
                        <input type="file" class="d-none" @change="onFileSelected($event, 'identity')">
                      </label>
                    </div>
                  </div>

                  <div class="col-md-6">
                    <label class="form-label fw-semibold text-dark small mb-1">2. Comprovante de Residência Atualizado</label>
                    <div class="dropzone-box" :class="addressFileName ? 'border-success bg-soft-success-subtle' : ''">
                      <i :class="addressFileName ? 'ri-checkbox-circle-fill text-success' : 'ri-map-pin-user-line text-muted'" class="fs-24"></i>
                      <p class="small fw-medium mb-1 mt-1">{{ addressFileName ? 'Anexo Carregado' : 'Contas Recentes de Consumo' }}</p>
                      <span class="badge bg-light text-primary text-truncate d-block mx-auto mb-2 font-monospace fs-11" style="max-width:180px;" v-if="addressFileName">{{ addressFileName }}</span>
                      <label class="btn btn-sm btn-primary fw-bold mb-0">
                        Selecionar Arquivo
                        <input type="file" class="d-none" @change="onFileSelected($event, 'address')">
                      </label>
                    </div>
                  </div>
                  <div class="col-md-12" v-if="personType === 'Physical'">
                    <label class="form-label fw-semibold text-dark small mb-1">3. Foto do Rosto Segurando o Documento (Selfie de Segurança)</label>
                    <div class="dropzone-box" :class="selfieFileName ? 'border-success bg-soft-success-subtle' : ''">
                      <i :class="selfieFileName ? 'ri-checkbox-circle-fill text-success' : 'ri-user-smile-line text-muted'" class="fs-24"></i>
                      <p class="small fw-medium mb-1 mt-1">{{ selfieFileName ? 'Selfie Carregada' : 'Aproximação de Rosto com RG/CNH' }}</p>
                      <span class="badge bg-light text-primary text-truncate d-block mx-auto mb-2 font-monospace fs-11" style="max-width:260px;" v-if="selfieFileName">{{ selfieFileName }}</span>
                      <label class="btn btn-sm btn-primary fw-bold mb-0">
                        Selecionar Arquivo
                        <input type="file" class="d-none" @change="onFileSelected($event, 'selfie')">
                      </label>
                    </div>
                  </div>
                  <div class="col-md-12" v-else>
                    <label class="form-label fw-semibold text-dark small mb-1">3. Certificado de MEI ou Contrato Social Atualizado</label>
                    <div class="dropzone-box" :class="businessFileName ? 'border-success bg-soft-success-subtle' : ''">
                      <i :class="businessFileName ? 'ri-checkbox-circle-fill text-success' : 'ri-building-line text-muted'" class="fs-24"></i>
                      <p class="small fw-medium mb-1 mt-1">{{ businessFileName ? 'PDF Carregado' : 'Arquivo CCMEI Digital Oficial' }}</p>
                      <span class="badge bg-light text-primary text-truncate d-block mx-auto mb-2 font-monospace fs-11" style="max-width:260px;" v-if="businessFileName">{{ businessFileName }}</span>
                      <label class="btn btn-sm btn-primary fw-bold mb-0">
                        Selecionar Arquivo
                        <input type="file" class="d-none" @change="onFileSelected($event, 'business')">
                      </label>
                    </div>
                  </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top border-light">
                  <p class="text-muted small mb-0"><i class="ri-lock-2-line text-success"></i> Seus dados trafegam de forma criptografada.</p>
                  <button type="submit" class="btn btn-success fw-bold px-4" :disabled="submittingAction">
                    {{ submittingAction ? 'Transmitindo...' : 'Concluir Envio para Análise' }}
                  </button>
                </div>
              </form>

              <!--div class="mt-4 pt-3 border-top border-light text-center">
                <button type="button" class="btn btn-soft-danger btn-sm font-monospace fs-11 px-3" @click="handleSimulateApproval" :disabled="submittingAction">
                  ⚙️ SIMULAR APROVAÇÃO IMEDIATA DA CARTEIRA (SANDBOX)
                </button>
              </!--div-->
            </div>
          </div>
        </div>
      </div>
      <div v-else-if="accountStatus === 'APPROVED'" class="row">
        <div class="col-xl-6 col-md-6 mb-3">
          <div class="card bg-success bg-gradient border-0 shadow-sm text-white">
            <div class="card-body p-4">
              <h6 class="text-white-50 text-uppercase fs-11 font-monospace fw-bold mb-1">Saldo Disponível</h6>
              <h2 class="fw-bold font-monospace mb-3 text-white">{{ formatCurrency(saldoDisponivel) }}</h2>
              <div class="d-flex justify-content-between align-items-center">
                <span class="text-white-50 small">Livre para saques Pix</span>
                <button type="button" class="btn btn-sm btn-light fw-bold" :disabled="saldoDisponivel <= 0">Transferir</button>
              </div>
            </div>
          </div>
        </div>

        <div class="col-xl-6 col-md-6 mb-3">
          <div class="card bg-dark bg-gradient border-0 shadow-sm text-white">
            <div class="card-body p-4">
              <h6 class="text-muted text-uppercase fs-11 font-monospace fw-bold mb-1">Cachês a Receber</h6>
              <h2 class="fw-bold font-monospace mb-3 text-white">{{ formatCurrency(cachesAReceber) }}</h2>
              <p class="text-muted small mb-0">Custódia temporária até a execução física dos shows</p>
            </div>
          </div>
        </div>
        <div class="col-12 mt-3">
          <div class="card border-0 shadow-sm">
            <div class="card-header bg-light border-0 p-3 d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2">
              <h6 class="fw-bold text-dark mb-0"><i class="ri-history-line me-1 text-primary"></i> Histórico de Extrato Financeiro</h6>
              <div class="d-flex gap-2">
                <select class="form-select form-select-sm fs-12" v-model="filters.type" style="width:130px;">
                  <option value="ALL">Todos os Tipos</option>
                  <option value="Receivable">Entradas</option>
                  <option value="Payout">Saques</option>
                </select>
                <select class="form-select form-select-sm fs-12" v-model="filters.status" style="width:130px;">
                  <option value="ALL">Todos os Status</option>
                  <option value="LIBERADO">Liberados</option>
                  <option value="RETIDO">Retidos</option>
                </select>
                <select class="form-select form-select-sm fs-12" v-model="filters.period" style="width:130px;">
                  <option value="TOTAL">Histórico Total</option>
                  <option value="MONTH">Mês Atual</option>
                  <option value="30_DAYS">Últimos 30 Dias</option>
                </select>
              </div>
            </div>
            <div class="card-body p-0">
              <div v-if="transacoesFiltradas.length > 0" class="table-responsive">
                <table class="table table-hover align-middle mb-0 fs-13 text-muted">
                  <thead class="table-light text-dark font-monospace fs-11">
                    <tr>
                      <th scope="col" class="p-3">Data / Hora</th>
                      <th scope="col" class="p-3">Tipo</th>
                      <th scope="col" class="p-3">Descrição da Operação</th>
                      <th scope="col" class="p-3">Status Liberação</th>
                      <th scope="col" class="p-3 text-end">Valor Bruto</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="tx in transacoesFiltradas" :key="tx.id">
                      <td class="p-3 font-monospace">{{ new Date(tx.createdAt).toLocaleString('pt-BR') }}</td>
                      <td class="p-3">
                        <span :class="tx.type === 'Receivable' ? 'badge bg-success-subtle text-success' : 'badge bg-danger-subtle text-danger'" class="fw-bold px-2 py-1">
                          {{ tx.type === 'Receivable' ? 'ENTRADA' : 'SAQUE' }}
                        </span>
                      </td>
                      <td class="p-3 text-dark fw-medium">{{ tx.type === 'Receivable' ? 'Cachê de Show Custodiado' : 'Transferência para conta real' }}</td>
                      <td class="p-3"><span :class="tx.isReleased ? 'badge bg-success' : 'badge bg-warning'" class="px-2">{{ tx.isReleased ? 'Liberado' : 'Retido' }}</span></td>
                      <td :class="tx.type === 'Receivable' ? 'text-success' : 'text-danger'" class="p-3 text-end font-monospace fw-bold">
                        {{ tx.type === 'Receivable' ? '+' : '-' }} {{ formatCurrency(tx.value) }}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div v-else class="text-center py-5 m-3 text-muted border rounded border-dashed fs-12">
                Nenhum lançamento financeiro corresponde aos filtros selecionados.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div> 
  </div> 
</template>

<style scoped>
.transition-all { transition: all 0.2s ease; }
.border-dashed { border-style: dashed !important; }
.bg-soft-success-subtle { background-color: rgba(25, 135, 84, 0.04) !important; }
.dropzone-box {
  border: 2px dashed #ced4da;
  background-color: #f8f9fa;
  border-radius: 6px;
  padding: 20px;
  text-align: center;
  transition: all 0.25s ease;
}
.dropzone-box:hover {
  border-color: #405189;
  background-color: #f3f4f9;
}
.dropzone-box.border-success:hover {
  border-color: #0ab39c;
  background-color: rgba(25, 135, 84, 0.06);
}
</style>
