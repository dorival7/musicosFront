<template>
  <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); font-family: monospace;">
    
    <!-- 🏁 COMPONENTE STEPPER (MARCADOR DE PASSOS NUMÉRICOS) -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 40px; padding: 0 10px;">
      <div style="display: flex; align-items: center; gap: 10px;">
        <div style="width: 36px; height: 36px; border-radius: 50%; background-color: #ff6c22; color: #ffffff; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; box-shadow: 0 0 15px rgba(255,108,34,0.4);">1</div>
        <span style="color: #ffffff; font-size: 13px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;">Agenda</span>
      </div>
      <div style="flex: 1; height: 2px; background-color: rgba(255,255,255,0.05); margin: 0 15px;"></div>
      <div style="display: flex; align-items: center; gap: 10px; opacity: 0.4;">
        <div style="width: 36px; height: 36px; border-radius: 50%; background-color: #2a2d3d; color: #adb5bd; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px;">2</div>
        <span style="color: #adb5bd; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;">Logística</span>
      </div>
      <div style="flex: 1; height: 2px; background-color: rgba(255,255,255,0.05); margin: 0 15px;"></div>
      <div style="display: flex; align-items: center; gap: 10px; opacity: 0.4;">
        <div style="width: 36px; height: 36px; border-radius: 50%; background-color: #2a2d3d; color: #adb5bd; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px;">3</div>
        <span style="color: #adb5bd; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;">Contrato</span>
      </div>
      <div style="flex: 1; height: 2px; background-color: rgba(255,255,255,0.05); margin: 0 15px;"></div>
      <div style="display: flex; align-items: center; gap: 10px; opacity: 0.4;">
        <div style="width: 36px; height: 36px; border-radius: 50%; background-color: #2a2d3d; color: #adb5bd; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px;">4</div>
        <span style="color: #adb5bd; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;">Pagar</span>
      </div>
    </div>

    <!-- TÍTULO ORIENTADOR DO PASSO -->
    <div style="margin-bottom: 25px; text-align: left;">
      <h3 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 18px; margin: 0 0 6px 0; letter-spacing: -0.3px;">Selecione a Data do Evento</h3>
      <p style="color: #878a99; font-size: 13px; margin: 0;">Navegue pelos meses para conferir a disponibilidade real da banda na folhinha.</p>
    </div>

    <!-- 🏛️ CARD DE NAVEGAÇÃO DO CALENDÁRIO -->
    <div style="border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; background-color: rgba(0,0,0,0.15); padding: 25px; position: relative;">
      
      <div v-if="loadingAgenda" style="position: absolute; top:0; left:0; width:100%; height:100%; background: rgba(19,21,32,0.8); display:flex; align-items:center; justify-content:center; border-radius:12px; z-index:5;">
        <div class="spinner-border text-primary" role="status" style="color: #ff6c22 !important;"></div>
      </div>

      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
        <button type="button" @click="mudarMes('anterior')" style="background: none; border: none; color: #ff6c22; font-size: 14px; font-weight: bold; cursor: pointer; padding: 5px 10px;">&lt; Anterior</button>
        <h4 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 14px; margin: 0; letter-spacing: 0.5px;">{{ nomesMeses[mesAtual - 1] }} {{ anoAtual }}</h4>
        <button type="button" @click="mudarMes('proximo')" style="background: none; border: none; color: #ff6c22; font-size: 14px; font-weight: bold; cursor: pointer; padding: 5px 10px;">Próximo &gt;</button>
      </div>

      <div style="display: grid; grid-template-columns: repeat(7, 1fr); text-align: center; margin-bottom: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 8px;">
        <span style="color: #ef4444; font-size: 11px; font-weight: bold;">DOM</span>
        <span style="color: #878a99; font-size: 11px; font-weight: bold;">SEG</span>
        <span style="color: #878a99; font-size: 11px; font-weight: bold;">TER</span>
        <span style="color: #878a99; font-size: 11px; font-weight: bold;">QUA</span>
        <span style="color: #878a99; font-size: 11px; font-weight: bold;">QUI</span>
        <span style="color: #878a99; font-size: 11px; font-weight: bold;">SEX</span>
        <span style="color: #ef4444; font-size: 11px; font-weight: bold;">SÁB</span>
      </div>
