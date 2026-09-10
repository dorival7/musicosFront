<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="animate__animated animate__fadeIn" style="text-align: left;">
    
    <!-- 🎛️ CABEÇALHO DO CALENDÁRIO: NAV COMPACTA COM DESTAQUE NEON -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; background-color: #151722; padding: 12px 20px; border-radius: 10px; border: 1px solid #222534; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
      <h5 style="color: #ffffff; font-weight: bold; font-size: 13px; margin: 0; text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; gap: 6px;">
        <span style="font-size: 15px;">📅</span> Agenda de Shows
      </h5>
      <div style="display: flex; align-items: center; gap: 10px; font-family: monospace;">
        <button @click="alterarMes(-1)" type="button" style="background: #1a1d29; border: 1px solid #2d3248; color: #ffffff; padding: 5px 12px; border-radius: 6px; font-size: 11px; cursor: pointer; font-weight: bold; transition: 0.2s;" onmouseover="this.style.borderColor='#ff6c22';" onmouseout="this.style.borderColor='#2d3248';">← ANT</button>
        <div style="background-color: rgba(255,108,34,0.05); border: 1px solid rgba(255,108,34,0.2); padding: 5px 15px; border-radius: 6px;">
          <span style="color: #ff6c22; font-weight: bold; font-size: 12px; text-transform: uppercase; min-width: 110px; display: inline-block; text-align: center; letter-spacing: 0.5px;">
            {{ obterNomeMesAno }}
          </span>
        </div>
        <button @click="alterarMes(1)" type="button" style="background: #1a1d29; border: 1px solid #2d3248; color: #ffffff; padding: 5px 12px; border-radius: 6px; font-size: 11px; cursor: pointer; font-weight: bold; transition: 0.2s;" onmouseover="this.style.borderColor='#ff6c22';" onmouseout="this.style.borderColor='#2d3248';">PRÓX →</button>
      </div>
    </div>

    <!-- 🗓️ GRID COMPACTO COM DIVISÓRIAS VIVAS (MUDANÇA DE MIN-HEIGHT PARA 65PX) -->
    <div style="background-color: #222534; border: 1px solid #2d3248; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); padding: 1px;">
      
      <!-- DIAS DA SEMANA (LEGENDA SUPERIOR) -->
      <div style="display: grid; grid-template-columns: repeat(7, 1fr); background-color: #11131c; border-bottom: 1px solid #222534; text-align: center;">
        <div v-for="diaSemana in legendaDiasSemana" :key="diaSemana" style="color: #a3a6b4; font-size: 11px; font-weight: bold; padding: 10px 5px; text-transform: uppercase;">
          {{ diaSemana }}
        </div>
      </div>

      <!-- MATRIZ DE CÉLULAS COMPACTAS (DENSIDADE ALTA) -->
      <div style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 1px; background-color: #222534;">
        <div 
          v-for="(celula, index) in matrizDiasCalendario" 
          :key="index"
          :style="{
            backgroundColor: celula.isHoje ? '#1b1f32' : (celula.isMesAtual ? '#151722' : '#0d0e14'),
            border: celula.isHoje ? '1px solid #ff6c22' : '1px solid transparent',
            opacity: celula.isMesAtual ? 1 : 0.25,
            minHeight: '65px'
          }"
          style="padding: 6px 8px; display: flex; flex-direction: column; justify-content: space-between; box-sizing: border-box; position: relative; transition: background-color 0.15s;"
          onmouseover="this.style.backgroundColor='#1c1f2e';"
          onmouseout="this.style.backgroundColor=this.style.border.includes('ff6c22') ? '#1b1f32' : (this.style.opacity === '0.25' ? '#0d0e14' : '#151722')"
        >
          <!-- Número do Dia Identificável -->
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <span 
              :style="{ 
                color: celula.isHoje ? '#ff6c22' : (celula.isMesAtual ? '#ffffff' : '#6c757d'),
                fontWeight: 'bold'
              }"
              style="font-size: 11px; font-family: monospace;"
            >
              {{ celula.numeroDia }}
            </span>
            <span v-if="celula.isHoje" style="color: #ff6c22; font-size: 8px; font-weight: bold; text-transform: uppercase;">• Hoje</span>
          </div>

          <!-- Tarjas Neon Vivas e Slim para os Shows -->
          <div style="display: flex; flex-direction: column; gap: 3px; margin-top: 4px; width: 100%;">
            <div 
              v-for="show in celula.showsDoDia" 
              :key="show.id"
              :style="{
                backgroundColor: show.status === 'Confirmed' ? 'rgba(10,179,156,0.12)' : 'rgba(255,108,34,0.12)',
                borderLeft: show.status === 'Confirmed' ? '3px solid #0ab39c' : '3px solid #ff6c22',
                color: show.status === 'Confirmed' ? '#29e7cd' : '#ff8e42'
              }"
              style="padding: 3px 6px; border-radius: 3px; font-size: 9px; font-weight: bold; text-transform: uppercase; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; width: 100%; box-sizing: border-box; letter-spacing: 0.3px;"
              :title="show.nomeMusico"
            >
              🎤 {{ show.nomeMusico }}
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- LEGENDA COMPACTA INFERIOR -->
    <div style="display: flex; gap: 20px; margin-top: 12px; padding: 8px 12px; background-color: #151722; border-radius: 6px; border: 1px solid #222534; width: max-content;">
      <div style="display: flex; align-items: center; gap: 6px; font-size: 10px; color: #a3a6b4; font-weight: bold; text-transform: uppercase;">
        <div style="width: 8px; height: 8px; background-color: rgba(255,108,34,0.15); border-left: 2px solid #ff6c22; border-radius: 1px;"></div>
        Pendente
      </div>
      <div style="display: flex; align-items: center; gap: 6px; font-size: 10px; color: #a3a6b4; font-weight: bold; text-transform: uppercase;">
        <div style="width: 8px; height: 8px; background-color: rgba(10,179,156,0.15); border-left: 2px solid #0ab39c; border-radius: 1px;"></div>
        Confirmado
      </div>
    </div>

  </div>
