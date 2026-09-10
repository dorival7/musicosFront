<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); font-family: monospace;">
    
    <!-- 🏁 MARCADOR DE PROGRESSO (STEPPER ATIVO NO PASSO 3) -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 40px; padding: 0 10px;">
      <div style="display: flex; align-items: center; gap: 10px; opacity: 0.5;"><div style="width: 36px; height: 36px; border-radius: 50%; background-color: #2a2d3d; color: #fff; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px;">1</div><span style="color: #fff; font-size: 13px; font-weight: bold; text-transform: uppercase;">Agenda</span></div>
      <div style="flex: 1; height: 2px; background-color: rgba(255,255,255,0.05); margin: 0 15px;"></div>
      <div style="display: flex; align-items: center; gap: 10px; opacity: 0.5;"><div style="width: 36px; height: 36px; border-radius: 50%; background-color: #2a2d3d; color: #fff; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px;">2</div><span style="color: #fff; font-size: 13px; font-weight: bold; text-transform: uppercase;">Logística</span></div>
      <div style="flex: 1; height: 2px; background-color: #ff6c22; margin: 0 15px;"></div>
      <div style="display: flex; align-items: center; gap: 10px;"><div style="width: 36px; height: 36px; border-radius: 50%; background-color: #ff6c22; color: #ffffff; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; box-shadow: 0 0 15px rgba(255,108,34,0.4);">3</div><span style="color: #ffffff; font-size: 13px; font-weight: bold; text-transform: uppercase;">Contrato</span></div>
      <div style="flex: 1; height: 2px; background-color: rgba(255,255,255,0.05); margin: 0 15px;"></div>
      <div style="display: flex; align-items: center; gap: 10px; opacity: 0.4;"><div style="width: 36px; height: 36px; border-radius: 50%; background-color: #2a2d3d; color: #adb5bd; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px;">4</div><span style="color: #adb5bd; font-size: 13px; text-transform: uppercase;">Pagar</span></div>
    </div>

    <!-- TÍTULO ORIENTADOR DO PASSO -->
    <div style="margin-bottom: 25px; text-align: left;">
      <h3 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 18px; margin: 0 0 6px 0;">Resumo da Contratação</h3>
      <p style="color: #878a99; font-size: 13px; margin: 0;">Revise os dados de agendamento abaixo e abra a minuta legal para formalizar o show.</p>
    </div>

    <!-- 🛡️ NOVO BOX INJETADO COM ENQUADRAMENTO PREMIUM NA COLUNA DA ESQUERDA -->
    <div style="background-color: rgba(10, 179, 156, 0.06); border: 1px solid rgba(10, 179, 156, 0.25); border-radius: 12px; padding: 18px; text-align: left; margin-bottom: 25px; box-shadow: inset 0 0 10px rgba(10,179,156,0.02);">
      <p style="color: #0ab39c; font-size: 12px; line-height: 1.5; margin: 0; font-weight: bold; text-transform: uppercase; letter-spacing: 0.3px;">
        🔒 CUSTÓDIA SEGURA SEVENSHOWS
      </p>
      <span style="color: #ced4da; font-size: 12px; font-weight: normal; display: block; margin-top: 4px; line-height: 1.4;">
        Seu dinheiro fica protegido na plataforma e o artista só recebe após a realização do show!
      </span>
    </div>

    <!-- 📋 COMPACT SUMÁRIO DE REVISÃO DO EVENTO COM DESIGN MODERNIZADO -->
    <div style="background-color: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 20px; text-align: left; margin-bottom: 20px;">
      <span style="color: #878a99; font-size: 11px; text-transform: uppercase; display: block; font-weight: bold; margin-bottom: 12px; letter-spacing: 0.5px;">📋 Dados do Agendamento Garantido</span>
      <p style="color: #ffffff; font-size: 13px; margin: 0 0 8px 0;"><strong>Apresentação:</strong> {{ dataFormatada }} às {{ horarioShow }}h</p>
      <p style="color: #ffffff; font-size: 13px; margin: 0; line-height: 1.4;"><strong>Adicionais Contratados:</strong> {{ horasExtras }}h Extras | Deslocamento Validado via CEP</p>
    </div>
    <!-- 📢 TARJA PREMIUM: FLUXO DE ASSINATURA BILATERAL E ENVIO DE CÓPIA -->
    <div style="background-color: rgba(42, 47, 66, 0.3); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 12px; padding: 18px 20px; text-align: left; margin-bottom: 25px; box-sizing: border-box;">
      <p style="color: #ffffff; font-size: 12px; line-height: 1.5; margin: 0; font-weight: bold; letter-spacing: 0.3px;">
        📢 OBSERVAÇÃO IMPORTANTE:<br/>
        <span style="color: #adb5bd; font-size: 11px; font-weight: normal; display: block; margin-top: 5px; line-height: 1.4;">
          O artista contratado assinará eletronicamente este mesmo contrato. Assim que ambas as partes concluírem o aceite, uma cópia integral autenticada em PDF será enviada automaticamente para o seu e-mail cadastrado.
        </span>
      </p>
    </div>

    <!-- GATILHO CENTRAL DO MODAL JURÍDICO -->
    <button type="button" @click="modalContratoAtivo = true" style="background-color: #2a2f42; border: 1px solid #3a3f50; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 12px; padding: 16px; border-radius: 8px; width: 100%; cursor: pointer; margin-bottom: 25px; outline: none; box-sizing: border-box; transition: 0.2s;">📋 Visualizar Minuta Completa do Contrato</button>

    <!-- 🔒 CHECKBOX REATIVO DE ASSINATURA DIGITAL -->
    <div style="display: flex; align-items: start; gap: 12px; text-align: left; margin-bottom: 30px; background-color: rgba(255,255,255,0.02); padding: 16px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.04); box-sizing: border-box;">
      <input type="checkbox" v-model="aceitouTermos" id="chkAssinaturaDigital" style="width: 18px; height: 18px; accent-color: #ff6c22; margin-top: 2px; cursor: pointer;" />
      <label for="chkAssinaturaDigital" style="color: #ffffff; font-size: 13px; line-height: 1.5; cursor: pointer; user-select: none;">Li a minuta completa e concordo com todos os termos e cláusulas do contrato. *</label>
    </div>

    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-top: 15px;">
      
      <!-- BOTÃO 1: ASSINAR E PAGAR COM PIX -->
      <button 
        type="button"
        @click="$emit('avancar-etapa', 'pix')" 
        :disabled="!aceitouTermos" 
        :style="{ 
          backgroundColor: aceitouTermos ? '#0ab39c' : '#2a2d3d', 
          borderColor: aceitouTermos ? '#0ab39c' : '#2a2d3d', 
          color: aceitouTermos ? '#ffffff' : '#878a99', 
          cursor: aceitouTermos ? 'pointer' : 'not-allowed' 
        }" 
        style="border: 1px solid; font-weight: bold; text-transform: uppercase; font-size: 11px; padding: 14px; border-radius: 50px; box-shadow: 0 4px 15px rgba(10,179,156,0.15); box-sizing: border-box; transition: 0.2s; letter-spacing: 0.3px; display: flex; align-items: center; justify-content: center;"
      >
        Pagar com Pix
      </button>

      <!-- BOTÃO 2: ASSINAR E PAGAR COM CARTÃO -->
      <button 
        type="button"
        @click="$emit('avancar-etapa', 'cartao')" 
        :disabled="!aceitouTermos" 
        :style="{ 
          backgroundColor: aceitouTermos ? '#0ab39c' : '#2a2d3d', 
          borderColor: aceitouTermos ? '#0ab39c' : '#2a2d3d', 
          color: aceitouTermos ? '#ffffff' : '#878a99', 
          cursor: aceitouTermos ? 'pointer' : 'not-allowed' 
        }" 
        style="border: 1px solid; font-weight: bold; text-transform: uppercase; font-size: 11px; padding: 14px; border-radius: 50px; box-shadow: 0 4px 15px rgba(10,179,156,0.15); box-sizing: border-box; transition: 0.2s; letter-spacing: 0.3px; display: flex; align-items: center; justify-content: center;"
      >
        Pagar com Cartão
      </button>

    </div>

    <!-- 🏛️ MODAL EM DARK MODE: POP-UP FLUTUANTE DA MINUTA LEGAL COMPLETA -->
    <div v-if="modalContratoAtivo" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.85); display: flex; align-items: center; justify-content: center; z-index: 9999; padding: 20px; box-sizing: border-box;">
      <div style="background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 12px; max-width: 650px; width: 100%; padding: 35px; box-shadow: 0 15px 40px rgba(0,0,0,0.6); font-family: monospace; box-sizing: border-box;">
        
        <h4 style="color: #ffffff; font-weight: bold; font-size: 13px; text-transform: uppercase; margin: 0 0 20px 0; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px; text-align: left; letter-spacing: 0.5px;">📄 INSTRUMENTO PARTICULAR DE PRESTAÇÃO DE SERVIÇOS ARTÍSTICOS E CUSTÓDIA DE CACHÊ</h4>
        
        <div style="max-height: 280px; overflow-y: auto; text-align: left; color: #ced4da; font-size: 11px; line-height: 1.6; padding-right: 12px; margin-bottom: 25px; box-sizing: border-box; border: 1px solid #3a3f50; padding: 15px; border-radius: 6px; background-color: rgba(0,0,0,0.2);">
          
          <p style="text-align: center; color: #ffffff; font-weight: bold; margin-top: 0; font-size: 11px; text-transform: uppercase; letter-spacing: 0.3px;">MINUTA CONTRATUAL REGULAMENTAR</p>
          
          <p><strong>CLÁUSULA 1ª - DAS PARTES E QUALIFICAÇÃO:</strong> O presente contrato vincula eletronicamente, de um lado, o usuário devidamente autenticado e registrado com conta ativa nesta plataforma, doravante denominado simplesmente <strong>CONTRATANTE</strong>, e, de outro lado, a atração musical e artística identificada no chassi corporativo como <strong>{{ pacoteInfo?.nomeBanda || pacoteInfo?.NomeBanda }}</strong>, neste ato representada por seu responsável legal cadastrado no banco de dados do MariaDB, doravante denominada <strong>CONTRATADO</strong>. Ambas as partes declaram possuir plena capacidade civil para a celebração deste negócio jurídico, intermediado tecnologicamente pelo portal SevenShows.</p>
          
          <p><strong>CLÁUSULA 2ª - DO OBJETO E DURAÇÃO CONTRATUAL:</strong> Constitui objeto deste instrumento a prestação de serviços de entretenimento musical ao vivo pelo CONTRATADO na execução do show estruturado sob o formato comercial "<strong>{{ pacoteInfo?.tituloPacote || pacoteInfo?.TituloPacote }}</strong>". A apresentação terá a duração regulamentar padrão de <strong>{{ pacoteInfo?.duracaoMinutos || pacoteInfo?.DuracaoMinutos }} minutos</strong>, acrescida del período adicional reativo de <strong>+{{ horasExtras }}h (horas extras)</strong> estendidas e adquiridas pelo CONTRATANTE nesta transação.</p>
          
          <p><strong>CLÁUSULA 3ª - DA DATA, HORÁRIO E LOCAL DE EXECUÇÃO:</strong> O show musical será executado impreterivelmente no dia <strong>{{ dataFormatada }}</strong>, com início programado e cravado de forma irrevogável para as <strong>{{ horarioShow }}h</strong>. A prestação dos serviços ocorrerá no endereço logístico preenchido e validado eletronicamente pelo CONTRATANTE através do Step 2 (Logística) deste checkout, servindo os dados postais coletados como roteiro oficial para deslocamento rodoviário da equipe artística técnica.</p>
          
          <p><strong>CLÁUSULA 4ª - DA INFRAESTRUTURA E RIDER TÉCNICO:</strong> O CONTRATADO assume a responsabilidade civil e profissional de fornecer integralmente a infraestrutura técnica e de sonorização inclusa no pacote selecionado, especificada conforme o seguinte registro do banco de dados: <em>{{ pacoteInfo?.descricaoPacote || pacoteInfo?.DescricaoPacote || "Instrumentação padrão e infraestrutura operacional de estrada acordadas no pacote básico." }}</em>. Qualquer alteração ou exigência de rider técnico complementar fora deste escopo deverá ser pactuada por escrito em canal interno próprio.</p>
          
          <p><strong>CLÁUSULA 5ª - DO PREÇO CONSOLIDADO E REGIME DE CUSTÓDIA:</strong> Pela execução integral dos serviços descritos, o CONTRATANTE pagará a quantia líquida e certa de <strong>{{ formatarMoeda(totalGeral) }}</strong>. Este montante financeiro total engloba o cachê base fixado em {{ formatarMoeda(pacoteInfo?.precoBase || pacoteInfo?.PrecoBase || 0) }}, somado reativamente ao custo das horas extras e da taxa de deslocamento logístico interestadual/intermunicipal calculada por KM postal. Fica expressamente ajustado que a integralidade deste valor será depositada pelo CONTRATANTE no Passo 4 e retida sob o regime estrito de <strong>CUSTÓDIA FINANCEIRA DE GARANTIA</strong> da SevenShows, agindo a plataforma como fiel depositária, cujo repasse e liberação ao CONTRATADO ocorrerá no prazo de 48 horas úteis após a realização física documentada do show.</p>
          <p><strong>CLÁUSULA 6ª - DAS PENALIDADES E RESCISÃO CONTRATUAL:</strong> O cancelamento imotivado por iniciativa do CONTRATANTE ensejará a retenção de multas proporcionais estipuladas no regulamento geral da plataforma. Na hipótese de cancelamento por inadimplemento ou força maior comprovada por parte do CONTRATADO, ou descumprimento de agenda técnica, a plataforma SevenShows realizará a devolução integral e imediata de 100% do montante custodiado para a conta do CONTRATANTE, sem qualquer retenção de taxas intermediárias ou burocracias operacionais.</p>
          
          <p><strong>CLÁUSULA 7ª - DA VALIDADE DA ASSINATURA ELETRÔNICA:</strong> As partes anuem de forma expressa, plena e irrevogável que o clique de aceite e a marcação de consentimento digital efetuados no encerramento deste chassi conferem total validade jurídica, eficácia executiva e força contratual ao presente instrumento, nos termos do art. 10, § 2º, da Medida Provisória nº 2.200-2/2001 e da Lei nº 14.063/2020, renunciando a qualquer alegação de nulidade por ausência de assinatura física ou reconhecimento de firma.</p>
          
          <p><strong>CLÁUSULA 8ª - DO FORO DE ELEIÇÃO:</strong> Fica eleito o Foro Central da Comarca de Londrina, Estado do Paraná, com exclusão de qualquer outro por mais privilegiado que seja, para dirimir quaisquer dúvidas, controvérsias ou litígios decorrentes da interpretação ou execução do presente contrato de entretenimento.</p>
        </div>
        
        <!-- BOTÃO DE FECHAMENTO DINÂMICO DO POP-UP -->
        <button type="button" @click="modalContratoAtivo = false" style="background-color: #ff6c22; border: none; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 12px; padding: 14px 30px; border-radius: 50px; cursor: pointer; width: 100%; box-sizing: border-box; box-shadow: 0 4px 12px rgba(255,108,34,0.2);">Fechar Minuta ✕</button>

      </div>
    </div>

  </div>
</template>

<script>
/* eslint-disable */
export default {
  name: "Step3Contrato",
  props: {
    pacoteInfo: { type: Object, default: () => ({}) },
    dataFormatada: { type: String, default: "" },
    horarioShow: { type: String, default: "" },
    horasExtras: { type: Number, default: 0 },
    taxaFrete: { type: Number, default: 0 },
    totalGeral: { type: Number, default: 0 }
  },
  emits: ["avancar-etapa"],
  data() {
    return {
      aceitouTermos: false,
      modalContratoAtivo: false
    };
  },
  methods: {
    // 🏛️ INTERPOLAÇÃO MONETÁRIA DINÂMICA DENTRO DAS CLÁUSULAS
    formatarMoeda(valor) {
      if (!valor) return "R$ 0,00";
      return new Intl.NumberFormat("pt-BR", {
        style: "currency",
        currency: "BRL"
      }).format(valor);
    }
  }
};
</script>
