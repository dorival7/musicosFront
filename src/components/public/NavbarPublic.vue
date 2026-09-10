<!-- eslint-disable vue/no-parsing-error -->
<!-- eslint-disable vue/no-parsing-error -->
<template>
  <nav class="navbar navbar-expand-lg navbar-landing bg-dark fixed-top" id="navbar" style="border-bottom: 1px solid rgba(255,255,255,0.06); padding: 15px 0;">
    <div class="container">
      <router-link class="navbar-brand" to="/">
        <img :src="logoSevenShows" alt="SevenShows Logo" style="height: 32px; width: auto; object-fit: contain;" />
      </router-link>
      
      <button class="navbar-toggler py-0 fs-20 text-white border-0" type="button" v-b-toggle.navbarSupportedContent>
        <i class="ri-menu-line"></i>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mx-auto mt-2 mt-lg-0">
          <!-- 🚀 CORREÇÃO DE ROTA: Aponta estritamente para o caminho da Landing Page (/visualizar-lp) -->
          <li class="nav-item">
            <a class="nav-link fs-14 text-white fw-bold" href="javascript:void(0)" @click="$route.path === '/visualizar-lp' ? rolarSuave('#como-funciona') : $router.push({ path: '/visualizar-lp', hash: '#como-funciona' })" style="opacity: 0.85; cursor: pointer;">Como Funciona</a>
          </li>
          <li class="nav-item">
            <a class="nav-link fs-14 text-white fw-bold" href="javascript:void(0)" @click="$route.path === '/visualizar-lp' ? rolarSuave('#seguranca') : $router.push({ path: '/visualizar-lp', hash: '#seguranca' })" style="opacity: 0.85; cursor: pointer;">Segurança</a>
          </li>
          <li class="nav-item"><router-link class="nav-link fs-14 text-white fw-bold" to="/artistas" style="opacity: 0.85;">Encontrar Artistas</router-link></li>
        </ul>

        <div class="d-flex align-items-center gap-3">
          <!-- CENÁRIO A: VISITANTE (DESLOGADO) -->
          <template v-if="!usuarioLogado">
            <!-- 🚀 ROTA ATUALIZADA: Agora direciona legitimamente para o login do cliente -->
            <router-link to="/login-cliente" class="btn btn-link fw-bold text-decoration-none text-white fs-14 px-3" style="opacity: 0.9;">Entrar</router-link>
            <router-link to="/quero-vender" class="btn btn-primary btn-sm fw-bold px-3 shadow-sm rounded-2 text-uppercase fs-12 font-monospace" style="letter-spacing: 0.5px;">Quero Vender Shows</router-link>
          </template>

          <!-- CENÁRIO B: DROPDOWN PREMIUM CORRIGIDO (MÁXIMA VISIBILIDADE) -->
          <template v-else>
            <div class="dropdown">
              <button class="btn d-flex align-items-center gap-2 p-0 border-0" type="button" id="dropdownUserMenu" data-bs-toggle="dropdown" aria-expanded="false" style="background: transparent; outline: none; box-shadow: none;">
                
                <!-- 🚀 AVATAR TURBINADO: Fundo neon visível com borda destacada -->
                <div class="d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; border-radius: 50%; background-color: rgba(10, 179, 156, 0.25); border: 1px solid #0ab39c; box-shadow: 0 0 10px rgba(10, 179, 156, 0.2);">
                  <i class="ri-user-3-fill" style="color: #ffffff; font-size: 14px; margin: auto;"></i>
                </div>
                
                <!-- 🚀 NOME TURBINADO: Branco puro destacado com peso semibold -->
                <span class="fs-14 fw-semibold font-monospace" style="color: #ffffff !important; transition: color 0.2s; letter-spacing: -0.1px;">
                  {{ primeiroNome }} 
                  <span style="font-size: 8px; color: #0ab39c; opacity: 0.9; margin-left: 3px; vertical-align: middle;">▼</span>
                </span>

              </button>
              
              <!-- Menu Flutuante Suspenso Estilizado Dark -->
              <ul class="dropdown-menu dropdown-menu-end shadow-lg py-2 animate__animated animate__fadeIn" aria-labelledby="dropdownUserMenu" style="background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; min-width: 160px; backdrop-filter: blur(10px); margin-top: 12px;">
                <li>
                  <router-link to="/contratante/dashboard" class="dropdown-item d-flex align-items-center gap-2 py-2 fs-12 font-monospace text-white" style="cursor: pointer;"><i class="ri-dashboard-2-line" style="color: #0ab39c;"></i> Meu Painel</router-link>
                </li>
                <li style="border-top: 1px solid rgba(255,255,255,0.06); margin: 6px 0;"></li>
                <li>
                  <button @click="efetuarLogoffSessao" class="dropdown-item d-flex align-items-center gap-2 py-2 fs-12 font-monospace" style="color: #f06548 !important; cursor: pointer; background: transparent; border: none; width: 100%; text-align: left;"><i class="ri-logout-box-r-line"></i> Sair da Conta</button>
                </li>
              </ul>
            </div>
          </template>
        </div>

      </div>
    </div>
  </nav>
</template>


<script>
/* eslint-disable */
import logoSevenShows from "@/assets/images/logo-light.png";

export default {
  name: "NavbarPublic",
  data() {
    return {
      logoSevenShows,
      usuarioLogado: null
    };
  },
  computed: {
    // Extrai o primeiro nome para saudar amigavelmente o usuário logado
    primeiroNome() {
      if (!this.usuarioLogado || !this.usuarioLogado.name) return "Usuário";
      return this.usuarioLogado.name.split(" ")[0];
    }
  },
  methods: {
    // Varre o armazenamento local em busca de uma sessão de faturamento ativa
    verificarSessaoAtiva() {
      const dadosUsuarioStr = localStorage.getItem("user");
      const tokenAtivo = localStorage.getItem("jwt");
      if (dadosUsuarioStr && tokenAtivo) {
        try {
          this.usuarioLogado = JSON.parse(dadosUsuarioStr);
        } catch (e) {
          this.usuarioLogado = null;
        }
      } else {
        this.usuarioLogado = null;
      }
    },
    // 🧠 SCROLL SUAVE INTEGRADO: Faz o deslize de tela elegante caso o usuário já esteja na Home
    rolarSuave(seletorId) {
      const elemento = document.querySelector(seletorId);
      if (elemento) {
        elemento.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    },
    // Limpa a memória RAM e o armazenamento unificado do navegador
    efetuarLogoffSessao() {
      localStorage.removeItem("jwt");
      localStorage.removeItem("user");
      localStorage.removeItem("userdata");
      this.usuarioLogado = null;

      if (this.$route?.path !== "/visualizar-lp") {
        this.$router.push("/visualizar-lp");
      } else {
        window.location.reload();
      }
    }
  },
  mounted() {
    // 1. Executa a varredura inicial padrão que você já possuía
    this.verificarSessaoAtiva();

    // 2. 🚀 INJETADO: Escuta o evento de login disparado pelo checkout para atualizar o nome na hora
    window.addEventListener("sessao-atualizada", this.verificarSessaoAtiva);
  },
  unmounted() {
    // Remove o listener para evitar vazamentos de memória na troca de rotas
    window.removeEventListener("sessao-atualizada", this.verificarSessaoAtiva);
  }
};
</script>


