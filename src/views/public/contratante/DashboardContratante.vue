<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="seven-portal text-start" style="position: relative; width: 100%; min-height: 100vh; background-color: #0a0b10 !important; padding-top: 120px; padding-bottom: 60px; display: block !important; box-sizing: border-box; font-family: monospace;">
    
    <!-- NAVBAR PÚBLICA INTEGRADA NO TOPO -->
    <NavbarPublic />

    <div style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
      
      <!-- FEEDBACK VISUAL DE CARREGAMENTO EM TEMPO DE REDE -->
      <div v-if="loadingGeral" style="text-align: center; padding: 100px 0; color: #878a99;">
        <div class="spinner-border text-primary" role="status" style="color: #ff6c22 !important;"></div>
        <p style="margin-top: 15px; font-size: 13px; letter-spacing: 0.5px; text-transform: uppercase;">Carregando Central do Contratante...</p>
      </div>

      <!-- CHASSI DO PAINEL MONTADO APÓS RETORNO DA SESSÃO E DA API -->
      <div v-else class="animate__animated animate__fadeIn">
        <div style="display: flex; flex-wrap: wrap; gap: 30px; align-items: start;">
          
          <!-- ==================================================================== -->
          <!-- 👤 COLUNA DA ESQUERDA: CARD DE IDENTIFICAÇÃO FIXO (30%)              -->
          <!-- ==================================================================== -->
          <div style="width: 320px; position: sticky; top: 120px;">
            <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); text-align: center;">
              
              <!-- Avatar com Iniciais do Usuário -->
              <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #ff6c22, #ff9e66); color: #ffffff; display: flex; align-items: center; justify-content: center; font-size: 28px; font-weight: bold; margin: 0 auto 20px auto; box-shadow: 0 5px 20px rgba(255,108,34,0.3);">
                {{ obterIniciais(usuarioSessao?.name) }}
              </div>

              <h4 style="color: #ffffff; font-weight: bold; font-size: 16px; margin: 0 0 4px 0; text-transform: uppercase; letter-spacing: 0.5px;">
                {{ usuarioSessao?.name || 'Contratante' }}
              </h4>
              <p style="color: #878a99; font-size: 12px; margin: 0 0 25px 0; word-break: break-all;">
                {{ usuarioSessao?.email }}
              </p>

              <div style="border-top: 1px solid rgba(255,255,255,0.05); margin-bottom: 25px;"></div>

              <button @click="executarLogoutSeguro" type="button" style="width: 100%; padding: 12px; background-color: rgba(240,101,72,0.05); border: 1px solid rgba(240,101,72,0.2); border-radius: 8px; color: #f06548; font-size: 11px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; cursor: pointer; transition: 0.2s;" onmouseover="this.style.backgroundColor='rgba(240,101,72,0.1)'" onmouseout="this.style.backgroundColor='rgba(240,101,72,0.05)'">
                🚪 Encerrar Sessão
              </button>
            </div>
          </div>

          <!-- ==================================================================== -->
          <!-- 🏛️ COLUNA DA DIREITA: HUB DE ABAS E CRONOGRAMAS REATIVOS (70%)        -->
          <!-- ==================================================================== -->
          <div style="flex: 1; min-width: 300px;">
            <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 35px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
              
              <!-- BARRA DE NAVEGAÇÃO SUPERIOR (NAV-TABS HORIZONTAIS DO VELZON) -->
              <div class="seven-tabs-container" style="display: flex; flex-wrap: wrap; gap: 5px; border-bottom: 2px solid rgba(255,255,255,0.05); padding-bottom: 0; margin-bottom: 35px; width: 100%; box-sizing: border-box; overflow: hidden; -ms-overflow-style: none; scrollbar-width: none;">
                
                <button 
                  v-for="aba in abasDisponiveis" 
                  :key="aba.id"
                  @click="abaAtiva = aba.id"
                  type="button"
                  :style="{
                    color: abaAtiva === aba.id ? '#ff6c22' : '#878a99',
                    borderBottomColor: abaAtiva === aba.id ? '#ff6c22' : 'transparent',
                    fontWeight: abaAtiva === aba.id ? 'bold' : 'normal'
                  }"
                  style="background: transparent; border: none; border-bottom: 3px solid transparent; padding: 12px 18px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; cursor: pointer; transition: 0.2s; outline: none; margin-bottom: -2px;"
                >
                  {{ aba.label }}
                </button>
              </div>

              <!-- ALTERNÂNCIA DE COMPONENTES FILHOS -->
              <div class="tab-content">
                <MinhaAgendaCalendario v-if="abaAtiva === 'agenda'" :eventos="listaShowsContratados" />
                <MeusShowsLista v-else-if="abaAtiva === 'shows'" :eventos="listaShowsContratados" @recarregar-dados="buscarShowsDoContratante" />
                <MeuPerfilForm v-else-if="abaAtiva === 'perfil'" :usuario="usuarioSessao" @atualizar-sessao="reidratarSessaoGlobal" />
                <AlterarSenhaForm v-else-if="abaAtiva === 'seguranca'" :userId="usuarioSessao?.id" />
              </div>

            </div>
          </div>

        </div>
      </div>

    </div>
  </div>
