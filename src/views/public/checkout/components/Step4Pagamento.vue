<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="payment-shell">
    <div v-if="!pagoSucesso">
      <div class="payment-header">
        <div class="payment-kicker">🔒 PAGAMENTO PROTEGIDO</div>
        <h3>Finalizar pagamento</h3>
        <p>Conclua o agendamento com segurança. O valor fica protegido pela Seven Shows até a realização do show.</p>
      </div>

      <div v-if="metodoAtivo === 'pix'" class="payment-panel pix-panel">
        <div v-if="pixCarregando" class="payment-loading">
          <div class="loader-ring"></div>
          <strong>Gerando seu Pix com segurança...</strong>
          <span>Aguarde alguns segundos. Não feche esta página.</span>
        </div>

        <div v-else-if="pixQrCodeBase64" class="pix-ready">
          <div class="status-pill">✓ PIX GERADO COM SUCESSO</div>
          <h4>Escaneie o QR Code para pagar</h4>
          <p class="pix-help">Abra o aplicativo do seu banco, escolha <strong>Pix → Pagar com QR Code</strong> e aponte a câmera.</p>

          <div class="qr-frame">
            <img :src="'data:image/png;base64,' + pixQrCodeBase64" alt="QR Code para pagamento via Pix" />
          </div>

          <div class="divider"><span>OU USE O PIX COPIA E COLA</span></div>

          <div class="copy-box">
            <input type="text" readonly :value="pixCopiaECola" aria-label="Código Pix copia e cola" />
            <button type="button" @click="copiarPix">📋 COPIAR CÓDIGO PIX</button>
          </div>

          <div class="waiting-note">
            <span class="pulse-dot"></span>
            <div>
              <strong>Aguardando confirmação do pagamento</strong>
              <small>Assim que o Pix for identificado, esta tela será atualizada automaticamente.</small>
            </div>
          </div>
        </div>

        <div v-else class="pix-start">
          <div class="pix-start-card">
            <div class="method-icon">⚡</div>
            <div class="pix-start-copy">
              <span class="pix-label">PAGAMENTO VIA PIX</span>
              <h4>Pague com Pix</h4>
              <p>Pagamento rápido, seguro e com confirmação automática. Gere o QR Code para concluir seu agendamento.</p>
            </div>
            <div class="pix-benefits">
              <span>✓ Confirmação automática</span>
              <span>✓ Pagamento protegido</span>
              <span>✓ Liberação após o show</span>
            </div>
            <button type="button" @click="gerarPix">GERAR QR CODE PIX →</button>
            <small>🔒 Você será direcionado para a etapa de pagamento seguro via Pix.</small>
          </div>
        </div>
      </div>

      <div v-else class="payment-panel card-panel">
        <div class="card-intro">
          <div class="method-icon">▣</div>
          <div><h4>Pagamento com cartão</h4><p>Preencha os dados do cartão para concluir o agendamento.</p></div>
        </div>
        <div class="holder-summary" v-if="!titularOutro">
          <div class="holder-summary-copy">
            <span class="holder-check">✓</span>
            <div>
              <strong>O cartão está em meu nome</strong>
              <small v-if="holderNome">Titular: {{ holderNome }}</small>
            </div>
          </div>
          <button type="button" class="holder-switch" @click="usarOutroTitular"><span class="holder-switch-icon">👤</span> Trocar titular</button>
        </div>

        <div v-else class="holder-fields">
          <div class="holder-fields-head">
            <div>
              <strong>Dados do titular do cartão</strong>
              <small>Preencha com os dados da pessoa cujo nome está no cartão.</small>
            </div>
            <button type="button" class="holder-switch" @click="usarMeusDados"><span class="holder-switch-icon">↩</span> Usar meus dados</button>
          </div>
          <div class="holder-grid">
            <div class="holder-full"><label>NOME DO TITULAR</label><input type="text" v-model="holderNome" placeholder="Nome completo" autocomplete="cc-name" /></div>
            <div><label>CPF / CNPJ</label><input type="text" v-model="holderCpf" placeholder="CPF ou CNPJ" inputmode="numeric" /></div>
            <div><label>E-MAIL</label><input type="email" v-model="holderEmail" placeholder="email@exemplo.com" /></div>
            <div><label>TELEFONE</label><input type="text" v-model="holderTelefone" placeholder="(00) 00000-0000" inputmode="tel" /></div>
            <div>
              <label>CEP</label>
              <input type="text" v-model="holderCep" @input="maskCep" @blur="buscarCepTitular" placeholder="00000-000" maxlength="9" inputmode="numeric" />
              <small v-if="buscandoCep" class="cep-status">Buscando endereço...</small>
              <small v-else-if="erroCep" class="cep-status cep-error">{{ erroCep }}</small>
            </div>
            <div class="holder-full"><label>LOGRADOURO</label><input type="text" v-model="holderLogradouro" placeholder="Rua / Avenida" /></div>
            <div><label>NÚMERO</label><input type="text" v-model="holderNumero" placeholder="Número" /></div>
            <div><label>COMPLEMENTO</label><input type="text" v-model="holderComplemento" placeholder="Apto, bloco, casa... (opcional)" /></div>
            <div><label>BAIRRO</label><input type="text" v-model="holderBairro" placeholder="Bairro" /></div>
            <div><label>CIDADE</label><input type="text" v-model="holderCidade" placeholder="Cidade" /></div>
            <div><label>UF</label><input type="text" v-model="holderUf" placeholder="UF" maxlength="2" /></div>
          </div>
        </div>

        <label>NÚMERO DO CARTÃO</label>
        <input type="text" v-model="cartaoNumero" @input="maskCard" placeholder="0000 0000 0000 0000" maxlength="19" />
        <div class="card-grid">
          <div><label>VALIDADE</label><input type="text" v-model="cartaoValidade" @input="maskVal" placeholder="MM/AA" maxlength="5" /></div>
          <div><label>CÓDIGO DE SEGURANÇA</label><input type="text" v-model="cartaoCvc" placeholder="CVC" maxlength="4" /></div>
        </div>
        <button class="pay-card-button" type="button" @click="pagarCartao" :disabled="loadingPagamento">
          {{ loadingPagamento ? '🔒 ANALISANDO PAGAMENTO...' : '🔒 PAGAR COM SEGURANÇA →' }}
        </button>
        <div class="secure-caption">Seus dados são enviados de forma protegida para o processamento do pagamento.</div>
      </div>
    </div>

    <div v-else class="success-state">
      <div class="success-hero">
        <span class="success-icon">✓</span>
        <div class="status-pill">PAGAMENTO CONFIRMADO</div>
        <h3>Agendamento realizado!</h3>
        <p>Seu pagamento foi confirmado com segurança. Agora a solicitação segue para a agenda do artista.</p>
      </div>

      <div class="success-steps" aria-label="Próximos passos do agendamento">
        <div class="success-step is-done">
          <span class="success-step-icon">✓</span>
          <div><strong>Pagamento confirmado</strong><small>A cobrança foi processada com sucesso.</small></div>
        </div>
        <div class="success-step is-done">
          <span class="success-step-icon">🔒</span>
          <div><strong>Valor protegido</strong><small>O cachê permanece protegido pela Seven Shows.</small></div>
        </div>
        <div class="success-step">
          <span class="success-step-icon">♫</span>
          <div><strong>Solicitação enviada ao artista</strong><small>Acompanhe o andamento e os próximos passos pelo seu painel.</small></div>
        </div>
      </div>

      <div class="success-actions">
        <button type="button" @click="$router.push('/contratante/dashboard')">IR PARA O MEU PAINEL →</button>
        <small>Você poderá acompanhar este agendamento na área do contratante.</small>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";

