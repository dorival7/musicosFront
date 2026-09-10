<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="animate__animated animate__fadeIn" style="text-align: left;">
    
    <!-- 🎛️ TOPO DO FORMULÁRIO -->
    <div style="margin-bottom: 25px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.05);">
      <h5 style="color: #ffffff; font-weight: bold; font-size: 15px; margin: 0; text-transform: uppercase; letter-spacing: 0.5px;">
        👤 Meus Dados Cadastrais &amp; Endereço
      </h5>
    </div>

    <!-- 📋 FORMULÁRIO OPERACIONAL EM GRID -->
    <form @submit.prevent="processarAtualizacaoCadastral" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; font-family: monospace;">
      
      <!-- Linhas de Dados Pessoais Fixo -->
      <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Nome Completo *</label>
        <input type="text" v-model="form.nomeCompleto" placeholder="Seu nome completo" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">CPF (Bloqueado) 🔒</label>
        <input type="text" v-model="form.cpf" readonly style="width: 100%; padding: 14px 20px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #878a99; font-size: 13px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
      </div>

      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Celular / WhatsApp *</label>
        <input type="text" v-model="form.celular" @input="aplicarMascaraCelular" placeholder="(00) 00000-0000" maxlength="15" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <!-- Divisória de Seção Postal -->
      <div style="grid-column: span 2; margin: 10px 0 5px 0; border-top: 1px dashed rgba(255,255,255,0.05); padding-top: 15px;">
        <span style="color: #ff6c22; font-size: 11px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px;">🏡 Rastro Global de Endereço</span>
      </div>

      <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Digite o CEP Residencial *</label>
        <div style="position: relative; display: flex; align-items: center;">
          <input type="text" v-model="form.zipCode" @input="validarETirarMascaraCep" placeholder="00000-000" maxlength="9" style="width: 100%; padding: 14px 20px; background-color: rgba(0,0,0,0.2); border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
          <div v-if="loadingCep" style="position: absolute; right: 20px;" class="spinner-border spinner-border-sm text-primary" role="status"></div>
        </div>
        <span v-if="erroCep" style="color: #f06548; font-size: 11px; font-weight: bold; text-transform: uppercase;">❌ CEP não localizado.</span>
      </div>

      <!-- Malha Hidratada via ViaCEP -->
      <div style="grid-column: span 2; display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
        <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Rua / Logradouro *</label>
          <input type="text" v-model="form.logradouro" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>

        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Número *</label>
          <input type="text" v-model="form.numero" placeholder="Ex: 123" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>

        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Complemento</label>
          <input type="text" v-model="form.complemento" placeholder="Apto, Bloco" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>

        <div style="grid-column: span 2; display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Bairro *</label>
          <input type="text" v-model="form.bairro" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>

        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: rgba(255,255,255,0.4); font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Cidade (Readonly)</label>
          <input type="text" v-model="form.cidade" readonly style="width: 100%; padding: 14px 20px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #0ab39c; font-size: 13px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
        </div>

        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: rgba(255,255,255,0.4); font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Estado / UF (Readonly)</label>
          <input type="text" v-model="form.estado" readonly style="width: 100%; padding: 14px 20px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #0ab39c; font-size: 13px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
        </div>
      </div>

      <!-- Botão de Postagem de Sucesso -->
      <div style="grid-column: span 2; margin-top: 15px; text-align: right;">
        <button type="submit" :disabled="loadingSalvar || loadingCep" :style="{ backgroundColor: (loadingSalvar || loadingCep) ? '#2a2d3d' : '#ff6c22', borderColor: (loadingSalvar || loadingCep) ? '#2a2d3d' : '#ff6c22', cursor: (loadingSalvar || loadingCep) ? 'not-allowed' : 'pointer' }" style="padding: 15px 35px; border: 1px solid; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 11px; border-radius: 50px; box-shadow: 0 4px 15px rgba(255,108,34,0.15); transition: 0.2s; letter-spacing: 0.5px;">
          {{ loadingSalvar ? 'Salvando Dados...' : 'Salvar Alterações e Atualizar Endereço →' }}
        </button>
      </div>

    </form>
  </div>
</template>
<script>
/* eslint-disable */
import axios from "axios";

