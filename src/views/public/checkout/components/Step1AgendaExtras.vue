<template>
  <div class="agenda-step">
    <!-- Stepper: apenas apresentação; fluxo e regras permanecem intactos -->
    <div class="checkout-stepper">
      <div class="step-item active"><div class="step-number">1</div><span>Agenda</span></div>
      <div class="step-line"></div>
      <div class="step-item"><div class="step-number">2</div><span>Logística</span></div>
      <div class="step-line"></div>
      <div class="step-item"><div class="step-number">3</div><span>Contrato</span></div>
      <div class="step-line"></div>
      <div class="step-item"><div class="step-number">4</div><span>Pagar</span></div>
    </div>

    <div class="agenda-heading">
      <div class="heading-kicker">PASSO 1 · AGENDA DO ARTISTA</div>
      <h3>Escolha a data do seu evento</h3>
      <p>Veja a agenda do artista e escolha uma das datas disponíveis.</p>
    </div>

    <div class="calendar-card">
      <div v-if="loadingAgenda" class="calendar-loading">
        <div class="spinner-border text-primary" role="status" style="color:#ff6c22 !important"></div>
      </div>

      <div class="calendar-toolbar">
        <button type="button" class="month-nav" @click="mudarMes('anterior')"><span>‹</span> Anterior</button>
        <div class="current-month">
          <small>AGENDA</small>
          <strong>{{ nomesMeses[mesAtual - 1] }} {{ anoAtual }}</strong>
        </div>
        <button type="button" class="month-nav" @click="mudarMes('proximo')">Próximo <span>›</span></button>
      </div>

      <div class="weekdays">
        <span class="weekend">DOM</span><span>SEG</span><span>TER</span><span>QUA</span><span>QUI</span><span>SEX</span><span class="weekend">SÁB</span>
      </div>

      <div class="calendar-grid">
        <div v-for="vazio in new Date(anoAtual, mesAtual - 1, 1).getDay()" :key="'vazio-' + vazio"></div>
        <button
          v-for="item in diasDoMes"
          :key="'dia-' + item.dia"
          type="button"
          class="day-button"
          :class="{
            selected: dataSelecionada === item.dia,
            available: item.status === 'disponivel',
            recess: item.status === 'recesso' || item.status === 'bloqueado',
            ownReservation: item.status === 'sua-reserva',
            reserved: item.status === 'reservado' || item.status === 'ocupado',
            off: item.status === 'folga',
            past: isDataPassada(item.dia)
          }"
          @click="item.status === 'disponivel' && !isDataPassada(item.dia) ? selecionarData(item.dia, item.status) : null"
          :disabled="item.status !== 'disponivel' || isDataPassada(item.dia)"
        >
          <span>{{ item.dia }}</span>
          <span v-if="dataSelecionada === item.dia" class="selected-check">✓</span>
        </button>
      </div>

      <div class="calendar-legend">
        <div class="legend-item"><i class="legend-dot available-dot"></i><span>Disponível</span></div>
        <div class="legend-item choice"><i class="legend-dot choice-dot">✓</i><span>Sua escolha</span></div>
        <div class="legend-item muted"><i class="legend-dot off-dot"></i><span>Folga padrão</span></div>
        <div class="legend-item recess-label"><i class="legend-dot recess-dot"></i><span>Recesso</span></div>
        <div class="legend-item reserved-label"><i class="legend-dot reserved-dot"></i><span>Reservado</span></div>
        <div class="legend-item own-label"><i class="legend-dot own-dot"></i><span>Sua reserva</span></div>
      </div>
    </div>

    <div v-if="dataSelecionada" ref="schedulePanel" class="schedule-panel animate__animated animate__fadeInUp">
      <div class="selection-confirmed">
        <span class="selection-icon">✓</span>
        <div><small>DATA SELECIONADA</small><strong>{{ String(dataSelecionada).padStart(2, '0') }} de {{ nomesMeses[mesAtual - 1] }} de {{ anoAtual }}</strong></div>
      </div>

      <div class="schedule-fields">
        <div class="field-block time-field" :class="{ 'needs-attention': !horarioShow }">
          <label>⏰ Defina o horário de início <span class="required-badge">OBRIGATÓRIO</span></label>
          <p class="field-hint">Informe a hora em que o show deve começar.</p>
          <div class="time-input-wrap">
            <input
              type="time"
              v-model="horarioShow"
              step="300"
              :min="limiteHoraDiaSelecionado || undefined"
              aria-label="Horário de início do show"
              @click="abrirSeletorHorario"
              @focus="timeInputFocused = true"
              @blur="timeInputFocused = false"
              @input="atualizarEstadoGlobal"
            />
          </div>
          <div v-if="limiteHoraDiaSelecionado && horarioShow && horarioShow < limiteHoraDiaSelecionado" class="time-warning">
            O artista atende apenas a partir das {{ limiteHoraDiaSelecionado }} neste dia.
          </div>
        </div>

        <div class="field-block extra-hours">
          <label>⏱️ Estender duração?</label>
          <div class="extra-control">
            <button type="button" @click="alterarHorasExtras(-1)" :disabled="horasExtras === 0">−</button>
            <div><strong>+{{ horasExtras }}h</strong><small>hora extra</small></div>
            <button type="button" @click="alterarHorasExtras(1)" :disabled="horasExtras >= 5">+</button>
          </div>
        </div>
      </div>

      <button
        type="button"
        class="continue-button"
        @click="emitirAvancoEtapa"
        :disabled="!horarioShow || (limiteHoraDiaSelecionado && horarioShow < limiteHoraDiaSelecionado)"
      >
        Confirmar data e avançar para logística <span>→</span>
      </button>
    </div>
  </div>