export default {
  name: "Step4Pagamento",
  props: { metodoPreSelecionado: { type: String, default: "pix" } },
  data() { 
    return { 
      metodoAtivo: "pix", cartaoNumero: "", cartaoValidade: "", cartaoCvc: "", loadingPagamento: false,
      pixQrCodeBase64: "", pixCopiaECola: "", pixCarregando: false, holderNome: "", holderCpf: "", holderTelefone: "",
      holderCep: "", holderEmail: "", holderLogradouro: "", holderNumero: "", holderComplemento: "", holderBairro: "", holderCidade: "", holderUf: "", buscandoCep: false, erroCep: "", titularOutro: false, dadosTitularContratante: null, pagoSucesso: false, pollingStatusId: null
    }; 
  },
  beforeUnmount() { if (this.pollingStatusId) clearInterval(this.pollingStatusId); },
  watch: { metodoPreSelecionado: { immediate: true, handler(v) { if (v) this.metodoAtivo = v; } } },
  mounted() { this.carregarDadosSessao(); },
  methods: {
    carregarDadosSessao() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      this.holderNome = user.name || ""; this.holderEmail = user.email || ""; this.holderCep = user.cep || "";
      this.holderCpf = user.cpf || user.cpfContratante || ""; this.holderTelefone = user.celular || user.celularContratante || "";
      this.dadosTitularContratante = { nome: this.holderNome, email: this.holderEmail, cep: this.holderCep, cpf: this.holderCpf, telefone: this.holderTelefone };
    },
    usarOutroTitular() {
      this.titularOutro = true;
      this.holderNome = ""; this.holderCpf = ""; this.holderTelefone = ""; this.holderCep = ""; this.holderEmail = "";
      this.holderLogradouro = ""; this.holderNumero = ""; this.holderComplemento = ""; this.holderBairro = ""; this.holderCidade = ""; this.holderUf = ""; this.erroCep = "";
    },
    usarMeusDados() {
      const d = this.dadosTitularContratante || {};
      this.holderNome = d.nome || ""; this.holderCpf = d.cpf || ""; this.holderTelefone = d.telefone || ""; this.holderCep = d.cep || ""; this.holderEmail = d.email || "";
      this.holderLogradouro = ""; this.holderNumero = ""; this.holderComplemento = ""; this.holderBairro = ""; this.holderCidade = ""; this.holderUf = ""; this.erroCep = "";
      this.titularOutro = false;
    },
    maskCep() {
      const digits = this.holderCep.replace(/\D/g, "").slice(0, 8);
      this.holderCep = digits.length > 5 ? digits.slice(0, 5) + "-" + digits.slice(5) : digits;
      this.erroCep = "";
      if (digits.length < 8) {
        this.holderLogradouro = ""; this.holderBairro = ""; this.holderCidade = ""; this.holderUf = "";
      }
    },
    async buscarCepTitular() {
      if (!this.titularOutro) return;
      const cep = this.holderCep.replace(/\D/g, "");
      if (cep.length !== 8) { this.erroCep = "Informe um CEP válido com 8 dígitos."; return; }
      this.buscandoCep = true; this.erroCep = "";
      try {
        const { data } = await axios.get(`https://viacep.com.br/ws/${cep}/json/`);
        if (data?.erro) throw new Error("CEP não encontrado");
        this.holderLogradouro = data.logradouro || "";
        this.holderBairro = data.bairro || "";
        this.holderCidade = data.localidade || "";
        this.holderUf = data.uf || "";
      } catch (e) {
        this.erroCep = "CEP não encontrado. Confira o CEP ou preencha o endereço manualmente.";
        this.holderLogradouro = ""; this.holderBairro = ""; this.holderCidade = ""; this.holderUf = "";
      } finally { this.buscandoCep = false; }
    },
    async gerarPix() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!user.id || !this.$parent.artistEventId) {
        return Swal.fire({ icon: "warning", title: "Não foi possível continuar", text: "Os dados do agendamento não foram encontrados. Atualize a página e tente novamente.", confirmButtonText: "OK" });
      }
      this.pixCarregando = true;
      try {
        const res = await axios.post(this.$parent.apiBaseUrlGlobal + "/public/pagamentos/gerar-pix", { artistEventId: this.$parent.artistEventId, contratanteId: user.id });
        if (res.data?.success) { const apiDetails = JSON.parse(res.data.pixDetails); this.pixQrCodeBase64 = apiDetails.encodedImage; this.pixCopiaECola = apiDetails.payload; this.iniciarPollingPagamento(); }
      } catch (e) {
        Swal.fire({ icon: "error", title: "Não foi possível gerar o Pix", text: "Tente novamente em alguns instantes.", confirmButtonText: "OK" });
      }
      finally { this.pixCarregando = false; }
    },
    async copiarPix() {
      if (!this.pixCopiaECola) return;
      try {
        await navigator.clipboard.writeText(this.pixCopiaECola);
        Swal.fire({ icon: "success", title: "Pix copiado!", text: "O código Pix foi copiado para a área de transferência.", timer: 1800, showConfirmButton: false });
      } catch (e) {
        Swal.fire({ icon: "error", title: "Não foi possível copiar", text: "Selecione o código Pix e copie manualmente.", confirmButtonText: "OK" });
      }
    },
    async pagarCartao() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      const numeroCartao = this.cartaoNumero.replace(/\D/g, "");
      const validadeOk = /^(0[1-9]|1[0-2])\/\d{2}$/.test(this.cartaoValidade);
      const cvcOk = /^\d{3,4}$/.test(this.cartaoCvc);
      if (numeroCartao.length < 13 || !validadeOk || !cvcOk) {
        return Swal.fire({ icon: "warning", title: "Confira os dados do cartão", text: "Preencha corretamente o número do cartão, a validade (MM/AA) e o código de segurança (CVC).", confirmButtonText: "OK" });
      }
      if (!this.holderNome || !this.holderCpf || !this.holderEmail || !this.holderTelefone || !this.holderCep) {
        return Swal.fire({ icon: "warning", title: "Dados do titular incompletos", text: "Confira os dados do titular do cartão antes de continuar.", confirmButtonText: "OK" });
      }
      if (this.titularOutro && (!this.holderLogradouro || !this.holderNumero || !this.holderBairro || !this.holderCidade || !this.holderUf)) {
        return Swal.fire({ icon: "warning", title: "Endereço incompleto", text: "Confira o endereço completo do titular do cartão antes de continuar.", confirmButtonText: "OK" });
      }
      this.loadingPagamento = true; const [mes, ano] = this.cartaoValidade.split("/");
      try {
        const res = await axios.post(this.$parent.apiBaseUrlGlobal + "/public/pagamentos/processar-cartao", {
          ArtistEventId: this.$parent.artistEventId, ContratanteId: user.id, CartaoNumero: this.cartaoNumero.replace(/\s+/g, ""), CartaoValidadeMes: mes,
          CartaoValidadeAno: "20" + ano, CartaoCvc: this.cartaoCvc,
          HolderInfo: { name: this.holderNome, cpfCnpj: this.holderCpf.replace(/\D/g, ""), email: this.holderEmail, phone: this.holderTelefone.replace(/\D/g, ""), postalCode: this.holderCep.replace(/\D/g, ""), addressNumber: this.titularOutro ? this.holderNumero : "", street: this.titularOutro ? this.holderLogradouro : "", neighborhood: this.titularOutro ? this.holderBairro : "", city: this.titularOutro ? this.holderCidade : "", state: this.titularOutro ? this.holderUf : "", complement: this.titularOutro ? this.holderComplemento : "" }
        });
        if (res.data?.success) this.pagoSucesso = true;
      } catch (e) {
        const mensagemApi = e?.response?.data?.message || e?.response?.data?.mensagem;
        Swal.fire({ icon: "error", title: "Pagamento não aprovado", text: mensagemApi || "Não foi possível concluir o pagamento com este cartão. Confira os dados ou tente outro cartão.", confirmButtonText: "OK" });
      }
      finally { this.loadingPagamento = false; }
    },
    maskCard() { this.cartaoNumero = this.cartaoNumero.replace(/\D/g, "").replace(/(\d{4})(?=\d)/g, "$1 "); },
    maskVal() { let v = this.cartaoValidade.replace(/\D/g, ""); if (v.length > 2) v = v.substring(0, 2) + "/" + v.substring(2, 4); this.cartaoValidade = v; },
    iniciarPollingPagamento() {
      const showId = this.$parent.artistEventId; if (!showId) return; if (this.pollingStatusId) clearInterval(this.pollingStatusId);
      this.pollingStatusId = setInterval(async () => {
        try {
          const url = `${this.$parent.apiBaseUrlGlobal}/public/pagamentos/status-pagamento/${showId}`; const res = await axios.get(url);
          if (res.data?.success && res.data.isPaid) { clearInterval(this.pollingStatusId); this.pollingStatusId = null; this.pagoSucesso = true; }
        } catch (error) { console.error("Erro na pulsação de monitoramento:", error); }
      }, 4000);
    },
  }
};
</script>

