<script>
import axios from "axios";
import simplebar from "simplebar-vue";
import { layoutComputed } from "@/state/helpers";

import NavBar from "@/components/nav-bar";
import Menu from "@/components/menu.vue";
import RightBar from "@/components/right-bar";
import Footer from "@/components/footer";
localStorage.setItem('hoverd', false);

/**
 * Vertical layout - Evoluído com Inteligência de Onboarding Financeiro Asaas
 */
export default {
  components: { NavBar, RightBar, Footer, Menu, simplebar },
  data() {
    return {
      isMenuCondensed: false,
      
      // 🆕 ADICIONADO: Estados de controle para a faixa horizontal reativa global
      profileStatus: "",       // Incomplete_Logistics, Incomplete_Packages, Incomplete_Media, Pending_Payment, Active
      asaasAccountStatus: "",  // NOT_CREATED, PENDING, APPROVED
      onboardingLink: ""       // Link oficial seguro do Asaas para envio de documentos
    };
  },
  computed: {
    ...layoutComputed,

    // 🆕 REGRA DE OURO ACORDADA: Define se a faixa deve se expandir no topo de todas as páginas
    exibirBannerCriticoGlobal() {
      // O banner só ganha vida após o músico cumprir a esteira de conteúdo (fotos, etc)
      const completouConteudo = this.profileStatus === 'Pending_Payment' || this.profileStatus === 'Active';
      const carteiraPendente = this.asaasAccountStatus !== 'APPROVED';
      
      // Nova trava de segurança de produto: checa se a rota ativa NÃO é a carteira
      const foraDaTelaCarteira = this.$route.path !== '/musicos/carteira';
      
      return completouConteudo && carteiraPendente && foraDaTelaCarteira;
    }
  },
  created() {
    document.body.removeAttribute("data-layout", "horizontal");
    document.body.removeAttribute("data-topbar", "dark");
    document.body.removeAttribute("data-layout-size", "boxed");
  },
  methods: {
    // 🆕 ADICIONADO: Consulta em background os metadados financeiros legítimos do .NET 10
    async checkGlobalComplianceStatus() {
      try {
        const token = localStorage.getItem('jwt');
        if (!token) return;

        const config = { headers: { Authorization: `Bearer ${token}` } };
        // Consome o endpoint higienizado do TenantsController.cs
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/me`, config);

        this.profileStatus = response.data.profileStatus || "";
        this.asaasAccountStatus = response.data.asaasAccountStatus || "NOT_CREATED";
        this.onboardingLink = response.data.onboardingLink || "";
      } catch (error) {
        console.error("Erro ao sincronizar status global de onboarding:", error);
      }
    },

    updateSidebarSize() {
      let sidebarSize = '';
      if (window.innerWidth < 1025) {
        this.sidebarSize = "sm";
        sidebarSize = 'sm';
      } else {
        this.sidebarSize = "lg";
        sidebarSize = 'lg';
      }
      document.documentElement.setAttribute("data-sidebar-size", sidebarSize);
    },

    initActiveMenu() {
      if (document.documentElement.getAttribute('data-sidebar-size') === 'sm-hover') {
        localStorage.setItem('hoverd', true);
        document.documentElement.setAttribute('data-sidebar-size', 'sm-hover-active');
      } else if (document.documentElement.getAttribute('data-sidebar-size') === 'sm-hover-active') {
        localStorage.setItem('hoverd', false);
        document.documentElement.setAttribute('data-sidebar-size', 'sm-hover');
      } else {
        document.documentElement.setAttribute('data-sidebar-size', 'sm-hover');
      }
    },
    
    toggleMenu() {
      document.body.classList.toggle("vertical-sidebar-enable");
      if (window.innerWidth >= 992) {
        document.body.classList.toggle("vertical-collpsed");
      } else {
        document.body.classList.remove("vertical-collpsed");
      }
      this.isMenuCondensed = !this.isMenuCondensed;
    },
    
    toggleRightSidebar() {
      document.body.classList.toggle("right-bar-enabled");
    },
    hideRightSidebar() {
      document.body.classList.remove("right-bar-enabled");
    },
  },
  mounted() {
    if (localStorage.getItem('hoverd') == 'true') {
      document.documentElement.setAttribute('data-sidebar-size', 'sm-hover-active');
    }

    const overlayElement = document.getElementById('overlay');
    if (overlayElement) {
      overlayElement.addEventListener('click', () => {
        document.body.classList.remove('vertical-sidebar-enable');
      });
    }

    if (window.innerWidth < 1025) {
      document.documentElement.setAttribute("data-sidebar-size", "sm");
    }

    window.addEventListener("resize", this.updateSidebarSize);
    
    document.documentElement.setAttribute("data-layout", "vertical");
    document.documentElement.setAttribute("data-sidebar", "dark");

    // Executa a verificação financeira no ato do boot do chassi
    this.checkGlobalComplianceStatus();

    // 🆕 ES_CUTADOR REATIVO INTER-TELAS: Se o músico simular aprovação na tela de carteira,
    // dispara esse evento na Janela e apaga a faixa horizontal do topo de todas as telas na mesma hora!
    window.addEventListener("wallet-status-updated", () => {
      this.checkGlobalComplianceStatus();
    });
  },
  unmounted() {
    window.removeEventListener("resize", this.updateSidebarSize);
    window.removeEventListener("wallet-status-updated", this.checkGlobalComplianceStatus);
  }
};
</script>
<template>
  <div id="layout-wrapper">
    <NavBar />
    <div>
      <!-- ========== App Menu ========== -->
      <div class="app-menu navbar-menu">
        <!-- LOGO -->
        <div class="navbar-brand-box">
          <!-- Dark Logo-->
          <router-link to="/musicos/dashboard" class="logo logo-dark">
            <span class="logo-sm">
              <img src="@/assets/images/logo-sm.png" alt="SevenShows" height="22" />
            </span>
            <span class="logo-lg">
              <img src="@/assets/images/logo-light.png" alt="SevenShows" height="26" style="filter: brightness(1.3) drop-shadow(0px 0px 4px rgba(255, 255, 255, 0.2));" />
            </span>
          </router-link>
          <!-- Light Logo-->
          <router-link to="/musicos/dashboard" class="logo logo-light">
            <span class="logo-sm">
              <img src="@/assets/images/logo-sm.png" alt="Seven Shows" height="22" />
            </span>
            <span class="logo-lg">
              <img src="@/assets/images/logo-light.png" alt="Seven Shows" height="32" style="width: auto; object-fit: contain;" />
            </span>
          </router-link>
          <button type="button" class="btn btn-sm p-0 fs-20 header-item float-end btn-vertical-sm-hover"
            id="vertical-hover" @click="initActiveMenu">
            <i class="ri-record-circle-line"></i>
          </button>
        </div>

        <simplebar id="scrollbar" class="h-100" ref="scrollbar">
          <Menu></Menu>
        </simplebar>
        <div class="sidebar-background"></div>
      </div>
      <!-- Vertical Overlay-->
      <div class="vertical-overlay" id="overlay"></div>
    </div>

    <!-- CORREÇÃO DO MAIN CONTENT: ACESSA OS SLOTS DE FORMA LIMPA -->
    <div class="main-content">
      <div class="page-content">
        <div class="container-fluid">
          
          <!-- ==================================================================== -->
          <!-- FAIXA HORIZONTAL CRÍTICA GLOBAL: APENAS EM CONTAS PENDENTES DE KYC   -->
          <!-- ==================================================================== -->
          <div v-if="exibirBannerCriticoGlobal" class="alert alert-warning border-0 shadow-sm rounded-3 p-3 mb-4 animate__animated animate__fadeInDown text-start">
            <div class="d-flex align-items-center flex-wrap gap-3">
              <div class="avatar-sm flex-shrink-0">
                <div class="avatar-title bg-soft-warning text-warning rounded-circle fs-20">
                  <i class="ri-error-warning-fill"></i>
                </div>
              </div>
              <div class="flex-grow-1">
                <h6 class="fw-bold text-dark mb-1">Onboarding Financeiro Necessário</h6>
                <p class="text-muted small mb-0" v-if="asaasAccountStatus === 'NOT_CREATED'">
                  Sua vitrine pública já está no ar para captação de clientes, mas você <strong>NÃO PODE RECEBER PAGAMENTOS OU VENDER SHOWS</strong> ainda. É necessário ativar seu recebimento bancário.
                </p>
                <p class="text-muted small mb-0" v-else-if="asaasAccountStatus === 'PENDING'">
                  Sua carteira está conectada, mas as vendas continuam suspensas. Conclua o envio da documentação de segurança no Banco para liberar a sua esteira de shows comerciais.
                </p>
              </div>
              <div class="flex-shrink-0">
                <router-link v-if="asaasAccountStatus === 'NOT_CREATED'" to="/musicos/carteira" class="btn btn-sm btn-warning fw-bold px-3 shadow-sm">
                  <i class="ri-wallet-3-line me-1"></i> Ativar Minha Carteira
                </router-link>
                <router-link v-else-if="asaasAccountStatus === 'PENDING'" to="/musicos/carteira" class="btn btn-sm btn-primary fw-bold px-3 shadow-sm">
                  <i class="ri-upload-cloud-2-line me-1"></i> Concluir Envio de Documentos
                </router-link>
              </div>
            </div>
          </div>

          <!-- PONTO DE INJEÇÃO DAS PÁGINAS (DASHBOARD, AGENDA, PACOTES) -->
          <router-view />

        </div>
      </div>
      <Footer />
    </div>
    <RightBar />
  </div>
</template>