</template>
<script>
/* eslint-disable */
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import MinhaAgendaCalendario from "./components/MinhaAgendaCalendario.vue";
import MeusShowsLista from "./components/MeusShowsLista.vue";
import MeuPerfilForm from "./components/MeuPerfilForm.vue";
import AlterarSenhaForm from "./components/AlterarSenhaForm.vue";
import axios from "axios";

export default {
  name: "DashboardContratante",
  components: {
    NavbarPublic,
    MinhaAgendaCalendario,
    MeusShowsLista,
    MeuPerfilForm,
    AlterarSenhaForm
  },
  data() {
    return {
      loadingGeral: false,
      abaAtiva: "agenda",
      usuarioSessao: null,
      listaShowsContratados: [],
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL,
      
      abasDisponiveis: [
        { id: "agenda", label: "📅 Minha Agenda" },
        { id: "shows", label: "📋 Meus Shows" },
        { id: "perfil", label: "👤 Meu Perfil" },
        { id: "seguranca", label: "🔒 Segurança" }
      ]
    };
  },
  methods: {
    // 🚀 ALIMENTAÇÃO DA PLATAFORMA: Consome o endpoint GET que criamos na esteira do C#
    async buscarShowsDoContratante() {
      if (!this.usuarioSessao?.id) return;
      try {
        const urlListar = `${this.apiBaseUrlGlobal}/public/contratantes/eventos/listar-por-contratante/${this.usuarioSessao.id}`;
        const response = await axios.get(urlListar);
        
        if (response.data && response.data.success) {
          this.listaShowsContratados = response.data.eventos || [];
          console.log("📊 [PAINEL PAI] Registros do MariaDB injetados na memória:", this.listaShowsContratados.length);
        }
      } catch (error) {
        console.error("Falha ao carregar lista de shows no painel pai:", error);
      }
    },

    // 👤 SINTONIA DO RASTRO GLOBAL: Reescreve as chaves do LocalStorage de forma síncrona
    reidratarSessaoGlobal(novoPerfilUser) {
      this.usuarioSessao = novoPerfilUser;
      const strUser = JSON.stringify(novoPerfilUser);
      localStorage.setItem("user", strUser);
      localStorage.setItem("userdata", strUser);
      
      window.dispatchEvent(new CustomEvent("sessao-atualizada"));
      console.log("⚡ [PAINEL PAI] Rastro global reidratado com sucesso.");
    },

    // 🚪 LOGOUT: Expulsa lixos de cache e retorna à Home pública
    executarLogoutSeguro() {
      localStorage.removeItem("jwt");
      localStorage.removeItem("user");
      localStorage.removeItem("userdata");
      window.dispatchEvent(new CustomEvent("sessao-atualizada"));
      this.$router.push("/");
    },

    // 🛠️ UTENSÍLIO DE INTERFACE: Recorta o nome para fabricar as iniciais do avatar
    obterIniciais(nome) {
      if (!nome) return "CS";
      const partes = nome.trim().toUpperCase().split(" ");
      if (partes.length > 1) {
        return partes[0].charAt(0) + partes[partes.length - 1].charAt(0);
      }
      return partes[0].slice(0, 2);
    }
  },
  mounted() {
    this.loadingGeral = true;
    const dadosUsuarioStr = localStorage.getItem("user");
    const tokenAtivo = localStorage.getItem("jwt");

    if (!dadosUsuarioStr || !tokenAtivo) {
      this.loadingGeral = false;
      this.$router.push("/");
      return;
    }

    try {
      this.usuarioSessao = JSON.parse(dadosUsuarioStr);
      this.buscarShowsDoContratante();
    } catch (error) {
      console.error("Falha ao inicializar chassi do painel:", error);
      this.executarLogoutSeguro();
    } finally {
      this.loadingGeral = false;
    }
  }
};
</script>