</template>
<script>
import axios from "axios";

export default {
  name: "Step1AgendaExtras",
  props: {
    artistId: { type: String, required: true },
    apiBaseUrl: { type: String, required: true }
  },
  emits: ["atualizar-agenda", "avancar-etapa"],
  data() {
    const dataDispositivo = new Date();
    return {
      mesAtual: dataDispositivo.getMonth() + 1,
      anoAtual: dataDispositivo.getFullYear(),
      diasDoMes: [],
      loadingAgenda: false,
      dataSelecionada: null,
      horarioShow: "",
      timeInputFocused: false,
      horasExtras: 0,
      nomesMeses: [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
      ],
      limiteHoraDiaSelecionado: null
    };
  },
  methods: {
    isDataPassada(dia) {
      const hoje = new Date();
      hoje.setHours(0, 0, 0, 0);
      const dataCalendario = new Date(this.anoAtual, this.mesAtual - 1, Number(dia));
      dataCalendario.setHours(0, 0, 0, 0);
      return dataCalendario < hoje;
    },

    // 🏛️ ATUALIZADO COM PUSH DE CONTRACTORID: Envia o ID na query de forma opcional
    async buscarDisponibilidadeAgenda() {
      this.loadingAgenda = true;
      try {
        const artistaId = this.artistId;
        
        // 🔐 SEGURANÇA REATIVA: Busca o ID do contratante logado armazenado na sua sessão local
        const usuarioLogadoRaw = localStorage.getItem("user") || localStorage.getItem("usuario");
        let idContratanteLogado = "";
        
        if (usuarioLogadoRaw) {
          try {
            const userObj = JSON.parse(usuarioLogadoRaw);
            idContratanteLogado = userObj.id || userObj.Id || "";
          } catch (e) {
            console.warn("Falha ao ler dados de objeto do usuário no localStorage", e);
          }
        }

        // 🚀 CONCATENAÇÃO SEGURA: Monta o endereço com contractorId se o usuário estiver autenticado
        let url = `${this.apiBaseUrl}/public/artists/${artistaId}/availability?mes=${this.mesAtual}&ano=${this.anoAtual}`;
        if (idContratanteLogado) {
          url += `&contractorId=${idContratanteLogado}`;
        }

        const response = await axios.get(url);
        console.log("Resposta", response);
        
        let dadosAPI = [];
        if (response.data) {
          dadosAPI = response.data.dias || response.data.Dias || [];
        }

        if (dadosAPI && dadosAPI.length > 0) {
          this.diasDoMes = dadosAPI.map(item => ({
            // 🚀 CORREÇÃO CIRÚRGICA: Trocado '=' por ':' para respeitar a sintaxe JavaScript de objetos
            dia: item.dia !== undefined ? item.dia : item.Dia,
            status: String(item.status || item.Status || 'disponivel').toLowerCase(),
            startTime: item.startTime || item.StartTime || null 
          }));
        } else {
          const totalDias = new Date(this.anoAtual, this.mesAtual, 0).getDate();
          this.diasDoMes = Array.from({ length: totalDias }, (_, i) => {
            const dia = i + 1;
            let status = "disponivel";
            if (dia === 7 || dia === 8) status = "bloqueado";
            return { dia: dia, status: status };
          });
        }
      } catch (error) {
        console.error("Erro ao processar mapa de calor da agenda do músico:", error);
      } finally {
        this.loadingAgenda = false;
      }
    },

    mudarMes(direcao) {
      if (direcao === 'proximo') {
        if (this.mesAtual === 12) {
          this.mesAtual = 1;
          this.anoAtual++;
        } else {
          this.mesAtual++;
        }
      } else {
        if (this.mesAtual === 1) {
          this.mesAtual = 12;
          this.anoAtual--;
        } else {
          this.mesAtual--;
        }
      }
      this.dataSelecionada = null; 
      this.atualizarEstadoGlobal();
      this.buscarDisponibilidadeAgenda();
    },

    abrirSeletorHorario(event) {
      // Abre o seletor nativo ao clicar em qualquer ponto do input, quando o navegador suporta showPicker().
      const input = event && event.currentTarget;
      if (input && typeof input.showPicker === "function") {
        try { input.showPicker(); } catch (e) { /* fallback: o input continua funcionando normalmente */ }
      }
    },

    alterarHorasExtras(valor) {
      const novaQuantidade = this.horasExtras + valor;
      if (novaQuantidade >= 0 && novaQuantidade <= 5) {
        this.horasExtras = novaQuantidade;
        this.atualizarEstadoGlobal();
      }
    },

    atualizarEstadoGlobal() {
      this.$emit("atualizar-agenda", {
        data: this.dataSelecionada ? `${this.anoAtual}-${String(this.mesAtual).padStart(2, '0')}-${String(this.dataSelecionada).padStart(2, '0')}` : null,
        horario: this.horarioShow,
        horasExtras: this.horasExtras,
        startTimeLimite: this.limiteHoraDiaSelecionado 
      });
    },

    selecionarData(dia, status) {
      if (status === 'disponivel') {
        this.dataSelecionada = dia;
        const diaDados = this.diasDoMes.find(d => d.dia === dia);
        
        if (diaDados && diaDados.startTime) {
          this.limiteHoraDiaSelecionado = diaDados.startTime;
        } else {
          this.limiteHoraDiaSelecionado = null;
        }

        // O backend informa o primeiro horário em que o artista atende neste dia.
        // Ele volta a ser o horário inicialmente selecionado, como no fluxo original.
        this.horarioShow = this.limiteHoraDiaSelecionado || "";
        
        this.atualizarEstadoGlobal();

        // UX: após escolher uma data, leva suavemente o usuário aos dados
        // do evento sem alterar nenhuma regra do fluxo/agenda.
        this.$nextTick(() => {
          const painel = this.$refs.schedulePanel;
          if (painel) {
            painel.scrollIntoView({ behavior: "smooth", block: "start" });
          }
        });
      }
    },

    emitirAvancoEtapa() {
      if (this.dataSelecionada && this.horarioShow && (!this.limiteHoraDiaSelecionado || this.horarioShow >= this.limiteHoraDiaSelecionado)) {
        this.$emit("avancar-etapa");
      }
    }
  },
  mounted() {
    this.buscarDisponibilidadeAgenda();
  }
};
</script>