<!-- GRID UNIFICADO: Mapeia de forma contínua sem quebrar as linhas do CSS -->
      <div style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 10px; text-align: center; margin-top: 15px;">
        <!-- 🚀 PASSO DE RECONCILIAÇÃO: Renderiza os espaços vazios do início do mês -->
        <div v-for="vazio in new Date(anoAtual, mesAtual - 1, 1).getDay()" :key="'vazio-' + vazio"></div>

        <!-- Renderiza os botões reais sequencialmente na mesma linha estrutural -->
        <button 
          v-for="item in diasDoMes" 
          :key="'dia-' + item.dia"
          type="button"
          @click="item.status === 'disponivel' ? selecionarData(item.dia, item.status) : null"
          :disabled="item.status !== 'disponivel'"
          :style="{
            backgroundColor: dataSelecionada === item.dia ? '#0ab39c' : 
                            (item.status === 'recesso' || item.status === 'bloqueado' ? '#ef4444' : 
                            (item.status === 'sua-reserva' ? '#ffb800' :
                            (item.status === 'reservado' || item.status === 'ocupado' ? '#299cdb' : 
                            (item.status === 'disponivel' ? '#2a2f42' : 'rgba(42, 45, 61, 0.15)')))),
            border: item.status === 'disponivel' ? '1px solid rgba(255,255,255,0.15)' : '1px solid rgba(255,255,255,0.02)',
            color: item.status === 'folga' ? 'rgba(255,255,255,0.2)' : '#ffffff',
            padding: '10px 0',
            borderRadius: '6px',
            fontWeight: 'bold',
            cursor: item.status === 'disponivel' ? 'pointer' : 'not-allowed',
            boxShadow: dataSelecionada === item.dia ? '0 0 10px rgba(10,179,156,0.5)' : 'none'
          }"
        >
          {{ item.dia }}
        </button>
      </div>

      <!-- RÉGUA DE LEGENDAS (PRESERVANDO AS ORIGINAIS, COM RECESSO DANGER EM VERMELHO E SUA RESERVA EM AMARELO) -->
      <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 15px 25px; margin-top: 25px; padding-top: 15px; border-top: 1px solid rgba(255,255,255,0.05); font-family: monospace; font-size: 11px;">
        <div style="display: flex; align-items: center; gap: 8px; height: 16px;"><div style="width: 12px; height: 12px; background-color: #2a2f42; border: 1px solid rgba(255,255,255,0.15); border-radius: 3px;"></div><span style="color: #ffffff; text-transform: uppercase; font-weight: bold; line-height: 1;">Disponível</span></div>
        <div style="display: flex; align-items: center; gap: 8px; height: 16px;"><div style="width: 12px; height: 12px; background-color: #0ab39c; border-radius: 3px; box-shadow: 0 0 5px rgba(10,179,156,0.5);"></div><span style="color: #0ab39c; text-transform: uppercase; font-weight: bold; line-height: 1;">Sua Escolha</span></div>
        <div style="display: flex; align-items: center; gap: 8px; height: 16px;"><div style="width: 12px; height: 12px; background-color: rgba(42, 45, 61, 0.4); border: 1px solid rgba(255,255,255,0.05); border-radius: 3px;"></div><span style="color: rgba(255,255,255,0.45); text-transform: uppercase; font-weight: bold; line-height: 1;">Folga Padrão</span></div>
        <div style="display: flex; align-items: center; gap: 8px; height: 16px;"><div style="width: 12px; height: 12px; background-color: #ef4444; border-radius: 3px;"></div><span style="color: #ef4444; text-transform: uppercase; font-weight: bold; line-height: 1;">Recesso</span></div>
        <div style="display: flex; align-items: center; gap: 8px; height: 16px;"><div style="width: 12px; height: 12px; background-color: #299cdb; border-radius: 3px;"></div><span style="color: #299cdb; text-transform: uppercase; font-weight: bold; line-height: 1;">Reservado</span></div>
        <div style="display: flex; align-items: center; gap: 8px; height: 16px;"><div style="width: 12px; height: 12px; background-color: #ffb800; border-radius: 3px;"></div><span style="color: #ffb800; text-transform: uppercase; font-weight: bold; line-height: 1;">Sua Reserva</span></div>
      </div>
    </div>

    <!-- 🚀 PAINEL DINÂMICO DE HORÁRIO & EXTRAS -->
    <div v-if="dataSelecionada" class="animate__animated animate__fadeInUp" style="margin-top: 30px; padding-top: 25px; border-top: 1px solid rgba(255,255,255,0.05); text-align: left; font-family: monospace;">
      <div style="display: flex; flex-wrap: wrap; gap: 30px; margin-bottom: 25px;">
        
        <!-- SELETOR DE HORÁRIO -->
        <div style="flex: 1; min-width: 200px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; display: block; margin-bottom: 8px;">⏰ Horário de Início</label>
          <input 
            type="time" 
            v-model="horarioShow"
            @input="atualizarEstadoGlobal"
            style="width: 100%; padding: 14px 20px; background-color: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.08); border-radius: 8px; color: #ffffff; font-size: 15px; font-weight: bold; outline: none; box-sizing: border-box;"
          />
          
          <div v-if="limiteHoraDiaSelecionado && horarioShow && horarioShow < limiteHoraDiaSelecionado" style="color: #ef4444; font-size: 11px; font-weight: bold; margin-top: 8px; text-transform: uppercase; letter-spacing: 0.3px;">
            ❌ O artista atende apenas a partir das {{ limiteHoraDiaSelecionado }} neste dia!
          </div>
        </div>

        <!-- CONTADOR DE HORAS EXTRAS -->
        <div style="width: 220px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; display: block; margin-bottom: 8px;">⏱️ Estender Duração?</label>
          <div style="display: flex; align-items: center; background-color: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.08); border-radius: 8px; height: 53px; overflow: hidden; box-sizing: border-box;">
            <button type="button" @click="alterarHorasExtras(-1)" :disabled="horasExtras === 0" style="width: 60px; height: 100%; background: none; border: none; color: #ff6c22; font-size: 18px; font-weight: bold; cursor: pointer;">-</button>
            <div style="flex: 1; text-align: center; color: #ffffff; font-size: 15px; font-weight: bold;">+{{ horasExtras }}h</div>
            <button type="button" @click="alterarHorasExtras(1)" :disabled="horasExtras >= 5" style="width: 60px; height: 100%; background: none; border: none; color: #ff6c22; font-size: 18px; font-weight: bold; cursor: pointer;">+</button>
          </div>
        </div>

      </div>

      <!-- BOTÃO CENTRAL DE AVANÇO -->
      <button 
        type="button"
        @click="emitirAvancoEtapa" 
        :disabled="!horarioShow || (limiteHoraDiaSelecionado && horarioShow < limiteHoraDiaSelecionado)"
        :style="{
          backgroundColor: (horarioShow && (!limiteHoraDiaSelecionado || horarioShow >= limiteHoraDiaSelecionado)) ? '#ff6c22' : '#2a2d3d',
          borderColor: (horarioShow && (!limiteHoraDiaSelecionado || horarioShow >= limiteHoraDiaSelecionado)) ? '#ff6c22' : '#2a2d3d',
          color: (horarioShow && (!limiteHoraDiaSelecionado || horarioShow >= limiteHoraDiaSelecionado)) ? '#ffffff' : '#878a99',
          cursor: (horarioShow && (!limiteHoraDiaSelecionado || horarioShow >= limiteHoraDiaSelecionado)) ? 'pointer' : 'not-allowed'
        }"
        style="border: 1px solid; font-weight: bold; text-transform: uppercase; font-size: 12px; padding: 16px 40px; border-radius: 50px; width: 100%; box-shadow: 0 4px 15px rgba(255,108,34,0.15);"
      >
        Confirmar Data e Avançar para Logística →
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
      horarioShow: "21:00", 
      horasExtras: 0,
      nomesMeses: [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
      ],
      limiteHoraDiaSelecionado: null
    };
  },
  methods: {
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
          this.horarioShow = diaDados.startTime; 
        } else {
          this.limiteHoraDiaSelecionado = null;
          this.horarioShow = "21:00"; 
        }
        
        this.atualizarEstadoGlobal();
      }
    },

    emitirAvancoEtapa() {
      if (this.dataSelecionada && this.horarioShow) {
        this.$emit("avancar-etapa");
      }
    }
  },
  mounted() {
    this.buscarDisponibilidadeAgenda();
  }
};
</script>