<style scoped>
.payment-shell{background:#131520;border:1px solid rgba(255,255,255,.07);border-radius:16px;padding:40px;box-shadow:0 12px 35px rgba(0,0,0,.35);font-family:monospace;text-align:left;color:#fff}.payment-header{margin-bottom:26px}.payment-kicker{font-size:10px;color:#00c9b2;font-weight:800;letter-spacing:.8px;margin-bottom:9px}.payment-header h3{font-family:Arial,sans-serif;text-transform:uppercase;font-size:21px;margin:0 0 8px}.payment-header p{color:#b0b5c4;font-size:13px;line-height:1.55;margin:0;max-width:610px}.payment-panel{background:#0f111a;border:1px solid #292d3b;border-radius:14px;padding:30px}.pix-start{text-align:center;max-width:520px;margin:auto}.method-icon{width:46px;height:46px;border-radius:12px;background:rgba(255,108,34,.12);color:#ff6c22;display:flex;align-items:center;justify-content:center;font-size:22px;margin:0 auto 14px}.pix-start h4,.pix-ready h4,.card-intro h4{font-family:Arial,sans-serif;font-size:17px;margin:0 0 8px}.pix-start p,.pix-help,.card-intro p{color:#a8adbc;line-height:1.55;font-size:12px;margin:0 auto 20px}.pix-start button,.success-state button{background:#ff6c22;color:#fff;border:0;border-radius:24px;padding:14px 28px;font-weight:800;font-family:monospace;cursor:pointer;box-shadow:0 8px 22px rgba(255,108,34,.18)}.pix-start small{display:block;color:#73798a;margin-top:14px;font-size:10px}.payment-loading{text-align:center;padding:38px 10px}.payment-loading strong,.payment-loading span{display:block}.payment-loading strong{margin-top:14px;font-size:13px}.payment-loading span{color:#8e94a4;font-size:11px;margin-top:7px}.loader-ring{width:38px;height:38px;border:3px solid #2a2e3c;border-top-color:#ff6c22;border-radius:50%;margin:auto;animation:spin .8s linear infinite}@keyframes spin{to{transform:rotate(360deg)}}.pix-ready{text-align:center}.status-pill{display:inline-block;border:1px solid rgba(0,201,178,.35);background:rgba(0,201,178,.08);color:#00c9b2;border-radius:20px;padding:7px 12px;font-size:10px;font-weight:800;margin-bottom:14px}.pix-help{max-width:540px;margin-bottom:18px}.qr-frame{display:inline-flex;background:#fff;border-radius:12px;padding:10px;box-shadow:0 10px 30px rgba(0,0,0,.3)}.qr-frame img{width:190px;height:190px;display:block}.divider{display:flex;align-items:center;gap:12px;margin:24px 0 14px;color:#707687;font-size:9px}.divider:before,.divider:after{content:"";height:1px;background:#292d3b;flex:1}.copy-box{display:grid;grid-template-columns:1fr auto;gap:10px}.copy-box input,.card-panel input{background:#181b27;border:1px solid #353a4b;border-radius:8px;color:#fff;outline:none}.copy-box input{padding:13px;font-size:10px;min-width:0}.copy-box button{background:#00ad99;color:#fff;border:0;border-radius:8px;padding:0 18px;font-family:monospace;font-weight:800;font-size:10px;cursor:pointer}.waiting-note{display:flex;align-items:center;justify-content:center;gap:10px;margin-top:20px;padding:13px;border-radius:9px;background:rgba(0,201,178,.05);border:1px solid rgba(0,201,178,.16);text-align:left}.waiting-note strong,.waiting-note small{display:block}.waiting-note strong{font-size:10px;color:#dce1eb}.waiting-note small{font-size:9px;color:#7f8798;margin-top:3px}.pulse-dot{width:8px;height:8px;border-radius:50%;background:#00c9b2;box-shadow:0 0 0 0 rgba(0,201,178,.5);animation:pulse 1.5s infinite}@keyframes pulse{70%{box-shadow:0 0 0 8px rgba(0,201,178,0)}}.card-intro{display:flex;align-items:center;gap:14px;margin-bottom:22px}.card-intro .method-icon{margin:0;flex:none}.card-intro p{margin:0}.card-panel label{display:block;color:#c8cbd5;font-size:10px;font-weight:800;margin:0 0 7px}.card-panel>input,.card-grid input{width:100%;height:48px;padding:0 13px;box-sizing:border-box;font-family:monospace;margin-bottom:16px}.card-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}.pay-card-button{width:100%;background:#ff6c22;color:#fff;border:0;border-radius:24px;padding:15px;font-family:monospace;font-weight:800;cursor:pointer;margin-top:5px}.pay-card-button:disabled{opacity:.55;cursor:not-allowed}.secure-caption{text-align:center;color:#9ca3b4;font-size:10px;margin-top:12px}.holder-summary{display:flex;align-items:center;justify-content:space-between;gap:18px;padding:15px 16px;margin-bottom:20px;border:1px solid rgba(0,201,178,.24);background:rgba(0,201,178,.055);border-radius:10px}.holder-summary-copy{display:flex;align-items:center;gap:10px}.holder-check{display:flex;align-items:center;justify-content:center;width:26px;height:26px;border-radius:50%;background:rgba(0,201,178,.13);color:#00c9b2;font-weight:900}.holder-summary strong,.holder-fields-head strong{display:block;color:#f4f6fa;font-size:11px}.holder-summary small,.holder-fields-head small{display:block;color:#aeb5c3;font-size:9px;margin-top:4px;line-height:1.45}.holder-switch{display:inline-flex;align-items:center;justify-content:center;gap:7px;flex:none;border:1px solid rgba(255,108,34,.48);background:rgba(255,108,34,.08);color:#ff9a68;font-family:monospace;font-size:9px;font-weight:900;text-transform:uppercase;cursor:pointer;padding:9px 13px;border-radius:8px;transition:background .18s ease,border-color .18s ease,color .18s ease,transform .18s ease}.holder-switch:hover{color:#fff;background:rgba(255,108,34,.18);border-color:#ff6c22;transform:translateY(-1px)}.holder-switch-icon{font-size:11px;line-height:1}.holder-fields{padding:18px;margin-bottom:20px;border:1px solid #34394a;background:#151823;border-radius:11px}.holder-fields-head{display:flex;justify-content:space-between;align-items:flex-start;gap:16px;margin-bottom:17px}.holder-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px 14px}.holder-grid .holder-full{grid-column:1/-1}.holder-grid input{margin-bottom:0!important}.holder-fields label{color:#d6dae3}.holder-fields input{height:44px!important}.cep-status{display:block;margin-top:6px;color:#9ca3b4;font-size:9px}.cep-error{color:#ff8b72}.success-state{text-align:center;padding:30px 15px}.success-icon{display:flex;width:76px;height:76px;align-items:center;justify-content:center;margin:0 auto 18px;border-radius:50%;background:rgba(0,201,178,.1);border:1px solid rgba(0,201,178,.3);color:#00c9b2;font-size:42px}.success-state h3{font-family:Arial,sans-serif;font-size:22px;text-transform:uppercase;margin:2px 0 10px}.success-state>p{color:#aeb3c2;line-height:1.65;font-size:13px;max-width:560px;margin:0 auto 20px}.success-info{display:inline-block;color:#00c9b2;background:rgba(0,201,178,.06);border:1px solid rgba(0,201,178,.15);border-radius:8px;padding:11px 16px;font-size:10px;margin-bottom:22px}.success-state button{display:block;margin:auto}.pix-start{max-width:590px}.pix-start-card{border:1px solid rgba(255,108,34,.22);background:linear-gradient(180deg,rgba(255,108,34,.065),rgba(255,255,255,.018));border-radius:16px;padding:30px 32px 26px;box-shadow:inset 0 1px 0 rgba(255,255,255,.025)}.pix-start-card .method-icon{width:54px;height:54px;font-size:25px;box-shadow:0 0 24px rgba(255,108,34,.12)}.pix-label{display:block;color:#ff8a50;font-size:9px;font-weight:900;letter-spacing:1px;margin-bottom:7px}.pix-start h4{color:#fff;font-size:20px;margin-bottom:9px}.pix-start p{color:#d1d5df;font-size:12px;line-height:1.65;max-width:470px;margin-bottom:18px}.pix-benefits{display:flex;justify-content:center;flex-wrap:wrap;gap:8px 16px;margin:0 0 22px;color:#bfc5d2;font-size:9px;font-weight:700}.pix-benefits span{white-space:nowrap}.pix-start button{font-size:11px;padding:15px 30px}.pix-start small{color:#9ba2b2;font-size:9px;line-height:1.5}.pix-ready h4{color:#fff;font-size:19px;margin-top:1px}.pix-help{color:#cbd0dc;font-size:12px;line-height:1.65}.pix-help strong{color:#fff}.divider{color:#9ba2b2;font-weight:700;letter-spacing:.25px}.copy-box input{color:#f4f5f8;background:#151823;border-color:#3b4153}.copy-box button{background:#00bda7}.waiting-note{background:rgba(0,201,178,.075);border-color:rgba(0,201,178,.28)}.waiting-note strong{font-size:11px;color:#f0f3f7}.waiting-note small{font-size:9px;color:#aeb5c3;line-height:1.5}.payment-loading span{color:#aeb5c3}.payment-header h3{color:#fff}.payment-header p{color:#c5cad5}
.success-state{max-width:650px;margin:0 auto;text-align:center;padding:38px 12px 34px}.success-hero{max-width:560px;margin:0 auto}.success-icon{width:82px;height:82px;margin-bottom:16px;font-size:44px;box-shadow:0 0 32px rgba(0,201,178,.08)}.success-state .status-pill{margin-bottom:15px}.success-state h3{color:#fff;font-size:24px;letter-spacing:.2px;margin:0 0 10px}.success-state> .success-hero>p{color:#c3c8d3;line-height:1.65;font-size:12px;max-width:510px;margin:0 auto}.success-steps{max-width:570px;margin:28px auto 24px;text-align:left;border:1px solid #292e3d;background:#0f1119;border-radius:14px;padding:5px 18px}.success-step{display:flex;align-items:center;gap:13px;padding:15px 4px;border-bottom:1px solid rgba(255,255,255,.055)}.success-step:last-child{border-bottom:0}.success-step-icon{width:34px;height:34px;display:flex;align-items:center;justify-content:center;flex:none;border-radius:50%;border:1px solid rgba(0,201,178,.25);background:rgba(0,201,178,.075);color:#00c9b2;font-size:15px;font-weight:900}.success-step strong,.success-step small{display:block}.success-step strong{color:#f5f7fa;font-size:11px;margin-bottom:4px}.success-step small{color:#949bab;font-size:9px;line-height:1.45}.success-step.is-done strong{color:#dffbf7}.success-actions{display:flex;flex-direction:column;align-items:center}.success-actions button{min-width:250px;font-size:11px;padding:15px 30px}.success-actions small{color:#7f8797;font-size:9px;margin-top:10px}.success-info{display:none}
@media(max-width:700px){.success-state{padding:28px 0 24px}.success-state h3{font-size:21px}.success-steps{padding:4px 13px;margin-top:23px}.success-step{align-items:flex-start}.success-actions button{width:100%;min-width:0}.holder-summary,.holder-fields-head{flex-direction:column;align-items:flex-start}.holder-grid{grid-template-columns:1fr}.holder-grid .holder-full{grid-column:auto}.pix-start-card{padding:24px 18px}.pix-benefits{display:grid;gap:7px}.payment-shell{padding:24px 18px}.payment-panel{padding:22px 16px}.copy-box{grid-template-columns:1fr}.copy-box button{padding:13px}.card-grid{grid-template-columns:1fr}.qr-frame img{width:170px;height:170px}}
</style>
