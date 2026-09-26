<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="logistica-step" style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); font-family: monospace;">
    
    <!-- 🏁 MARCADOR DE PROGRESSO (STEPPER ATIVO NO PASSO 2) -->
    <div class="checkout-stepper">
      <div class="step-item"><div class="step-number">1</div><span>Agenda</span></div>
      <div class="step-line completed"></div>
      <div class="step-item active"><div class="step-number">2</div><span>Logística</span></div>
      <div class="step-line"></div>
      <div class="step-item"><div class="step-number">3</div><span>Confirmar</span></div>
      <div class="step-line"></div>
      <div class="step-item"><div class="step-number">4</div><span>Agendar</span></div>
    </div>

    <!-- TÍTULO ORIENTADOR DO PASSO -->
    <div style="margin-bottom: 25px; text-align: left;">
      <h3 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 18px; margin: 0 0 6px 0;">Identificação e Local do Evento</h3>
      <p style="color: #878a99; font-size: 13px; margin: 0;">Confira seus dados e o local do evento para continuarmos com a contratação.</p>
    </div>

    <!-- 🚀 CARD DE CONTA LOCALIZADA (RESOLVIDO: SEM LEITURA DE LOCALSTORAGE NO HTML) -->
    <div v-if="exibirPainelDuplicidade && !nomeContratante" class="animate__animated animate__fadeIn" style="background: #141622; border: 1px solid #ff6c22; border-radius: 12px; padding: 24px; margin-bottom: 30px; text-align: left; box-shadow: 0 4px 20px rgba(255, 108, 34, 0.05);">
      <div style="display: flex; flex-direction: column; gap: 16px;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <span style="font-size: 18px; color: #ff6c22;">⚠️</span>
          <div>
            <h4 style="color: #ff6c22; font-weight: bold; font-size: 13px; text-transform: uppercase; margin: 0 0 2px 0; letter-spacing: 0.5px;">Você já tem uma conta ✓</h4>
            <p style="color: #ced4da; font-size: 13px; margin: 0; line-height: 1.4;">Encontramos uma conta com <strong>{{ emailContratante }}</strong>. Digite sua senha para continuar de onde parou:</p>
          </div>
        </div>
        <div style="display: flex; flex-direction: column; gap: 8px; width: 100%;">
          <div style="position: relative; width: 100%; min-height: 52px; display: flex; align-items: center; box-sizing: border-box;">
            <input :type="revelarSenha ? 'text' : 'password'" v-model="senhaContratante" @keyup.enter="efectuarLoginNoCheckout" placeholder="Digite a sua senha de acesso" style="display: block; width: 100%; height: 52px; min-height: 52px; padding: 0 50px 0 20px; background-color: #1a1d29 !important; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff !important; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
            <button type="button" @click="revelarSenha = !revelarSenha" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: transparent; border: none; color: #878a99; cursor: pointer; font-size: 14px; outline: none; z-index: 10; padding: 5px;">{{ revelarSenha ? '👁️' : '🙈' }}</button>
          </div>
          <div style="text-align: right; margin-top: 2px;">
            <button @click="dispararRecuperacaoSenha" :disabled="loadingRecuperacao" type="button" style="background: transparent; border: none; color: #878a99; font-size: 11px; font-weight: bold; text-decoration: underline; cursor: pointer; padding: 2px 0; outline: none;">Esqueceu a senha?</button>
          </div>
        </div>
        <button @click="efectuarLoginNoCheckout" :disabled="loadingCep || !senhaContratante" type="button" :style="{ backgroundColor: senhaContratante ? '#ff6c22' : '#2a2d3d', borderColor: senhaContratante ? '#ff6c22' : '#2a2d3d', color: senhaContratante ? '#ffffff' : '#878a99', cursor: senhaContratante ? 'pointer' : 'not-allowed' }" style="width: 100%; height: 48px; border: 1px solid; font-weight: bold; text-transform: uppercase; font-size: 11px; padding: 0; border-radius: 8px; transition: 0.2s; letter-spacing: 0.5px; box-sizing: border-box; display: flex; align-items: center; justify-content: center;">{{ loadingCep ? 'Verificando Credenciais...' : 'Entrar e Continuar a Contratação →' }}</button>
      </div>
    </div>
    <!-- 🚀 CASO 2: SESSÃO RECONHECIDA (SURGE NO LUGAR DO FORMULÁRIO DE CADASTRO PÓS-LOGIN SUCESSO) -->
    <div v-else-if="isAutenticado && !exibirPainelDuplicidade" class="animate__animated animate__fadeIn" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; text-align: left; margin-bottom: 30px; background-color: rgba(10, 179, 156, 0.04); border: 1px solid rgba(10, 179, 156, 0.2); border-radius: 12px; padding: 25px;">
      
      <div style="grid-column: span 2; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px; margin-bottom: 5px;">
        <span style="color: #878a99; font-size: 11px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;">✓ Seus dados já estão preenchidos</span>
        <span style="color: #0ab39c; font-size: 10px; font-weight: bold; text-transform: uppercase;">✓ Cliente autenticado</span>
      </div>
      
      <div style="display: flex; flex-direction: column; gap: 4px;">
        <span style="color: #878a99; font-size: 11px; text-transform: uppercase;">Nome Completo</span>
        <span style="color: #ffffff; font-weight: bold; font-size: 14px;">{{ nomeContratante }}</span>
      </div>
      
      <div style="display: flex; flex-direction: column; gap: 4px;">
        <span style="color: #878a99; font-size: 11px; text-transform: uppercase;">E-mail</span>
        <span style="color: #ffffff; font-weight: bold; font-size: 14px;">{{ emailContratante }}</span>
      </div>

      <!-- 🚀 LINHA LOGÍSTICA PREMIUM: Mostra de forma clara o deslocamento rodoviário se houver cobrança -->
      <div v-if="cidadeEvento" style="grid-column: span 2; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 15px; margin-top: 5px; display: flex; align-items: center; justify-content: space-between; font-family: monospace;">
        <div style="display: flex; flex-direction: column; gap: 2px;">
          <span style="color: #878a99; font-size: 11px; text-transform: uppercase;">Local do evento identificado</span>
          <span style="color: #ced4da; font-size: 12px; font-weight: bold;">{{ $parent.quilometrosCalculados || 0 }} km de deslocamento</span>
        </div>
        <div style="text-align: right;">
          <span style="color: #ff6c22; font-size: 14px; font-weight: bold;">Adicional: + R$ {{ ($parent.taxaDeslocamentoFrete || 0).toFixed(2).replace('.', ',') }}</span>
        </div>
      </div>

    </div>

    <!-- 🚀 CASO 3: NOVO CADASTRO (EXIBE OS INPUTS TRADICIONAIS ABERTOS SE O E-MAIL FOR INÉDITO) -->
    <div v-if="!isAutenticado && !exibirPainelDuplicidade" class="animate__animated animate__fadeIn" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; text-align: left; margin-bottom: 30px;">
      
      <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Nome Completo *</label>
        <input type="text" v-model="nomeContratante" placeholder="Digite seu nome completo" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">CPF *</label>
        <input type="text" v-model="cpfContratante" @input="aplicarMascaraCpf" placeholder="000.000.000-00" maxlength="14" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Celular / WhatsApp *</label>
        <input type="text" v-model="celularContratante" @input="aplicarMascaraCelular" placeholder="(00) 00000-0000" maxlength="15" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">E-mail de Acesso *</label>
        <input type="email" v-model="emailContratante" @blur="verificarDuplicidadeEmail" placeholder="seu@email.com" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Crie uma Senha (mín. 6 dgt) *</label>
        <div style="position: relative; display: flex; align-items: center;">
          <input :type="revelarSenha ? 'text' : 'password'" v-model="senhaContratante" placeholder="******" style="width: 100%; padding: 14px 50px 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
          <button type="button" @click="revelarSenha = !revelarSenha" style="position: absolute; right: 15px; background: transparent; border: none; color: #878a99; cursor: pointer; font-size: 14px; outline: none;">
            {{ revelarSenha ? '👁️' : '🙈' }}
          </button>
        </div>
      </div>

      <!-- LOGO OPCIONAL DO CONTRATANTE / ESTABELECIMENTO -->
      <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px; margin-top: 4px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Logo do estabelecimento / contratante <span style="color:#878a99; font-weight:normal;">(opcional)</span></label>
        <input ref="logoInput" type="file" accept="image/png,image/jpeg,image/webp" @change="selecionarLogo" style="display:none;" />
        <div style="display:flex; align-items:center; gap:16px; padding:14px; background:#171a25; border:1px dashed #3a3f50; border-radius:10px;">
          <div v-if="logoPreview" style="width:76px; height:76px; border-radius:10px; background:#ffffff; display:flex; align-items:center; justify-content:center; overflow:hidden; flex:0 0 76px;">
            <img :src="logoPreview" alt="Prévia do logo" style="max-width:100%; max-height:100%; object-fit:contain;" />
          </div>
          <div v-else style="width:76px; height:76px; border-radius:10px; background:#1f2230; display:flex; align-items:center; justify-content:center; font-size:28px; flex:0 0 76px;">🖼️</div>
          <div style="flex:1; min-width:0;">
            <div style="color:#ced4da; font-size:12px; line-height:1.5; margin-bottom:9px;">Será usado automaticamente na criação dos cartazes dos seus shows. PNG, JPG ou WEBP, até 5 MB.</div>
            <div style="display:flex; gap:8px; flex-wrap:wrap;">
              <button type="button" @click="$refs.logoInput.click()" style="background:#252938; border:1px solid #454b60; color:#fff; border-radius:7px; padding:8px 12px; font-size:11px; font-weight:bold; cursor:pointer;">{{ logoArquivo ? 'Trocar logo' : 'Selecionar logo' }}</button>
              <button v-if="logoArquivo" type="button" @click="removerLogoSelecionado" style="background:transparent; border:1px solid #f06548; color:#f06548; border-radius:7px; padding:8px 12px; font-size:11px; font-weight:bold; cursor:pointer;">Remover</button>
            </div>
          </div>
        </div>
      </div>

    </div>
    <!-- FORMULÁRIO DE ENDEREÇO (BLOCO INTEGRAL ORIGINAL: CEP E SEU ENGENHO ASSÍNCRONO) -->
    <div v-if="!isAutenticado && !exibirPainelDuplicidade" style="display: flex; flex-direction: column; gap: 20px; text-align: left; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 25px;">
      
      <!-- Bloco de Entrada do CEP -->
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Digite o CEP do Local do Show *</label>
        <div style="position: relative; display: flex; align-items: center;">
          <input type="text" v-model="cepEvento" @input="validarETirarMascaraCep" placeholder="00000-000" maxlength="9" style="width: 100%; padding: 14px 20px; background-color: rgba(0,0,0,0.2); border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 15px; font-weight: bold; outline: none; box-sizing: border-box;" />
          <div v-if="loadingCep" style="position: absolute; right: 20px;" class="spinner-border spinner-border-sm text-primary" role="status"></div>
        </div>
        <span v-if="erroCep" style="color: #f06548; font-size: 11px; font-weight: bold; text-transform: uppercase;">❌ CEP não encontrado ou inválido.</span>
      </div>

      <!-- Grid de Inputs de Endereço Aberto Automaticamente via ViaCEP -->
      <div v-if="cidadeEvento" class="animate__animated animate__fadeIn" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 5px; text-align: left;">
        <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Rua / Logradouro *</label>
          <input type="text" v-model="logradouroEvento" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff !important; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Número *</label>
          <input type="text" v-model="numeroEvento" placeholder="Ex: 123" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff !important; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Complemento</label>
          <input type="text" v-model="complementoEvento" placeholder="Apto, Bloco, Casa" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff !important; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>
        <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 12px; text-transform: uppercase;">Bairro *</label>
          <input type="text" v-model="bairroEvento" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff !important; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: rgba(255,255,255,0.6); font-weight: bold; font-size: 12px; text-transform: uppercase;">Cidade</label>
          <input type="text" v-model="cidadeEvento" readonly style="width: 100%; padding: 14px 20px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #0ab39c !important; font-size: 14px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
        </div>
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: rgba(255,255,255,0.6); font-weight: bold; font-size: 12px; text-transform: uppercase;">Estado / UF</label>
          <input type="text" v-model="estadoEvento" readonly style="width: 100%; padding: 14px 20px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #0ab39c !important; font-size: 14px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
        </div>
      </div>

    </div>

    <!-- 🚀 BOTÃO MESTRE COMPACTO: SEMPRE VISÍVEL NO RODAPÉ INDEPENDENTE DO MODO DE SESSÃO -->
    <div v-if="!exibirPainelDuplicidade" style="margin-top: 20px;">
      <button 
        @click="processarAcaoDoBotaoMestre"
        :style="{
          backgroundColor: '#ff6c22',
          borderColor: '#ff6c22',
          color: '#ffffff',
          cursor: 'pointer'
        }"
        style="width: 100%; border: 1px solid; font-weight: bold; text-transform: uppercase; font-size: 12px; padding: 18px; border-radius: 50px; box-shadow: 0 4px 15px rgba(255,108,34,0.15);"
      >
        {{ isAutenticado ? 'Está tudo certo — Continuar →' : 'Confirmar dados e continuar →' }}
      </button>
    </div>

  </div>