</template>
<script>
/* eslint-disable */
export default {
  name: "MinhaAgendaCalendario",
  props: {
    // Herda reativamente a lista unificada de shows carregada pelo componente Pai
    eventos: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      mesAtivo: new Date().getMonth(),
      anoAtivo: new Date().getFullYear(),
      legendaDiasSemana: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
      nomesMeses: [
        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
      ]
    };
  },
  computed: {
    // 🛠️ AUXILIAR TEXTUAL: Fabrica o título dinâmico do topo (Ex: "SETEMBRO 2026")
    obterNomeMesAno() {
      return `${this.nomesMeses[this.mesAtivo]} ${this.anoAtivo}`;
    },

    // 🧠 ALGORITMO SÊNIOR: Monta a matriz perfeita de 35 ou 42 células para o grid CSS
    matrizDiasCalendario() {
      const matriz = [];
      
      // Captura o primeiro dia da semana do mês atual (0 = Domingo, 1 = Segunda, etc)
      const primeiroDiaSemana = new Date(this.anoAtivo, this.mesAtivo, 1).getDay();
      
      // Captura a quantidade total de dias contidos no mês ativo
      const totalDiasMesAtual = new Date(this.anoAtivo, this.mesAtivo + 1, 0).getDate();
      
      // Captura a quantidade total de dias contidos no mês anterior (para preencher o recuo)
      const totalDiasMesAnterior = new Date(this.anoAtivo, this.mesAtivo, 0).getDate();

      // Hoje real para marcar o indicador visual em laranja
      const hojeData = new Date();

      // 1. RECUO DO MÊS ANTERIOR: Preenche as células vazias iniciais da primeira semana
      for (let i = primeiroDiaSemana - 1; i >= 0; i--) {
        const diaNum = totalDiasMesAnterior - i;
        matriz.push({
          numeroDia: diaNum,
          isMesAtual: false,
          isHoje: false,
          showsDoDia: []
        });
      }

      // 2. DIAS DO MÊS ATUAL: Popula as células legítimas cruzando os shows na mesma data
      for (let dia = 1; dia <= totalDiasMesAtual; dia++) {
        // Constrói o escopo do dia atual em loop para checagem cronológica
        const dataCelula = new Date(this.anoAtivo, this.mesAtivo, dia);
        
        const isHoje = hojeData.getDate() === dia && 
                       hojeData.getMonth() === this.mesAtivo && 
                       hojeData.getFullYear() === this.anoAtivo;

        // 🚀 FILTRO E ASSOCIAÇÃO: Filtra os shows salvos no MariaDB que acontecem neste exato dia
        const showsAgendadosParaEsteDia = this.eventos.filter(evento => {
          if (!evento.dataEvento) return false;
          
          // Converte o timestamp ISO string vindo do C# para objeto Date da memória
          const dataShow = new Date(evento.dataEvento);
          return dataShow.getDate() === dia &&
                 dataShow.getMonth() === this.mesAtivo &&
                 dataShow.getFullYear() === this.anoAtivo;
        });

        matriz.push({
          numeroDia: dia,
          isMesAtual: true,
          isHoje: isHoje,
          showsDoDia: showsAgendadosParaEsteDia // Injeta o array de bandas dentro da célula HTML
        });
      }

      // 3. AVANÇO DO MÊS SEGUINTE: Preenche o grid restante até fechar múltiplos de 7 colunas
      const totalCelulasPreenchidas = matriz.length;
      const sobraCelulas = totalCelulasPreenchidas % 7;
      
      if (sobraCelulas !== 0) {
        const celulasFaltantes = 7 - sobraCelulas;
        for (let diaProx = 1; diaProx <= celulasFaltantes; diaProx++) {
          matriz.push({
            numeroDia: diaProx,
            isMesAtual: false,
            isHoje: false,
            showsDoDia: []
          });
        }
      }

      return matriz;
    }
  },
  methods: {
    // 🎛️ NAVEGADOR OPERACIONAL: Avança ou retrocede as folhas do calendário cuidando da virada de ano
    alterarMes(direcao) {
      this.mesAtivo += direcao;
      if (this.mesAtivo < 0) {
        this.mesAtivo = 11;
        this.anoAtivo -= 1;
      } else if (this.mesAtivo > 11) {
        this.mesAtivo = 0;
        this.anoAtivo += 1;
      }
    }
  }
};
</script>