<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="animate__animated animate__fadeIn" style="text-align: left;">
    
    <!-- 🎛️ TOPO DA LISTA -->
    <div style="margin-bottom: 25px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.05);">
      <h5 style="color: #ffffff; font-weight: bold; font-size: 15px; margin: 0; text-transform: uppercase; letter-spacing: 0.5px;">
        📋 Histórico e Status de Contratações
      </h5>
    </div>

    <!-- 💡 ESTADO VAZIO: Exibido caso o contratante não tenha nenhum show proposto -->
    <div v-if="!eventos || eventos.length === 0" style="text-align: center; padding: 50px 20px; background-color: rgba(255,255,255,0.02); border-radius: 12px; border: 1px dashed rgba(255,255,255,0.05);">
      <span style="font-size: 24px; display: block; margin-bottom: 10px;">🎸</span>
      <p style="color: #878a99; font-size: 13px; margin: 0;">Você ainda não possui propostas ou apresentações artísticas registradas.</p>
    </div>

    <!-- 📊 TABELA ANALÍTICA RESPONSIVA DO VELZON -->
    <div v-else style="width: 100%; max-width: 100%; overflow-x: hidden; background-color: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; box-sizing: border-box;">
      <table style="width: 100%; table-layout: fixed; border-collapse: collapse; font-family: monospace; font-size: 12px; color: #ced4da; box-sizing: border-box;">
        
        <!-- 📐 DISTRIBUIÇÃO ESPAÇOSA DE LARGURAS (Soma exata de 100%) -->
        <thead>
          <tr style="background-color: #1a1d29; border-bottom: 1px solid rgba(255,255,255,0.05); text-align: left;">
            <th style="padding: 15px; width: 28%; color: #878a99; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;">Atração / Músico</th>
            <th style="padding: 15px; width: 26%; color: #878a99; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;">Data &amp; Hora</th>
            <th style="padding: 15px; width: 20%; color: #878a99; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;">Localidade</th>
            <th style="padding: 15px; width: 14%; color: #878a99; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; text-align: right;">Cachê</th>
            <th style="padding: 15px; width: 12%; color: #878a99; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; text-align: center;">Status</th>
          </tr>
        </thead>

        <!-- Corpo da Tabela Espaçoso -->
        <tbody>
          <tr 
            v-for="show in eventos" 
            :key="show.id" 
            style="border-bottom: 1px solid rgba(255,255,255,0.02); transition: 0.2s;" 
            onmouseover="this.style.backgroundColor='rgba(255,255,255,0.01)'" 
            onmouseout="this.style.backgroundColor='transparent'"
          >
            <!-- Atração -->
            <td style="padding: 15px; font-weight: bold; color: #ffffff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
              🎤 {{ show.nomeMusico }}
            </td>
            
            <!-- Data e Hora -->
            <td style="padding: 15px; color: #ced4da;">
              {{ formatarDataBr(show.dataEvento) }}
            </td>
            
            <!-- Localidade -->
            <td style="padding: 15px; color: #a3a3a3; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
              {{ show.cidade }} / {{ show.estado }}
            </td>
            
            <!-- Cachê Total -->
            <td style="padding: 15px; text-align: right; font-weight: bold; color: #ff6c22;">
              {{ formatCurrency(show.precoTotal) }}
            </td>
            
            <!-- Emblema de Status -->
            <td style="padding: 15px; text-align: center;">
              <span 
                :style="{
                  backgroundColor: show.status === 'Confirmed' ? 'rgba(10,179,156,0.1)' : 'rgba(255,108,34,0.1)',
                  borderColor: show.status === 'Confirmed' ? 'rgba(10,179,156,0.2)' : 'rgba(255,108,34,0.2)',
                  color: show.status === 'Confirmed' ? '#0ab39c' : '#ff6c22'
                }"
                style="display: inline-block; padding: 4px 10px; border: 1px solid; border-radius: 4px; font-size: 10px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;"
              >
                {{ show.status === 'Confirmed' ? 'Pronto' : 'Pendente' }}
              </span>
            </td>
          </tr>
        </tbody>

      </table>
    </div>

  </div>
</template>
<script>
/* eslint-disable */
export default {
  name: "MeusShowsLista",
  props: {
    // Array reativo alimentado pela chamada centralizada do orquestrador Pai
    eventos: {
      type: Array,
      default: () => []
    }
  },
  emits: ["recarregar-dados"],
  methods: {
    // 🛠️ FORMATADOR MONETÁRIO: Transforma floats decimais no padrão pt-BR de Real (R$)
    formatCurrency(value) {
      if (!value) return "R$ 0,00";
      return new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value);
    },

    // 🗓️ FORMATADOR DE DATA BRASILEIRO: Trata o timestamp ISO string vindo do MariaDB
    formatarDataBr(dataIsoString) {
      if (!dataIsoString) return "--/--/----";
      try {
        const dataObjeto = new Date(dataIsoString);
        
        const dia = String(dataObjeto.getDate()).padStart(2, "0");
        const mes = String(dataObjeto.getMonth() + 1).padStart(2, "0");
        const ano = dataObjeto.getFullYear();
        
        const horas = String(dataObjeto.getHours()).padStart(2, "0");
        const minutos = String(dataObjeto.getMinutes()).padStart(2, "0");
        
        return `${dia}/${mes}/${ano} às ${horas}:${minutos}`;
      } catch (error) {
        return "--/--/----";
      }
    },

    // 📝 LINK RÁPIDO JURÍDICO: Avisa que no futuro pode empurrar o status para revisita legal
    abrirContratoDoShow(show) {
      if (!show?.id) return;
      alert(`Visualização da Proposta #${show.id.substring(0, 8).toUpperCase()}\nAtração: ${show.nomeMusico}\nLocal: ${show.cidade}/${show.estado}\n\nO fluxo de reabertura do contrato está sendo integrado.`);
    }
  }
};
</script>