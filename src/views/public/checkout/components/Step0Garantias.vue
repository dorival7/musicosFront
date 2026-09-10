<!-- 🛡️ COMPONENTE FILHO ISOLADO: MANIFESTO DE CONFIANÇA SEVENSHOWS -->
<template>
  <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); font-family: monospace;">
    
    <!-- EMBLEMA DE AMBIENTE SEGURO -->
    <div style="margin-bottom: 30px; text-align: left;">
      <span style="background-color: rgba(255, 108, 34, 0.12); color: #ff6c22; font-size: 13px; font-weight: bold; padding: 10px 22px; border-radius: 50px; text-transform: uppercase; display: inline-block; margin-bottom: 18px; letter-spacing: 0.8px; border: 1px solid rgba(255, 108, 34, 0.15);">
        🔒 AMBIENTE 100% SEGURO
      </span>
      <h2 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 22px; margin: 0 0 10px 0; letter-spacing: -0.5px; line-height: 1.3;">
        Você está a poucos passos de garantir {{ nomeAtracao }} no seu evento!
      </h2>
      <p style="color: #878a99; font-size: 15px; margin: 0 0 5px 0; line-height: 1.5;">
        Leia atentamente as garantias comerciais da nossa plataforma antes de reservar a sua data.
      </p>
    </div>

    <div style="border-top: 1px solid rgba(255,255,255,0.05); margin: 25px 0;"></div>

    <!-- LISTA DE GARANTIAS HUMANIZADAS -->
    <div style="display: flex; gap: 28px; flex-direction: column; text-align: left;">
      
      <!-- PILAR 1: DINHEIRO PROTEGIDO -->
      <div style="display: flex; gap: 20px; align-items: start;">
        <div style="background-color: rgba(255, 108, 34, 0.1); border-radius: 8px; width: 54px; height: 54px; min-width: 54px; display: flex; align-items: center; justify-content: center;">
          <span style="font-size: 24px;">🛡️</span>
        </div>
        <div>
          <h5 style="color: #ffffff; font-weight: bold; font-size: 16px; text-transform: uppercase; margin: 0 0 6px 0; letter-spacing: -0.3px;">Seu dinheiro fica protegido com a gente</h5>
          <p style="color: #a3a3a3; font-size: 14px; line-height: 1.6; margin: 0;">
            O valor do cachê não vai direto para o músico. A plataforma segura o pagamento e <strong>o artista só recebe após a realização do show e quando você liberar o pagamento no painel</strong>. É garantia total, sem riscos.
          </p>
        </div>
      </div>

      <!-- PILAR 2: CONFIRMAÇÃO DO ARTISTA -->
      <div style="display: flex; gap: 20px; align-items: start;">
        <div style="background-color: rgba(255, 108, 34, 0.1); border-radius: 8px; width: 54px; height: 54px; min-width: 54px; display: flex; align-items: center; justify-content: center;">
          <span style="font-size: 24px;">⏰</span>
        </div>
        <div>
          <h5 style="color: #ffffff; font-weight: bold; font-size: 16px; text-transform: uppercase; margin: 0 0 6px 0; letter-spacing: -0.3px;">O artista tem até 48 horas para confirmar</h5>
          <p style="color: #a3a3a3; font-size: 14px; line-height: 1.6; margin: 0;">
            Assim que você fizer a reserva, a banda é avisada imediatamente no WhatsApp. O músico tem um prazo de até 2 dias para conferir a logística e dar o sinal verde oficial para a viagem e a apresentação.
          </p>
        </div>
      </div>

      <!-- PILAR 3: DEVOLUÇÃO INTEGRAL -->
      <div style="display: flex; gap: 20px; align-items: start;">
        <div style="background-color: rgba(255, 108, 34, 0.1); border-radius: 8px; width: 54px; height: 54px; min-width: 54px; display: flex; align-items: center; justify-content: center;">
          <span style="font-size: 24px;">💰</span>
        </div>
        <div>
          <h5 style="color: #ffffff; font-weight: bold; font-size: 16px; text-transform: uppercase; margin: 0 0 6px 0; letter-spacing: -0.3px;">Devolução garantida sem burocracia</h5>
          <p style="color: #a3a3a3; font-size: 14px; line-height: 1.6; margin: 0;">
            Se por qualquer imprevisto ou motivo de agenda o músico não puder aceitar o seu convite, o pedido é cancelado e <strong>todo o seu dinheiro é devolvido na hora</strong>, direto na sua conta Pix ou cartão, sem taxas ou enrolação.
          </p>
        </div>
      </div>

    </div>

    <div style="border-top: 1px solid rgba(255,255,255,0.05); margin: 25px 0;"></div>

    <!-- DISPARA EVENTO PARA O PAI ALTERAR O PASSO -->
    <button @click="$emit('prosseguir')" style="background-color: #ff6c22; border: 1px solid #ff6c22; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 13px; padding: 16px; border-radius: 50px; width: 100%; cursor: pointer; box-shadow: 0 4px 15px rgba(255,108,34,0.3); transition: all 0.2s ease;">
      Li as garantias e quero escolher a data →
    </button>

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
