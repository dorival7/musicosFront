<script>
import axios from 'axios';

export default {
  name: "ArtistSubscriptionManager",
  data() {
    return {
      loading: true,
      submittingAction: false,
      successMessage: null,
      errorMessage: null,

      // Dados reais do plano atual do músico (Alimentados pelas APIs do C#)
      currentPlan: {
        name: "Carregando...",
        fee: 0,
        currentPackagesCount: 0,
        totalPackagesPermitidosNoPlano: 3, // Limite elástico vindo do MariaDB
        canAddMorePackages: true,
        totalPhotosPermitidasNoPlano: 5,
        fotosRestantesDisponiveis: 5
      },

      // A matriz inicia vazia e é populada via HTTP a partir da tabela saas_invoices
      invoices: []
    };
  },

  computed: {
    // CÁLCULOS GRÁFICOS EM RAM EM TEMPO REAL PARA AS BARRAS DO VELZON
    percentualFotosUtilizadas() {
      const totalPermitido = this.currentPlan.totalPhotosPermitidasNoPlano || 5;
      const restantes = this.currentPlan.fotosRestantesDisponiveis || 0;
      const utilizadas = totalPermitido - restantes;
      return Math.min(Math.round((utilizadas / totalPermitido) * 100), 100);
    },
    totalFotosTexto() {
      const totalPermitido = this.currentPlan.totalPhotosPermitidasNoPlano || 5;
      const restantes = this.currentPlan.fotosRestantesDisponiveis || 0;
      return `${totalPermitido - restantes} de ${totalPermitido}`;
    }
  },

  methods: {
    // 1. LEITURA DE CONSUMO E FATURAMENTO CONCORRENTE VIA API
    async loadSubscriptionData() {
      this.loading = true;
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        // Consome os endpoints oficiais do seu ecossistema C#
        const responseMe = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/me`, config);
        const responseMetrics = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/dashboard-metrics`, config);
        const responseInvoices = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/saas-invoices`, config);

        // Sincroniza os metadados do plano atual
        this.currentPlan.name = responseMe.data.plan?.name || "Plano Bronze";
        this.currentPlan.fee = responseMe.data.plan?.monthlyFee || responseMe.data.plan?.fee || 0;
        
        // Sincronização de métricas e limites tridimensionais dinâmicos do .NET 10
        this.currentPlan.currentPackagesCount = responseMetrics.data.pacotesCriados || 0;
        this.currentPlan.totalPhotosPermitidasNoPlano = responseMetrics.data.totalPhotosPermitidasNoPlano || 5;
        this.currentPlan.fotosRestantesDisponiveis = responseMetrics.data.fotosRestantesDisponiveis || 0;
        
        // Captura o teto elástico de formatos permitidos vindo dinamicamente do banco de dados
        this.currentPlan.totalPackagesPermitidosNoPlano = responseMetrics.data.totalPacotesPermitidos || 3;

        // Popula as faturas reais do MariaDB
        this.invoices = responseInvoices.data || [];

        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.errorMessage = "Falha ao sincronizar dados de faturamento com o servidor.";
        console.error("Erro no carregamento de faturamento SaaS:", error);
      }
    },

    // Action de cópia rápida do Pix diretamente da linha da tabela do Velzon
    copyPixKey(pixString) {
      if (!pixString) return;
      navigator.clipboard.writeText(pixString);
      this.successMessage = "Código Pix Copia e Cola copiado com sucesso! Insira no app do seu banco.";
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },

    // Redireciona via Vue Router para a nova tela dedicada de Upgrade
    navigateToMigrationPage() {
      this.$router.push("/musicos/assinatura/migrar");
    }
  },

  mounted() {
    this.loadSubscriptionData();
  }
};
</script>

<template>
  <div class="assinatura-page">
    <!-- CABEÇALHO DA TELA NATIVO DO VELZON -->
    <div class="row assinatura-heading-row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary">Gestão de Assinatura e Faturamento</h4>
          <div class="page-title-right">
            <ol class="breadcrumb m-0">
              <li class="breadcrumb-item"><a href="javascript: void(0);">Minha Conta</a></li>
              <li class="breadcrumb-item active">Assinatura</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <!-- CENTRAL DE BALÕES DE ALERTAS E FEEDBACKS VUE -->
    <div v-if="successMessage" class="alert alert-success border-0 shadow-sm text-start animate__animated animate__fadeIn" role="alert">
      <i class="ri-checkbox-circle-line me-2 align-middle fs-16"></i>
      {{ successMessage }}
    </div>

    <div v-if="errorMessage" class="alert alert-danger alert-dismissible fade show border-0 shadow-sm text-start animate__animated animate__shakeX" role="alert">
      <i class="ri-error-warning-line me-2 align-middle fs-16"></i>
      {{ errorMessage }}
      <button type="button" class="btn-close" @click="errorMessage = null" aria-label="Close"></button>
    </div>

    <!-- SINALIZADOR DE REDE / CARREGAMENTO INICIAL -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status"></div>
      <p class="text-muted mt-2 fs-13">Buscando histórico financeiro e limites no MariaDB...</p>
    </div>

    <div v-else class="row animate__animated animate__fadeIn assinatura-content">
      <!-- COLUNA DA ESQUERDA: RESUMO DO PLANO ATIVO E LIMITES DE CAPACIDADE -->
      <div class="col-xl-4 assinatura-plan-col">
        <div class="card card-animate border-0 shadow-sm">
          <div class="card-body p-4">
            <div class="d-flex align-items-center mb-3">
              <div class="avatar-sm flex-shrink-0">
                <span class="avatar-title bg-soft-primary text-primary rounded-circle fs-20">
                  <i class="ri-vip-diamond-line"></i>
                </span>
              </div>
              <div class="flex-grow-1 ms-3">
                <h5 class="fw-bold text-dark mb-0">{{ currentPlan.name }}</h5>
                <p class="text-muted small mb-0">Plano de Acesso à Plataforma</p>
              </div>
            </div>

            <div class="mb-4">
              <h2 class="fw-bold text-primary font-monospace mb-0">
                R$ {{ currentPlan.fee.toFixed(2).replace('.', ',') }}<span class="fs-13 text-muted fw-normal">/mês</span>
              </h2>
            </div>

            <hr class="text-muted opacity-15 my-3">

            <!-- SEÇÃO DE BARRAS DE CAPACIDADE DO SAAS -->
            <h6 class="text-muted text-uppercase fw-bold fs-11 mb-3 tracking-wider">Consumo de Cotas do Plano</h6>

            <!-- BARRA 1: LIMITE DE FOTOS (DINÂMICA) -->
            <div class="mb-3 fs-13">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <span class="fw-medium text-dark"><i class="ri-image-line me-1 text-primary"></i> Fotos na Galeria</span>
                <span class="text-muted font-monospace small">{{ totalFotosTexto }}</span>
              </div>
              <div class="progress animated-progress progress-sm">
                <div 
                  class="progress-bar bg-primary" 
                  role="progressbar" 
                  :style="`width: ${percentualFotosUtilizadas}%`" 
                  :aria-valuenow="percentualFotosUtilizadas" 
                  aria-valuemin="0" 
                  aria-valuemax="100"
                ></div>
              </div>
            </div>

            <!-- BARRA 2: LIMITE DE PACOTES DE SHOWS (100% DINÂMICA VIA MARIADB) -->
            <div class="mb-4 fs-13">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <span class="fw-medium text-dark"><i class="ri-music-2-line me-1 text-primary"></i> Formatos de Shows Ativos</span>
                <span class="text-muted font-monospace small">
                  {{ currentPlan.currentPackagesCount }} de {{ currentPlan.totalPackagesPermitidosNoPlano }}
                </span>
              </div>
              <div class="progress animated-progress progress-sm">
                <div 
                  class="progress-bar bg-primary" 
                  role="progressbar" 
                  :style="`width: ${(currentPlan.currentPackagesCount / currentPlan.totalPackagesPermitidosNoPlano) * 100}%`" 
                  :aria-valuenow="(currentPlan.currentPackagesCount / currentPlan.totalPackagesPermitidosNoPlano) * 100" 
                  aria-valuemin="0" 
                  aria-valuemax="100"
                ></div>
              </div>
            </div>

            <!-- BOTÃO MESTRE DE DIRECIONAMENTO PARA A TELA DE UPGRADE -->
            <button type="button" class="btn btn-primary w-100 fw-bold p-2 shadow-sm fs-13" @click="navigateToMigrationPage">
              <i class="ri-arrow-up-circle-line me-1 align-middle fs-16"></i> Alterar ou Fazer Upgrade de Plano
            </button>
          </div>
        </div>
      </div>

      <!-- COLUNA DA DIREITA: HISTÓRICO DE MENSALIDADES DO BANCO DE DADOS -->
      <div class="col-xl-8 assinatura-history-col">
        <div class="card border-0 shadow-sm">
          <div class="card-header border-0 bg-white p-3 pt-4">
            <h5 class="card-title mb-0 fw-bold text-dark">Histórico de Cobranças</h5>
          </div>
          <div class="card-body p-0">
            <div class="assinatura-history">
              <table class="table table-hover table-nowrap align-middle mb-0">
                <thead class="table-light text-muted uppercase fs-11 tracking-wider border-bottom">
                  <tr>
                    <th scope="col" class="ps-4">Cód. Fatura</th>
                    <th scope="col">Vencimento</th>
                    <th scope="col">Valor</th>
                    <th scope="col">Forma de Pagamento</th>
                    <th scope="col" class="text-center">Status</th>
                    <th scope="col" class="text-end pe-4">Ação</th>
                  </tr>
                </thead>
                <tbody class="fs-13 border-0">
                  <!-- SE NÃO HOUVER FATURAS CADASTRADAS -->
                  <tr v-if="invoices.length === 0">
                    <td colspan="6" class="text-center text-muted py-4">
                      Nenhuma mensalidade localizada no histórico de faturamento.
                    </td>
                  </tr>

                  <!-- RENDERIZAÇÃO REAL VIA SEV_ENSHOWS BACKEND -->
                  <tr v-for="invoice in invoices" :key="invoice.id">
                    <td class="fw-medium text-primary font-monospace ps-4">#{{ invoice.id }}</td>
                    <td>{{ new Date(invoice.dueDate).toLocaleDateString('pt-BR') }}</td>
                    <td class="fw-semibold text-dark font-monospace">
                      R$ {{ invoice.value.toFixed(2).replace('.', ',') }}
                    </td>
                    <td>
                      <span v-if="invoice.method === 'PIX'"><i class="ri-qr-code-line text-muted me-1"></i> Pix</span>
                      <span v-else><i class="ri-credit-card-line text-muted me-1"></i> Cartão de Crédito</span>
                    </td>
                    <td class="text-center">
                      <span v-if="invoice.status === 'PAYMENT_RECEIVED'" class="badge bg-success-subtle text-success px-2.5 py-1 text-uppercase fw-bold fs-11">
                        Paga
                      </span>
                      <span v-else-if="invoice.status === 'PAYMENT_OVERDUE'" class="badge bg-danger-subtle text-danger px-2.5 py-1 text-uppercase fw-bold fs-11 animate__animated animate__pulse animate__infinite">
                        Vencida
                      </span>
                      <span v-else class="badge bg-warning-subtle text-warning px-2.5 py-1 text-uppercase fw-bold fs-11">
                        Aguardando
                      </span>
                    </td>
                    <td class="text-end pe-4">
                      <!-- COPIA DO PIX COPIA E COLA REAL DO BANCO CENTRAL VIA ASAAS -->
                      <button 
                        v-if="invoice.method === 'PIX' && invoice.status !== 'PAYMENT_RECEIVED' && invoice.pixCopyPaste"
                        type="button" 
                        class="btn btn-sm btn-soft-primary fw-bold"
                        @click="copyPixKey(invoice.pixCopyPaste)"
                      >
                        <i class="ri-file-copy-line me-1 align-middle"></i> Copiar PIX
                      </button>
                      <span v-else class="text-muted small font-monospace">-</span>
                    </td>
                  </tr>
                </tbody>
              </table>

              <div class="assinatura-mobile-list">
                <div v-if="invoices.length === 0" class="text-center text-muted py-4 fs-12">
                  Nenhuma mensalidade localizada no histórico de faturamento.
                </div>
                <div v-for="invoice in invoices" :key="'mobile-' + invoice.id" class="invoice-mobile-card">
                  <div class="d-flex justify-content-between align-items-start gap-2">
                    <div class="invoice-code font-monospace text-primary fw-medium">#{{ invoice.id }}</div>
                    <span v-if="invoice.status === 'PAYMENT_RECEIVED'" class="badge bg-success-subtle text-success">Paga</span>
                    <span v-else-if="invoice.status === 'PAYMENT_OVERDUE'" class="badge bg-danger-subtle text-danger">Vencida</span>
                    <span v-else class="badge bg-warning-subtle text-warning">Aguardando</span>
                  </div>
                  <div class="invoice-mobile-info">
                    <span><small>Vencimento</small>{{ new Date(invoice.dueDate).toLocaleDateString('pt-BR') }}</span>
                    <span class="text-end"><small>Valor</small><strong>R$ {{ invoice.value.toFixed(2).replace('.', ',') }}</strong></span>
                  </div>
                  <div class="invoice-mobile-footer">
                    <span class="text-muted">
                      <i :class="invoice.method === 'PIX' ? 'ri-qr-code-line' : 'ri-credit-card-line'" class="me-1"></i>
                      {{ invoice.method === 'PIX' ? 'Pix' : 'Cartão de Crédito' }}
                    </span>
                    <button v-if="invoice.method === 'PIX' && invoice.status !== 'PAYMENT_RECEIVED' && invoice.pixCopyPaste"
                      type="button" class="btn btn-sm btn-soft-primary fw-bold" @click="copyPixKey(invoice.pixCopyPaste)">
                      <i class="ri-file-copy-line me-1"></i> Copiar PIX
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.table-nowrap td, .table-nowrap th {
  padding-top: 14px !important;
  padding-bottom: 14px !important;
}
.opacity-15 {
  opacity: 0.15;
}
.tracking-wider {
  letter-spacing: 0.05em;
}

.assinatura-mobile-list { display: none; }

@media (max-width: 767.98px) {
  /* PRIMEIRO: margem externa padrão do painel mobile. */
  .assinatura-page {
    width: calc(100% + 24px);
    max-width: none;
    margin-left: -12px;
    margin-right: -12px;
    box-sizing: border-box;
  }

  .assinatura-page > .row,
  .assinatura-content {
    --vz-gutter-x: 0;
    margin-left: 0;
    margin-right: 0;
  }

  .assinatura-page > .row > [class*="col-"],
  .assinatura-content > [class*="col-"] {
    padding-left: 0;
    padding-right: 0;
    box-sizing: border-box;
  }

  .assinatura-heading-row > .col-12 {
    padding-left: 0 !important;
    padding-right: 0 !important;
  }

  .assinatura-heading-row .page-title-box {
    min-height: auto;
    padding: 10px 0 !important;
    margin-bottom: 8px;
  }

  .assinatura-heading-row h4 {
    width: 100%;
    margin: 0 !important;
    text-align: center;
    font-size: 15px;
    line-height: 1.25;
  }

  .assinatura-heading-row .page-title-right { display: none; }

  .assinatura-page > .alert {
    margin-left: 0;
    margin-right: 0;
  }

  .assinatura-plan-col .card,
  .assinatura-history-col .card {
    margin-bottom: 10px;
    border-radius: 7px;
  }

  .assinatura-plan-col .card-body { padding: 14px !important; }

  .assinatura-plan-col .avatar-sm {
    width: 38px;
    height: 38px;
  }

  .assinatura-plan-col .avatar-title { font-size: 15px !important; }
  .assinatura-plan-col h5 { font-size: 16px; }
  .assinatura-plan-col h2 { font-size: 23px; }
  .assinatura-plan-col .mb-4 { margin-bottom: 14px !important; }
  .assinatura-plan-col .mb-3 { margin-bottom: 11px !important; }
  .assinatura-plan-col .btn { min-height: 42px; font-size: 12px !important; }

  .assinatura-history-col .card-header {
    padding: 12px !important;
  }
  .assinatura-history-col .card-title { font-size: 14px; }

  .assinatura-history table { display: none; }
  .assinatura-mobile-list { display: block; padding: 8px; }

  .invoice-mobile-card {
    padding: 11px;
    margin-bottom: 7px;
    border: 1px solid var(--vz-border-color);
    border-radius: 7px;
    background: var(--vz-card-bg, #fff);
  }
  .invoice-mobile-card:last-child { margin-bottom: 0; }
  .invoice-code {
    max-width: 72%;
    overflow-wrap: anywhere;
    font-size: 11px;
  }
  .invoice-mobile-card .badge { font-size: 9px; }
  .invoice-mobile-info {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
    margin-top: 10px;
    font-size: 12px;
  }
  .invoice-mobile-info span { display: flex; flex-direction: column; }
  .invoice-mobile-info small {
    margin-bottom: 2px;
    color: var(--vz-secondary-color);
    font-size: 9px;
    text-transform: uppercase;
  }
  .invoice-mobile-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    padding-top: 9px;
    margin-top: 9px;
    border-top: 1px solid var(--vz-border-color);
    font-size: 10px;
  }
  .invoice-mobile-footer .btn { font-size: 10px; }
}

</style>
