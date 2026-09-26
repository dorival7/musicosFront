<script>
import axios from 'axios';

export default {
  name: "MusicoLogistica",
  data() {
    return {
      loading: true,
      saving: false,
      successMessage: null,
      errorMessage: null,
      
      // Modelo de dados numérico limpo sincronizado com o .NET 10 / MySQL
      form: {
        freeRadiusKm: 0,
        extraKmValue: 0.00,
        acceptExtraHours: false,
        extraHourValue: 0.00,
        attendedRegions: ""
      },

      // Propriedades temporárias de espelho para as máscaras em tela
      displayExtraKm: "",
      displayExtraHour: ""
    };
  },
  methods: {
    // 1. CARREGA OS DADOS REAIS DO BANCO DE DADOS VIA GET
    async loadLogisticsSettings() {
      this.loading = true;
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/commercial-settings`, config);
        
        if (response.data) {
          this.form.freeRadiusKm = response.data.freeRadiusKm ?? 0;
          this.form.extraKmValue = response.data.extraKmValue ?? 0.00;
          this.form.acceptExtraHours = response.data.acceptExtraHours ?? false;
          this.form.extraHourValue = response.data.extraHourValue ?? 0.00;
          this.form.attendedRegions = response.data.attendedRegions ?? "";

          // INICIALIZAÇÃO DE MÁSCARA: Formata os valores salvos no boot da tela
          this.displayExtraKm = this.formatCurrencyRaw(this.form.extraKmValue);
          this.displayExtraHour = this.formatCurrencyRaw(this.form.extraHourValue);
        }
        
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.errorMessage = "Erro ao carregar dados de logística do banco de dados.";
        console.error("Erro ao buscar configurações comerciais:", error);
      }
    },

    // GATILHO REATIVO DE DIGITAÇÃO: Executa a formatação elástica (CORRIGIDO SEM ESPAÇOS)
    handleMoneyInput(fieldName, event) {
      let inputValue = event.target.value;

      // Remove absolutamente tudo o que não for dígito numérico
      let apenasNumeros = inputValue.replace(/\D/g, "");

      if (!apenasNumeros) apenasNumeros = "0";

      // CORREÇÃO: Variável unificada sem espaços para não quebrar o compilador
      const valorDecimalPuro = parseFloat(apenasNumeros) / 100;

      // Sincroniza a propriedade real com o número decimal puro que o C# exige
      this.form[fieldName] = valorDecimalPuro;

      // Atualiza o espelho de texto com a máscara brasileira formatada visualmente
      if (fieldName === 'extraKmValue') {
        this.displayExtraKm = this.formatCurrencyRaw(valorDecimalPuro);
      } else if (fieldName === 'extraHourValue') {
        this.displayExtraHour = this.formatCurrencyRaw(valorDecimalPuro);
      }
    },

    // 2. DISPARO DO UPSERT: Salva ou Atualiza os dados de Frete
    async saveSettings() {
      this.saving = true;
      this.successMessage = null;
      this.errorMessage = null;
      
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        // Envia o payload puramente decimal numérico para o backend
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/commercial-settings`, this.form, config);

        this.successMessage = "Configurações de logística comercial atualizadas com sucesso!";
        this.saving = false;
        
        if (localStorage.getItem('profileStatus') === 'Incomplete_Logistics') {
          localStorage.setItem('profileStatus', 'Incomplete_Packages');
        }

        window.scrollTo({ top: 0, behavior: 'smooth' });
      } catch (error) {
        this.saving = false;
        this.errorMessage = "Erro ao salvar as configurações. Verifique os campos ou o servidor.";
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },

    formatCurrencyRaw(value) {
      return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value || 0);
    }
  },
  mounted() {
    this.loadLogisticsSettings();
  }
};
</script>