<style scoped>
.agenda-step{background:#131520;border:1px solid rgba(255,255,255,.06);border-radius:18px;padding:40px;box-shadow:0 18px 50px rgba(0,0,0,.28);font-family:monospace;color:#fff}
.checkout-stepper{display:flex;align-items:center;margin-bottom:38px;padding:0 8px}.step-item{display:flex;align-items:center;gap:10px;color:#8f94a5;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.5px}.step-item.active{color:#fff}.step-number{width:36px;height:36px;border-radius:50%;background:#242836;border:1px solid rgba(255,255,255,.05);display:flex;align-items:center;justify-content:center;color:#9ba0b0}.step-item.active .step-number{background:#ff6c22;color:#fff;border-color:#ff6c22;box-shadow:0 0 20px rgba(255,108,34,.35)}.step-line{flex:1;height:1px;background:rgba(255,255,255,.10);margin:0 16px;min-width:28px}
.agenda-heading{margin-bottom:25px}.heading-kicker{color:#ff6c22;font-size:10px;font-weight:800;letter-spacing:1.2px;margin-bottom:8px}.agenda-heading h3{margin:0 0 7px;font-size:20px;text-transform:uppercase;font-weight:800;letter-spacing:-.4px}.agenda-heading p{margin:0;color:#a7adbd;font-size:13px;line-height:1.55}
.calendar-card{position:relative;border:1px solid rgba(255,255,255,.08);border-radius:14px;background:rgba(5,7,13,.28);padding:24px}.calendar-loading{position:absolute;inset:0;background:rgba(19,21,32,.84);display:flex;align-items:center;justify-content:center;border-radius:14px;z-index:5}.calendar-toolbar{display:flex;align-items:center;justify-content:space-between;margin-bottom:22px}.month-nav{background:#181b27;border:1px solid rgba(255,255,255,.08);border-radius:9px;color:#ff7b38;font-size:12px;font-weight:800;cursor:pointer;padding:10px 14px;transition:.18s ease}.month-nav:hover{border-color:rgba(255,108,34,.6);background:rgba(255,108,34,.08);transform:translateY(-1px)}.month-nav span{font-size:18px;line-height:0;vertical-align:-1px}.current-month{text-align:center;display:flex;flex-direction:column;gap:3px}.current-month small{font-size:9px;color:#73798a;letter-spacing:1.4px}.current-month strong{font-size:16px;text-transform:uppercase;letter-spacing:.4px}
.weekdays{display:grid;grid-template-columns:repeat(7,1fr);text-align:center;border-bottom:1px solid rgba(255,255,255,.07);padding:0 0 11px;margin-bottom:14px}.weekdays span{color:#9da3b5;font-size:10px;font-weight:800;letter-spacing:.5px}.weekdays .weekend{color:#ff6262}.calendar-grid{display:grid;grid-template-columns:repeat(7,1fr);gap:9px;text-align:center}.day-button{position:relative;min-height:43px;border-radius:7px;font-family:monospace;font-weight:800;transition:.16s ease}.day-button.available{background:#2a2f42;border:1px solid rgba(255,255,255,.16);color:#fff;cursor:pointer}.day-button.available:hover{background:#343a51;border-color:rgba(255,108,34,.75);box-shadow:0 6px 18px rgba(0,0,0,.2);transform:translateY(-2px)}.day-button.selected{background:#0ab39c!important;border-color:#23d9be!important;color:#fff!important;box-shadow:0 0 0 2px rgba(10,179,156,.16),0 0 18px rgba(10,179,156,.35)!important;cursor:pointer}.selected-check{position:absolute;right:6px;top:4px;font-size:9px;color:#fff}.day-button.recess{background:#ef4444;border:1px solid rgba(255,255,255,.04);color:#fff}.day-button.ownReservation{background:#ffb800;border:1px solid rgba(255,255,255,.04);color:#17191f}.day-button.reserved{background:#299cdb;border:1px solid rgba(255,255,255,.04);color:#fff}.day-button.off{background:rgba(42,45,61,.15);border:1px solid rgba(255,255,255,.02);color:rgba(255,255,255,.2)}.day-button.past{background:#171a24!important;border-color:rgba(255,255,255,.055)!important;color:rgba(255,255,255,.42)!important;box-shadow:none!important;transform:none!important;opacity:1}.day-button.past:hover{background:#171a24!important;border-color:rgba(255,255,255,.055)!important;color:rgba(255,255,255,.42)!important;box-shadow:none!important;transform:none!important}.day-button:disabled{cursor:not-allowed}
.calendar-legend{display:flex;flex-wrap:wrap;justify-content:center;gap:13px 22px;margin-top:24px;padding-top:16px;border-top:1px solid rgba(255,255,255,.07);font-size:10px;font-weight:800;text-transform:uppercase}.legend-item{display:flex;align-items:center;gap:7px;color:#e5e7eb}.legend-dot{width:12px;height:12px;border-radius:3px;display:flex;align-items:center;justify-content:center;font-size:8px;font-style:normal}.available-dot{background:#2a2f42;border:1px solid rgba(255,255,255,.2)}.choice{color:#22cdb4}.choice-dot{background:#0ab39c;color:#fff;box-shadow:0 0 7px rgba(10,179,156,.4)}.muted{color:#777d8e}.off-dot{background:rgba(42,45,61,.45);border:1px solid rgba(255,255,255,.06)}.recess-label{color:#ff6262}.recess-dot{background:#ef4444}.reserved-label{color:#45aee7}.reserved-dot{background:#299cdb}.own-label{color:#ffc42b}.own-dot{background:#ffb800}
.schedule-panel{scroll-margin-top:110px;margin-top:26px;padding:22px;border:1px solid rgba(10,179,156,.22);border-radius:14px;background:linear-gradient(135deg,rgba(10,179,156,.07),rgba(0,0,0,.08))}.selection-confirmed{display:flex;align-items:center;gap:12px;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid rgba(255,255,255,.07)}.selection-icon{width:32px;height:32px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:#0ab39c;font-weight:900;box-shadow:0 0 15px rgba(10,179,156,.25)}.selection-confirmed div{display:flex;flex-direction:column;gap:3px}.selection-confirmed small{font-size:9px;color:#63d7c5;letter-spacing:1px}.selection-confirmed strong{font-size:14px;text-transform:uppercase}.schedule-fields{display:flex;flex-wrap:wrap;gap:22px;margin-bottom:20px}.field-block{flex:1;min-width:210px}.field-block label{display:block;margin-bottom:8px;font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:.4px}.field-block input{width:100%;padding:14px 16px;background:#0d0f17;border:1px solid rgba(255,255,255,.12);border-radius:9px;color:#fff;font-size:15px;font-weight:800;outline:none;box-sizing:border-box}.field-block input:focus{border-color:#ff6c22;box-shadow:0 0 0 3px rgba(255,108,34,.08)}.time-field label{display:flex;align-items:center;gap:8px}.required-badge{display:inline-flex;align-items:center;padding:3px 7px;border-radius:999px;background:rgba(255,108,34,.12);border:1px solid rgba(255,108,34,.38);color:#ff7b38;font-size:8px;letter-spacing:.7px}.field-hint{margin:-1px 0 9px;color:#aeb4c3;font-size:10px;line-height:1.45}.time-input-wrap{position:relative}.time-input-wrap input{position:relative;z-index:2;background:transparent}.time-input-wrap:before{content:"";position:absolute;inset:0;background:#0d0f17;border-radius:9px;z-index:0}.time-field.needs-attention .time-input-wrap{border-radius:9px;box-shadow:0 0 0 1px rgba(255,108,34,.68),0 0 18px rgba(255,108,34,.12)}.time-field.needs-attention .time-input-wrap input{border-color:rgba(255,108,34,.58);color:#fff}.time-field.needs-attention .time-input-wrap input::-webkit-calendar-picker-indicator{filter:invert(55%) sepia(95%) saturate(2600%) hue-rotate(342deg) brightness(104%);cursor:pointer}.time-field:not(.needs-attention) .time-input-wrap input{background:#0d0f17}.extra-hours{max-width:250px}.extra-control{height:50px;display:flex;align-items:center;background:#0d0f17;border:1px solid rgba(255,255,255,.12);border-radius:9px;overflow:hidden}.extra-control button{width:58px;height:100%;border:0;background:transparent;color:#ff6c22;font-size:20px;font-weight:900;cursor:pointer}.extra-control button:hover:not(:disabled){background:rgba(255,108,34,.08)}.extra-control button:disabled{opacity:.3;cursor:not-allowed}.extra-control div{flex:1;text-align:center;display:flex;flex-direction:column}.extra-control strong{font-size:14px}.extra-control small{font-size:8px;color:#7f8596;text-transform:uppercase}.time-warning{color:#ff6262;font-size:10px;font-weight:800;margin-top:8px;text-transform:uppercase;line-height:1.4}.continue-button{width:100%;border:1px solid #ff6c22;background:#ff6c22;color:#fff;font-weight:800;text-transform:uppercase;font-family:monospace;font-size:12px;padding:16px 30px;border-radius:50px;box-shadow:0 8px 24px rgba(255,108,34,.2);cursor:pointer;transition:.18s ease}.continue-button:hover:not(:disabled){transform:translateY(-1px);box-shadow:0 10px 28px rgba(255,108,34,.3)}.continue-button:disabled{background:#2a2d3d;border-color:#2a2d3d;color:#878a99;box-shadow:none;cursor:not-allowed}.continue-button span{font-size:16px;margin-left:5px}
@media(max-width:760px){.agenda-step{padding:24px 16px}.checkout-stepper{overflow:hidden}.step-item span{display:none}.step-line{margin:0 8px}.calendar-card{padding:16px 10px}.month-nav{padding:9px 8px;font-size:10px}.current-month strong{font-size:13px}.calendar-grid{gap:6px}.day-button{min-height:39px}.calendar-legend{justify-content:flex-start}.extra-hours{max-width:none}}
</style>
