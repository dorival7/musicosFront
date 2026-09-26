<template>
  <div class="confirmacao-show">
    <!-- PROGRESSO -->
    <div class="stepper">
      <div class="step muted"><span>1</span><b>Agenda</b></div><i></i>
      <div class="step muted"><span>2</span><b>Logística</b></div><i class="done"></i>
      <div class="step active"><span>3</span><b>Confirmar</b></div><i></i>
      <div class="step muted"><span>4</span><b>Agendar</b></div>
    </div>

    <div class="intro">
      <span class="eyebrow">PASSO 3 · CONFIRMAÇÃO DO SHOW</span>
      <h2 class="desktop-confirm-title">CONFIRME OS DETALHES DO SEU SHOW</h2>
      <h2 class="mobile-confirm-title">CONFIRA SEU AGENDAMENTO</h2>
      <p>Confira os dados da apresentação e garanta o seu agendamento.</p>
    </div>

    <!-- RESUMO DO QUE ESTÁ SENDO AGENDADO -->
    <section class="show-card">
      <div class="show-card-title"><span class="icon-box">♫</span><div><small>SEU SHOW</small><strong>{{ pacoteInfo?.nomeBanda || pacoteInfo?.NomeBanda }}</strong></div></div>
      <div class="show-grid">
        <div class="show-item"><small>FORMATO</small><strong>{{ pacoteInfo?.tituloPacote || pacoteInfo?.TituloPacote }}</strong><span>{{ pacoteInfo?.duracaoMinutos || pacoteInfo?.DuracaoMinutos }} minutos de show</span></div>
        <div class="show-item"><small>DATA E HORÁRIO</small><strong>{{ dataFormatada }}</strong><span>Início às {{ horarioShow }}h</span></div>
        <div class="show-item"><small>ADICIONAIS</small><strong>{{ horasExtras }}h extra{{ horasExtras === 1 ? '' : 's' }}</strong><span>Deslocamento validado via CEP</span></div>
      </div>

      <!-- No mobile este é o resumo final da contratação; evita duplicar o card lateral. -->
      <div class="mobile-financial-summary">
        <div class="financial-row">
          <span>Cachê do show</span>
          <strong>{{ formatarMoeda(pacoteInfo?.precoBase || pacoteInfo?.PrecoBase || 0) }}</strong>
        </div>
        <div v-if="horasExtras > 0" class="financial-row extra">
          <span>+{{ horasExtras }}h extra{{ horasExtras === 1 ? '' : 's' }}</span>
          <strong>+{{ formatarMoeda(valorTotalHorasExtras) }}</strong>
        </div>
        <div v-if="taxaFrete > 0" class="financial-row logistics">
          <span>Logística / deslocamento</span>
          <strong>+{{ formatarMoeda(taxaFrete) }}</strong>
        </div>
        <div class="financial-total">
          <span>TOTAL DA CONTRATAÇÃO</span>
          <strong>{{ formatarMoeda(totalGeral) }}</strong>
        </div>
      </div>
    </section>

    <div class="trust-grid">
      <section class="trust-card secure">
        <div class="trust-icon">🔒</div><div><strong>SEU PAGAMENTO FICA PROTEGIDO</strong><p>O valor permanece protegido pela Seven Shows e só é liberado ao artista após a realização do show.</p></div>
      </section>
      <section class="trust-card confirm">
        <div class="trust-icon">⏱</div><div><strong>CONFIRMAÇÃO DO ARTISTA EM ATÉ 6 HORAS</strong><p>O artista tem 6 horas para confirmar o seu agendamento ou o seu dinheiro será totalmente reembolsado.</p></div>
      </section>
    </div>

    <!-- TERMOS -->
    <section class="terms-card">
      <div class="terms-copy">
        <div class="terms-icon">📄</div>
        <div><strong>TERMOS DA CONTRATAÇÃO</strong><p>A contratação é formalizada digitalmente entre você e o artista. Ambos recebem uma cópia do documento por e-mail.</p></div>
      </div>
      <button type="button" class="secondary-btn" @click="modalContratoAtivo = true">LER TERMOS COMPLETOS →</button>
      <label class="accept-card mobile-terms-accept" for="chkAssinaturaDigitalMobile">
        <input type="checkbox" v-model="aceitouTermos" id="chkAssinaturaDigitalMobile" />
        <span><strong>LI E CONCORDO COM OS TERMOS DA CONTRATAÇÃO</strong></span>
      </label>
    </section>

    <label class="accept-card desktop-terms-accept" for="chkAssinaturaDigital">
      <input type="checkbox" v-model="aceitouTermos" id="chkAssinaturaDigital" />
      <span><strong>Li e concordo com os termos da contratação.</strong><button type="button" @click.prevent.stop="modalContratoAtivo = true">Ler termos completos</button></span>
    </label>

    <div class="payment-head">
      <span>FORMA DE PAGAMENTO</span>
      <h3>ESCOLHA COMO PAGAR E FINALIZE O AGENDAMENTO</h3>
      <p>Selecione a opção de pagamento que prefere. Você verá os dados para concluir na próxima etapa.</p>
    </div>

    <div class="payment-grid">
      <button type="button" class="pay-btn" @click="$emit('avancar-etapa', 'pix')" :disabled="!aceitouTermos">
        <span class="pay-symbol">◆</span>
        <span class="pay-copy">
          <small>PAGAR COM PIX</small>
          <strong>CONTINUAR COM PIX <b>→</b></strong>
          <em>Pagamento rápido e confirmação do pagamento em poucos instantes.</em>
        </span>
      </button>
      <button type="button" class="pay-btn" @click="$emit('avancar-etapa', 'cartao')" :disabled="!aceitouTermos">
        <span class="pay-symbol">▣</span>
        <span class="pay-copy">
          <small>PAGAR COM CARTÃO</small>
          <strong>CONTINUAR COM CARTÃO <b>→</b></strong>
          <em>Pagamento seguro com cartão. Confira as condições na próxima etapa.</em>
        </span>
      </button>
    </div>
    <p v-if="!aceitouTermos" class="payment-hint">Marque o aceite dos termos acima para liberar as formas de pagamento.</p>

    <!-- MODAL DOS TERMOS: conteúdo jurídico preservado -->
    <div v-if="modalContratoAtivo" class="modal-backdrop" @click.self="modalContratoAtivo = false">
      <div class="contract-modal">
        <div class="modal-header">
          <div><span>TERMOS DA CONTRATAÇÃO</span><h4>{{ pacoteInfo?.nomeBanda || pacoteInfo?.NomeBanda }} · {{ pacoteInfo?.tituloPacote || pacoteInfo?.TituloPacote }}</h4><p>{{ dataFormatada }} às {{ horarioShow }}h</p></div>
          <button type="button" class="modal-x" @click="modalContratoAtivo = false">×</button>
        </div>
        <div class="contract-scroll">
          <p class="contract-title">MINUTA CONTRATUAL REGULAMENTAR</p>
          <p><strong>CLÁUSULA 1ª - DAS PARTES E QUALIFICAÇÃO:</strong> O presente contrato vincula eletronicamente, de um lado, o usuário devidamente autenticado e registrado com conta ativa nesta plataforma, doravante denominado simplesmente <strong>CONTRATANTE</strong>, e, de outro lado, a atração musical e artística identificada no chassi corporativo como <strong>{{ pacoteInfo?.nomeBanda || pacoteInfo?.NomeBanda }}</strong>, neste ato representada por seu responsável legal cadastrado no banco de dados do MariaDB, doravante denominada <strong>CONTRATADO</strong>. Ambas as partes declaram possuir plena capacidade civil para a celebração deste negócio jurídico, intermediado tecnologicamente pelo portal SevenShows.</p>
          <p><strong>CLÁUSULA 2ª - DO OBJETO E DURAÇÃO CONTRATUAL:</strong> Constitui objeto deste instrumento a prestação de serviços de entretenimento musical ao vivo pelo CONTRATADO na execução do show estruturado sob o formato comercial "<strong>{{ pacoteInfo?.tituloPacote || pacoteInfo?.TituloPacote }}</strong>". A apresentação terá a duração regulamentar padrão de <strong>{{ pacoteInfo?.duracaoMinutos || pacoteInfo?.DuracaoMinutos }} minutos</strong>, acrescida del período adicional reativo de <strong>+{{ horasExtras }}h (horas extras)</strong> estendidas e adquiridas pelo CONTRATANTE nesta transação.</p>
          <p><strong>CLÁUSULA 3ª - DA DATA, HORÁRIO E LOCAL DE EXECUÇÃO:</strong> O show musical será executado impreterivelmente no dia <strong>{{ dataFormatada }}</strong>, com início programado e cravado de forma irrevogável para as <strong>{{ horarioShow }}h</strong>. A prestação dos serviços ocorrerá no endereço logístico preenchido e validado eletronicamente pelo CONTRATANTE através do Step 2 (Logística) deste checkout, servindo os dados postais coletados como roteiro oficial para deslocamento rodoviário da equipe artística técnica.</p>
          <p><strong>CLÁUSULA 4ª - DA INFRAESTRUTURA E RIDER TÉCNICO:</strong> O CONTRATADO assume a responsabilidade civil e profissional de fornecer integralmente a infraestrutura técnica e de sonorização inclusa no pacote selecionado, especificada conforme o seguinte registro do banco de dados: <em>{{ pacoteInfo?.descricaoPacote || pacoteInfo?.DescricaoPacote || "Instrumentação padrão e infraestrutura operacional de estrada acordadas no pacote básico." }}</em>. Qualquer alteração ou exigência de rider técnico complementar fora deste escopo deverá ser pactuada por escrito em canal interno próprio.</p>
          <p><strong>CLÁUSULA 5ª - DO PREÇO CONSOLIDADO E REGIME DE CUSTÓDIA:</strong> Pela execução integral dos serviços descritos, o CONTRATANTE pagará a quantia líquida e certa de <strong>{{ formatarMoeda(totalGeral) }}</strong>. Este montante financeiro total engloba o cachê base fixado em {{ formatarMoeda(pacoteInfo?.precoBase || pacoteInfo?.PrecoBase || 0) }}, somado reativamente ao custo das horas extras e da taxa de deslocamento logístico interestadual/intermunicipal calculada por KM postal. Fica expressamente ajustado que a integralidade deste valor será depositada pelo CONTRATANTE no Passo 4 e retida sob o regime estrito de <strong>CUSTÓDIA FINANCEIRA DE GARANTIA</strong> da SevenShows, agindo a plataforma como fiel depositária, cujo repasse e liberação ao CONTRATADO ocorrerá no prazo de 48 horas úteis após a realização física documentada do show.</p>
          <p><strong>CLÁUSULA 6ª - DAS PENALIDADES E RESCISÃO CONTRATUAL:</strong> O cancelamento imotivado por iniciativa do CONTRATANTE ensejará a retenção de multas proporcionais estipuladas no regulamento geral da plataforma. Na hipótese de cancelamento por inadimplemento ou força maior comprovada por parte do CONTRATADO, ou descumprimento de agenda técnica, a plataforma SevenShows realizará a devolução integral e imediata de 100% do montante custodiado para a conta do CONTRATANTE, sem qualquer retenção de taxas intermediárias ou burocracias operacionais.</p>
          <p><strong>CLÁUSULA 7ª - DA VALIDADE DA ASSINATURA ELETRÔNICA:</strong> As partes anuem de forma expressa, plena e irrevogável que o clique de aceite e a marcação de consentimento digital efetuados no encerramento deste chassi conferem total validade jurídica, eficácia executiva e força contratual ao presente instrumento, nos termos do art. 10, § 2º, da Medida Provisória nº 2.200-2/2001 e da Lei nº 14.063/2020, renunciando a qualquer alegação de nulidade por ausência de assinatura física ou reconhecimento de firma.</p>
          <p><strong>CLÁUSULA 8ª - DO FORO DE ELEIÇÃO:</strong> Fica eleito o Foro Central da Comarca de Londrina, Estado do Paraná, com exclusão de qualquer outro por mais privilegiado que seja, para dirimir quaisquer dúvidas, controvérsias ou litígios decorrentes da interpretação ou execução do presente contrato de entretenimento.</p>
        </div>
        <button type="button" class="modal-close" @click="modalContratoAtivo = false">FECHAR E CONTINUAR →</button>
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
  computed: {
    valorTotalHorasExtras() {
      const valorHora = Number(this.pacoteInfo?.extraHourValue || this.pacoteInfo?.ExtraHourValue || 0);
      return Number(this.horasExtras || 0) * valorHora;
    }
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


<style scoped>
.confirmacao-show{background:#131520;border:1px solid rgba(255,255,255,.05);border-radius:16px;padding:40px;box-shadow:0 10px 30px rgba(0,0,0,.5);font-family:monospace;color:#fff}.stepper{display:flex;align-items:center;justify-content:space-between;margin-bottom:38px;padding:0 10px}.step{display:flex;align-items:center;gap:10px;white-space:nowrap}.step span{width:36px;height:36px;border-radius:50%;background:#2a2d3d;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px}.step b{font-size:13px;text-transform:uppercase}.stepper i{flex:1;height:2px;background:rgba(255,255,255,.06);margin:0 15px}.stepper i.done{background:#ff6c22}.step.muted{opacity:.48}.step.active span{background:#ff6c22;box-shadow:0 0 15px rgba(255,108,34,.42)}.intro{text-align:left;margin-bottom:24px}.eyebrow{display:block;color:#ff6c22;font-size:10px;font-weight:800;letter-spacing:1px;margin-bottom:10px}.intro h2{font-family:Arial,sans-serif;font-size:23px;line-height:1.15;margin:0 0 8px;font-weight:900}.intro p{color:#a9afbd;font-size:13px;margin:0}.show-card{background:linear-gradient(135deg,rgba(255,108,34,.08),rgba(255,255,255,.025));border:1px solid rgba(255,108,34,.24);border-radius:14px;padding:20px;margin-bottom:16px}.show-card-title{display:flex;align-items:center;gap:12px;margin-bottom:18px}.icon-box{width:42px;height:42px;border-radius:11px;background:rgba(255,108,34,.14);display:flex;align-items:center;justify-content:center;color:#ff6c22;font-size:20px}.show-card-title div{display:flex;flex-direction:column;gap:4px}.show-card-title small,.show-item small{color:#8d94a5;font-size:9px;font-weight:800;letter-spacing:.7px}.show-card-title strong{font-family:Arial,sans-serif;font-size:18px}.show-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:10px}.show-item{background:rgba(0,0,0,.18);border:1px solid rgba(255,255,255,.055);border-radius:10px;padding:14px;display:flex;flex-direction:column;gap:5px}.show-item strong{font-size:12px}.show-item span{font-size:10px;color:#9da4b4}.trust-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:16px}.trust-card{display:flex;gap:12px;padding:17px;border-radius:12px;text-align:left}.trust-card.secure{background:rgba(10,179,156,.07);border:1px solid rgba(10,179,156,.28)}.trust-card.confirm{background:rgba(255,183,0,.055);border:1px solid rgba(255,183,0,.2)}.trust-icon{font-size:20px}.trust-card strong{font-size:10px;letter-spacing:.35px}.secure strong{color:#12cdb2}.confirm strong{color:#ffbd38}.trust-card p{color:#b7bdc9;font-size:10px;line-height:1.55;margin:5px 0 0}.terms-card{display:flex;align-items:center;justify-content:space-between;gap:18px;background:rgba(255,255,255,.025);border:1px solid rgba(255,255,255,.08);border-radius:12px;padding:18px;margin-bottom:14px}.terms-copy{display:flex;gap:12px;text-align:left;align-items:flex-start}.terms-icon{font-size:20px}.terms-copy strong{font-size:11px}.terms-copy p{font-size:10px;color:#aeb4c1;line-height:1.5;margin:5px 0 0;max-width:420px}.secondary-btn{flex:0 0 auto;background:#252a3b;border:1px solid #3c4256;color:#fff;border-radius:8px;padding:12px 15px;font:700 10px monospace;cursor:pointer}.accept-card{display:flex;align-items:flex-start;gap:12px;padding:15px 16px;background:rgba(255,255,255,.025);border:1px solid rgba(255,255,255,.07);border-radius:10px;text-align:left;cursor:pointer}.accept-card input{width:19px;height:19px;accent-color:#ff6c22;margin:1px 0 0}.accept-card span{display:flex;flex-direction:column;gap:4px;font-size:11px}.accept-card button{border:0;background:transparent;padding:0;color:#ff8a50;font:700 10px monospace;text-align:left;cursor:pointer;width:max-content}.payment-head{text-align:left;margin:24px 0 12px}.payment-head>span{color:#ff6c22;font-size:9px;font-weight:800;letter-spacing:.8px}.payment-head h3{font-family:Arial,sans-serif;font-size:17px;margin:5px 0 4px}.payment-head p{font-size:10px;color:#8f96a6;margin:0}.payment-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}.pay-btn{min-height:78px;border:1px solid #ff6c22;background:#ff6c22;color:#fff;border-radius:12px;padding:14px 16px;display:flex;align-items:center;gap:13px;text-align:left;transition:.2s;cursor:pointer;box-shadow:0 6px 18px rgba(255,108,34,.16)}.pay-btn:disabled{background:#292d3e;border-color:#34394b;color:#747b8e;cursor:not-allowed;box-shadow:none}.pay-symbol{font-size:22px}.pay-copy{display:flex;flex-direction:column;gap:3px}.pay-copy small{font-size:9px;font-weight:800}.pay-copy strong{font:800 10px monospace}.pay-copy em{font-style:normal;font-size:9px;opacity:.78}.payment-hint{text-align:center;color:#747b8e;font-size:9px;margin:10px 0 0}.modal-backdrop{position:fixed;inset:0;background:rgba(0,0,0,.88);display:flex;align-items:center;justify-content:center;z-index:9999;padding:20px}.contract-modal{background:#1a1d29;border:1px solid #3a3f50;border-radius:14px;width:min(780px,100%);max-height:90vh;padding:26px;box-shadow:0 20px 55px rgba(0,0,0,.7);box-sizing:border-box;display:flex;flex-direction:column}.modal-header{display:flex;justify-content:space-between;gap:15px;text-align:left;border-bottom:1px solid rgba(255,255,255,.08);padding-bottom:15px;margin-bottom:15px}.modal-header span{color:#ff6c22;font-size:9px;font-weight:800;letter-spacing:.7px}.modal-header h4{font-family:Arial,sans-serif;font-size:17px;margin:5px 0 3px}.modal-header p{color:#9da4b4;font-size:10px;margin:0}.modal-x{width:34px;height:34px;border-radius:50%;border:1px solid #3a3f50;background:#242838;color:#fff;font-size:20px;cursor:pointer}.contract-scroll{overflow-y:auto;text-align:left;color:#ced4da;font-size:11px;line-height:1.65;padding:18px;border:1px solid #34394b;border-radius:8px;background:rgba(0,0,0,.2);flex:1;min-height:280px}.contract-scroll p{margin:0 0 14px}.contract-title{text-align:center;color:#fff;font-weight:800}.modal-close{margin-top:16px;background:#ff6c22;border:0;color:#fff;font:800 11px monospace;padding:15px;border-radius:50px;cursor:pointer}.modal-close:hover,.pay-btn:not(:disabled):hover{filter:brightness(1.08)}
.payment-head{margin:26px 0 14px}.payment-head>span{font-size:10px;color:#ff7a32}.payment-head h3{font-size:18px;color:#fff;font-weight:900;margin:7px 0 6px}.payment-head p{font-size:11px;line-height:1.45;color:#c2c7d2}.pay-btn{min-height:94px;padding:17px 18px;gap:15px;background:#ff6c22;border-color:#ff7a32}.pay-symbol{font-size:24px;color:#fff;flex:0 0 auto}.pay-copy{gap:5px;min-width:0}.pay-copy small{font-size:9px;color:#fff;opacity:.92;letter-spacing:.45px}.pay-copy strong{font:900 12px/1.25 monospace;color:#fff}.pay-copy strong b{font-size:14px}.pay-copy em{font-size:10px;line-height:1.35;color:#fff;opacity:.92}.pay-btn:disabled{background:#292d3e;border-color:#3b4053;color:#9aa1b3;opacity:.72}.pay-btn:disabled .pay-copy small,.pay-btn:disabled .pay-copy strong,.pay-btn:disabled .pay-copy em,.pay-btn:disabled .pay-symbol{color:#aab0bf;opacity:1}.payment-hint{font-size:10px;line-height:1.4;color:#aab0bf;margin-top:11px}
.mobile-financial-summary{display:none}.financial-row,.financial-total{display:flex;align-items:center;justify-content:space-between;gap:14px}.financial-row{padding:10px 0;border-top:1px solid rgba(255,255,255,.06);font-size:11px;color:#b7bdc9}.financial-row strong{color:#fff;font-size:12px}.financial-row.extra strong{color:#ff7a32}.financial-row.logistics strong{color:#12cdb2}.financial-total{margin-top:4px;padding:15px 0 2px;border-top:1px solid rgba(255,255,255,.1)}.financial-total span{font-size:10px;color:#9da4b4;font-weight:800}.financial-total strong{font-family:Arial,sans-serif;font-size:20px;color:#ff6c22}
.mobile-terms-accept{display:none}
.mobile-confirm-title{display:none}
@media(max-width:760px){
  .confirmacao-show{padding:22px 16px}.stepper{padding:0;margin-bottom:26px}.step b{display:none}.stepper i{margin:0 7px}
  .desktop-confirm-title{display:none}.mobile-confirm-title{display:block}.intro{margin-bottom:17px}.intro h2{font-size:20px}.intro p{font-size:11px;line-height:1.45}
  .show-card{padding:15px 16px;margin-bottom:12px}.show-card-title{margin-bottom:10px}.show-card-title strong{font-size:16px}.icon-box{width:36px;height:36px;font-size:17px}
  .show-grid{display:flex;flex-wrap:wrap;gap:5px 14px;padding:0 0 9px}.show-item{display:block;background:transparent;border:0;border-radius:0;padding:0}.show-item small{display:none}.show-item strong,.show-item span{display:inline;font-size:10px}.show-item strong{color:#fff}.show-item span{color:#9da4b4}.show-item strong:after{content:" · ";color:#666d7d}.show-item:nth-child(2) strong:after{content:" · "}.show-item:nth-child(3) span{display:none}.show-item:nth-child(3) strong:after{content:""}
  .mobile-financial-summary{display:block;margin-top:2px;padding-top:3px;border-top:1px solid rgba(255,255,255,.06)}.financial-row{padding:8px 0}.financial-total{padding:11px 0 1px}.financial-total strong{font-size:19px}
  .trust-grid{display:block;margin-bottom:12px;padding:3px 14px;background:rgba(255,255,255,.02);border:1px solid rgba(255,255,255,.08);border-radius:12px}.trust-card{padding:12px 0;border:0!important;background:transparent!important;border-radius:0}.trust-card+.trust-card{border-top:1px solid rgba(255,255,255,.07)!important}.trust-icon{font-size:17px}.trust-card p{margin-top:3px;line-height:1.45}
  .terms-copy p{display:none}.mobile-terms-accept{display:flex;margin-top:0;padding:11px 0 0;border:0;border-top:1px solid rgba(255,255,255,.07);border-radius:0;background:transparent}.desktop-terms-accept{display:none}.terms-card{gap:10px;padding:14px;margin-bottom:10px;align-items:stretch;flex-direction:column}.terms-copy{align-items:center}.terms-icon{font-size:17px}.secondary-btn{width:100%;padding:10px 12px}
  .payment-head{margin:18px 0 9px}.payment-head h3,.payment-head p{display:none}.payment-head>span{font-size:11px}.payment-grid{grid-template-columns:1fr;gap:8px}.pay-btn{min-height:68px;padding:12px 14px}.pay-copy small{display:none}.pay-copy strong{font-size:11px}.pay-copy em{font-size:9px}.pay-symbol{font-size:20px}.payment-hint{margin-top:8px}
  .contract-modal{padding:18px}
}
</style>