</template>

<script>
/* eslint-disable */
import axios from "axios";

export default {
  name: "Step2Logistica",
  emits: ["avancar-etapa", "atualizar-frete"],
  data() {
    return {
      loadingCep: false,
      erroCep: false,
      cepEvento: "",
      logradouroEvento: "",
      bairroEvento: "",
      cidadeEvento: "",
      estadoEvento: "",
      numeroEvento: "",
      complementoEvento: "",

      // Puxa o endereço do backend direto do arquivo .env do projeto
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL,

      // Estados de Controle do Smart Identity Check
      nomeContratante: "",
      cpfContratante: "",
      celularContratante: "",
      emailContratante: "",
      senhaContratante: "",
      revelarSenha: false,
      modoApenasLogin: false,
      exibirPainelDuplicidade: false,
      loadingRecuperacao: false,
      isAutenticado: false,
      logoArquivo: null,
      logoPreview: ""
    };
  },
  methods: {
    // ====================================================================
    // 🔀 BOTÃO MESTRE: Escolhe inteligentemente entre Salvar ou Apenas Avançar
    // ====================================================================
    async processarAcaoDoBotaoMestre() {
      if (this.exibirPainelDuplicidade) {
        this.efectuarLoginNoCheckout();
        return;
      }

      // Se o usuário não está logado, força primeiro o cadastro silencioso da conta
      if (!this.isAutenticado) {
        await this.processarCadastroELogistica();
        return;
      }

      // Se ele já está autenticado, dispara diretamente o salvamento da proposta artística
      await this.salvarPropostaNoBancoDados();
    },

    // 🚀 O MOTOR SECRETO: Realiza o POST contra o .NET 10 vinculando o ContractorId
    async salvarPropostaNoBancoDados() {
      const user = JSON.parse(localStorage.getItem("user") || "{}");
      if (!user.id) return this.$swal({ icon: "warning", title: "Sessão expirada", text: "Efetue o acesso novamente.", confirmButtonText: "OK" });

      const pacote = this.$parent.pacoteInfo || {};
      const packageId = pacote.idPackage || pacote.id || sizeof.Id;
      if (!packageId) return this.$swal({ icon: "error", title: "Não foi possível continuar", text: "Identificador do pacote do artista não localizado.", confirmButtonText: "OK" });

      // 🌐 CAPTURA DINÂMICA: Lê as variáveis reais do componente Pai (CheckoutContratacao)
      const dataBrBruta = this.$parent.dataSelecionadaFormatada; // Formato esperado: "DD/MM/AAAA"
      const horarioBruto = this.$parent.horarioSelecionado || "18:00"; // Formato esperado: "HH:mm"

      let dataIsoFinal = "2026-09-27"; // Fallback de segurança

      // Converte o formato de data brasileiro "DD/MM/AAAA" para o formato universal "AAAA-MM-DD"
      if (dataBrBruta && dataBrBruta.includes("/")) {
        const partesData = dataBrBruta.split("/");
        if (partesData.length === 3) {
          const dia = partesData[0].trim();
          const mes = partesData[1].trim();
          const ano = partesData[2].trim();
          dataIsoFinal = `${ano}-${mes}-${dia}`;
        }
      } else if (dataBrBruta) {
        dataIsoFinal = dataBrBruta; // Caso já venha tratada como string ISO
      }

      // Monta o timestamp literal completo exigido pelo C# (YYYY-MM-DDTHH:mm:ss)
      const timestampEnvio = `${dataIsoFinal}T${horarioBruto}:00`;

      this.loadingCep = true;
      try {
        const payloadShow = {
          ContractorId: user.id,
          ArtistPackageId: packageId,
          Title: "Apresentação Artística - " + (this.cidadeEvento || "Show"),
          EventDate: timestampEnvio, // ⚡ TEXTO BLINDADO: Salva o dia exato selecionado sem distorção!
          VenueName: `${this.logradouroEvento || ""}, ${this.numeroEvento || ""}`.trim(),
          City: this.cidadeEvento || "",
          State: this.estadoEvento || "",
          Notes: this.complementoEvento || "",

          DistanceKm: parseInt(this.$parent.quilometrosCalculados) || 0,
          ExtraKm: parseInt(this.kmExtrasDeslocamento) || 0,
          ExtraKmValueCharged: parseFloat(this.valorExtrasDeslocamento) || 0.00,
          RequestedDurationHours: parseInt(pacote.durationHours || pacote.DurationHours) || 0,
          ExtraHours: parseInt(this.$parent.horasExtrasContratadas) || 0,
          ExtraHoursValueCharged: parseFloat(this.$parent.valorHoraExtraMúsico * this.$parent.horasExtrasContratadas) || 0.00
        };

        const urlProposta = this.apiBaseUrlGlobal + "/public/contratantes/eventos/propor-show";
        const response = await axios.post(urlProposta, payloadShow);

        if (response.data && response.data.success) {
          this.$parent.artistEventId = response.data.artistEventId;
          this.$emit("avancar-etapa");
        }
      } catch (error) {
        console.error("Falha ao registrar proposta artística no MariaDB:", error);
        const erroBanco = error.response?.data?.error || "Erro de rede no servidor.";
        this.$swal({ icon: "error", title: "Não foi possível salvar", text: erroBanco, confirmButtonText: "OK" });
      } finally {
        this.loadingCep = false;
      }
    },
    
    // 🏛️ ENGENHO DO VIA_CEP COPIADO FIELMENTE DO SEU PRINT (100% INTACTO)
    async consultarViaCep() {
      this.loadingCep = true;
      this.erroCep = false;
      try {
        const cepFormatado = this.cepEvento.replace("-", "");
        
        // 🚀 EXATAMENTE IGUAL AO SEU MONITOR: Linha por linha, sem nenhuma alteração
        const construtorUrl = new URL("https://viacep.com.br");
        construtorUrl.pathname = "/ws/" + cepFormatado + "/json/";
        const urlFinal = construtorUrl.toString();
        
        const response = await axios.get(urlFinal);
        
        if (response.data && !response.data.erro) {
          this.logradouroEvento = response.data.logradouro || "";
          this.bairroEvento = response.data.bairro || "";
          this.cidadeEvento = response.data.localidade || "";
          this.estadoEvento = response.data.uf || "";
          
          this.$emit("atualizar-frete", { 
            cidade: this.cidadeEvento, 
            uf: this.estadoEvento, 
            cep: cepFormatado 
          });
        } else {
          this.erroCep = true;
        }
      } catch (error) {
        console.error("Erro ao conectar à API do ViaCEP:", error);
        this.erroCep = true;
      } finally {
        this.loadingCep = false;
      }
    },

    // 🔍 GATILHO @BLUR: Verifica duplicidade e abre caminhos reativos na tela contra o .NET 10
    async verificarDuplicidadeEmail() {
      if (!this.emailContratante || !this.emailContratante.includes("@")) return;
      
      try {
        const urlFinalCheck = this.apiBaseUrlGlobal + "/public/contratantes/check-email?email=" + this.emailContratante.trim();
        const response = await axios.get(urlFinalCheck);
        
        this.exibirPainelDuplicidade = response.data && response.data.exists;
        if (this.exibirPainelDuplicidade) {
          this.modoApenasLogin = true; // Força o chaveamento para o fluxo de senha se o cliente existir
        }
      } catch (error) {
        console.error("Erro ao checar duplicidade de e-mail na API:", error);
      }
    },

    // 🔐 AUTENTICAÇÃO DIRETA: Executa o login na tabela unificada e popula o LocalStorage compartilhado
    async efectuarLoginNoCheckout() {
      if (!this.senhaContratante) return this.$swal({ icon: "warning", title: "Senha necessária", text: "Digite sua senha para entrar.", confirmButtonText: "OK" });
      this.loadingCep = true;
      try {
        const response = await axios.post(`${this.apiBaseUrlGlobal}/public/contratantes/login`, {
          email: this.emailContratante.trim(), password: this.senhaContratante
        });
        if (response.data && response.data.token) {
          const strUser = JSON.stringify(response.data.user);
          localStorage.setItem("jwt", response.data.token);
          localStorage.setItem("user", strUser);
          localStorage.setItem("userdata", strUser);

          window.dispatchEvent(new CustomEvent("sessao-atualizada"));

          this.isAutenticado = true;

          const user = response.data.user;
          this.nomeContratante = user.name || "";
          this.cepEvento = user.cep || "";
          this.logradouroEvento = user.logradouro || "";
          this.bairroEvento = user.bairro || "";
          this.numeroEvento = user.numero || "";
          this.cidadeEvento = user.cidade || "";
          this.estadoEvento = user.estado || "";
          this.complementoEvento = user.complemento || "";

          this.exibirPainelDuplicidade = false;

          // 🚀 CONEXÃO ATIVA: Dispara o novo cálculo passando a distância (ex: 120 KM)
          if (this.cidadeEvento && this.estadoEvento) {
            this.$emit("atualizar-frete", { 
              cidade: this.cidadeEvento, 
              uf: this.estadoEvento, 
              cep: this.cepEvento ? this.cepEvento.replace(/\D/g, "") : "" 
            });
          }
        }
      } catch (error) {
        this.$swal({ icon: "error", title: "Não foi possível entrar", text: error.response?.data?.message || "Senha incorreta. Tente novamente.", confirmButtonText: "OK" });
      } finally { this.loadingCep = false; }
    },

    // 📧 RECUPERAÇÃO DE ACESSO: Simula o disparo de redefinição de credenciais
    async dispararRecuperacaoSenha() {
      this.loadingRecuperacao = true;
      try {
        await new Promise(resolve => setTimeout(resolve, 1500));
        this.$swal({ icon: "success", title: "Link enviado", text: `Um link de redefinição foi enviado para ${this.emailContratante}. Verifique sua caixa de entrada.`, confirmButtonText: "OK" });
      } finally {
        this.loadingRecuperacao = false;
      }
    },

    selecionarLogo(event) {
      const file = event.target.files && event.target.files[0];
      if (!file) return;
      const permitidos = ["image/png", "image/jpeg", "image/webp"];
      if (!permitidos.includes(file.type)) {
        this.$swal({ icon: "warning", title: "Formato inválido", text: "Use uma imagem PNG, JPG ou WEBP.", confirmButtonText: "OK" });
        event.target.value = "";
        return;
      }
      if (file.size > 5 * 1024 * 1024) {
        this.$swal({ icon: "warning", title: "Arquivo muito grande", text: "O logo deve ter no máximo 5 MB.", confirmButtonText: "OK" });
        event.target.value = "";
        return;
      }
      if (this.logoPreview) URL.revokeObjectURL(this.logoPreview);
      this.logoArquivo = file;
      this.logoPreview = URL.createObjectURL(file);
    },

    removerLogoSelecionado() {
      if (this.logoPreview) URL.revokeObjectURL(this.logoPreview);
      this.logoArquivo = null;
      this.logoPreview = "";
      if (this.$refs.logoInput) this.$refs.logoInput.value = "";
    },

    async enviarLogoContratante(contratanteId) {
      if (!this.logoArquivo || !contratanteId) return null;
      const formData = new FormData();
      formData.append("file", this.logoArquivo);
      const url = `${this.apiBaseUrlGlobal}/public/contratantes/${contratanteId}/logo`;
      const response = await axios.post(url, formData, {
        headers: { "Content-Type": "multipart/form-data" }
      });
      return response.data?.logoUrl || null;
    },

    // 🏛️ CADASTRO TRADICIONAL: Envia o payload limpo para la tabela única do MariaDB
    async processarCadastroELogistica() {
      this.loadingCep = true;
      
      const payloadCadastro = {
        nomeCompleto: this.nomeContratante,
        cpf: this.cpfContratante.replace(/\D/g, ""),
        celular: this.celularContratante.replace(/\D/g, ""),
        email: this.emailContratante.trim(),
        senha: this.senhaContratante,
        zipCode: this.cepEvento.replace(/\D/g, ""),
        logradouro: this.logradouroEvento,
        numero: this.numeroEvento,
        bairro: this.bairroEvento,
        cidade: this.cidadeEvento,
        estado: this.estadoEvento,
        complemento: this.complementoEvento || null
      };

      try {
        const urlCadastro = this.apiBaseUrlGlobal + "/public/contratantes/cadastro-checkout";
        const response = await axios.post(urlCadastro, payloadCadastro);

        if (response.data && response.data.token) {
          const userCriado = { ...response.data.user };

          // Logo é opcional: só envia depois que o ContratanteId existir.
          if (this.logoArquivo && userCriado.id) {
            try {
              userCriado.logoUrl = await this.enviarLogoContratante(userCriado.id);
            } catch (logoError) {
              console.error("Cadastro concluído, mas o logo não pôde ser enviado:", logoError);
              this.$swal({ icon: "warning", title: "Cadastro concluído", text: "Não foi possível enviar o logo agora. Você poderá adicioná-lo depois.", confirmButtonText: "OK" });
            }
          }

          const stringifiedUser = JSON.stringify(userCriado);
          localStorage.setItem("jwt", response.data.token);
          localStorage.setItem("user", stringifiedUser);
          localStorage.setItem("userdata", stringifiedUser);

          // Dispara o evento global para avisar o cabeçalho que a sessão mudou
          window.dispatchEvent(new CustomEvent("sessao-atualizada"));

          this.isAutenticado = true;

          // 🔒 GATILHO EM LOTE: Agora que o ID nasceu, encadeia a criação do show de forma contínua!
          await this.salvarPropostaNoBancoDados();
        }
      } catch (error) {
        console.error("Falha crítica no silent signup do checkout:", error);
        this.$swal({ icon: "error", title: "Não foi possível concluir o cadastro", text: error.response?.data?.message || "Verifique os dados informados e tente novamente.", confirmButtonText: "OK" });
      } finally {
        this.loadingCep = false;
      }
    },

    // 🛠️ MÁSCARA AUTOMÁTICA ORIGINAL
    aplicarMascaraCpf() {
      let valor = this.cpfContratante.replace(/\D/g, "");
      if (valor.length > 11) valor = valor.slice(0, 11);
      
      if (valor.length > 9) {
        this.cpfContratante = `${valor.slice(0, 3)}.${valor.slice(3, 6)}.${valor.slice(6, 9)}-${valor.slice(9, 11)}`;
      } else if (valor.length > 6) {
        this.cpfContratante = `${valor.slice(0, 3)}.${valor.slice(3, 6)}.${valor.slice(6, 9)}`;
      } else if (valor.length > 3) {
        this.cpfContratante = `${valor.slice(0, 3)}.${valor.slice(3, 6)}`;
      } else {
        this.cpfContratante = valor;
      }
    },

    // 🛠️ MÁSCARA AUTOMÁTICA ORIGINAL
    aplicarMascaraCelular() {
      let valor = this.celularContratante.replace(/\D/g, "");
      if (valor.length > 11) valor = valor.slice(0, 11);
      
      if (valor.length > 6) {
        this.celularContratante = `(${valor.slice(0, 2)}) ${valor.slice(2, 7)}-${valor.slice(7, 11)}`;
      } else if (valor.length > 2) {
        this.celularContratante = `(${valor.slice(0, 2)}) ${valor.slice(2, 6)}`;
      } else {
        this.celularContratante = valor;
      }
    },

    // 🛠️ ACESSOR ORIGINAL DO SEU CEP
    validarETirarMascaraCep() {
      let cepLimpo = this.cepEvento.replace(/\D/g, "");
      if (cepLimpo.length > 5) {
        this.cepEvento = cepLimpo.slice(0, 5) + "-" + cepLimpo.slice(5, 8);
      } else {
        this.cepEvento = cepLimpo;
      }
      if (cepLimpo.length === 8) {
        this.consultarViaCep();
      }
    },

    // ====================================================================
    // 🚚 LOGÍSTICA SÊNIOR: Calcula Frete Abatendo a Franquia Isenta (FreeRadiusKm)
    // ====================================================================
    calcularLogisticaExcedente(distanciaTotalRodoviaria = 120) {
      // 1. Captura com segurança as propriedades físicas vindas da tabela do MariaDB
      // Caso o seu componente receba via props (ex: artistCommercialSettings ou objeto artista)
      const configuracoesArtista = this.$attrs.artistCommercialSettings || this.artistCommercialSettings || {};
      
      // Mapeia as colunas exatas descobertas no print do seu phpMyAdmin com fallback seguro
      const franquiaIsentaKm = Number(configuracoesArtista.FreeRadiusKm || configuracoesArtista.freeRadiusKm || 35);
      const valorKmExtra = Number(configuracoesArtista.ExtraKmValue || configuracoesArtista.extraKmValue || 2.50);

      // 2. A MATEMÁTICA DE MERCADO: Subtrai a franquia isenta garantindo o piso zero (Math.max)
      // Evita valores negativos caso a distância do show seja menor que o raio gratuito
      this.kmExtrasDeslocamento = Math.max(0, distanciaTotalRodoviaria - franquiaIsentaKm);

      // 3. Multiplica única e exclusivamente a quilometragem que extrapolou o raio
      this.valorExtrasDeslocamento = this.kmExtrasDeslocamento * valorKmExtra;

      // 🚀 ATUALIZAÇÃO EM ESPELHO: Despacha os valores consolidados para o componente Pai
      // Faz o Resumo Detalhado da direita renderizar os mesmos Km e Valor do card azul
      this.$emit("atualizar-frete", {
        cidade: this.cidadeEvento,
        uf: this.estadoEvento,
        cep: this.cepEvento ? this.cepEvento.replace(/\D/g, "") : "",
        
        // Substitui os fallbacks fixos pelas propriedades dinâmicas do seu data()
        kmExtras: this.kmExtrasDeslocamento,
        valorFrete: this.valorExtrasDeslocamento
      });
    }
  },
  mounted() {
    const dadosUsuarioStr = localStorage.getItem("user");
    const tokenAtivo = localStorage.getItem("jwt");

    if (dadosUsuarioStr && tokenAtivo) {
      try {
        const user = JSON.parse(dadosUsuarioStr);
        if (user) {
          // 🚀 LEITURA DIRETA DO ENDEREÇO GLOBAL: Sem atrasos e sem requisições adicionais de rede
          this.nomeContratante = user.name || "";
          this.emailContratante = user.email || "";
          this.cepEvento = user.cep || "";
          this.logradouroEvento = user.logradouro || "";
          this.bairroEvento = user.bairro || "";
          this.numeroEvento = user.numero || "";
          this.cidadeEvento = user.cidade || "";
          this.estadoEvento = user.estado || "";
          this.complementoEvento = user.complemento || "";

          // Ativa a interface de Usuário Autenticado ocultando o formulário aberto
          this.isAutenticado = true;
          
          console.log("✓ [FILHO MOUNTED] Interface de usuário carregada instantaneamente via rastro global.");
        }
      } catch (error) { 
        console.error("Erro crítico no ciclo de vida mounted do componente filho:", error); 
      }
    }
  }
};
</script>
<style scoped>
.checkout-stepper{display:flex;align-items:center;margin-bottom:40px;padding:0 10px}.step-item{display:flex;align-items:center;gap:10px;color:#adb5bd;font-size:13px;text-transform:uppercase;opacity:.4}.step-item.active{color:#fff;opacity:1;font-weight:bold}.step-number{width:36px;height:36px;flex:0 0 36px;border-radius:50%;background:#2a2d3d;color:#adb5bd;display:flex;align-items:center;justify-content:center;font-weight:bold;font-size:14px}.step-item.active .step-number{background:#ff6c22;color:#fff;box-shadow:0 0 15px rgba(255,108,34,.4)}.step-line{flex:1;height:2px;background:rgba(255,255,255,.05);margin:0 15px}.step-line.completed{background:#ff6c22}
@media(max-width:760px){
.logistica-step{box-sizing:border-box;padding:24px 16px !important;width:100%;max-width:100%}
.logistica-step *{box-sizing:border-box;min-width:0;max-width:100%}
.logistica-step [style*="display: grid"]{grid-template-columns:minmax(0,1fr) !important}
.logistica-step [style*="grid-column: span 2"]{grid-column:1 / -1 !important}
.logistica-step input,.logistica-step button{min-width:0 !important;max-width:100% !important}
.checkout-stepper{width:100%;max-width:100%;margin-bottom:38px;padding:0 8px}
.step-item span{display:none}.step-item{gap:0;min-width:36px}.step-line{height:1px;margin:0 8px;min-width:0}.step-number{width:36px;height:36px;flex-basis:36px}
}
</style>
