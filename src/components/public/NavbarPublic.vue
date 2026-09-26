<!-- eslint-disable vue/no-parsing-error -->
<!-- eslint-disable vue/no-parsing-error -->
<template>
  <nav class="navbar navbar-expand-lg navbar-landing bg-dark fixed-top" id="navbar" style="border-bottom: 1px solid rgba(255,255,255,0.06); padding: 15px 0;">
    <div class="container">
      <router-link class="navbar-brand" to="/visualizar-lp">
        <img :src="logoSevenShows" alt="SevenShows Logo" style="height: 32px; width: auto; object-fit: contain;" />
      </router-link>
      
      <button class="navbar-toggler py-0 fs-20 text-white border-0" type="button"
        :aria-expanded="menuMobileAberto ? 'true' : 'false'" aria-controls="navbarSupportedContent"
        @click="alternarMenuMobile">
        <i :class="menuMobileAberto ? 'ri-close-line' : 'ri-menu-line'"></i>
      </button>

      <div class="collapse navbar-collapse" :class="{ show: menuMobileAberto }" id="navbarSupportedContent">
        <ul class="navbar-nav mx-auto mt-2 mt-lg-0">
          <!-- 🚀 CORREÇÃO DE ROTA: Aponta estritamente para o caminho da Landing Page (/visualizar-lp) -->
          <li class="nav-item">
            <a class="nav-link fs-14 text-white fw-bold" href="javascript:void(0)" @click="navegarSecao('#como-funciona')" style="opacity: 0.85; cursor: pointer;"><i class="ri-information-line mobile-menu-icon"></i><span>Como funciona</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link fs-14 text-white fw-bold" href="javascript:void(0)" @click="navegarSecao('#seguranca')" style="opacity: 0.85; cursor: pointer;"><i class="ri-shield-check-line mobile-menu-icon"></i><span>Segurança</span></a>
          </li>
          <li class="nav-item"><router-link class="nav-link fs-14 text-white fw-bold" to="/artistas" style="opacity: 0.85;" @click="fecharMenuMobile"><i class="ri-search-eye-line mobile-menu-icon"></i><span>Encontrar artistas</span></router-link></li>
        </ul>

        <div class="d-flex align-items-center gap-3">
          <!-- CENÁRIO A: VISITANTE (DESLOGADO) -->
          <template v-if="!usuarioLogado">
            <!-- 🚀 ROTA ATUALIZADA: Agora direciona legitimamente para o login do cliente -->
            <router-link to="/login-cliente" class="btn btn-link fw-bold text-decoration-none text-white fs-14 px-3 mobile-login" style="opacity: 0.9;"><span>Entrar na minha conta</span><i class="ri-arrow-right-line"></i></router-link>
            <router-link to="/quero-vender" class="btn btn-primary btn-sm fw-bold px-3 shadow-sm rounded-2 text-uppercase fs-12 font-monospace mobile-musician-cta" style="letter-spacing: 0.5px;"><span class="mobile-musician-kicker">É músico ou tem uma banda?</span><strong>Quero vender meus shows</strong><i class="ri-arrow-right-line"></i></router-link>
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
      usuarioLogado: null,
      menuMobileAberto: false
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
    alternarMenuMobile() {
      this.menuMobileAberto = !this.menuMobileAberto;
    },
    fecharMenuMobile() {
      this.menuMobileAberto = false;
    },
    navegarSecao(seletorId) {
      this.fecharMenuMobile();
      if (this.$route.path === "/visualizar-lp") {
        this.$nextTick(() => this.rolarSuave(seletorId));
      } else {
        this.$router.push({ path: "/visualizar-lp", hash: seletorId });
      }
    },
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



<style scoped>
/* v1.4.32 — Home responsiva: navegação mobile sem duplicar a página. */
@media (max-width: 991.98px) {
  #navbar {
    padding: 10px 0 !important;
  }

  #navbar .container {
    padding-left: 16px;
    padding-right: 16px;
  }

  #navbar .navbar-brand img {
    height: 31px !important;
  }

  #navbar .navbar-toggler {
    width: 42px;
    height: 42px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 10px;
    background: rgba(255, 255, 255, .045);
  }

  #navbarSupportedContent {
    margin-top: 10px;
    padding: 14px;
    border: 1px solid rgba(255, 255, 255, .08);
    border-radius: 14px;
    background: rgba(10, 11, 16, .98);
    box-shadow: 0 18px 40px rgba(0, 0, 0, .28);
  }

  #navbarSupportedContent .navbar-nav {
    margin: 0 !important;
  }

  #navbarSupportedContent .nav-link {
    padding: 11px 8px;
  }

  #navbarSupportedContent > .d-flex {
    margin-top: 10px;
    padding-top: 12px;
    border-top: 1px solid rgba(255, 255, 255, .07);
    flex-direction: column;
    align-items: stretch !important;
    gap: 8px !important;
  }

  #navbarSupportedContent > .d-flex .btn,
  #navbarSupportedContent > .d-flex > a {
    width: 100%;
    min-height: 44px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  #navbarSupportedContent .dropdown > button {
    min-height: 44px;
  }
}