<template>
  <div class="logistica-page">
    <!-- CABEÇALHO DA PÁGINA -->
    <div class="row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary">Configurações de Logística e Frete</h4>
          <div class="page-title-right">
            <ol class="breadcrumb m-0">
              <li class="breadcrumb-item"><a href="javascript: void(0);">SevenShows</a></li>
              <li class="breadcrumb-item active">Logística</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <!-- CENTRAL DE BALÕES DE ALERTAS -->
    <div v-if="successMessage" class="alert alert-success alert-dismissible fade show border-0 shadow-sm text-start" role="alert">
      <i class="ri-checkbox-circle-line me-2 align-middle fs-16"></i>
      {{ successMessage }}
      <button type="button" class="btn-close" @click="successMessage = null" aria-label="Close"></button>
    </div>

    <div v-if="errorMessage" class="alert alert-danger alert-dismissible fade show border-0 shadow-sm text-start" role="alert">
      <i class="ri-error-warning-line me-2 align-middle fs-16"></i>
      {{ errorMessage }}
      <button type="button" class="btn-close" @click="errorMessage = null" aria-label="Close"></button>
    </div>

    <!-- TELA DE CARREGAMENTO -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status"></div>
      <p class="text-muted mt-2">Sincronizando regras com o MySQL...</p>
    </div>

    <!-- FORMULÁRIO DE GESTÃO DO MÚSICO -->
    <form v-else class="logistica-form" @submit.prevent="saveSettings">
      <div class="row">
        <!-- COLUNA DA ESQUERDA: CADASTROS DE VALORES E REGRAS -->
        <div class="col-xl-8">
          
          <!-- CARD 1: CONFIGURAÇÕES DE FRETE E DESLOCAMENTO -->
          <div class="card shadow-sm border-0 logistica-card">
            <div class="card-header border-0 align-items-center d-flex bg-light">
              <h4 class="card-title mb-0 flex-grow-1 text-dark fw-bold">Cálculo de Deslocamento Automático</h4>
            </div>
            <div class="card-body text-start">
              <p class="text-muted mb-4">
                Defina o raio de distância no qual você não cobra taxas extras de combustível ou frete, e estipule o valor cobrado por quilômetro adicional percorrido para apresentações distantes.
              </p>
              
              <div class="row">
                <!-- RAIO DE KM GRATUITO -->
                <div class="col-md-6 mb-3">
                  <label for="freeRadius" class="form-label fw-semibold">Raio de Cobertura Gratuita (KM)</label>
                  <div class="input-group">
                    <input type="number" id="freeRadius" class="form-control" placeholder="Ex: 50" v-model.number="form.freeRadiusKm" required min="0" />
                    <span class="input-group-text">KM</span>
                  </div>
                  <small class="text-muted">Abaixo dessa distância, o frete sairá zerado para o contratante.</small>
                </div>

                <!-- VALOR DO KM EXTRA ATUALIZADO COM MÁSCARA DINÂMICA -->
                <div class="col-md-6 mb-3">
                  <label for="extraKmValue" class="form-label fw-semibold">Valor do KM Extra Adicional</label>
                  <div class="input-group">
                    <input 
                      type="text" 
                      id="extraKmValue" 
                      class="form-control text-start font-monospace fw-bold" 
                      placeholder="R$ 0,00" 
                      :value="displayExtraKm"
                      @input="handleMoneyInput('extraKmValue', $event)"
                      required 
                    />
                  </div>
                  <small class="text-muted">Cobrado por cada KM que ultrapassar o raio de gratuidade.</small>
                </div>
              </div>
            </div>
          </div>

          <!-- CARD 2: REGRAS PARA HORAS ADICIONAIS DE SHOW -->
          <div class="card shadow-sm border-0 logistica-card">
            <div class="card-header border-0 align-items-center d-flex bg-light">
              <h4 class="card-title mb-0 flex-grow-1 text-dark fw-bold">Disponibilidade para Horas Extras</h4>
            </div>
            <div class="card-body text-start">
              <p class="text-muted mb-4">
                Informe ao contratante se a sua banda aceita estender o tempo de apresentação caso o evento se atrase ou precise de mais tempo de show ao vivo.
              </p>

              <!-- SWITCH LIGA/DESLIGA DO BOOTSTRAP PURA -->
              <div class="form-check form-switch form-switch-md mb-4 logistica-extra-switch" role="switch">
                <input class="form-check-input" type="checkbox" id="acceptExtraHoursSwitch" v-model="form.acceptExtraHours" />
                <label class="form-check-label fw-medium text-primary" for="acceptExtraHoursSwitch">
                  {{ form.acceptExtraHours ? "Sim, aceitamos realizar horas extras no evento" : "Não, fazemos estritamente o tempo contratado" }}
                </label>
              </div>

              <!-- INPUT DE VALOR DA HORA EXTRA ATUALIZADO COM MÁSCARA DINÂMICA -->
              <div class="row" v-if="form.acceptExtraHours">
                <div class="col-md-6 mb-3">
                  <label for="extraHourValue" class="form-label fw-semibold">Preço por Hora Adicional</label>
                  <div class="input-group">
                    <input 
                      type="text" 
                      id="extraHourValue" 
                      class="form-control text-start font-monospace fw-bold" 
                      placeholder="R$ 0,00" 
                      :value="displayExtraHour"
                      @input="handleMoneyInput('extraHourValue', $event)"
                      required 
                    />
                  </div>
                  <small class="text-muted">Valor cobrado a cada 60 minutos estendidos além do pacote.</small>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- COLUNA DA DIREITA: FILTROS GEOGRÁFICOS E DISPARO -->
        <div class="col-xl-4">
          <!-- CARD 3: REGIÕES ATENDIDAS -->
          <div class="card shadow-sm border-0 logistica-card">
            <div class="card-header border-0 bg-light">
              <h4 class="card-title mb-0 text-dark fw-bold">Área de Atuação Geográfica</h4>
            </div>
            <div class="card-body text-start">
              <p class="text-muted mb-3">
                Liste as cidades, regiões ou estados para os quais sua banda aceita fechar contratos e viajar.
              </p>
              
              <div class="mb-3">
                <label for="attendedRegions" class="form-label fw-semibold">Regiões Atendidas</label>
                <textarea id="attendedRegions" class="form-control" rows="4" placeholder="Ex: São Paulo Capital, Vale do Paraíba, Sul de Minas, Todo o Paraná..." v-model="form.attendedRegions" required></textarea>
                <small class="text-muted">Separe as localizações por vírgula para facilitar a leitura.</small>
              </div>
            </div>
          </div>

          <!-- BOTÃO DE SUBMISSÃO DA PLATAFORMA -->
          <div class="card bg-transparent border-0 shadow-none">
            <button type="submit" class="btn btn-success btn-lg w-100 shadow-sm fw-bold logistica-save-btn" :disabled="saving">
              <i class="ri-save-line me-1 align-middle" v-if="!saving"></i>
              {{ saving ? "Processando e Gravando no MySQL..." : "Salvar Configurações Comerciais" }}
            </button>
            <p class="text-muted text-center fs-11 mt-2 mb-0">
              Ao salvar, suas regras de frete passam a calcular instantaneamente o orçamento na Landing Page de vendas.
            </p>
          </div>
        </div>

      </div>
    </form>
  </div>
