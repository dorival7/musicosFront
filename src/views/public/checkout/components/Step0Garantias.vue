<!-- 🛡️ COMPONENTE FILHO ISOLADO: MANIFESTO DE CONFIANÇA SEVEN SHOWS -->
<template>
  <div class="guarantees-card">
    <div class="guarantees-head">
      <span class="security-badge">🔒 AMBIENTE 100% SEGURO</span>
      <h2>Você está a poucos passos de garantir {{ nomeAtracao }} no seu evento!</h2>
      <p>Antes de escolher a data, veja como a Seven Shows protege sua contratação do início ao fim.</p>
    </div>

    <div class="guarantees-divider"></div>

    <div class="guarantees-list">
      <div class="guarantee-item">
        <div class="guarantee-icon">🛡️</div>
        <div>
          <span class="guarantee-kicker">PAGAMENTO PROTEGIDO</span>
          <h5>Seu cachê fica protegido até o show</h5>
          <p>
            O valor não vai direto para o músico. Ele permanece protegido na plataforma e
            <strong>o artista só recebe após a realização do show e a sua liberação no painel.</strong>
          </p>
        </div>
      </div>

      <div class="guarantee-item">
        <div class="guarantee-icon">⏰</div>
        <div>
          <span class="guarantee-kicker">CONFIRMAÇÃO DA DATA</span>
          <h5>Sua solicitação é confirmada pelo artista em até 6 horas</h5>
          <p>
            Após a reserva, a banda é avisada imediatamente para conferir agenda e logística.
            O artista tem até 6 horas para confirmar oficialmente a apresentação.
          </p>
        </div>
      </div>

      <div class="guarantee-item">
        <div class="guarantee-icon">💰</div>
        <div>
          <span class="guarantee-kicker">RESERVA SEM RISCO</span>
          <h5>Se o artista não puder aceitar, o valor é devolvido</h5>
          <p>
            Se houver indisponibilidade ou algum impedimento para o artista aceitar a data,
            o pedido é cancelado e <strong>o valor pago é devolvido pelo meio de pagamento utilizado.</strong>
          </p>
        </div>
      </div>
    </div>

    <div class="guarantees-divider"></div>

    <button class="continue-button" @click="$emit('prosseguir')">
      Li as garantias e quero escolher a data →
    </button>
    <p class="continue-note">✓ Nesta etapa você apenas avança para escolher a data do evento.</p>
  </div>
</template>

<script>
export default {
  name: "Step0Garantias",
  props: {
    nomeAtracao: { type: String, default: "o artista" }
  },
  emits: ["prosseguir"]
};
</script>

<style scoped>
.guarantees-card {
  background: linear-gradient(145deg, #141722 0%, #11131d 100%);
  border: 1px solid rgba(255,255,255,.07);
  border-radius: 18px;
  padding: 40px;
  box-shadow: 0 18px 45px rgba(0,0,0,.34);
  font-family: monospace;
}
.guarantees-head { text-align: left; }
.security-badge {
  display: inline-flex; align-items: center; gap: 7px;
  margin-bottom: 20px; padding: 10px 20px; border-radius: 50px;
  color: #ff7a35; background: rgba(255,108,34,.11);
  border: 1px solid rgba(255,108,34,.3); font-size: 13px;
  font-weight: 800; letter-spacing: .8px;
}
.guarantees-head h2 {
  color: #fff; font-size: 24px; line-height: 1.3; font-weight: 800;
  text-transform: uppercase; letter-spacing: -.6px; margin: 0 0 12px;
}
.guarantees-head p { color: #b3b7c3; font-size: 15px; line-height: 1.65; margin: 0; max-width: 760px; }
.guarantees-divider { height: 1px; background: rgba(255,255,255,.07); margin: 28px 0; }
.guarantees-list { display: flex; flex-direction: column; gap: 18px; }
.guarantee-item {
  display: flex; gap: 18px; align-items: flex-start; padding: 18px;
  border: 1px solid rgba(255,255,255,.055); border-radius: 12px;
  background: rgba(255,255,255,.018);
}
.guarantee-icon {
  width: 54px; height: 54px; min-width: 54px; display: flex;
  align-items: center; justify-content: center; border-radius: 10px;
  background: rgba(255,108,34,.11); border: 1px solid rgba(255,108,34,.13);
  font-size: 24px;
}
.guarantee-kicker { display: block; color: #ff7a35; font-size: 11px; font-weight: 800; letter-spacing: .9px; margin-bottom: 5px; }
.guarantee-item h5 { color: #fff; font-size: 17px; line-height: 1.35; font-weight: 800; margin: 0 0 7px; }
.guarantee-item p { color: #b7bac4; font-size: 14px; line-height: 1.65; margin: 0; }
.guarantee-item strong { color: #e8e9ed; }
.continue-button {
  width: 100%; padding: 17px 20px; border: 1px solid #ff6c22; border-radius: 50px;
  background: #ff6c22; color: #fff; cursor: pointer; font-family: monospace;
  font-size: 13px; font-weight: 800; text-transform: uppercase;
  box-shadow: 0 7px 22px rgba(255,108,34,.24); transition: .2s ease;
}
.continue-button:hover { transform: translateY(-1px); box-shadow: 0 10px 28px rgba(255,108,34,.34); }
.continue-note { margin: 11px 0 0; text-align: center; color: #8f94a2; font-size: 11px; line-height: 1.45; }
@media (max-width: 700px) {
  .guarantees-card { padding: 26px 20px; }
  .guarantees-head h2 { font-size: 20px; }
  .guarantee-item { padding: 15px; gap: 13px; }
  .guarantee-icon { width: 46px; height: 46px; min-width: 46px; }
}
</style>
