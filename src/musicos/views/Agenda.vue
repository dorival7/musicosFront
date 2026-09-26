<script>
import axios from 'axios';

export default {
  name: "ArtistAgendaManager",
  data() {
    return {
      // Sinalizadores de carregamento concorrente e feedbacks visuais do Velzon
      loadingCalendar: true,
      loadingRequests: true,
      submittingAction: false,
      successMessage: null,
      errorMessage: null,
      availabilitySaveState: null, // saving | saved | error
      availabilitySaveMessage: null,
      mobileAgendaSection: null,

      // Matrizes de dados puros sincronizadas com o C# e MariaDB
      calendarDays: [],
      allRequests: [], // Centraliza todas as propostas para fatiamento local em RAM
      weeklyAvailability: [], // Matriz estática de 7 dias com chaves liga/desliga
      activeBlocks: [],      // Armazenará a coleção legítima de recessos vinda da API
      editingBlockId: null,  // Ponteiro reativo: guarda o ID do recesso em edição

      // Navegação cronológica elástica (Sincronizado em Setembro de 2026)
      currentMonth: new Date().getMonth() + 1, 
      currentYear: new Date().getFullYear(),   

      // Formulário unificado: preparado tanto para inserção (POST) quanto para edição (PUT)
      blockForm: {
        startDate: "", // Data Inicial do recesso
        endDate: "",   // Data Final do recesso
        reason: ""
      },

      // CONTROLE DE INTERAÇÃO DA MODAL DE DETALHES DO SHOW (BALÃO AZUL/LARANJA/ROXO)
      selectedEvent: null,
      showDetailsModal: false,
      cartazEventoExiste: false,
      verificandoCartazEvento: false,

      // CONTROLE DA MESA DE NEGOCIAÇÕES (MODAL DE DECISÃO DA RECUSA)
      activeTargetRequest: null,
      showDecisionModal: false,   
      negotiationNotes: ""        
    };
  },

  computed: {
    // FILTROS ELÁSTICOS LOCAIS: Evitam múltiplas requisições de rede pesadas contra a API
    listaRecebidas() {
      return this.allRequests.filter(r => r.status && r.status.toLowerCase() === 'pending');
    },
    listaNegociando() {
      return this.allRequests.filter(r => r.status && r.status.toLowerCase() === 'in_negotiation');
    },
    listaRecusadas() {
      return this.allRequests.filter(r => r.status && r.status.toLowerCase() === 'rejected');
    },

    // FILTRO CRONOLÓGICO DE UX: Varre a memória local e exibe apenas recessos vigentes ou futuros
    listaRecusosFuturos() {
      const hoje = new Date();
      hoje.setHours(0, 0, 0, 0); // Limpa frações de horas para comparação milimétrica

      return this.activeBlocks.filter(b => {
        if (!b.startDate && !b.endDate) return false;
        // Avalia o término do recesso contra o dia de hoje
        const dataTermino = b.endDate ? new Date(b.endDate) : new Date(b.startDate);
        return dataTermino >= hoje;
      });
    }
  },

  methods: {
    // 1. CARREGAMENTO INICIAL: Consome a visão unificada elástica com suporte a multi-eventos
    async loadCalendarView() {
      this.loadingCalendar = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = {
          headers: { Authorization: `Bearer ${token}` },
          params: { month: this.currentMonth, year: this.currentYear }
        };

        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/calendar-view`, config);
        this.calendarDays = response.data || [];
        this.loadingCalendar = false;
      } catch (error) {
        this.loadingCalendar = false;
        this.errorMessage = "Falha ao renderizar o mapa de calor do calendário.";
      }
    },

    // 2. BUSCA GLOBAL DE PEDIDOS: Puxa todas as propostas ativas de uma só vez (Otimizado)
    async loadAllRequests() {
      this.loadingRequests = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/requests`, config);
        this.allRequests = response.data || [];
        this.loadingRequests = false;
      } catch (error) {
        this.loadingRequests = false;
        this.errorMessage = "Erro ao carregar a esteira transacional do banco de dados.";
      }
    },

    // 3. GRADE SEMANAL RECORRENTE: Renderiza os 7 dias fixos e liga apenas os ativos no MariaDB
    async loadWeeklyAvailability() {
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        const gradePadraoSeteDias = [
          { dayOfWeek: 0, startTime: "19:00:00", endTime: "23:59:00", isAvailable: false },
          { dayOfWeek: 1, startTime: "19:00:00", endTime: "23:59:00", isAvailable: false },
          { dayOfWeek: 2, startTime: "19:00:00", endTime: "23:59:00", isAvailable: false },
          { dayOfWeek: 3, startTime: "19:00:00", endTime: "23:59:00", isAvailable: false },
          { dayOfWeek: 4, startTime: "19:00:00", endTime: "23:59:00", isAvailable: false },
          { dayOfWeek: 5, startTime: "21:00:00", endTime: "03:00:00", isAvailable: false },
          { dayOfWeek: 6, startTime: "18:00:00", endTime: "04:00:00", isAvailable: false }
        ];

        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/availability`, config);
        const dadosDoBanco = response.data || [];

        this.weeklyAvailability = gradePadraoSeteDias.map(diaFixo => {
          const correspondenteNoBanco = dadosDoBanco.find(d => d.dayOfWeek === diaFixo.dayOfWeek);
          if (correspondenteNoBanco) {
            return {
              id: correspondenteNoBanco.id, 
              dayOfWeek: correspondenteNoBanco.dayOfWeek,
              startTime: correspondenteNoBanco.startTime,
              endTime: correspondenteNoBanco.endTime,
              isAvailable: correspondenteNoBanco.isAvailable
            };
          }
          return diaFixo;
        });
      } catch (error) {
        console.error("Erro no mapeamento estático da grade de 7 dias:", error);
      }
    }
    , // 👈 VÍRGULA DE UNIÃO SINTÁTICA CRÍTICA DE MÉTODOS

    // 4. ACEITAR SHOW: Altera o status da proposta real no banco para Pre_Approved
    async handleAcceptRequest(requestId) {
      this.successMessage = null;
      this.errorMessage = null;
      this.submittingAction = true;

      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/requests/${requestId}/accept`, {}, config);
        this.successMessage = "Show aceito com sucesso! Data reservada e enviada para pagamento do contratante.";
        
        await this.refreshAgendaDashboard();
      } catch (error) {
        this.submittingAction = false;
        this.errorMessage = error.response?.data || "Erro ao processar o aceite do show.";
      }
    },

    // GATILHO INTERMEDIÁRIO: Intercepta o clique no botão Recusar e joga na Modal de Decisão
    triggerRequestDecision(requestItem) {
      this.activeTargetRequest = requestItem;
      this.negotiationNotes = ""; 
      this.showDecisionModal = true;
    },

    // 5. RECUSAR DE VEZ: Aciona o endpoint POST /reject enviando a justificativa
    async handleRejectRequestFinal() {
      this.successMessage = null;
      this.errorMessage = null;
      this.submittingAction = true;

      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        const payload = { notes: this.negotiationNotes || "Recusado pelo artista." };

        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/requests/${this.activeTargetRequest.id}/reject`, payload, config);
        this.successMessage = "Proposta recusada de vez. O dia correspondente foi liberado na vitrine pública.";
        
        this.showDecisionModal = false;
        await this.refreshAgendaDashboard();
      } catch (error) {
        this.submittingAction = false;
        this.errorMessage = error.response?.data || "Erro ao processar o descarte do show.";
      }
    },

    // 6. ENVIAR PARA NEGOCIAÇÃO: Aciona o endpoint POST /negotiate criando a contraproposta
    async handleNegotiateRequest() {
      this.successMessage = null;
      this.errorMessage = null;

      if (!this.negotiationNotes.trim()) {
        alert("Por favor, digite uma mensagem ou contraproposta para iniciar a negociação.");
        return;
      }

      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        const payload = { notes: this.negotiationNotes };

        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/requests/${this.activeTargetRequest.id}/negotiate`, payload, config);
        this.successMessage = "Proposta enviada para a mesa de negociações. O dia acendeu em roxo no calendário.";
        
        this.showDecisionModal = false;
        await this.refreshAgendaDashboard();
      } catch (error) {
        this.submittingAction = false;
        this.errorMessage = error.response?.data || "Erro ao abrir canal de negociação.";
      }
    },

    // 7. SALVAR GRADE DE ROTINA: Altera a matriz semanal (PUT /availability) de 7 posições
    async handleSaveDayAvailability(dayItem) {
      // O feedback desta operação fica junto da grade semanal, onde o músico está editando.
      this.availabilitySaveState = 'saving';
      this.availabilitySaveMessage = 'Salvando alterações...';
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        
        const payload = {
          dayOfWeek: dayItem.dayOfWeek,
          startTime: this.normalizeTimeForApi(dayItem.startTime),
          endTime: this.normalizeTimeForApi(dayItem.endTime),
          isAvailable: dayItem.isAvailable
        };

        await axios.put(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/availability`, payload, config);
        this.availabilitySaveState = 'saved';
        this.availabilitySaveMessage = 'Alterações salvas automaticamente';
        await this.loadCalendarView();
      } catch (error) {
        this.availabilitySaveState = 'error';
        this.availabilitySaveMessage = 'Não foi possível salvar. Tente novamente.';
      }
    },

    formatTimeForDisplay(value) {
      if (!value) return '';
      return String(value).slice(0, 5);
    },

    normalizeTimeForApi(value) {
      if (!value) return value;
      const time = String(value).trim();
      return /^\d{2}:\d{2}$/.test(time) ? `${time}:00` : time;
    },

    isValidTime(value) {
      const match = String(value || '').match(/^(\d{2}):(\d{2})$/);
      if (!match) return false;
      const hours = Number(match[1]);
      const minutes = Number(match[2]);
      return hours >= 0 && hours <= 23 && minutes >= 0 && minutes <= 59;
    },

    maskTimeValue(value) {
      const digits = String(value || '').replace(/\D/g, '').slice(0, 4);
      if (digits.length <= 2) return digits;
      return `${digits.slice(0, 2)}:${digits.slice(2)}`;
    },

    handleTimeFocus(dayItem, field, event) {
      event.target.dataset.originalValue = this.formatTimeForDisplay(dayItem[field]);
      event.target.select();
    },

    handleTimeInput(dayItem, field, event) {
      const masked = this.maskTimeValue(event.target.value);
      event.target.value = masked;
      dayItem[field] = masked;
    },

    handleTimeBlur(dayItem, field, event) {
      const value = String(dayItem[field] || '').trim();
      if (!this.isValidTime(value)) {
        const original = event.target.dataset.originalValue || '';
        dayItem[field] = original;
        event.target.value = original;
        return;
      }
      this.handleSaveDayAvailability(dayItem);
    },

    // 8. GERENCIADOR DE RECESSO UNIFICADO: Detecta e executa a Inserção (POST) ou Edição (PUT)
    async handleCreateManualBlock() {
      this.successMessage = null;
      this.errorMessage = null;
      if (!this.blockForm.startDate || !this.blockForm.endDate) return;

      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        const payload = {
          startDate: this.blockForm.startDate,
          endDate: this.blockForm.endDate, 
          reason: this.blockForm.reason
        };

        if (this.editingBlockId) {
          // SE ESTIVER EM MODO EDIÇÃO: Bate na rota PUT que blindamos no C#
          await axios.put(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/blocks/${this.editingBlockId}`, payload, config);
          this.successMessage = "Intervalo de recesso editado e atualizado com sucesso!";
        } else {
          // SE ESTIVER EM MODO INSERÇÃO: Mantém o fluxo tradicional de POST
          await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/blocks`, payload, config);
          this.successMessage = "Novo intervalo de recesso bloqueado no seu calendário!";
        }

        this.handleCancelEditBlock(); // Reseta e limpa os campos do formulário lateral
        await Promise.all([this.loadCalendarView(), this.loadActiveBlocks()]);
      } catch (error) {
        this.errorMessage = error.response?.data?.message || error.response?.data || "Erro ao tentar processar o recesso.";
      } finally {
        this.submittingAction = false;
      }
    },

    // ADICIONADO: Método que consome o GET do C# para trazer a lista de travas salvas
    async loadActiveBlocks() {
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/blocks`, config);
        this.activeBlocks = response.data || [];
      } catch (error) {
        console.error("Erro na leitura dos recessos agendados:", error);
      }
    },

    // ADICIONADO: Gatilho que joga as informações do recesso de volta nos inputs para edição
    handleSetupEditBlock(blockItem) {
      this.editingBlockId = blockItem.id;
      
      // Corta o rastro de timestamps ('T00:00:00') para o input date do HTML5 reconhecer
      this.blockForm.startDate = blockItem.startDate ? blockItem.startDate.split('T')[0] : "";
      this.blockForm.endDate = blockItem.endDate ? blockItem.endDate.split('T')[0] : "";
      this.blockForm.reason = blockItem.reason;
    },

    // ADICIONADO: Reseta a memória e desliga o modo de edição, limpando os campos
    handleCancelEditBlock() {
      this.editingBlockId = null;
      this.blockForm.startDate = "";
      this.blockForm.endDate = "";
      this.blockForm.reason = "";
    },

    // ADICIONADO: Dispara o expurgo definitivo (DELETE) contra o C# liberando o calendário na hora
    async handleDeleteBlock(blockId) {
      if (!confirm("Deseja realmente cancelar este intervalo de recesso e liberar as datas para novos shows?")) return;

      this.submittingAction = true;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };

        await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/blocks/${blockId}`, config);
        this.successMessage = "Recesso cancelado. Horários liberados com sucesso na vitrine pública!";
        
        if (this.editingBlockId === blockId) this.handleCancelEditBlock();
        await Promise.all([this.loadCalendarView(), this.loadActiveBlocks()]);
      } catch (error) {
        this.errorMessage = "Falha ao tentar remover o bloqueio da agenda.";
      } finally {
        this.submittingAction = false;
      }
    },

    // SINCRO CONCORRENTE: Atualiza o estado global sem gargalos de concorrência
    async refreshAgendaDashboard() {
      await Promise.all([
        this.loadCalendarView(),
        this.loadAllRequests()
      ]);
      this.submittingAction = false;
    },

    urlPublicaApi(url) {
      if (!url) return null;
      if (/^https?:\/\//i.test(url)) return url;
      const api = (process.env.VUE_APP_API_BASE_URL || "http://localhost:5297").replace(/\/$/, "");
      const origem = api.replace(/\/api$/i, "");
      return `${origem}${url.startsWith("/") ? "" : "/"}${url}`;
    },

    // DETALHES DO SHOW: mantém o músico na Agenda e abre o raio-X em modal.
    async handleOpenEventDetails(evento) {
      if (!evento || evento.status === "Blocked") return;
      this.selectedEvent = evento;
      const chaveLocal = evento?.id ? `sevenDesignerPosterEvent:${String(evento.id).toLowerCase()}` : null;
      // Resposta imediata no modal. O vínculo local é gravado pelo Designer após
      // criar/abrir com sucesso e evita o botão piscar ou voltar para "Criar cartaz".
      this.cartazEventoExiste = !!(chaveLocal && localStorage.getItem(chaveLocal));
      this.showDetailsModal = true;

      if (String(evento.status || "").toLowerCase() !== "confirmed" || !evento.id) return;

      this.verificandoCartazEvento = true;
      try {
        const token = localStorage.getItem("jwt");
        const api = (process.env.VUE_APP_API_BASE_URL || "http://localhost:5297").replace(/\/$/, "");
        const headers = { Authorization: `Bearer ${token}` };
        let existe = this.cartazEventoExiste;
        let posterId = null;

        try {
          const { data } = await axios.get(`${api}/tenants/designer-posters/by-event/${evento.id}`, { headers });
          existe = data?.exists === true || data?.Exists === true;
          posterId = data?.posterId || data?.PosterId || null;
        } catch (_) {
          // Fallback compatível com camelCase/PascalCase.
          const { data } = await axios.get(`${api}/tenants/designer-posters`, { headers });
          const itens = Array.isArray(data?.items) ? data.items : (Array.isArray(data?.Items) ? data.Items : []);
          // Compatibilidade com cartazes antigos criados pela Agenda antes do EventId
          // começar a ser devolvido pela listagem. O nome do draft é determinístico.
          const dt = evento.eventDate ? new Date(evento.eventDate) : null;
          const dataValida = dt && !Number.isNaN(dt.getTime());
          const dataNome = dataValida
            ? `${String(dt.getDate()).padStart(2, "0")}-${String(dt.getMonth() + 1).padStart(2, "0")}`
            : "Show";
          const localNome = evento.venueName || evento.city || "Evento";
          const nomeEsperado = `Show ${dataNome} - ${localNome}`.slice(0, 120).trim().toLowerCase();

          const encontrado = itens.find(p => {
            const vinculo = String(p.eventId || p.EventId || "").toLowerCase();
            const nome = String(p.name || p.Name || "").trim().toLowerCase();
            return vinculo === String(evento.id).toLowerCase() || nome === nomeEsperado;
          });
          existe = !!encontrado || existe;
          posterId = encontrado?.id || encontrado?.Id || posterId;
        }

        if (existe && chaveLocal) localStorage.setItem(chaveLocal, String(posterId || "linked"));
        if (this.selectedEvent?.id === evento.id) this.cartazEventoExiste = existe;
      } catch (e) {
        // Em falha de rede/API, não apaga um vínculo já confirmado neste navegador.
        this.cartazEventoExiste = !!(chaveLocal && localStorage.getItem(chaveLocal));
      } finally {
        this.verificandoCartazEvento = false;
      }
    },

    handleCloseEventDetails() {
      this.showDetailsModal = false;
      this.selectedEvent = null;
    },

    // SHOW CONFIRMADO -> SEVEN DESIGNER
    // O contexto fica apenas na sessão do navegador; o Designer o consome uma vez.
    criarCartazDoShow() {
      if (!this.selectedEvent || String(this.selectedEvent.status || "").toLowerCase() !== "confirmed") return;

      const evento = this.selectedEvent;
      const contexto = {
        origem: "agenda",
        eventId: evento.id,
        titulo: evento.title || evento.eventName || "Show ao vivo",
        eventType: evento.eventType || "Show",
        eventDate: evento.eventDate || null,
        venueName: evento.venueName || "",
        city: evento.city || "",
        state: evento.state || "",
        contractorName: evento.contractorName || "",
        contractorLogoUrl: this.urlPublicaApi(evento.contractorLogoUrl)
      };

      sessionStorage.setItem("sevenDesignerEventContext", JSON.stringify(contexto));
      this.handleCloseEventDetails();
      this.$router.push({ name: "musicos-recursos-ia", query: { ferramenta: "designer", origem: "agenda" } });
    },

    // CONTROLE CRONOLÓGICO: Avançar ou retroceder meses no calendário
    handleNavigateMonth(direction) {
      if (direction === 'prev') {
        if (this.currentMonth === 1) {
          this.currentMonth = 12;
          this.currentYear--;
        } else {
          this.currentMonth--;
        }
      } else {
        if (this.currentMonth === 12) {
          this.currentMonth = 1;
          this.currentYear++;
        } else {
          this.currentMonth++;
        }
      }
      this.loadCalendarView();
    },

    getDayName(dayIndex) {
      const names = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"];
      return names[dayIndex] || "Desconhecido";
    },

    getTranslateMonthName(monthNumber) {
      const months = [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
      ];
      return months[monthNumber - 1] || "";
    }
  },
  mounted() {
    this.loadCalendarView();
    this.loadAllRequests();
    this.loadWeeklyAvailability();
    this.loadActiveBlocks(); // Garante o carregamento do inventário de recessos no boot da tela
  }
};
</script>

<template>
  <div class="agenda-page">
    <!-- TÍTULO DA PÁGINA NATIVO DO TEMPLATE VELZON -->
    <div class="row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary">Minha Agenda</h4>
        </div>
      </div>
    </div>

    <!-- FEEDBACKS VISUAIS REATIVOS DE SUCESSO OU ERRO -->
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

    <!-- CARD PRINCIPAL EM GRID RESPONSIVO (ESQUERDA: CALENDÁRIO | DIREITA: PAINEL LATERAL) -->
    <div class="row">
      
      <!-- COLUNA DA ESQUERDA: O MAPA DE CALOR MENSAL DO SEVENSHOWS -->
      <div class="col-xl-7 col-lg-12 mb-4">
        <div class="card h-100 shadow-sm border-0 agenda-calendar-card">
          <div class="card-header bg-light border-0 d-flex justify-content-between align-items-center p-3 agenda-calendar-header">
            <h5 class="card-title mb-0 text-dark fw-bold">
              <i class="ri-calendar-todo-line me-1 text-primary"></i> Visão Geral: {{ getTranslateMonthName(currentMonth) }} de {{ currentYear }}
            </h5>
            <div class="btn-group agenda-month-nav">
              <button type="button" class="btn btn-sm btn-outline-secondary" @click="handleNavigateMonth('prev')" aria-label="Mês anterior">
                <i class="ri-arrow-left-s-line"></i><span class="agenda-nav-label"> Mês Anterior</span>
              </button>
              <button type="button" class="btn btn-sm btn-outline-secondary" @click="handleNavigateMonth('next')" aria-label="Próximo mês">
                <span class="agenda-nav-label">Próximo Mês </span><i class="ri-arrow-right-s-line"></i>
              </button>
            </div>
          </div>
          
          <div class="card-body">
            <div v-if="loadingCalendar" class="text-center py-5">
              <div class="spinner-border text-primary avatar-sm" role="status"></div>
              <p class="text-muted mt-2 fs-13">Processando mapa de calor da agenda...</p>
            </div>

            <!-- GRID ATÔMICO DE DIAS DO MÊS -->
            <div v-else class="row g-2 row-cols-xxl-5 row-cols-lg-4 row-cols-md-3 row-cols-2 agenda-days-grid">
              <div class="col" v-for="day in calendarDays" :key="day.date">
                <div :class="`card border shadow-none mb-0 bg-${day.color}-subtle border-${day.color} text-center h-100 agenda-day-card`">
                  <div class="p-2 d-flex flex-column h-100 justify-content-between">
                    <div class="mb-2">
                      <span :class="`fs-18 fw-bold text-${day.color === 'light' ? 'dark' : day.color}`">
                        {{ day.date ? new Date(day.date + 'T00:00:00').getDate() : '' }}
                      </span>
                      <small class="text-muted d-block font-monospace fs-10 mb-1">{{ getDayName(day.dayOfWeek) }}</small>
                    </div>
                    
                    <!-- LAÇO ANINHADO: EMPILHA E EXIBE QUANTOS COMPROMISSOS O DIA TIVER NO BANCO -->
                    <div class="d-flex flex-column gap-1 w-100" v-if="day.events && day.events.length > 0">
                      <span 
                        v-for="evt in day.events" 
                        :key="evt.id" 
                        @click="handleOpenEventDetails(evt)"
                        :style="evt.status !== 'Blocked' ? 'cursor: pointer;' : ''"
                        :class="`badge bg-${evt.color} text-white d-block text-wrap fs-10 py-1 shadow-sm`"
                        :title="evt.status !== 'Blocked' ? 'Clique para auditar detalhes logísticos' : ''"
                      >
                        {{ evt.status === 'Confirmed' ? '🎉' : (evt.status === 'In_Negotiation' ? '💬' : (evt.status === 'Blocked' ? '🚫' : '⏳')) }} {{ evt.title }}
                      </span>
                    </div>

                    <!-- ESTADO PADRÃO: EXIBIDO APENAS SE NÃO HOUVER NENHUM SHOW NO DIA -->
                    <div v-else>
                      <span :class="`badge bg-${day.color} text-${day.color === 'light' ? 'dark' : 'white'} d-block text-wrap fs-10 py-1`">
                        {{ day.cellDefaultTitle }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- LEGENDA REATIVA DE CORES EXPANDIDA -->
            <div class="d-flex flex-wrap gap-3 mt-4 pt-3 border-top justify-content-center agenda-legend">
              <span class="fs-12 text-muted agenda-legend-item"><i class="ri-checkbox-blank-circle-fill text-success me-1"></i> Disponível</span>
              <span class="fs-12 text-muted agenda-legend-item"><i class="ri-checkbox-blank-circle-fill text-info me-1"></i> Confirmado</span>
              <span class="fs-12 text-muted agenda-legend-item"><i class="ri-checkbox-blank-circle-fill text-warning me-1"></i> Pré-Agendado</span>
              <span class="fs-12 text-muted agenda-legend-item"><i class="ri-checkbox-blank-circle-fill text-secondary me-1"></i> Negociando</span>
              <span class="fs-12 text-muted agenda-legend-item"><i class="ri-checkbox-blank-circle-fill text-danger me-1"></i> Travado</span>
              <span class="fs-12 text-muted agenda-legend-item"><i class="ri-checkbox-blank-circle-fill text-dark me-1"></i> Folga</span>
            </div>
          </div>
        </div>
      </div>
      <!-- COLUNA DA DIREITA: PAINEL DE QUATRO ABAS DE NOMES CURTOS (SEM MOCKS) -->
      <div class="col-xl-5 col-lg-12 mb-4">
        <div class="card h-100 shadow-sm border-0 agenda-requests-card">
          
          <!-- SELETOR DE ABAS HORIZONTAIS CURTAS NATIVO DO VELZON -->
          <div class="card-header p-0 border-0 bg-light d-none d-md-block">
            <ul class="nav nav-tabs nav-tabs-custom nav-success fs-12 agenda-tabs" role="tablist">
              <li class="nav-item" role="presentation">
                <a class="nav-link active p-2" data-bs-toggle="tab" href="#recebidasTab" role="tab">
                  Recebidas <span class="badge bg-danger ms-1" v-if="listaRecebidas.length > 0">{{ listaRecebidas.length }}</span>
                </a>
              </li>
              <li class="nav-item" role="presentation">
                <a class="nav-link p-2" data-bs-toggle="tab" href="#negociandoTab" role="tab">
                  Negociando <span class="badge bg-secondary ms-1" v-if="listaNegociando.length > 0">{{ listaNegociando.length }}</span>
                </a>
              </li>
              <li class="nav-item" role="presentation">
                <a class="nav-link p-2" data-bs-toggle="tab" href="#recusadasTab" role="tab">
                  Recusadas <span class="badge bg-dark ms-1" v-if="listaRecusadas.length > 0">{{ listaRecusadas.length }}</span>
                </a>
              </li>
              <li class="nav-item" role="presentation">
                <a class="nav-link p-2" data-bs-toggle="tab" href="#disponibilidadeTab" role="tab">
                  Minha Disponibilidade
                </a>
              </li>
            </ul>
          </div>

          <div class="card-body tab-content p-3">
            
            <!-- LISTAGEM DA ABA 1: RECEBIDAS (PENDING) -->
            <button type="button" class="agenda-accordion-toggle d-md-none" :class="{ active: mobileAgendaSection === 'recebidas' }" @click="mobileAgendaSection = mobileAgendaSection === 'recebidas' ? null : 'recebidas'">
              <span class="agenda-accordion-label"><i class="ri-inbox-archive-line agenda-accordion-section-icon"></i><span class="agenda-accordion-title">Recebidas</span><span class="badge bg-danger" v-if="listaRecebidas.length > 0">{{ listaRecebidas.length }}</span></span>
              <i class="agenda-accordion-chevron" :class="mobileAgendaSection === 'recebidas' ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
            </button>
            <div class="tab-pane active" :class="{ 'mobile-open': mobileAgendaSection === 'recebidas' }" id="recebidasTab" role="tabpanel">
              <div v-if="loadingRequests" class="text-center py-4"><div class="spinner-border text-success avatar-sm" role="status"></div></div>
              <div v-else-if="listaRecebidas.length > 0" class="d-flex flex-column gap-3">
                <div class="card border shadow-none mb-0 agenda-request-item" v-for="req in listaRecebidas" :key="req.id">
                  <div class="card-body p-3 agenda-request-body" @click="handleOpenEventDetails(req)" style="cursor: pointer;" title="Clique para ver o raio-X detalhado da proposta">
                    <div class="d-flex justify-content-between align-items-start border-bottom pb-2 mb-2">
                      <div><h6 class="fw-bold text-dark mb-0">{{ req.eventName }}</h6><small class="text-muted">{{ req.contractorName }}</small></div>
                      <span class="badge bg-soft-success text-success fw-bold">{{ new Date(req.eventDate).toLocaleDateString('pt-BR') }}</span>
                    </div>
                    <div class="bg-light p-2 rounded mb-2 fs-12 text-muted text-start">
                      <div><strong>Show:</strong> {{ req.packageTitle }} | <strong>Distância:</strong> {{ req.distanceKm }} km</div>
                      <div class="text-warning" v-if="req.extraKm > 0">+{{ req.extraKm }} km extra (R$ {{ req.extraKmValueCharged.toFixed(2) }})</div>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <span class="small text-muted">Cachê Proposto:</span><h5 class="text-success fw-bold mb-0">R$ {{ req.totalProposedPrice.toFixed(2) }}</h5>
                    </div>
                    <div class="d-flex gap-2" @click.stop>
                      <button type="button" class="btn btn-sm btn-soft-danger w-50 fw-bold" @click="triggerRequestDecision(req)" :disabled="submittingAction">Recusar</button>
                      <button type="button" class="btn btn-sm btn-success w-50 fw-bold shadow-sm" @click="handleAcceptRequest(req.id)" :disabled="submittingAction">Aceitar</button>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center py-4 border rounded border-dashed text-muted fs-12">Nenhuma proposta recebida pendente.</div>
            </div>

            <!-- LISTAGEM DA ABA 2: NEGOCIANDO (IN_NEGOTIATION) -->
            <button type="button" class="agenda-accordion-toggle d-md-none" :class="{ active: mobileAgendaSection === 'negociando' }" @click="mobileAgendaSection = mobileAgendaSection === 'negociando' ? null : 'negociando'">
              <span class="agenda-accordion-label"><i class="ri-chat-3-line agenda-accordion-section-icon"></i><span class="agenda-accordion-title">Negociando</span><span class="badge bg-secondary" v-if="listaNegociando.length > 0">{{ listaNegociando.length }}</span></span>
              <i class="agenda-accordion-chevron" :class="mobileAgendaSection === 'negociando' ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
            </button>
            <div class="tab-pane" :class="{ 'mobile-open': mobileAgendaSection === 'negociando' }" id="negociandoTab" role="tabpanel">
              <div v-if="listaNegociando.length > 0" class="d-flex flex-column gap-3">
                <div class="card border border-secondary shadow-none mb-0 agenda-request-item" v-for="req in listaNegociando" :key="req.id">
                  <div class="card-body p-3" @click="handleOpenEventDetails(req)" style="cursor: pointer;" title="Clique para ver o raio-X detalhado da renegociação">
                    <div class="d-flex justify-content-between align-items-start border-bottom pb-2 mb-2">
                      <div><h6 class="fw-bold text-dark mb-0">{{ req.eventName }}</h6><small class="text-muted">{{ req.contractorName }}</small></div>
                      <span class="badge bg-secondary text-white fw-bold">{{ new Date(req.eventDate).toLocaleDateString('pt-BR') }}</span>
                    </div>
                    <div class="bg-soft-secondary p-2 rounded mb-2 fs-12 text-dark text-start">
                      <i class="ri-chat-voice-line me-1 text-primary"></i><strong>Minha Contraproposta:</strong> "{{ req.notes }}"
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <span class="small text-muted">Valor em Pauta:</span><h5 class="text-secondary fw-bold mb-0">R$ {{ req.totalProposedPrice.toFixed(2) }}</h5>
                    </div>
                    <div class="d-flex gap-2" @click.stop>
                      <button type="button" class="btn btn-sm btn-soft-danger w-50 fw-bold" @click="triggerRequestDecision(req)" :disabled="submittingAction">Descartar</button>
                      <button type="button" class="btn btn-sm btn-success w-50 fw-bold shadow-sm" @click="handleAcceptRequest(req.id)" :disabled="submittingAction">Fechar Acordo</button>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center py-4 border rounded border-dashed text-muted fs-12">Não há negociações ativas em pauta.</div>
            </div>
            <!-- LISTAGEM DA ABA 3: RECUSADAS (REJECTED) -->
            <button type="button" class="agenda-accordion-toggle d-md-none" :class="{ active: mobileAgendaSection === 'recusadas' }" @click="mobileAgendaSection = mobileAgendaSection === 'recusadas' ? null : 'recusadas'">
              <span class="agenda-accordion-label"><i class="ri-close-circle-line agenda-accordion-section-icon"></i><span class="agenda-accordion-title">Recusadas</span><span class="badge bg-dark" v-if="listaRecusadas.length > 0">{{ listaRecusadas.length }}</span></span>
              <i class="agenda-accordion-chevron" :class="mobileAgendaSection === 'recusadas' ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
            </button>
            <div class="tab-pane" :class="{ 'mobile-open': mobileAgendaSection === 'recusadas' }" id="recusadasTab" role="tabpanel">
              <div v-if="listaRecusadas.length > 0" class="d-flex flex-column gap-2">
                <div class="card border bg-light shadow-none mb-0" v-for="req in listaRecusadas" :key="req.id">
                  <div class="card-body p-3 text-start" @click="handleOpenEventDetails(req)" style="cursor: pointer;" title="Clique para ver o histórico detalhado deste show">
                    <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-2">
                      <div>
                        <h6 class="fw-bold text-dark mb-0">{{ req.eventName }}</h6>
                        <small class="text-muted"><i class="ri-user-line me-1"></i>{{ req.contractorName }}</small>
                      </div>
                      <span class="badge bg-soft-danger text-danger fw-bold fs-11">
                        {{ new Date(req.eventDate).toLocaleDateString('pt-BR') }}
                      </span>
                    </div>
                    <div class="text-danger font-monospace fs-12">
                      <i class="ri-close-circle-line me-1"></i>
                      <strong>Justificativa:</strong> 
                      "{{ req.notes && req.notes.trim() !== '' ? req.notes : 'Recusado pelo artista sem justificativa.' }}"
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center py-4 border rounded border-dashed text-muted fs-12">O histórico de recusas está limpo.</div>
            </div>

            <!-- LISTAGEM DA ABA 4: DISPONIBILIDADE (EVOLUÍDA COM EDIÇÃO E DELEÇÃO) -->
            <button type="button" class="agenda-accordion-toggle d-md-none" :class="{ active: mobileAgendaSection === 'disponibilidade' }" @click="mobileAgendaSection = mobileAgendaSection === 'disponibilidade' ? null : 'disponibilidade'">
              <span class="agenda-accordion-label agenda-accordion-label-wide"><i class="ri-calendar-check-line agenda-accordion-section-icon"></i><span class="agenda-accordion-title">Minha Disponibilidade</span></span>
              <i class="agenda-accordion-chevron" :class="mobileAgendaSection === 'disponibilidade' ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
            </button>
            <div class="tab-pane" :class="{ 'mobile-open': mobileAgendaSection === 'disponibilidade' }" id="disponibilidadeTab" role="tabpanel">
              
              <!-- BLOCO A: FORMULÁRIO DE BLOQUEIO MANUAL POR RANGE DE DATAS (FÉRIAS/TURNÊ) -->
              <h6 class="fw-bold text-dark border-bottom pb-1 mb-2 fs-12">
                <i class="ri-lock-line me-1 text-danger"></i> 
                {{ editingBlockId ? 'Editar Recesso / Intervalo Selecionado' : 'Agendar Recesso / Intervalo de Férias' }}
              </h6>
              
              <form @submit.prevent="handleCreateManualBlock" class="row g-2 mb-3 p-2 bg-light border rounded text-start">
                <div class="col-6">
                  <label class="form-label font-monospace fs-10 mb-0 fw-bold">Data Inicial</label>
                  <input type="date" class="form-control form-control-sm fs-11" v-model="blockForm.startDate" required />
                </div>
                <div class="col-6">
                  <label class="form-label font-monospace fs-10 mb-0 fw-bold">Data Final</label>
                  <input type="date" class="form-control form-control-sm fs-11" v-model="blockForm.endDate" required />
                </div>
                <div class="col-12 mt-1">
                  <label class="form-label font-monospace fs-10 mb-0 fw-bold">Motivo do Afastamento</label>
                  <input type="text" class="form-control form-control-sm fs-11" v-model="blockForm.reason" placeholder="Ex: Turnê Internacional, Gravação, Férias..." required />
                </div>
                
                <!-- BOTÕES DE COMANDO DINÂMICOS CONFORME O MODO DE OPERAÇÃO -->
                <div class="col-12 mt-2 d-flex gap-2">
                  <button v-if="editingBlockId" type="button" class="btn btn-sm btn-light w-30 fs-11 fw-bold border" @click="handleCancelEditBlock">
                    Cancelar
                  </button>
                  <button type="submit" :class="`btn btn-sm ${editingBlockId ? 'btn-warning' : 'btn-danger'} ${editingBlockId ? 'w-70' : 'w-100'} fs-11 fw-bold shadow-sm`" :disabled="submittingAction">
                    {{ editingBlockId ? 'Salvar Alterações' : 'Bloquear Intervalo de Datas' }}
                  </button>
                </div>
              </form>

              <!-- NOVO BLOCO A.2: EXIBIÇÃO FILTRADA DOS RECESSOS ATIVOS (DIA ATUAL E FUTUROS) -->
              <h6 class="fw-bold text-dark border-bottom pb-1 mb-2 fs-12">
                <i class="ri-git-repository-private-line me-1 text-primary"></i> Meus Recessos Cadastrados
              </h6>
              
              <div v-if="listaRecusosFuturos.length > 0" class="table-responsive border rounded bg-white mb-4">
                <table class="table table-sm table-borderless mb-0 fs-11 text-start text-muted align-middle">
                  <thead>
                    <tr class="bg-light text-dark font-monospace fs-10">
                      <th class="p-2">Período / Motivo</th>
                      <th class="text-end p-2">Ações</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="blk in listaRecusosFuturos" :key="blk.id" :class="{'bg-soft-warning': editingBlockId === blk.id, 'border-bottom': true}">
                      <td class="p-2 text-wrap">
                        <div class="fw-bold text-dark mb-0 fs-11">{{ blk.reason }}</div>
                        <span class="text-muted font-monospace fs-10">
                          {{ new Date(blk.startDate.split('T')[0] + 'T00:00:00').toLocaleDateString('pt-BR') }} 
                          a 
                          {{ new Date(blk.endDate.split('T')[0] + 'T00:00:00').toLocaleDateString('pt-BR') }}
                        </span>
                      </td>
                      <td class="text-end p-2">
                        <div class="d-flex gap-1 justify-content-end">
                          <button type="button" class="btn btn-sm btn-icon btn-soft-info p-1" title="Editar este recesso" @click="handleSetupEditBlock(blk)">
                            <i class="ri-pencil-fill fs-12"></i>
                          </button>
                          <button type="button" class="btn btn-sm btn-icon btn-soft-danger p-1" title="Cancelar este recesso" @click="handleDeleteBlock(blk.id)">
                            <i class="ri-delete-bin-fill fs-12"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div v-else class="text-center py-3 border rounded border-dashed text-muted fs-11 mb-4">
                Não há recessos agendados vigentes ou futuros.
              </div>

              <!-- BLOCO B: GRADE DE 7 SLIDERS SEMANAIS DE DOMINGO A SÁBADO -->
              <h6 class="fw-bold text-dark border-bottom pb-1 mb-2 fs-12">
                <i class="ri-time-line me-1 text-success"></i> Configuração de Agenda Semanal (7 Dias)
              </h6>

              <div
                v-if="availabilitySaveMessage"
                class="agenda-autosave-feedback"
                :class="`is-${availabilitySaveState}`"
                aria-live="polite"
              >
                <i v-if="availabilitySaveState === 'saving'" class="ri-loader-4-line agenda-save-spinner"></i>
                <i v-else-if="availabilitySaveState === 'saved'" class="ri-checkbox-circle-line"></i>
                <i v-else class="ri-error-warning-line"></i>
                <span>{{ availabilitySaveMessage }}</span>
              </div>
              
              <div class="d-flex flex-column gap-2" v-if="weeklyAvailability.length > 0">
                <div class="p-2 border rounded bg-white text-start d-flex flex-column gap-2" v-for="day in weeklyAvailability" :key="day.id">
                  
                  <!-- SLIDER TIPO SWITCH DO BOOTSTRAP PARA CADA DIA DA SEMANA -->
                  <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold text-dark fs-13">
                      <i class="ri-calendar-event-line text-muted me-1"></i>{{ getDayName(day.dayOfWeek) }}
                    </span>
                    <div class="form-check form-switch form-switch-success mb-0">
                      <input class="form-check-input" type="checkbox" role="switch" v-model="day.isAvailable" @change="handleSaveDayAvailability(day)" />
                      <label class="form-check-label small text-muted font-monospace fs-10 fw-bold">
                        {{ day.isAvailable ? 'ABERTO PARA SHOWS' : 'INDISPONÍVEL (FOLGA)' }}
                      </label>
                    </div>
                  </div>
                  
                  <!-- CAMPOS DE HORÁRIOS: SURGEM DINAMICAMENTE SE O SLIDER ESTIVER ATIVO (ON) -->
                  <div class="agenda-time-editor animate__animated animate__fadeIn" v-if="day.isAvailable">
                    <div class="agenda-time-field">
                      <label>INÍCIO</label>
                      <input type="text" class="form-control text-center" :value="formatTimeForDisplay(day.startTime)" @focus="handleTimeFocus(day, 'startTime', $event)" @input="handleTimeInput(day, 'startTime', $event)" @blur="handleTimeBlur(day, 'startTime', $event)" placeholder="19:00" inputmode="numeric" maxlength="5" autocomplete="off" aria-label="Horário de início" />
                    </div>
                    <div class="agenda-time-field">
                      <label>TÉRMINO</label>
                      <input type="text" class="form-control text-center" :value="formatTimeForDisplay(day.endTime)" @focus="handleTimeFocus(day, 'endTime', $event)" @input="handleTimeInput(day, 'endTime', $event)" @blur="handleTimeBlur(day, 'endTime', $event)" placeholder="23:59" inputmode="numeric" maxlength="5" autocomplete="off" aria-label="Horário de término" />
                    </div>
                  </div>

                </div>
              </div>
            </div> <!-- FECHAMENTO COMPLETO DA ABA DE DISPONIBILIDADE -->

          </div>
        </div>
      </div>

    </div> <!-- FECHAMENTO SEGURO DA ROW DO GRID PRINCIPAL -->
    <!-- ==================================================================== -->
    <!-- JANELA FLUTUANTE 1: RAY-X COMPLETO DO COMPROMISSO CLICADO NO CALENDÁRIO -->
    <!-- ==================================================================== -->
    <div v-if="showDetailsModal && selectedEvent" class="modal fade show d-block" tabindex="-1" style="background: rgba(0, 0, 0, 0.5);" role="dialog">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content border-0 shadow-lg animate__animated animate__fadeInUp">
          <div :class="`modal-header bg-${selectedEvent.color} text-white p-3`">
            <h5 class="modal-title fw-bold text-white mb-0">
              <i class="ri-music-2-line me-1"></i> Detalhes do Show
            </h5>
            <button type="button" class="btn-close btn-close-white" @click="handleCloseEventDetails" aria-label="Close"></button>
          </div>
          
          <div class="modal-body p-3">
            <div class="mb-3 text-center">
              <span :class="`badge bg-${selectedEvent.color}-subtle text-${selectedEvent.color} px-3 py-1 fs-12 fw-bold mb-2`">
                {{ selectedEvent.status === 'Confirmed' ? '🟢 Show Confirmado / Pago' : (selectedEvent.status === 'In_Negotiation' ? '💬 Em Negociação Ativa' : '🟡 Pré-Agendado / Aguardando Cliente') }}
              </span>
              <h4 class="fw-bold text-dark mb-0">{{ selectedEvent.title }}</h4>
              
              <small class="text-muted d-block mt-1">
                <i class="ri-calendar-event-line me-1"></i>Data: 
                {{ selectedEvent.eventDate ? new Date(selectedEvent.eventDate.split('T')[0] + 'T00:00:00').toLocaleDateString('pt-BR') : '' }}
                às 
                {{ selectedEvent.eventDate ? new Date(selectedEvent.eventDate).toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' }) : '' }}
              </small>
            </div>

            <!-- CARD DE INFORMAÇÕES DO CLIENTE E LOCALIZAÇÃO FÍSICA -->
            <div class="border rounded p-2 mb-3 bg-white text-start">
              <h6 class="fw-bold text-dark fs-12 mb-2 text-uppercase font-monospace tracking-wide">
                <i class="ri-user-star-line me-1"></i> Ficha do Contratante
              </h6>
              <div v-if="selectedEvent.contractorLogoUrl" class="text-center mb-3">
                <img :src="urlPublicaApi(selectedEvent.contractorLogoUrl)" alt="Logo do contratante" class="agenda-contractor-logo" />
              </div>
              <p class="mb-1 text-muted small"><strong>Nome:</strong> {{ selectedEvent.contractorName }}</p>
              <p class="mb-1 text-muted small"><strong>Tipo de Evento:</strong> {{ selectedEvent.eventType }}</p>
              <p class="mb-0 text-muted small">
                <i class="ri-map-pin-2-line text-danger me-1"></i>
                <strong>Local:</strong> {{ selectedEvent.venueName }} ({{ selectedEvent.city }} - {{ selectedEvent.state }})
              </p>
            </div>

            <!-- PLANILHA DE CUSTOS E LOGÍSTICA COM DADOS REAIS -->
            <div class="table-responsive border rounded bg-light">
              <table class="table table-sm table-borderless mb-0 fs-12 text-muted text-start">
                <thead>
                  <tr class="bg-soft-secondary text-dark">
                    <th scope="col" class="p-2">Item Discriminado</th>
                    <th scope="col" class="text-end p-2">Composição</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="p-2">Formato Comercial ({{ selectedEvent.packageTitle }})</td>
                    <td class="text-end p-2 text-dark font-monospace">R$ {{ selectedEvent.basePackagePrice.toFixed(2) }}</td>
                  </tr>
                  <tr v-if="selectedEvent.extraKm > 0">
                    <td class="p-2 text-warning">Logística Extra (+{{ selectedEvent.extraKm }} km rodados)</td>
                    <td class="text-end p-2 text-warning font-monospace">+ R$ {{ selectedEvent.extraKmValueCharged.toFixed(2) }}</td>
                  </tr>
                  <tr v-else>
                    <td class="p-2 text-muted">Deslocamento (Raio de frete gratuito)</td>
                    <td class="text-end p-2 text-success font-monospace">Grátis ({{ selectedEvent.distanceKm }} km)</td>
                  </tr>
                  <tr v-if="selectedEvent.extraHours > 0">
                    <td class="p-2 text-warning">Tempo Adicional (+{{ selectedEvent.extraHours }}h de palco)</td>
                    <td class="text-end p-2 text-warning font-monospace">+ R$ {{ selectedEvent.extraHoursValueCharged.toFixed(2) }}</td>
                  </tr>
                  <tr v-if="selectedEvent.notes" class="bg-soft-secondary-subtle">
                    <td colspan="2" class="p-2 fs-11 text-dark italic border-top">
                      <i class="ri-chat-history-line me-1 text-primary"></i><strong>Histórico de Notas:</strong> "{{ selectedEvent.notes }}"
                    </td>
                  </tr>
                  <tr class="border-top fw-bold text-dark fs-13 bg-soft-success-subtle">
                    <td class="p-2 text-success">Cachê Líquido do Artista</td>
                    <td class="text-end p-2 text-success font-monospace">R$ {{ selectedEvent.totalProposedPrice.toFixed(2) }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          
          <div class="modal-footer bg-light p-2 d-flex justify-content-between align-items-center">
            <div v-if="selectedEvent.status && (selectedEvent.status.toLowerCase() === 'pending' || selectedEvent.status.toLowerCase() === 'in_negotiation')" class="d-flex gap-2 w-70">
              <button 
                type="button" 
                class="btn btn-sm btn-soft-danger fw-bold" 
                @click="handleCloseEventDetails(); triggerRequestDecision(selectedEvent)"
                :disabled="submittingAction"
              >
                {{ selectedEvent.status.toLowerCase() === 'in_negotiation' ? 'Descartar' : 'Recusar' }}
              </button>
              
              <button 
                type="button" 
                class="btn btn-sm btn-success fw-bold shadow-sm" 
                @click="handleCloseEventDetails(); handleAcceptRequest(selectedEvent.id)"
                :disabled="submittingAction"
              >
                {{ selectedEvent.status.toLowerCase() === 'in_negotiation' ? 'Fechar Acordo' : 'Aceitar e Reservar' }}
              </button>
            </div>
            <div v-else class="text-muted small italic text-start ps-2">
              <i class="ri-information-line me-1"></i>Este compromisso já foi processado e arquivado.
            </div>
            <div class="d-flex gap-2 ms-auto">
              <button
                v-if="String(selectedEvent.status || '').toLowerCase() === 'confirmed'"
                type="button"
                class="btn btn-sm btn-primary px-3 fw-bold"
                @click="criarCartazDoShow"
              >
                <i class="ri-palette-line me-1"></i> {{ cartazEventoExiste ? "Visualizar cartaz" : "Criar cartaz" }}
              </button>
              <button type="button" class="btn btn-sm btn-secondary px-3" @click="handleCloseEventDetails">Fechar</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ==================================================================== -->
    <!-- JANELA FLUTUANTE 2: MESA DE NEGOCIAÇÃO / MODAL DE DECISÃO DA RECUSA -->
    <!-- ==================================================================== -->
    <div v-if="showDecisionModal && activeTargetRequest" class="modal fade show d-block" tabindex="-1" style="background: rgba(0, 0, 0, 0.6);" role="dialog">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content border-0 shadow-lg border-start border-4 border-danger">
          <div class="modal-header bg-light p-3">
            <h5 class="modal-title fw-bold text-dark mb-0">
              <i class="ri-git-pull-request-line me-1 text-danger"></i> Avaliar Proposta: Recusar ou Negociar?
            </h5>
            <button type="button" class="btn-close" @click="showDecisionModal = false" aria-label="Close"></button>
          </div>
          
          <div class="modal-body p-3 text-start">
            <p class="text-muted small mb-3">
              Você está prestes a recusar o show <strong>"{{ activeTargetRequest.title || activeTargetRequest.eventName }}"</strong> de R$ {{ activeTargetRequest.totalProposedPrice.toFixed(2) }}. Escolha o destino comercial desta data:
            </p>
            <div class="mb-3">
              <label class="form-label small fw-bold text-dark mb-1">Escreva uma mensagem para o contratante</label>
              <textarea 
                class="form-control fs-13" 
                rows="3" 
                v-model="negotiationNotes" 
                placeholder="Ex para Negociar: Só consigo fazer por R$ X...&#10;Ex para Recusar: Já tenho um compromisso..."
                required
              ></textarea>
              <small class="text-muted fs-11 mt-1 d-block">* A mensagem é obrigatória para abrir o canal de Negociação.</small>
            </div>
            <div class="bg-light p-2 rounded d-flex flex-column gap-2">
              <button 
                type="button" 
                class="btn btn-secondary w-100 fw-bold d-flex align-items-center justify-content-center gap-1 shadow-sm"
                @click="handleNegotiateRequest"
                :disabled="submittingAction"
              >
                <i class="ri-chat-quote-line fs-14"></i> Enviar para a Aba Negociando
              </button>
              <button 
                type="button" 
                class="btn btn-danger w-100 fw-bold d-flex align-items-center justify-content-center gap-1 shadow-sm"
                @click="handleRejectRequestFinal"
                :disabled="submittingAction"
              >
                <i class="ri-close-circle-line fs-14"></i> Recusar de Vez e Liberar Calendário
              </button>
            </div>
          </div>
          <div class="modal-footer bg-light p-2">
            <button type="button" class="btn btn-sm btn-outline-secondary px-3" @click="showDecisionModal = false">Voltar</button>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>


<style scoped>
.agenda-contractor-logo { max-width:150px; max-height:82px; object-fit:contain; padding:8px 12px; border:1px solid #e5e7eb; border-radius:10px; background:#fff; }


@media (max-width: 767.98px) {
  /* Mantém a largura útil aprovada na v10: compensa apenas o padding do layout Velzon. */
  .agenda-page { margin-left: -12px; margin-right: -12px; }
  .agenda-page > .row { margin-left: 0; margin-right: 0; }
  .agenda-page > .row > [class*="col-"] { min-width: 0; padding-left: 0; padding-right: 0; }

  /* O título recebe o recuo internamente, sem estreitar calendário/cards. */
  .page-title-box { padding: 10px 12px 12px; min-height: auto; box-sizing: border-box; display: flex !important; justify-content: center !important; text-align: center; width: 100vw; max-width: 100vw; margin-left: calc(50% - 50vw); margin-right: calc(50% - 50vw); }
  .page-title-box h4 { font-size: 15px; font-weight: 700; margin: 0; width: 100%; text-align: center; }

  .agenda-calendar-header { padding: 10px 12px !important; gap: 8px; }
  .agenda-calendar-header .card-title { font-size: 13px; line-height: 1.25; }
  .agenda-nav-label { display: none; }
  .agenda-month-nav .btn { width: 34px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center; }
  .agenda-month-nav .btn i { font-size: 18px; }

  .agenda-calendar-card > .card-body { padding: 10px !important; }
  .agenda-days-grid { --bs-gutter-x: 6px; --bs-gutter-y: 6px; display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); margin: 0; }
  .agenda-days-grid > .col { width: auto; padding: 0; }
  .agenda-day-card { min-height: 78px; border-radius: 7px; }
  .agenda-day-card .p-2 { padding: 6px !important; }
  .agenda-day-card .mb-2 { margin-bottom: 4px !important; }
  .agenda-day-card .fs-18 { font-size: 15px !important; }
  .agenda-day-card small { font-size: 8px !important; line-height: 1.1; }
  .agenda-day-card .badge { font-size: 8px !important; line-height: 1.15; padding: 4px 3px !important; border-radius: 4px; }
  .agenda-legend { display: grid !important; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px 12px !important; margin-top: 14px !important; padding-top: 12px !important; justify-content: stretch !important; }
  .agenda-legend .fs-12 { font-size: 12px !important; font-weight: 600; line-height: 1.2; }
  .agenda-legend-item { display: inline-flex; align-items: center; white-space: nowrap; min-width: 0; }
  .agenda-legend-item i { font-size: 13px !important; margin-right: 5px !important; }


  .agenda-accordion-toggle {
    position: relative; display: flex; align-items: center; justify-content: flex-start; width: 100%; min-height: 48px;
    margin: 0 0 7px; padding: 10px 42px 10px 62px; border: 1px solid #cfd8e3; border-radius: 9px; background: #e9f2f4;
    box-shadow: 0 2px 5px rgba(18,38,63,.08); color: #183b46; font-size: 13px; font-weight: 700; text-align: left; transition: .18s ease;
  }
  .agenda-accordion-toggle:last-child { margin-bottom: 0; }
  .agenda-accordion-toggle.active { color: #087f73; border-color: rgba(10,179,156,.55); background: #dff4f1; box-shadow: 0 3px 8px rgba(10,179,156,.12); }
  .agenda-accordion-chevron { position: absolute; right: 14px; top: 50%; transform: translateY(-50%); font-size: 20px; }
  .agenda-accordion-label { display: grid; grid-template-columns: 18px 116px 22px; align-items: center; column-gap: 8px; text-align: left; }
  .agenda-accordion-label-wide { grid-template-columns: 18px auto; }
  .agenda-accordion-title { white-space: nowrap; }
  .agenda-accordion-section-icon { position: static; transform: none; font-size: 17px; color: #0ab39c; }
  .agenda-accordion-label .badge { font-size: 10px; min-width: 20px; padding: 4px 6px; transform: translateX(10px); }
  .agenda-accordion-toggle + .tab-pane.mobile-open {
    margin: -8px 0 10px;
    padding: 12px 10px 10px;
    border: 1px solid rgba(10,179,156,.25);
    border-top: 0;
    border-radius: 0 0 10px 10px;
    background: #fff;
  }
  .agenda-accordion-toggle.active { margin-bottom: 8px; border-radius: 9px 9px 0 0; }
  .agenda-requests-card > .card-body { padding: 10px !important; background: #f3f6f9; }
  .agenda-requests-card .tab-content > .tab-pane { display: none !important; }
  .agenda-requests-card .tab-content > .tab-pane.mobile-open { display: block !important; }

  .agenda-requests-card .card-header { overflow: hidden; }
  .agenda-tabs { display: grid; grid-template-columns: repeat(4, 1fr); width: 100%; }
  .agenda-tabs .nav-item { min-width: 0; text-align: center; }
  .agenda-tabs .nav-link { min-height: 48px; padding: 9px 4px !important; font-size: 10px; font-weight: 600; line-height: 1.15; display: flex; align-items: center; justify-content: center; gap: 4px; flex-wrap: wrap; }
  .agenda-tabs .nav-link.active { font-weight: 700; }
  .agenda-tabs .badge { font-size: 9px; margin-left: 0 !important; }
  .agenda-requests-card > .card-body { padding: 10px !important; }

  .agenda-request-item { border-radius: 8px; }
  .agenda-request-body { padding: 10px !important; }
  .agenda-request-body h6 { font-size: 13px; line-height: 1.2; }
  .agenda-request-body small, .agenda-request-body .small { font-size: 10px !important; }
  .agenda-request-body .fs-12 { font-size: 10px !important; }
  .agenda-request-body h5 { font-size: 16px; }
  .agenda-request-body .btn { min-height: 36px; font-size: 11px; }

  .agenda-autosave-feedback {
    display: flex;
    align-items: center;
    gap: 7px;
    min-height: 34px;
    margin: 0 0 10px;
    padding: 7px 10px;
    border-radius: 6px;
    font-size: 11px;
    font-weight: 600;
  }
  .agenda-autosave-feedback.is-saving { background: rgba(41,156,219,.10); color: #299cdb; }
  .agenda-autosave-feedback.is-saved { background: rgba(10,179,156,.10); color: #0ab39c; }
  .agenda-autosave-feedback.is-error { background: rgba(240,101,72,.10); color: #f06548; }
  .agenda-save-spinner { display: inline-block; animation: agendaSpin .8s linear infinite; }

  .agenda-autosave-feedback {
    position: fixed;
    left: 50%;
    bottom: 18px;
    transform: translateX(-50%);
    z-index: 1095;
    width: calc(100vw - 32px);
    max-width: 360px;
    margin: 0;
    min-height: 46px;
    padding: 11px 14px;
    border: 1px solid currentColor;
    box-shadow: 0 8px 28px rgba(0,0,0,.18);
    background: #fff !important;
    font-size: 13px;
    border-radius: 10px;
  }

  .agenda-time-editor {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
    width: 100%;
    padding-top: 2px;
  }
  .agenda-time-field { min-width: 0; }
  .agenda-time-field label {
    display: block;
    margin: 0 0 5px;
    color: #878a99;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: .05em;
  }
  .agenda-time-field .form-control {
    width: 100%;
    min-width: 0;
    height: 46px;
    padding: 8px 10px;
    border-radius: 7px;
    font-size: 17px;
    font-weight: 700;
    line-height: 1;
    font-family: inherit;
  }
  .agenda-time-field .form-control:focus {
    border-color: #0ab39c;
    box-shadow: 0 0 0 3px rgba(10,179,156,.12);
  }
}

@keyframes agendaSpin { to { transform: rotate(360deg); } }
</style>
