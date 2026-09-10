<script>
import axios from 'axios';

export default {
  name: "ArtistDashboard",
  data() {
    return {
      loading: true,
      
      // Matriz de métricas alimentada de forma unificada pelo .NET 10
      metrics: {
        showsEsteMes: 0,
        cachesAReceber: 0,
        pacotesCriados: 0,
        totalPacotesPermitidos: 3,
        pacotesRestantesDisponiveis: 3,
        totalFotosPermitidasNoPlano: 5,
        fotosRestantesDisponiveis: 5,
        raioDeslocamentoKm: 0,
        progressoEpkPercentual: 0,
        proximosShows: []
      },

      // VARIÁVEIS DE COMPLIANCE FINANCEIRO E OPERACIONAL (100% DINÂMICAS)
      asaasAccountStatus: "NOT_CREATED", // NOT_CREATED, PENDING, APPROVED
      onboardingLink: "",
      
      // 🆕 ADICIONADO: Flag de controle real capturada do MariaDB para o card de frete
      hasLogisticsConfigured: true 
    };
  },

  methods: {
    // CARREGAMENTO REAL: Consome o endpoint que atualizamos com as flags universais
    async loadDashboardData() {
      this.loading = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/dashboard-metrics`, config);
        
        // Alimenta a malha de métricas padrão
        this.metrics = response.data;

        // CAPTURA REATIVA: Alimenta os estados de conformidade vindos do C# sem cache antigo
        this.asaasAccountStatus = response.data.asaasAccountStatus || "NOT_CREATED";
        this.onboardingLink = response.data.onboardingLink || "";
        
        // 🆕 S_INCRONIZAÇÃO DA MISSÃO: Preenche o estado da logística direto da tabela física
        this.hasLogisticsConfigured = response.data.hasLogisticsConfigured ?? true;

        this.loading = false;
      } catch (error) {
        this.loading = false;
        console.error("Erro ao ler os dados do painel do artista:", error);
      }
    },

    formatCurrency(value) {
      return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value || 0);
    }
  },

  mounted() {
    this.loadDashboardData();
  }
};
</script>

<template>
  <div>
    <!-- TÍTULO DA DASHBOARD NATIVO DO VELZON -->
    <div class="row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary">Visão Geral do Perfil</h4>
        </div>
      </div>
    </div>

    <!-- SINALIZADOR DE REDE -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status">
        <span class="visually-hidden">Consolidando inventário...</span>
      </div>
      <p class="text-muted mt-2 fs-13">Consolidando inventário de performance...</p>
    </div>

    <div v-else class="animate__animated animate__fadeIn">
      <!-- LINHA DE CARDS DE MÉTRICAS REAIS DO MARIADB -->
      <div class="row">
        <!-- CARD 1: SHOWS DO MÊS -->
        <div class="col-xl-4 col-md-6 mb-4">
          <div class="card card-animate border-0 shadow-sm h-100">
            <div class="card-body p-4 text-start">
              <div class="d-flex align-items-center mb-3">
                <div class="flex-grow-1">
                  <h6 class="text-muted text-uppercase fs-11 font-monospace mb-0 fw-bold">Shows Agendados (Este Mês)</h6>
                </div>
                <div class="avatar-sm flex-shrink-0">
                  <span class="avatar-title bg-soft-primary text-primary rounded-circle fs-18">
                    <i class="ri-calendar-check-line"></i>
                  </span>
                </div>
              </div>
              <h2 class="fw-bold text-dark mb-0 font-monospace">{{ metrics.showsEsteMes }}</h2>
            </div>
          </div>
        </div>

        <!-- CARD 2: CACHÊS EM CUSTÓDIA -->
        <div class="col-xl-4 col-md-6 mb-4">
          <div class="card card-animate border-0 shadow-sm h-100">
            <div class="card-body p-4 text-start">
              <div class="d-flex align-items-center mb-3">
                <div class="flex-grow-1">
                  <h6 class="text-muted text-uppercase fs-11 font-monospace mb-0 fw-bold">Cachês Garantidos a Receber</h6>
                </div>
                <div class="avatar-sm flex-shrink-0">
                  <span class="avatar-title bg-soft-success text-success rounded-circle fs-18">
                    <i class="ri-money-dollar-box-line"></i>
                  </span>
                </div>
              </div>
              <h2 class="fw-bold text-success mb-0 font-monospace">{{ formatCurrency(metrics.cachesAReceber) }}</h2>
            </div>
          </div>
        </div>

        <!-- CARD 3: FORMATOS COMERCIAIS ATIVOS -->
        <div class="col-xl-4 col-md-12 mb-4">
          <div class="card card-animate border-0 shadow-sm h-100">
            <div class="card-body p-4 text-start">
              <div class="d-flex align-items-center mb-3">
                <div class="flex-grow-1">
                  <h6 class="text-muted text-uppercase fs-11 font-monospace mb-0 fw-bold">Formatos de Shows Disponíveis</h6>
                </div>
                <div class="avatar-sm flex-shrink-0">
                  <span class="avatar-title bg-soft-info text-info rounded-circle fs-18">
                    <i class="ri-music-2-line"></i>
                  </span>
                </div>
              </div>
              <h2 class="fw-bold text-dark mb-0 font-monospace">{{ metrics.pacotesCriados }} <span class="fs-14 text-muted fw-normal">/ {{ metrics.totalPacotesPermitidos }}</span></h2>
            </div>
          </div>
        </div>
      </div>
      <!-- BLOCOS INFERIORES CONCORRENTES: PROGRESSO E PRÓXIMOS COMPROMISSOS -->
      <div class="row">
        
        <!-- ESTEIRA DA ESQUERDA: LISTA REATIVA DE AÇÕES RECOMENDADAS (ONBOARDING SELETIVO) -->
        <div class="col-xl-6 col-lg-12 mb-4">
          <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-light border-0 p-3">
              <h5 class="card-title mb-0 text-dark fw-bold">
                <i class="ri-list-check-2 me-1 text-primary"></i> Ações Recomendadas para Evolução
              </h5>
            </div>
            
            <div class="card-body p-3 text-start">
              <!-- BARRA DE PROGRESSO DO EPK MATEMÁTICA PONDERADA CUMULATIVA -->
              <div class="mb-4 bg-light p-3 rounded border fs-13">
                <div class="d-flex justify-content-between align-items-center mb-2">
                  <span class="fw-bold text-dark">Força e Maturidade do Portfólio Comercial</span>
                  <span class="badge bg-success font-monospace fw-bold fs-11">{{ metrics.progressoEpkPercentual }}%</span>
                </div>
                <div class="progress animated-progress progress-sm">
                  <div class="progress-bar bg-success" role="progressbar" :style="`width: ${metrics.progressoEpkPercentual}%`" :aria-valuenow="metrics.progressoEpkPercentual" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
              </div>

              <!-- ESTEIRA FLUIDA DE CARDS DE MISSÕES INDIVIDUAIS (100% DINÂMICAS) -->
              <div class="d-flex flex-column gap-3">
                
                <!-- 🆕 ADICIONADO: CARD DE MISSÃO REAL E UNIVERSAL DE LOGÍSTICA / FRETE -->
                <!-- Desaparece de forma legítima se a flag hasLogisticsConfigured for true no MariaDB -->
                <div v-if="!hasLogisticsConfigured" class="p-3 border rounded border-dashed bg-white d-flex align-items-center justify-content-between animate__animated animate__fadeIn">
                  <div>
                    <h6 class="fw-bold text-dark mb-1">
                      <i class="ri-map-pin-time-line text-info me-1 fs-15"></i> Configurar Logística e Frete de Deslocamento
                    </h6>
                    <small class="text-muted">Estipule suas regras de cobertura gratuita e taxas extras para o cálculo automatizado de cachês.</small>
                  </div>
                  <router-link to="/musicos/logistica" class="btn btn-sm btn-soft-info fw-bold px-3">Configurar</router-link>
                </div>

                <!-- MISSÃO 2: CRIAR SHOWS (Desaparece se atingir 3 formatos) -->
                <div v-if="metrics.pacotesRestantesDisponiveis > 0" class="p-3 border rounded border-dashed bg-white d-flex align-items-center justify-content-between">
                  <div>
                    <h6 class="fw-bold text-dark mb-1">
                      <i class="ri-add-box-line text-primary me-1 fs-15"></i> Cadastrar {{ metrics.pacotesRestantesDisponiveis }} Formatos de Shows
                    </h6>
                    <small class="text-muted">Expanda suas variações de palco, infraestrutura técnica e valores na vitrine pública.</small>
                  </div>
                  <router-link to="/musicos/pacotes" class="btn btn-sm btn-soft-primary fw-bold">Criar</router-link>
                </div>

                <!-- MISSÃO 3: ADICIONAR FOTOS GALERIA (Desaparece se preencher o limite do plano) -->
                <div v-if="metrics.fotosRestantesDisponiveis > 0" class="p-3 border rounded border-dashed bg-white d-flex align-items-center justify-content-between">
                  <div>
                    <h6 class="fw-bold text-dark mb-1">
                      <i class="ri-image-add-line text-success me-1 fs-15"></i> Adicionar {{ metrics.fotosRestantesDisponiveis }} Fotos na Galeria
                    </h6>
                    <small class="text-muted">Alimente o repositório visual para aumentar o engajamento e a conversão de contratantes.</small>
                  </div>
                  <router-link to="/musicos/portfolio" class="btn btn-sm btn-soft-success fw-bold">Upar</router-link>
                </div>

                <!-- MISSÃO 4: CARD DE MISSÃO DA CARTEIRA DIGITAL ASAAS -->
                <!-- Some de forma definitiva da esteira caso o status da subconta vire APPROVED -->
                <div v-if="asaasAccountStatus !== 'APPROVED'" class="p-3 border rounded border-warning bg-soft-warning-subtle d-flex align-items-center justify-content-between animate__animated animate__pulse">
                  <div class="pe-2">
                    <h6 class="fw-bold text-dark mb-1">
                      <i class="ri-wallet-3-fill text-warning me-1 fs-15"></i>
                      {{ asaasAccountStatus === 'NOT_CREATED' ? 'Ativar sua Carteira de Recebimentos' : 'Concluir Onboarding de Segurança' }}
                    </h6>
                    <small class="text-muted d-block">Necessário para liberar você receber pelos seus shows.</small>
                  </div>
                  <div class="flex-shrink-0">
                    <router-link v-if="asaasAccountStatus === 'NOT_CREATED'" to="/musicos/carteira" class="btn btn-sm btn-warning fw-bold shadow-sm px-3">
                      Ativar
                    </router-link>
                    <a v-else-if="asaasAccountStatus === 'PENDING'" :href="onboardingLink" target="_blank" class="btn btn-sm btn-primary fw-bold shadow-sm px-3">
                      Enviar
                    </a>
                  </div>
                </div>

                <!-- ESTADO DE CONQUISTA: EXIBIDO SE TODAS AS MISSÕES FOREM COMPLETADAS -->
                <div v-if="hasLogisticsConfigured && metrics.pacotesRestantesDisponiveis <= 0 && metrics.fotosRestantesDisponiveis <= 0 && asaasAccountStatus === 'APPROVED'" class="text-center py-4 border rounded border-dashed bg-light text-muted">
                  <i class="ri-award-line fs-24 text-success d-block mb-1"></i>
                  Parabéns! Seu perfil está completo, financeiramente ativo e pronto para receber propostas.
                </div>

              </div>
            </div>
          </div>
        </div>

        <!-- ESTEIRA DA DIREITA: CALENDÁRIO COM OS PRÓXIMOS SHOWS AGENDADOS DO MYSQL -->
        <div class="col-xl-6 col-lg-12 mb-4">
          <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-light border-0 p-3">
              <h5 class="card-title mb-0 text-dark fw-bold">
                <i class="ri-time-line me-1 text-info"></i> Próximos 3 Compromissos Confirmados
              </h5>
            </div>
            
            <div class="card-body p-3">
              <div v-if="metrics.proximosShows && metrics.proximosShows.length > 0" class="d-flex flex-column gap-3">
                <div class="d-flex border rounded bg-white p-2" v-for="(show, idx) in metrics.proximosShows" :key="idx">
                  <div class="bg-soft-info p-2 rounded text-center d-flex flex-column justify-content-center" style="width: 60px; min-width: 60px;">
                    <h3 class="fw-bold text-info mb-0 font-monospace fs-20">{{ show.data }}</h3>
                    <small class="text-info-500 font-monospace text-uppercase fs-9 fw-bold">{{ show.mesAno.substring(0, 3) }}</small>
                  </div>
                  <div class="ps-3 text-start flex-grow-1">
                    <h6 class="fw-bold text-dark mb-1 fs-14">{{ show.nomeEvento }}</h6>
                    <p class="text-muted mb-1 small"><i class="ri-map-pin-2-line text-danger me-1"></i>{{ show.local }}</p>
                    <small class="text-muted font-monospace bg-light p-1 rounded fs-10">{{ show.cidadeEstado }}</small>
                  </div>
                </div>
              </div>
              <div v-else class="text-center py-5 border rounded border-dashed text-muted fs-12 h-100 d-flex flex-column align-items-center justify-content-center">
                <i class="ri-calendar-event-line fs-24 d-block mb-1"></i>
                Nenhum show confirmado na agenda para as próximas semanas.
              </div>
            </div>
          </div>
        </div>

      </div>
    </div> <!-- FECHAMENTO DO V-ELSE PRINCIPAL -->
  </div>
</template>
