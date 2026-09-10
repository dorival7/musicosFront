<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); font-family: monospace; text-align: left;">
    
    <!-- 🛒 LAYOUT PRINCIPAL DE COBRANÇA: Visível apenas enquanto o show não foi pago -->
    <div v-if="!pagoSucesso">
      <!-- TÍTULO -->
      <div style="margin-bottom: 30px;">
        <h3 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 18px; margin: 0 0 6px 0;">Finalizar Pagamento</h3>
        <p style="color: #878a99; font-size: 13px; margin: 0;">Quite o cachê de forma protegida via Pix ou Cartão.</p>
      </div>

      <!-- MODO PIX DINÂMICO -->
      <div v-if="metodoAtivo === 'pix'" style="background-color: rgba(255,255,255,0.02); border: 1px dashed rgba(255,255,255,0.1); border-radius: 12px; padding: 35px; text-align: center;">
        <div v-if="pixCarregando">
          <p style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 12px;">🔒 Gerando QR Code com Split...</p>
        </div>
        <div v-else-if="pixQrCodeBase64">
          <img :src="'data:image/png;base64,' + pixQrCodeBase64" alt="Pix QR Code" style="width: 180px; height: 180px; border: 4px solid #fff; border-radius: 8px; margin-bottom: 15px;" />
          <input type="text" readonly :value="pixCopiaECola" style="width: 100%; padding: 12px; background: #1a1d29; border: 1px solid #3a3f50; border-radius: 6px; color: #fff; text-align: center; margin-bottom: 15px; font-weight: bold; font-size: 11px;" />
          <button type="button" @click="copiarPix" style="background: #0ab39c; color: #fff; font-weight: bold; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; text-transform: uppercase; font-size: 11px;">📋 Copiar Código</button>
        </div>
        <div v-else>
          <button type="button" @click="gerarPix" style="background: #ff6c22; color: #fff; font-weight: bold; padding: 12px 30px; border: none; border-radius: 20px; cursor: pointer; text-transform: uppercase; font-size: 12px;">⚡ Emitir QR Code Pix</button>
        </div>
      </div>

      <!-- MODO CARTÃO DE CRÉDITO -->
      <div v-else style="display: flex; flex-direction: column; gap: 15px;">
        <input type="text" v-model="cartaoNumero" @input="maskCard" placeholder="Número do Cartão" maxlength="19" style="width: 100%; height: 40px; padding: 0 10px; background: #1a1d29; border: 1px solid #3a3f50; color: #fff; border-radius: 6px;" />
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <input type="text" v-model="cartaoValidade" @input="maskVal" placeholder="MM/AA" maxlength="5" style="height: 40px; padding: 0 10px; background: #1a1d29; border: 1px solid #3a3f50; color: #fff; border-radius: 6px;" />
          <input type="text" v-model="cartaoCvc" placeholder="CVC" maxlength="4" style="height: 40px; padding: 0 10px; background: #1a1d29; border: 1px solid #3a3f50; color: #fff; border-radius: 6px;" />
        </div>
        <button type="button" @click="pagarCartao" :disabled="loadingPagamento" style="background: #0ab39c; color: #fff; font-weight: bold; padding: 14px; border: none; border-radius: 20px; cursor: pointer; text-transform: uppercase; font-size: 12px;">
          {{ loadingPagamento ? '🔒 Analisando Antifraude...' : '🔒 Efetuar Pagamento' }}
        </button>
      </div>
    </div>

    <!-- 🎉 TELA DE SUCESSO REAL: Renderiza automaticamente na liquidação do Webhook -->
    <div v-else style="text-align: center; padding: 40px 20px;">
      <div style="margin-bottom: 25px;">
        <span style="display: inline-flex; align-items: center; justify-content: center; width: 80px; height: 80px; background-color: rgba(10, 179, 156, 0.1); border-radius: 50%; color: #0ab39c; font-size: 48px;">✓</span>
      </div>
      <h3 style="color: #0ab39c; font-weight: bold; text-transform: uppercase; font-size: 20px; margin: 0 0 10px 0;">¡Pagamento Confirmado!</h3>
      <p style="color: #878a99; font-size: 14px; line-height: 1.6; max-width: 380px; margin: 0 auto 30px auto;">
        O cachê foi retido em custódia com sucesso absoluto e a proposta foi encaminhada para a agenda oficial do artista.
      </p>
      <button type="button" @click="$router.push('/dashboard')" style="background: #299cdb; color: #fff; font-weight: bold; padding: 12px 35px; border: none; border-radius: 20px; cursor: pointer; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px;">
        Ir para o meu Painel
      </button>
    </div>

  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Step4Pagamento",
  props: { metodoPreSelecionado: { type: String, default: "pix" } },
  data() { 
    return { 
      metodoAtivo: "pix", 
      cartaoNumero: "", 
      cartaoValidade: "", 
      cartaoCvc: "", 
      loadingPagamento: false,
      pixQrCodeBase64: "", 
      pixCopiaECola: "", 
      pixCarregando: false,
      holderNome: "", 
      holderCpf: "", 
      holderTelefone: "", 
      holderCep: "", 
      holderEmail: "",
      pagoSucesso: false,
      pollingStatusId: null
    }; 
  },
  beforeUnmount() {
    // 🛡️ SEGURANÇA DE MEMÓRIA: Destrói o relógio imediatamente se o usuário sair da tela
    if (this.pollingStatusId) {
      clearInterval(this.pollingStatusId);
    }
  },
  watch: {
    metodoPreSelecionado: { immediate: true, handler(v) { if (v) this.metodoAtivo = v; } }
  },
  mounted() {
    this.carregarDadosSessao();
  },
  methods: {
    carregarDadosSessao() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      this.holderNome = user.name || "";
      this.holderEmail = user.email || "";
      this.holderCep = user.cep || "";
      this.holderCpf = user.cpf || user.cpfContratante || "";
      this.holderTelefone = user.celular || user.celularContratante || "";
    },
    async gerarPix() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!user.id || !this.$parent.artistEventId) return alert("Identificadores ausentes.");
      
      this.pixCarregando = true;
      try {
        const res = await axios.post(this.$parent.apiBaseUrlGlobal + "/public/pagamentos/gerar-pix", {
          artistEventId: this.$parent.artistEventId,
          contratanteId: user.id
        });
        
        if (res.data?.success) {
          const apiDetails = JSON.parse(res.data.pixDetails);
          this.pixQrCodeBase64 = apiDetails.encodedImage;
          this.pixCopiaECola = apiDetails.payload;
          this.iniciarPollingPagamento();
        }
      } catch (e) {
        alert("Erro ao emitir QR Code do Pix.");
      } finally { this.pixCarregando = false; } // 🚀 CORREÇÃO CIRÚRGICA: finally legítimo do JavaScript
    },
    copiarPix() {
      if (!this.pixCopiaECola) return;
      navigator.clipboard.writeText(this.pixCopiaECola);
      alert("📋 Código Pix copiado para a área de transferência!");
    },
    async pagarCartao() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!this.cartaoNumero || !this.cartaoValidade || !this.cartaoCvc) return;
      
      this.loadingPagamento = true;
      const [mes, ano] = this.cartaoValidade.split("/");
      try {
        const res = await axios.post(this.$parent.apiBaseUrlGlobal + "/public/pagamentos/processar-cartao", {
          ArtistEventId: this.$parent.artistEventId,
          ContratanteId: user.id,
          CartaoNumero: this.cartaoNumero.replace(/\s+/g, ""),
          CartaoValidadeMes: mes,
          CartaoValidadeAno: "20" + ano,
          CartaoCvc: this.cartaoCvc,
          HolderInfo: { 
            name: this.holderNome, 
            cpfCnpj: this.holderCpf.replace(/\D/g, ""), 
            email: this.holderEmail, 
            phone: this.holderTelefone.replace(/\D/g, ""), 
            postalCode: this.holderCep.replace(/\D/g, "") 
          }
        });
        if (res.data?.success) {
          this.pagoSucesso = true;
        }
      } catch (e) {
        alert("Transação recusada pela análise antifraude.");
      } finally { this.loadingPagamento = false; } // 🚀 CORREÇÃO CIRÚRGICA: finally legítimo do JavaScript
    },
    maskCard() {
      let v = this.cartaoNumero.replace(/\D/g, "").replace(/(\d{4})(?=\d)/g, "$1 ");
      this.cartaoNumero = v;
    },
    maskVal() {
      let v = this.cartaoValidade.replace(/\D/g, "");
      if (v.length > 2) v = v.substring(0, 2) + "/" + v.substring(2, 4);
      this.cartaoValidade = v;
    },
    // ====================================================================
    // 🔍 MOTOR REATIVO: Monitora a mudança de status na nova coluna do banco
    // ====================================================================
    iniciarPollingPagamento() {
      const showId = this.$parent.artistEventId;
      if (!showId) return;

      if (this.pollingStatusId) clearInterval(this.pollingStatusId);

      this.pollingStatusId = setInterval(async () => {
        try {
          const url = `${this.$parent.apiBaseUrlGlobal}/public/pagamentos/status-pagamento/${showId}`;
          const res = await axios.get(url);

          if (res.data?.success && res.data.isPaid) {
            // 🚀 SUCESSO ABSOLUTO: Desliga o timer de rede e chaveia a interface
            clearInterval(this.pollingStatusId);
            this.pollingStatusId = null;
            this.pagoSucesso = true;
          }
        } catch (error) {
          console.error("Erro na pulsação de monitoramento:", error);
        }
      }, 4000);
    },
  }
};
</script>

