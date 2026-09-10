<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div style="background-color: #0a0b10; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; font-family: monospace;">
    
    <!-- CARD CENTRAL DE ALTO CONTRASTE (VELZON DARK STYLE) -->
    <div class="animate__animated animate__fadeIn" style="width: 100%; max-width: 450px; background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); text-align: left;">
      
      <!-- LOGO / CABEÇALHO -->
      <div style="text-align: center; margin-bottom: 30px;">
        <h3 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 22px; margin: 0 0 8px 0; letter-spacing: 0.5px;">Seven<span style="color: #ff6c22;">Shows</span></h3>
        <p style="color: #878a99; font-size: 13px; margin: 0;">Área de Acesso do Contratante</p>
      </div>

      <!-- FORMULÁRIO DE AUTENTICAÇÃO -->
      <form @submit.prevent="executarLoginCliente" style="display: flex; flex-direction: column; gap: 20px;">
        
        <!-- CAMPO: E-MAIL -->
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">E-mail Cadastrado *</label>
          <input type="email" v-model="email" placeholder="seu@email.com" required style="width: 100%; height: 52px; padding: 0 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
        </div>

        <!-- CAMPO: SENHA COM OLHO DIGITAL -->
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Sua Senha *</label>
          <div style="position: relative; width: 100%; height: 52px;">
            <input :type="revelarSenha ? 'text' : 'password'" v-model="password" placeholder="Digite sua senha" required style="width: 100%; height: 52px; padding: 0 50px 0 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 14px; font-weight: bold; outline: none; box-sizing: border-box;" />
            <button type="button" @click="revelarSenha = !revelarSenha" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); background: transparent; border: none; color: #878a99; cursor: pointer; font-size: 14px; outline: none; padding: 5px; z-index: 10;">
              {{ revelarSenha ? '👁️' : '🙈' }}
            </button>
          </div>
          
          <!-- Link Elegante de Esqueci a Senha alinhado à direita -->
          <div style="text-align: right; margin-top: 2px;">
            <button @click="dispararRecuperacaoSenha" :disabled="loadingRecuperacao" type="button" style="background: transparent; border: none; color: #878a99; font-size: 11px; font-weight: bold; text-decoration: underline; cursor: pointer; padding: 2px 0; outline: none;">
              {{ loadingRecuperacao ? 'Enviando...' : 'Esqueceu a senha?' }}
            </button>
          </div>
        </div>

        <!-- BOTÃO DE DISPARO MESTRE -->
        <button type="submit" :disabled="loading || !email || !password" :style="{ backgroundColor: (email && password) ? '#ff6c22' : '#2a2d3d', borderColor: (email && password) ? '#ff6c22' : '#2a2d3d', color: (email && password) ? '#ffffff' : '#878a99', cursor: (email && password) ? 'pointer' : 'not-allowed' }" style="width: 100%; height: 50px; border: 1px solid; font-weight: bold; text-transform: uppercase; font-size: 12px; border-radius: 8px; transition: 0.2s; letter-spacing: 0.5px; margin-top: 10px; display: flex; align-items: center; justify-content: center;">
          {{ loading ? 'Verificando Credenciais...' : 'Entrar no Painel →' }}
        </button>

      </form>

      <!-- LINK DE RETORNO -->
      <div style="text-align: center; margin-top: 25px; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 20px;">
        <router-link to="/visualizar-lp" style="color: #878a99; font-size: 12px; text-decoration: none; font-weight: bold;">← Voltar para a Home Pública</router-link>
      </div>

    </div>
  </div>
</template>
<script>
/* eslint-disable */
import axios from "axios";

export default {
  name: "LoginContratante",
  data() {
    return {
      // 🚀 ESTADOS REATIVOS DO FORMULÁRIO
      email: "",
      password: "",
      
      // 🚀 ESTADOS DE CONTROLE VISUAL
      loading: false,
      revelarSenha: false,
      
      // 🚀 CAPTURA DA URL GLOBAL DE CONEXÃO COM O BACKEND .NET 10
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL
    };
  },
  methods: {
    // ====================================================================
    // 🔐 AUTENTICAÇÃO ISOLADA: Valida o contratante e aciona a Navbar na hora
    // ====================================================================
    async executarLoginCliente() {
      if (!this.email || !this.password) return;
      this.loading = true;

      try {
        const urlLogin = this.apiBaseUrlGlobal + "/public/contratantes/login";
        const response = await axios.post(urlLogin, {
          email: this.email.trim(),
          password: this.password
        });

        if (response.data && response.data.token) {
          const stringifiedUser = JSON.stringify(response.data.user);

          // 🚀 PERSISTÊNCIA EM LOTE UNIFICADA NO REPOSITÓRIO LOCAL
          localStorage.setItem("jwt", response.data.token);
          localStorage.setItem("user", stringifiedUser);
          localStorage.setItem("userdata", stringifiedUser);

          // 🚀 GATILHO REATIVO: Avisa a NavbarPublic para mudar o topo para "Olá, [Nome]" na hora
          window.dispatchEvent(new CustomEvent("sessao-atualizada"));

          // Redireciona o cliente de volta para a vitrine pública da Landing Page
          this.$router.push("/visualizar-lp");
        }
      } catch (error) {
        console.error("Falha crítica no login do contratante:", error);
        alert(error.response?.data?.message || "E-mail ou senha incorretos para o perfil Contratante.");
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>
