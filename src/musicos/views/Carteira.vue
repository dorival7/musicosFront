<script>
/* eslint-disable */
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
      filters: { type: "ALL", status: "ALL", period: "TOTAL" },
      
      // 🛡️ CONTROLADOR DE SESSÃO: Impede a cortina precoce e força a abertura dos dropzones no primeiro acesso
      documentosEnviadosNaSessao: false,

      // 📋 OBJETO LOCAL ISOLADO: Captura os dados comerciais antes da ativação do gateway
      onboardingInterno: {
        personType: "Physical", // Physical ou Legal
        cnpj: "",
        companyType: "MEI",     // MEI, INDIVIDUAL, LIMITED, ASSOCIATION
        incomeValue: ""         // Faturamento real coletado apenas para PJ
      }
    };
  },
  computed: {
    identityFileName() { return this.kycFiles.identity ? this.kycFiles.identity.name : null; },
    addressFileName() { return this.kycFiles.address ? this.kycFiles.address.name : null; },
    selfieFileName() { return this.kycFiles.selfie ? this.kycFiles.selfie.name : null; },
    businessFileName() { return this.kycFiles.business ? this.kycFiles.business.name : null; },
    
    // 🧠 TRAVA DE AUDITORIA INTELIGENTE: Só exibe a ampulheta se os documentos foram transmitidos de fato
    exibirCortinaAuditoria() {
      // Se a conta está PENDING no banco de dados, mas o usuário ainda não enviou os arquivos nesta sessão,
      // retorna false para forçar a renderização do formulário de uploads (bloco v-else do template)!
      if (this.accountStatus === 'PENDING' && !this.documentosEnviadosNaSessao) {
        return false;
      }
      return this.accountStatus === 'PENDING' && this.walletId !== null && this.walletId !== "";
    },
    
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
    // 🔍 SINCRONIA INICIAL: Consulta os dados cadastrais atualizados do músico logado
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
        
        // Sincroniza o chaveador local com o banco de dados
        this.onboardingInterno.personType = this.personType;

        // 🔥 VALIDAÇÃO HISTÓRICA: Se o status for PENDING e o banco já possuir registros de transações anteriores,
        // ou se você quiser que as contas que retornam do refresh fiquem presas em auditoria se já enviaram os dados
        // antes, mantemos a segurança. Para o usuário novo, a flag inicia sempre como false no mount.
        if (this.accountStatus === 'PENDING' && this.walletId && this.documentosEnviadosNaSessao) {
          this.documentosEnviadosNaSessao = true;
        }

        if (this.accountStatus === 'APPROVED') await this.loadWalletTransactions();
        this.loading = false;
      } catch (e) { this.loading = false; this.errorMessage = "Falha ao ler status da carteira."; }
    },

    // 🌊 EXECUÇÃO EM CONCORDÂNCIA COM O DTO C#: Transmite a carga comercial no corpo da rota
    async handleConnectWallet() {
      this.successMessage = null;
      this.errorMessage = null;
      this.submittingAction = true;

      try {
        const token = localStorage.getItem('jwt');
        const configHeaders = { headers: { Authorization: `Bearer ${token}` } };

        // 🧠 AJUSTE DE TIPAGEM: Chaves minúsculas exigidas pelo deserializador do .NET 10
        let payloadComercial = {
          personType: this.onboardingInterno.personType,
          cnpj: this.onboardingInterno.personType === 'Legal' ? this.onboardingInterno.cnpj : null,
          companyType: this.onboardingInterno.personType === 'Legal' ? this.onboardingInterno.companyType : null,
          incomeValue: this.onboardingInterno.personType === 'Legal' ? parseFloat(this.onboardingInterno.incomeValue) : 7000.00
        };

        console.log("🚀 [CARTEIRA] Transmitindo payload em camelCase oficial:", JSON.stringify(payloadComercial));

        const urlConnect = `${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/connect`;
        const res = await axios.post(urlConnect, payloadComercial, configHeaders);
        
        this.walletId = res.data.walletId; 
        this.accountStatus = res.data.status || "PENDING";
        this.onboardingLink = res.data.onboardingLink || "";
        this.personType = this.onboardingInterno.personType;
        this.documentosEnviadosNaSessao = false;

        console.log("🎯 [CARTEIRA] Onboarding inicializado com sucesso absoluto no Gateway!");

      } catch (e) { 
        console.error("Erro na esteira de conexão da subconta:", e);
        this.errorMessage = e.response && e.response.data && e.response.data.message 
          ? e.response.data.message 
          : "Falha ao processar dados cadastrais no servidor de recebimentos."; 
        this.documentosEnviadosNaSessao = false;
      } finally { 
        this.submittingAction = false; 
      }
    },

    // 📊 HISTÓRICO DE LANÇAMENTOS COMERCIAIS
    async loadWalletTransactions() {
      try {
        const token = localStorage.getItem('jwt');
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/transactions`, { headers: { Authorization: `Bearer ${token}` } });
        this.walletTransactions = response.data || [];
      } catch (e) { console.error(e); }
    },

    // 🖨️ CAPTURA POSICIONAL DE BINÁRIOS
    onFileSelected(event, key) {
      if (event.target.files && event.target.files.length > 0) this.kycFiles[key] = event.target.files[0];
      else this.kycFiles[key] = null;
    },

    // 🚀 UPLOAD REATIVO COM ATUALIZAÇÃO IMEDIATA (MARCA BRANCA COMPLETA)
    async handleUploadKYCDocuments() {
      this.successMessage = null; 
      this.errorMessage = null;
      
      if (!this.kycFiles.identity || !this.kycFiles.address) { 
        this.errorMessage = "Por favor, selecione os documentos obrigatórios antes de prosseguir."; 
        return; 
      }
      
      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const formData = new FormData();
        
        formData.append("identityFile", this.kycFiles.identity[0]);
        formData.append("addressFile", this.kycFiles.address[0]);
        
        if (this.personType === 'Physical') {
          if (!this.kycFiles.selfie) {
            this.errorMessage = "A selfie de segurança é obrigatória para cadastros CPF.";
            this.submittingAction = false;
            return;
          }
          formData.append("selfieFile", this.kycFiles.selfie[0]);
        } else {
          if (!this.kycFiles.business) {
            this.errorMessage = "O comprovante de CNPJ (CCMEI/Contrato Social) é obrigatório.";
            this.submittingAction = false;
            return;
          }
          formData.append("businessFile", this.kycFiles.business[0]);
        }
        
        const urlUpload = `${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/upload-documents`;
        
        // Dispara o multipart/form-data de forma síncrona aguardando o upload real dos arquivos
        const response = await axios.post(urlUpload, formData, { 
          headers: { 
            Authorization: `Bearer ${token}`, 
            'Content-Type': 'multipart/form-data' 
          } 
        });
        
        // 🛡️ TRAVA CIRÚRGICA: Só altera o estado visual da interface se a API C# retornar sucesso legítimo
        if (response.status === 200 || response.status === 201) {
          this.successMessage = "Documentos recebidos com sucesso e enviados para validação do nosso Gateway de Recebimento de Shows!";
          
          // 🌟 ATIVAÇÃO CONTROLADA: Agora sim o Vue autoriza reativamente a abertura da cortina de auditoria
          this.documentosEnviadosNaSessao = true;
          
          // Re-hidrata os dados de carteira vindos do MariaDB
          await this.loadWalletCompliance();
          
          // Limpa as referências voláteis de binários da memória local
          this.kycFiles = { identity: null, address: null, selfie: null, business: null };
        } else {
          this.errorMessage = "O servidor de faturamento recusou os arquivos. Tente novamente.";
        }
        
      } catch (e) { 
        console.error("Falha física ou rejeição na esteira de upload KYC:", e);
        this.errorMessage = e.response && e.response.data && e.response.data.message 
          ? e.response.data.message 
          : "Erro ao transmitir arquivos de verificação cadastral. Verifique o tamanho dos anexos."; 
          
        // Garante que a flag permaneça bloqueada caso ocorra qualquer estouro de timeout ou erro de rede
        this.documentosEnviadosNaSessao = false;
      } finally { 
        this.submittingAction = false; 
      }
    },

    // ⚙️ SIMULADOR DE AUDITORIA DE SANDBOX
    async handleSimulateApproval() {
      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/wallet/simulate-kyc-approval`, {}, { headers: { Authorization: `Bearer ${token}` } });
        this.accountStatus = "APPROVED"; await this.loadWalletTransactions();
      } catch (e) { this.errorMessage = "Falha na simulação de auditoria."; } finally { this.submittingAction = false; }
    },

    // 💰 FORMATADOR DECIMAL DE MOEDA NACIONAL
    formatCurrency(v) { return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v || 0); },
    
    // 🖨️ FORMATADOR REATIVO: Injeta a máscara de CNPJ em tempo de execução
    aplicarMascaraCnpjLocal(event) {
      let v = event.target.value.replace(/\D/g, "");
      if (v.length > 14) v = v.substring(0, 14);
      if (v.length > 12) {
        v = v.substring(0, 2) + "." + v.substring(2, 5) + "." + v.substring(5, 8) + "/" + v.substring(8, 12) + "-" + v.substring(12, 14);
      } else if (v.length > 8) {
        v = v.substring(0, 2) + "." + v.substring(2, 5) + "." + v.substring(5, 8) + "/" + v.substring(8, v.length);
      } else if (v.length > 5) {
        v = v.substring(0, 2) + "." + v.substring(2, 5) + "." + v.substring(5, v.length);
      } else if (v.length > 2) {
        v = v.substring(0, 2) + "." + v.substring(2, v.length);
      }
      this.onboardingInterno.cnpj = v;
    }
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
      <div v-if="accountStatus === 'NOT_CREATED'" class="card border-0 shadow-sm p-4 p-md-5" style="background-color: #ffffff; border-radius: 16px;">
        <div class="text-center mb-4">
          <div class="avatar-lg bg-light text-primary rounded-circle mx-auto mb-3 d-flex align-items-center justify-content-center" style="width:60px; height:60px; background-color: rgba(64,81,137,0.08) !important;">
            <i class="ri-wallet-3-line fs-28" style="color: #405189;"></i>
          </div>
          <h5 class="fw-bold text-dark mb-1">Ative sua Carteira de Recebimentos</h5>
          <p class="text-muted small mx-auto" style="max-width: 550px;">
            Configure seu perfil de faturamento para criar sua subconta digital de segurança no nosso <strong>Gateway de Recebimento de Shows</strong>.
          </p>
        </div>

        <div class="mx-auto" style="max-width: 480px; width: 100%; box-sizing: border-box;">
          
          <!-- 🎛️ CHAVEADOR REATIVO DE CATEGORIA FINANCEIRA -->
          <div class="mb-4">
            <label class="form-label fw-bold text-dark small mb-2">Como você deseja receber seus cachês de shows? *</label>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; width: 100%;">
              <button 
                type="button" 
                @click="onboardingInterno.personType = 'Physical'"
                :class="onboardingInterno.personType === 'Physical' ? 'btn-primary text-white fw-bold' : 'btn-light text-muted'"
                class="btn btn-sm py-2 fs-12 transition-all"
                style="border-radius: 8px;"
              >
                Como Pessoa Física (CPF)
              </button>
              <button 
                type="button" 
                @click="onboardingInterno.personType = 'Legal'"
                :class="onboardingInterno.personType === 'Legal' ? 'btn-primary text-white fw-bold' : 'btn-light text-muted'"
                class="btn btn-sm py-2 fs-12 transition-all"
                style="border-radius: 8px;"
              >
                Como Empresa / Banda (CNPJ)
              </button>
            </div>
          </div>

          <!-- 💎 CARD DE GATILHO COMERCIAL DE INCENTIVO AO CNPJ -->
          <div style="background-color: rgba(255,108,34,0.05); border: 1px dashed rgba(255,108,34,0.3); border-radius: 12px; padding: 16px; margin-bottom: 25px; box-sizing: border-box;">
            <h6 style="color: #ff6c22; font-size: 11px; font-weight: bold; margin: 0 0 6px 0; text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; gap: 6px;">
              <span>⭐</span> Vantagem Exclusiva PJ
            </h6>
            <p style="color: #6c757d; font-size: 11px; line-height: 1.5; margin: 0; font-family: sans-serif;">
              Cadastrando o seu CNPJ você garante <strong>elegibilidade automática para fechar apresentações de grande porte diretas com prefeituras, órgãos públicos, festivais e grandes eventos corporativos</strong>, além de usufruir de taxas de antecipação reduzidas diretamente na sua conta de artista!
            </p>
          </div>

          <!-- 📋 FORMULÁRIO OPERACIONAL DINÂMICO -->
          <form @submit.prevent="handleConnectWallet">
            
            <!-- BLOCO CONDICIONAL EXPANDIDO APENAS PARA PESSOA JURÍDICA -->
            <div v-if="onboardingInterno.personType === 'Legal'" class="animate__animated animate__fadeIn" style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 20px;">
              
              <!-- Campo CNPJ -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label class="form-label fw-bold text-dark small mb-0">Número do CNPJ da Banda / Empresa *</label>
                <input 
                  type="text" 
                  v-model="onboardingInterno.cnpj" 
                  @input="aplicarMascaraCnpjLocal" 
                  placeholder="00.000.000/0001-00" 
                  maxlength="18" 
                  required 
                  class="form-control form-control-sm font-monospace fw-bold" 
                />
              </div>

              <!-- Campo Tipo de Empresa -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label class="form-label fw-bold text-dark small mb-0">Tipo de Empresa (Exigência de Gateway) *</label>
                <select class="form-select form-select-sm fs-13" v-model="onboardingInterno.companyType" required>
                  <option value="MEI">MEI - Microempreendedor Individual</option>
                  <option value="INDIVIDUAL">INDIVIDUAL - Empresário Individual</option>
                  <option value="LIMITED">LIMITED - Sociedade Limitada (LTDA / SLU)</option>
                  <option value="ASSOCIATION">ASSOCIATION - Sociedade Anônima / Associação</option>
                </select>
              </div>

              <!-- Campo Faturamento Real -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label class="form-label fw-bold text-dark small mb-0">Faturamento Mensal Estimado com Shows (R$) *</label>
                <input 
                  type="number" 
                  step="0.01" 
                  v-model="onboardingInterno.incomeValue" 
                  placeholder="Ex: 8500.00" 
                  required 
                  class="form-control form-control-sm font-monospace fw-bold" 
                />
              </div>

            </div>

            <!-- 🟢 BOTÃO MASTER EM VERDE ESMERALDA PADRÃO VELZON -->
            <button 
              type="submit" 
              class="btn btn-success fw-bold w-100 py-2 fs-13 shadow-sm" 
              :disabled="submittingAction"
              style="border-radius: 8px;"
            >
              <i class="ri-checkbox-circle-line me-1"></i> 
              {{ submittingAction ? 'Salvando Perfil e Ativando...' : (onboardingInterno.personType === 'Legal' ? 'Salvar Dados Comerciais e Ativar Carteira →' : 'Ativar Minha Carteira Digital com CPF →') }}
            </button>
          </form>
          
        </div>
      </div>
            <!-- ==================================================================== -->
      <!-- ⏳ ESTADO: PENDING (CORTINA DE AUDITORIA OU FORMULÁRIO DE ARQUIVOS)  -->
      <!-- ==================================================================== -->
      <div v-else-if="accountStatus === 'PENDING'" class="row animate__animated animate__fadeIn">
        <div class="col-xl-9 mx-auto">
          
          <!-- 📯 CENÁRIO A: CORTINA DE AUDITORIA AUTOMÁTICA (CONTA EM ANÁLISE NO MARIADB) -->
          <div v-if="exibirCortinaAuditoria" class="card border-0 shadow-sm text-center p-5 mb-4" style="background-color: #ffffff; border-radius: 16px;">
            <div class="avatar-lg bg-soft-warning rounded-circle mx-auto mb-4 d-flex align-items-center justify-content-center animate__animated animate__pulse animate__infinite" style="width:70px; height:70px; background-color: rgba(255,198,0,0.1); animation-duration: 2s;">
              <i class="ri-time-line fs-36" style="color: #ffc107;"></i>
            </div>
            
            <h5 class="fw-bold text-dark mb-2">Documentação em Auditoria de Segurança</h5>
            <p class="text-muted small mx-auto mb-4" style="max-width: 500px; font-family: sans-serif; line-height: 1.6;">
              Seus arquivos foram recebidos com sucesso e enviados para validação do nosso <strong>Gateway de Recebimento de Shows</strong>! Nossa mesa de compliance está revisando os dados cadastrais. A liberação total do painel de saldos ocorre em até 24 horas úteis.
            </p>

            <div class="alert alert-info border-0 shadow-sm mx-auto mb-4 fs-12 text-start d-flex align-items-center gap-2" style="max-width: 440px; background-color: rgba(41,156,219,0.06); color: #299cdb; border-radius: 8px;">
              <span>ℹ️</span>
              <span>Sua vitrine de shows continua online e recebendo acessos normalmente na região.</span>
            </div>

            <!-- GATILHO DE TESTES: ACESSÍVEL NA ATIVIDADE DE AUDITORIA -->
            <div class="pt-3 border-top border-light mt-2">
              <button type="button" class="btn btn-soft-danger btn-sm font-monospace fs-11 px-3" @click="handleSimulateApproval" :disabled="submittingAction">
                ⚙️ SIMULAR APROVAÇÃO IMEDIATA DA CARTEIRA (SANDBOX)
              </button>
            </div>
          </div>

          <!-- 📂 CENÁRIO B: FORMULÁRIO COMPLETO ORIGINAL INTACTO (AGUARDANDO ENVIO DOS BINÁRIOS) -->
          <div v-else class="animate__animated animate__fadeIn">
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
                    
                    <!-- Dropzone 1: Identificação (CORRIGIDO E FILTRADO SEM QUEBRAS) -->
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

                    <!-- Dropzone 2: Comprovante de Residência -->
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
                    
                    <!-- Dropzone 3 Dinâmico: Selfie ou CCMEI -->
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
              </div>
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