export default {
  name: "MeuPerfilForm",
  props: {
    // Recebe os dados de sessão injetados diretamente pela Fonte da Verdade do Pai
    usuario: {
      type: Object,
      required: true,
      default: () => ({})
    }
  },
  emits: ["atualizar-sessao"],
  data() {
    return {
      loadingCep: false,
      loadingSalvar: false,
      erroCep: false,
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL,
      
      // Modelo de dados do formulário preenchido na inicialização
      form: {
        nomeCompleto: "",
        cpf: "",
        celular: "",
        zipCode: "",
        logradouro: "",
        numero: "",
        bairro: "",
        cidade: "",
        estado: "",
        complemento: ""
      }
    };
  },
  methods: {
    // 🚀 ENVIO ATÔMICO: Dispara o PUT contra o .NET 10 e atualiza as tabelas do MariaDB
    async processarAtualizacaoCadastral() {
      if (this.loadingSalvar || this.loadingCep) return;
      this.loadingSalvar = true;

      try {
        const urlPut = `${this.apiBaseUrlGlobal}/public/contratantes/atualizar-perfil/${this.usuario.id}`;
        const response = await axios.put(urlPut, this.form);

        if (response.data && response.data.success) {
          // 🔥 GATILHO DE REIDRATAÇÃO: Avisa o Pai para regravar o localStorage global com o novo endereço
          this.$emit("atualizar-sessao", response.data.user);
          alert("🏆 Sucesso!\nSeus dados cadastrais e rastro de endereço foram atualizados com sucesso absoluto no ecossistema.");
        }
      } catch (error) {
        console.error("Falha ao persistir dados do contratante no banco:", error);
        alert(error.response?.data?.message || "Ocorreu um erro interno ao salvar o perfil no servidor.");
      } finally {
        this.loadingSalvar = false;
      }
    },

    // 🏛️ ENGENHO ASSÍNCRONO: Consulta o ViaCEP para preencher a malha urbana da esquerda
    async consultarViaCep() {
      this.loadingCep = true;
      this.erroCep = false;
      try {
        const cepFormatado = this.form.zipCode.replace("-", "");
        const response = await axios.get(`https://viacep.com.br{cepFormatado}/json/`);
        
        if (response.data && !response.data.erro) {
          this.form.logradouro = response.data.logradouro || "";
          this.form.bairro = response.data.bairro || "";
          this.form.cidade = response.data.localidade || "";
          this.form.estado = response.data.uf || "";
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

    // 🛠️ MÁSCARA AUTOMÁTICA REGULAR DO TELEFONE
    aplicarMascaraCelular() {
      let valor = this.form.celular.replace(/\D/g, "");
      if (valor.length > 11) valor = valor.slice(0, 11);
      
      if (valor.length > 6) {
        this.form.celular = `(${valor.slice(0, 2)}) ${valor.slice(2, 7)}-${valor.slice(7, 11)}`;
      } else if (valor.length > 2) {
        this.form.celular = `(${valor.slice(0, 2)}) ${valor.slice(2, 6)}`;
      } else {
        this.form.celular = valor;
      }
    },

    // 🛠️ MÁSCARA AUTOMÁTICA REGULAR DO CEP
    validarETirarMascaraCep() {
      let cepLimpo = this.form.zipCode.replace(/\D/g, "");
      if (cepLimpo.length > 5) {
        this.form.zipCode = cepLimpo.slice(0, 5) + "-" + cepLimpo.slice(5, 8);
      } else {
        this.form.zipCode = cepLimpo;
      }
      if (cepLimpo.length === 8) {
        this.consultarViaCep();
      }
    },

    // 🛠️ AUXILIAR DE MODELO: Transpõe a sessão armazenada para o formulário local
    hidratarCamposLocais() {
      if (!this.usuario) return;
      this.form.nomeCompleto = this.usuario.name || "";
      this.form.cpf = this.usuario.cpf || "";
      this.form.celular = this.usuario.celular || "";
      this.form.zipCode = this.usuario.cep || "";
      this.form.logradouro = this.usuario.logradouro || "";
      this.form.numero = this.usuario.numero || "";
      this.form.bairro = this.usuario.bairro || "";
      this.form.cidade = this.usuario.cidade || "";
      this.form.estado = this.usuario.estado || "";
      this.form.complemento = this.usuario.complemento || "";
    }
  },
  mounted() {
    // Hidrata as caixas de texto com o rastro global assim que o componente nasce
    this.hidratarCamposLocais();
  }
};
</script>