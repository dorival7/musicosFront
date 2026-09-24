<script>
import { layoutMethods } from "@/state/helpers";
import simplebar from "simplebar-vue";
import i18n from "../i18n";
import axios from "axios";

/**
 * Nav-bar Component - Higienizado e Conectado aos dados REAIS do .NET 10
 */
export default {
  name: "NavBar",
  data() {
    return {
      text: "Português",
      myVar: 1,
      pendingRequests: [],
      loadingNotifications: false,
      notificationsTimer: null,
    };
  },
  components: {
    simplebar
  },
  computed: {
    // Somente Tenant deve consumir notificações da agenda do músico.
    isTenant() {
      try {
        const rolesRaw = localStorage.getItem("roles");
        const roles = rolesRaw ? JSON.parse(rolesRaw) : [];
        if (Array.isArray(roles) && roles.includes("Tenant")) return true;

        const userRaw = localStorage.getItem("user");
        const user = userRaw ? JSON.parse(userRaw) : {};
        return Array.isArray(user.roles) && user.roles.includes("Tenant");
      } catch (e) {
        return false;
      }
    },
    // CAPTURA REATIVA DOS DADOS DO USUÁRIO LOGADO NO LOCALSTORAGE
    currentUser() {
      const userRaw = localStorage.getItem('user');
      if (userRaw) {
        try {
          return JSON.parse(userRaw);
        } catch (e) {
          return { name: "Músico Cadastrado", email: "" };
        }
      }
      return { name: "Músico Cadastrado", email: "" };
    }
  },
  methods: {
    ...layoutMethods,
    async loadPendingRequests() {
      // SuperAdmin e Contratante não têm acesso ao endpoint /tenants/agenda/requests.
      if (!this.isTenant) {
        this.pendingRequests = [];
        return;
      }

      this.loadingNotifications = true;
      try {
        const token = localStorage.getItem("jwt");
        if (!token) {
          this.pendingRequests = [];
          return;
        }
        const response = await axios.get(
          `${process.env.VUE_APP_API_BASE_URL}/tenants/agenda/requests`,
          { headers: { Authorization: `Bearer ${token}` } }
        );
        this.pendingRequests = (response.data || []).filter(
          request => String(request.status || "").toLowerCase() === "pending"
        );
      } catch (error) {
        console.error("Falha ao carregar avisos da agenda:", error);
        this.pendingRequests = [];
      } finally {
        this.loadingNotifications = false;
      }
    },
    async openAgendaRequests() {
      // O BDropdown desta versão não expõe hide() pelo ref.
      // Acionamos o próprio toggle aberto para fechá-lo antes da navegação.
      const toggle = document.getElementById("page-header-notifications-dropdown");
      if (toggle && toggle.getAttribute("aria-expanded") === "true") {
        toggle.click();
      }

      await this.$nextTick();
      this.$router.push({ name: "musicos-agenda" });
    },
    formatNotificationDate(value) {
      if (!value) return "Data a confirmar";
      const date = new Date(value);
      if (Number.isNaN(date.getTime())) return "Data a confirmar";
      return date.toLocaleDateString("pt-BR");
    },
    toggleHamburgerMenu() {
      var windowSize = document.documentElement.clientWidth;
      let layoutType = document.documentElement.getAttribute("data-layout");

      document.documentElement.setAttribute("data-sidebar-visibility", "show");
      let visiblilityType = document.documentElement.getAttribute("data-sidebar-visibility");

      if (windowSize > 767)
        document.querySelector(".hamburger-icon").classList.toggle("open");

      if (document.documentElement.getAttribute("data-layout") === "horizontal") {
        document.body.classList.contains("menu") ?
          document.body.classList.remove("menu") :
          document.body.classList.add("menu");
      }

      if (visiblilityType === "show" && (layoutType === "vertical" || layoutType === "semibox")) {
        if (windowSize < 1025 && windowSize > 767) {
          document.body.classList.remove("vertical-sidebar-enable");
          document.documentElement.getAttribute("data-sidebar-size") == "sm" ?
            document.documentElement.setAttribute("data-sidebar-size", "") :
            document.documentElement.setAttribute("data-sidebar-size", "sm");
        } else if (windowSize > 1025) {
          document.body.classList.remove("vertical-sidebar-enable");
          document.documentElement.getAttribute("data-sidebar-size") == "lg" ?
            document.documentElement.setAttribute("data-sidebar-size", "sm") :
            document.documentElement.setAttribute("data-sidebar-size", "lg");
        } else if (windowSize <= 767) {
          document.body.classList.add("vertical-sidebar-enable");
          document.documentElement.setAttribute("data-sidebar-size", "lg");
        }
      }
    },
    toggleMenu() {
      this.$parent.toggleMenu();
    },
    toggleRightSidebar() {
      this.$parent.toggleRightSidebar();
    },
    initFullScreen() {
      document.body.classList.toggle("fullscreen-enable");
      if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) {
        if (document.documentElement.requestFullscreen) {
          document.documentElement.requestFullscreen();
        }
      } else {
        if (document.cancelFullScreen) {
          document.cancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
          document.webkitCancelFullScreen();
        }
      }
    },
    toggleDarkMode() {
      if (document.documentElement.getAttribute("data-bs-theme") == "dark") {
        document.documentElement.setAttribute("data-bs-theme", "light");
      } else {
        document.documentElement.setAttribute("data-bs-theme", "dark");
      }
      const mode = document.documentElement.getAttribute("data-bs-theme");
      this.changeMode({ mode: mode });
    },
    
    // ====================================================================
    // MÉTODO DE EXPULSÃO DE SESSÃO ESTADO (LOGOUT STATELESS)
    // ====================================================================
    handleLogout() {
      // 1. Purifica totalmente o LocalStorage eliminando os tokens da Banda Dois
      localStorage.removeItem('jwt');
      localStorage.removeItem('profileStatus');
      localStorage.removeItem('user');
      localStorage.removeItem('username');
      localStorage.removeItem('userEmail');
      
      // 2. Chuta o usuário reativamente de volta para a tela de Login limpa
      this.$router.push('/login');
    }
  },

  mounted() {
    i18n.locale = "pt";
    if (this.isTenant) {
      this.loadPendingRequests();
      this.notificationsTimer = window.setInterval(this.loadPendingRequests, 60000);
    }

    document.addEventListener("scroll", function () {
      var pageTopbar = document.getElementById("page-topbar");
      if (pageTopbar) {
        document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50 ? pageTopbar.classList.add(
          "topbar-shadow") : pageTopbar.classList.remove("topbar-shadow");
      }
    });
    if (document.getElementById("topnav-hamburger-icon"))
      document
        .getElementById("topnav-hamburger-icon")
        .addEventListener("click", this.toggleHamburgerMenu);
  },
  beforeUnmount() {
    if (this.notificationsTimer) window.clearInterval(this.notificationsTimer);
    const hamburger = document.getElementById("topnav-hamburger-icon");
    if (hamburger) hamburger.removeEventListener("click", this.toggleHamburgerMenu);
  },
};
</script>
<template>
  <header id="page-topbar">
    <div class="layout-width">
      <div class="navbar-header">
        <div class="d-flex">
          <!-- LOGO -->
          <div class="navbar-brand-box horizontal-logo">
            <router-link to="/musicos/dashboard" class="logo logo-dark">
              <span class="logo-sm">
                <img src="@/assets/images/logo-sm.png" alt="" height="22" />
              </span>
              <span class="logo-lg">
                <img src="@/assets/images/logo-dark.png" alt="" height="17" />
              </span>
            </router-link>

            <router-link to="/musicos/dashboard" class="logo logo-light">
              <span class="logo-sm">
                <img src="@/assets/images/logo-sm.png" alt="" height="22" />
              </span>
              <span class="logo-lg">
                <img src="@/assets/images/logo-light.png" alt="" height="17" />
              </span>
            </router-link>
          </div>

          <button type="button" class="btn btn-sm px-3 fs-16 header-item vertical-menu-btn topnav-hamburger shadow-none"
            id="topnav-hamburger-icon">
            <span class="hamburger-icon">
              <span></span>
              <span></span>
              <span></span>
            </span>
          </button>
        </div>

        <div class="d-flex align-items-center">
          
          <!-- IDIOMA TRAVADO (TEXTO SEMÂNTICO PURO) -->
          <div class="header-item d-none d-sm-flex align-items-center">
            <span class="fs-13 text-muted fw-bold">PT-BR</span>
          </div>

          <!-- BOTÃO TELA CHEIA -->
          <div class="ms-1 header-item d-none d-sm-flex">
            <BButton type="button" variant="ghost-secondary" class="btn-icon btn-topbar rounded-circle shadow-none"
              data-toggle="fullscreen" @click="initFullScreen">
              <i class="bx bx-fullscreen fs-22"></i>
            </BButton>
          </div>

          <!-- BOTÃO MUDAR TEMA (LIGHT/DARK) -->
          <div class="ms-1 header-item d-none d-sm-flex">
            <BButton type="button" variant="ghost-secondary" class="btn-icon btn-topbar rounded-circle light-dark-mode shadow-none"
              @click="toggleDarkMode">
              <i class="bx bx-moon fs-22"></i>
            </BButton>
          </div>

          <!-- NOTIFICAÇÕES REAIS: SOMENTE ABA RECEBIDAS (PENDING) DA AGENDA -->
          <BDropdown ref="notificationsDropdown" variant="ghost-dark" dropstart class="ms-1 dropdown"
            :offset="{ alignmentAxis: 57, crossAxis: 0, mainAxis: -42 }"
            toggle-class="btn-icon btn-topbar rounded-circle arrow-none shadow-none" id="page-header-notifications-dropdown"
            menu-class="dropdown-menu-lg dropdown-menu-end p-0" auto-close="outside" @show="loadPendingRequests">
            <template #button-content>
              <i class='bx bx-bell fs-22'></i>
              <span v-if="pendingRequests.length > 0" class="position-absolute topbar-badge fs-10 translate-middle badge rounded-pill bg-danger">
                <span class="notification-badge">{{ pendingRequests.length }}</span>
              </span>
            </template>
            <div class="dropdown-head bg-primary bg-pattern rounded-top dropdown-menu-lg">
              <div class="p-3">
                <BRow class="align-items-center">
                  <BCol>
                    <h6 class="m-0 fs-16 fw-semibold text-white">Central de Avisos</h6>
                    <span class="text-white-50 fs-11">Solicitações recebidas aguardando sua decisão</span>
                  </BCol>
                  <BCol cols="auto">
                    <span class="badge bg-danger-subtle text-danger">{{ pendingRequests.length }}</span>
                  </BCol>
                </BRow>
              </div>
            </div>
            <BTabs nav-class="dropdown-tabs nav-tab-custom bg-primary px-2 pt-2">
              <BTab title="Recebidas" class="tab-pane fade py-2 ps-2 show" id="all-noti-tab" role="tabpanel">
                <simplebar data-simplebar style="max-height: 360px" class="pe-2">
                  <div v-if="loadingNotifications && pendingRequests.length === 0" class="text-center py-4 text-muted">
                    <span class="spinner-border spinner-border-sm me-2"></span>Carregando solicitações...
                  </div>
                  <div v-else-if="pendingRequests.length === 0" class="text-center py-4 px-3 text-muted">
                    <i class="bx bx-calendar-check fs-28 d-block mb-2 text-success"></i>
                    <span class="fs-12">Nenhuma solicitação recebida pendente.</span>
                  </div>
                  <div v-for="req in pendingRequests" :key="req.id" class="notification-item d-block dropdown-item position-relative py-3">
                    <div class="d-flex">
                      <div class="avatar-xs me-3 flex-shrink-0">
                        <span class="avatar-title bg-info-subtle text-info rounded-circle fs-16">
                          <i class="bx bx-calendar-event"></i>
                        </span>
                      </div>
                      <div class="flex-grow-1 overflow-hidden">
                        <h6 class="mt-0 mb-1 lh-base text-truncate">{{ req.eventName || 'Nova solicitação de show' }}</h6>
                        <p class="mb-1 fs-12 text-muted text-truncate">{{ req.contractorName || 'Contratante' }}</p>
                        <p class="mb-2 fs-11 text-muted">
                          <strong>{{ req.packageTitle || 'Show' }}</strong> · {{ formatNotificationDate(req.eventDate) }}
                        </p>
                        <button type="button" class="btn btn-sm btn-soft-primary fw-semibold" @click.stop="openAgendaRequests">
                          Ver solicitação
                        </button>
                      </div>
                    </div>
                  </div>
                </simplebar>
              </BTab>
            </BTabs>
          </BDropdown>

          <!-- DROPDOWN DO PERFIL DO MÚSICO LOGADO (CONECTADO AO .NET 10) -->
          <BDropdown variant="link" class="ms-sm-3 header-item topbar-user" toggle-class="rounded-circle arrow-none shadow-none"
            menu-class="dropdown-menu-end" :offset="{ alignmentAxis: -14, crossAxis: 0, mainAxis: 0 }">
            <template #button-content>
              <span class="d-flex align-items-center">
                <img class="rounded-circle header-profile-user" src="@/assets/images/users/user-dummy-img.jpg" alt="Avatar">

                <span class="text-start ms-xl-2">
                  <!-- LEITURA REATIVA DO NOME REAL ENVIADO PELA API -->
                  <span class="d-none d-xl-inline-block ms-1 fw-medium user-name-text">{{ currentUser.name }}</span>
                  <span class="d-none d-xl-block ms-1 fs-12 user-name-sub-text">Painel Privado</span>
                </span>
              </span>
            </template>
            <h6 class="dropdown-header">Opções da Conta</h6>
            
            <router-link class="dropdown-item" to="/musicos/portfolio">
              <i class="mdi mdi-account-circle text-muted fs-16 align-middle me-1"></i>
              <span class="align-middle">Meu Portfólio / EPK</span>
            </router-link>
            
            <router-link class="dropdown-item" to="/musicos/carteira">
              <i class="mdi mdi-wallet text-muted fs-16 align-middle me-1"></i>
              <span class="align-middle">Carteira Digital</span>
            </router-link>
            
            <router-link class="dropdown-item" to="/musicos/assinatura">
              <i class="mdi mdi-cog-outline text-muted fs-16 align-middle me-1"></i>
              <span class="align-middle">Minha Assinatura</span>
            </router-link>
            
            <!-- CORRIGIDO: Modificado de router-link para tag 'a' interceptada pelo método de limpeza -->
            <a class="dropdown-item text-danger" href="javascript:void(0);" @click.prevent="handleLogout">
              <i class="mdi mdi-logout text-danger fs-16 align-middle me-1"></i>
              <span class="align-middle"><b>Sair do Painel</b></span>
            </a>
          </BDropdown>

        </div>
      </div>
    </div>
  </header>
</template>