</template>


<style scoped>
@media (max-width: 767.98px) {
  /* Mesmo padrão de largura útil aprovado na Agenda. */
  .logistica-page { margin-left: -12px; margin-right: -12px; }
  .logistica-page > .row { margin-left: 0; margin-right: 0; }
  .logistica-page > .row > [class*="col-"] { min-width: 0; padding-left: 0; padding-right: 0; }

  .page-title-box {
    min-height: auto;
    width: 100vw;
    max-width: 100vw;
    margin-left: calc(50% - 50vw);
    margin-right: calc(50% - 50vw);
    padding: 10px 12px 12px;
    display: flex !important;
    justify-content: center !important;
    text-align: center;
    box-sizing: border-box;
  }
  .page-title-box h4 {
    width: 100%;
    margin: 0;
    font-size: 15px;
    line-height: 1.25;
    font-weight: 700;
    text-align: center;
  }
  .page-title-right { display: none !important; }

  .logistica-page > .alert {
    margin: 10px 6px 0;
    padding: 10px 12px;
    font-size: 12px;
    border-radius: 8px;
  }

  .logistica-form { padding: 10px 6px 18px; }
  .logistica-form > .row {
    --bs-gutter-x: 0;
    --bs-gutter-y: 0;
    margin: 0;
  }
  .logistica-form > .row > [class*="col-"] {
    min-width: 0;
    padding-left: 0;
    padding-right: 0;
  }

  .logistica-card {
    margin-bottom: 10px;
    border-radius: 9px;
    overflow: hidden;
  }
  .logistica-card .card-header {
    min-height: auto;
    padding: 11px 12px !important;
  }
  .logistica-card .card-title {
    font-size: 14px;
    line-height: 1.25;
  }
  .logistica-card .card-body {
    padding: 12px !important;
  }
  .logistica-card .card-body > p {
    margin-bottom: 13px !important;
    font-size: 12px;
    line-height: 1.45;
  }
  .logistica-card .row {
    --bs-gutter-x: 10px;
    --bs-gutter-y: 0;
  }
  .logistica-card .mb-3 { margin-bottom: 12px !important; }

  .logistica-card .form-label {
    margin-bottom: 5px;
    font-size: 12px;
  }
  .logistica-card .form-control,
  .logistica-card .input-group-text {
    min-height: 44px;
    font-size: 14px;
  }
  .logistica-card textarea.form-control {
    min-height: 92px;
    resize: vertical;
  }
  .logistica-card small {
    display: block;
    margin-top: 4px;
    font-size: 10px;
    line-height: 1.35;
  }

  .logistica-extra-switch {
    display: flex;
    align-items: center;
    gap: 10px;
    min-height: 46px;
    margin: 0 0 12px !important;
    padding: 8px 10px 8px 48px;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    background: #f8fafb;
  }
  .logistica-extra-switch .form-check-input {
    width: 38px;
    height: 20px;
    margin-left: -38px;
    margin-top: 0;
    flex: 0 0 auto;
  }
  .logistica-extra-switch .form-check-label {
    font-size: 12px;
    line-height: 1.35;
  }

  .logistica-save-btn {
    min-height: 46px;
    padding: 10px 12px;
    border-radius: 7px;
    font-size: 14px;
  }
  .logistica-form .col-xl-4 > .card.bg-transparent {
    margin: 2px 0 0;
  }
  .logistica-form .col-xl-4 > .card.bg-transparent .fs-11 {
    padding: 0 8px;
    font-size: 10px !important;
    line-height: 1.4;
  }
}
</style>
