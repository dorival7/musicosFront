<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="animate__animated animate__fadeIn" style="text-align: left;">
    
    <!-- 🎛️ TOPO DO FORMULÁRIO -->
    <div style="margin-bottom: 25px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.05);">
      <h5 style="color: #ffffff; font-weight: bold; font-size: 15px; margin: 0; text-transform: uppercase; letter-spacing: 0.5px;">
        🔒 Alterar Senha de Acesso
      </h5>
    </div>

    <!-- 💡 AVISO PROTETIVO -->
    <div style="background-color: rgba(255, 193, 7, 0.03); border: 1px dashed rgba(255, 193, 7, 0.15); border-radius: 8px; padding: 15px; margin-bottom: 25px;">
      <p style="color: #ffc107; font-size: 12px; margin: 0; line-height: 1.5; font-family: monospace;">
        ⚠️ <strong>Atenção com a Segurança:</strong> Para modificar suas credenciais, informe a senha atual cadastrada no portal. A nova senha deve conter no mínimo 6 caracteres e passará por criptografia direta antes de ser gravada na tabela única do MariaDB.
      </p>
    </div>

    <!-- 📝 FORMULÁRIO DE TROCA ISOLADA -->
    <form @submit.prevent="processarTrocaDeSenha" style="display: flex; flex-direction: column; gap: 20px; max-width: 500px; font-family: monospace;">
      
      <!-- Entrada 1: Senha Atual -->
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Sua Senha Atual *</label>
        <div style="position: relative; display: flex; align-items: center;">
          <input :type="exibirSenhaAtual ? 'text' : 'password'" v-model="form.senhaAtual" placeholder="Digite sua senha atual" style="width: 100%; padding: 14px 50px 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
          <button type="button" @click="exibirSenhaAtual = !exibirSenhaAtual" style="position: absolute; right: 15px; background: transparent; border: none; color: #878a99; cursor: pointer; font-size: 14px; outline: none; padding: 5px;">
            {{ exibirSenhaAtual ? '👁️' : '🙈' }}
          </button>
        </div>
      </div>

      <!-- Entrada 2: Nova Senha -->
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Crie a Nova Senha (mín. 6 dgt) *</label>
        <div style="position: relative; display: flex; align-items: center;">
          <input :type="exibirNovaSenha ? 'text' : 'password'" v-model="form.novaSenha" placeholder="Mínimo 6 caracteres" style="width: 100%; padding: 14px 50px 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
          <button type="button" @click="exibirNovaSenha = !exibirNovaSenha" style="position: absolute; right: 15px; background: transparent; border: none; color: #878a99; cursor: pointer; font-size: 14px; outline: none; padding: 5px;">
            {{ exibirNovaSenha ? '👁️' : '🙈' }}
          </button>
        </div>
      </div>

      <!-- Entrada 3: Confirmar Nova Senha -->
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Confirme a Nova Senha *</label>
        <input type="password" v-model="form.confirmarNovaSenha" placeholder="Repita a nova senha criada" style="width: 100%; padding: 14px 20px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
      </div>

      <!-- Botão de Postagem Contra o .NET 10 -->
      <div style="margin-top: 10px; text-align: right;">
        <button type="submit" :disabled="loadingSalvar" :style="{ backgroundColor: loadingSalvar ? '#2a2d3d' : '#ff6c22', borderColor: loadingSalvar ? '#2a2d3d' : '#ff6c22', cursor: loadingSalvar ? 'not-allowed' : 'pointer' }" style="padding: 15px 35px; border: 1px solid; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 11px; border-radius: 50px; box-shadow: 0 4px 15px rgba(255,108,34,0.15); transition: 0.2s; letter-spacing: 0.5px;">
          {{ loadingSalvar ? 'Processando Troca...' : 'Atualizar Credencial de Acesso →' }}
        </button>
      </div>

    </form>
  </div>
</template>
<script>
/* eslint-disable */
import axios from "axios";

export default {
  name: "AlterarSenhaForm",
  props: {
    // Recebe o ID do usuário ativo passado pelo orquestrador Pai
    userId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      loadingSalvar: false,
      exibirSenhaAtual: false,
      exibirNovaSenha: false,
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL,
      
      form: {
        senhaAtual: "",
        novaSenha: "",
        confirmarNovaSenha: ""
      }
    };
  },
  methods: {
    // 🚀 EXECUÇÃO DE CRIPTOGRAFIA: Dispara as credenciais contra a controller do .NET 10
    async processarTrocaDeSenha() {
      if (this.loadingSalvar) return;

      // Validações básicas de segurança na interface cliente
      if (!this.form.senhaAtual || !this.form.novaSenha || !this.form.confirmarNovaSenha) {
        return alert("⚠️ Atenção:\nTodos os campos de senha são estritamente obrigatórios.");
      }

      if (this.form.novaSenha.length < 6) {
        return alert("⚠️ Restrição de tamanho:\nA nova senha deve conter no mínimo 6 caracteres.");
      }

      if (this.form.novaSenha !== this.form.confirmarNovaSenha) {
        return alert("❌ Inconsistência:\nA confirmação não confere com a nova senha criada.");
      }

      this.loadingSalvar = true;
      try {
        const urlSenha = `${this.apiBaseUrlGlobal}/public/contratantes/alterar-senha/${this.userId}`;
        const response = await axios.put(urlSenha, {
          senhaAtual: this.form.senhaAtual,
          novaSenha: this.form.novaSenha
        });

        if (response.data && response.data.success) {
          alert("🏆 Credencial Atualizada!\nSua senha de acesso foi modificada com sucesso absoluto na plataforma.");
          
          // Limpa as caixas de texto do formulário por privacidade
          this.form.senhaAtual = "";
          this.form.novaSenha = "";
          this.form.confirmarNovaSenha = "";
        }
      } catch (error) {
        console.error("Falha ao redefinir credenciais na API C#:", error);
        alert(error.response?.data?.message || "Ocorreu um erro ao processar a troca de senha no servidor.");
      } finally {
        this.loadingSalvar = false;
      }
    }
  }
};
</script>