/* v1.4.45 — mobile: logo centralizado no header, independente do botão de menu. */
@media (max-width: 767.98px) {
  #navbar .container {
    position: relative;
    min-height: 42px;
  }

  #navbar .navbar-brand {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    margin: 0 !important;
    padding: 0 !important;
    z-index: 2;
  }

  #navbar .navbar-toggler {
    margin-left: auto;
    position: relative;
    z-index: 3;
  }
}

/* Seven Shows — menu público mobile em tela cheia. Desktop preservado. */
@media (max-width: 767.98px) {
  body:has(#navbarSupportedContent.show) {
    overflow: hidden;
  }

  #navbar:has(#navbarSupportedContent.show) {
    z-index: 1055;
    background: #090b10 !important;
  }

  #navbar:has(#navbarSupportedContent.show) .navbar-brand {
    position: fixed;
    left: 50%;
    top: 22px;
    transform: translateX(-50%);
    z-index: 1062;
  }

  #navbar:has(#navbarSupportedContent.show) .navbar-brand img {
    height: 31px !important;
  }

  #navbar:has(#navbarSupportedContent.show) .navbar-toggler {
    position: fixed;
    right: 16px;
    top: 12px;
    z-index: 1063;
    width: 46px;
    height: 46px;
    border: 1px solid rgba(255,255,255,.14) !important;
    background: #171a22;
    font-size: 26px !important;
  }

  #navbarSupportedContent.show {
    display: flex !important;
    position: fixed;
    inset: 0;
    z-index: 1060;
    margin: 0;
    padding: 88px 22px 24px;
    border: 0;
    border-radius: 0;
    background: #090b10;
    box-shadow: none;
    flex-direction: column;
    overflow-y: auto;
  }

  #navbarSupportedContent.show .navbar-nav {
    width: 100%;
    flex: 0 0 auto;
  }

  #navbarSupportedContent.show .nav-item {
    border-bottom: 1px solid rgba(255,255,255,.07);
  }

  #navbarSupportedContent.show .nav-link {
    min-height: 58px;
    padding: 0 4px;
    display: flex;
    align-items: center;
    gap: 13px;
    font-size: 16px !important;
    color: #fff !important;
    opacity: 1 !important;
  }

  #navbarSupportedContent.show .mobile-menu-icon {
    width: 28px;
    height: 28px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    background: rgba(255, 103, 48, .10);
    color: #ff6730;
    font-size: 17px;
    flex: 0 0 28px;
  }

  #navbarSupportedContent.show > .d-flex {
    width: 100%;
    margin-top: 18px;
    padding-top: 18px;
    border-top: 0;
    gap: 14px !important;
  }

  #navbarSupportedContent.show .mobile-login {
    min-height: 52px !important;
    padding: 0 4px !important;
    justify-content: space-between !important;
    font-size: 15px !important;
    border-bottom: 1px solid rgba(255,255,255,.07);
    border-radius: 0;
  }

  #navbarSupportedContent.show .mobile-login i {
    color: #ff6730;
    font-size: 20px;
  }

  #navbarSupportedContent.show .mobile-musician-cta {
    position: relative;
    margin-top: auto;
    min-height: 92px !important;
    padding: 17px 48px 17px 18px !important;
    display: flex !important;
    flex-direction: column;
    align-items: flex-start !important;
    justify-content: center !important;
    gap: 5px;
    text-align: left;
    border: 1px solid rgba(255,103,48,.45);
    border-radius: 14px !important;
    background: linear-gradient(135deg, rgba(255,103,48,.16), rgba(255,103,48,.06)) !important;
    color: #fff !important;
    box-shadow: none !important;
  }

  #navbarSupportedContent.show .mobile-musician-kicker {
    color: #aeb4c3;
    font-size: 10px;
    line-height: 1.2;
    letter-spacing: .8px;
  }

  #navbarSupportedContent.show .mobile-musician-cta strong {
    color: #ff6730;
    font-size: 15px;
    line-height: 1.25;
  }

  #navbarSupportedContent.show .mobile-musician-cta > i {
    position: absolute;
    right: 18px;
    top: 50%;
    transform: translateY(-50%);
    color: #ff6730;
    font-size: 22px;
  }
}

</style>
