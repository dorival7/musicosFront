<script>
import {
  layoutComputed
} from "@/state/helpers";

export default {
  data() {
    return {
      settings: {
        minScrollbarLength: 60,
      },
    };
  },
  computed: {
    ...layoutComputed,
    layoutType: {
      get() {
        return this.$store ? this.$store.state.layout.layoutType : {} || {};
      },
    },
  },

  watch: {
    $route: {
      handler: "onRoutechange",
      immediate: true,
      deep: true,
    },
  },

  mounted() {
    this.initActiveMenu();
    if (this.rmenu == 'vertical' && this.layoutType == 'twocolumn') {
      document.documentElement.setAttribute("data-layout", "vertical");
    }
    document.getElementById('overlay').addEventListener('click', () => {
      document.body.classList.remove('vertical-sidebar-enable');
    });

    window.addEventListener("resize", () => {
      if (this.layoutType == 'twocolumn') {
        var windowSize = document.documentElement.clientWidth;
        if (windowSize < 767) {
          document.documentElement.setAttribute("data-layout", "vertical");
          this.rmenu = 'vertical';
          localStorage.setItem('rmenu', 'vertical');
        } else {
          document.documentElement.setAttribute("data-layout", "vertical");
          this.rmenu = 'twocolumn';
          localStorage.setItem('rmenu', 'twocolumn');
          setTimeout(() => {
            this.initActiveMenu();
          }, 50);
        }
      }
    });
  },

  methods: {
    isRouteActive(path, includeChildren = false) {
      const currentPath = this.$route?.path || window.location.pathname;
      return includeChildren
        ? currentPath === path || currentPath.startsWith(`${path}/`)
        : currentPath === path;
    },

    onRoutechange(ele) {
      // Ao navegar pelo menu no celular, fecha a sidebar e devolve o foco ao conteúdo.
      if (window.innerWidth < 768) {
        document.body.classList.remove('vertical-sidebar-enable');
      }

      this.initActiveMenu(ele.path);
      if (document.getElementsByClassName("mm-active").length > 0) {
        const currentPosition = document.getElementsByClassName("mm-active")[0].offsetTop;
        if (currentPosition > 500)
          if (this.$refs.isSimplebar)
            this.$refs.isSimplebar.value.getScrollElement().scrollTop = currentPosition + 300;
      }
    },

    initActiveMenu() {
      const pathName = window.location.pathname;
      const ul = document.getElementById("navbar-nav");
      if (ul) {
        const items = Array.from(ul.querySelectorAll("a.nav-link"));
        let activeItems = items.filter((x) => x.classList.contains("active"));
        this.removeActivation(activeItems);
        let matchingMenuItem = items.find((x) => {
          return x.getAttribute("href") === pathName;
        });
        if (matchingMenuItem) {
          this.activateParentDropdown(matchingMenuItem);
        }
      }
    },

    removeActivation(items) {
      items.forEach((item) => {
        if (item.classList.contains("menu-link")) {
          if (!item.classList.contains("active")) {
            item.setAttribute("aria-expanded", false);
          }
          item?.nextElementSibling?.classList?.remove("show");
        }
        if (item.classList.contains("nav-link")) {
          if (item.nextElementSibling) {
            item?.nextElementSibling?.classList?.remove("show");
          }
          item.setAttribute("aria-expanded", false);
        }
        item.classList.remove("active");
      });
    },

    activateParentDropdown(item) {
      item.classList.add("active");
      let parentCollapseDiv = item.closest(".collapse.menu-dropdown");
      if (parentCollapseDiv) {
        parentCollapseDiv.classList.add("show");
        parentCollapseDiv.parentElement.children[0].classList.add("active");
        parentCollapseDiv.parentElement.children[0].setAttribute("aria-expanded", "true");
        return false;
      }
      return false;
    }
  },
};
</script>

<template>
  <BContainer fluid>
    <div id="two-column-menu"></div>

    <template v-if="layoutType === 'vertical' || layoutType === 'semibox'">
      <ul class="navbar-nav h-100" id="navbar-nav">
        
        <!-- SEÇÃO 1: VISÃO GERAL -->
        <li class="menu-title">
          <span>Visão Geral</span>
        </li>
        
        <li class="nav-item">
          <router-link to="/musicos/dashboard" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/dashboard') }">
            <i class="mdi mdi-speedometer"></i>
            <span>Início / Resumo</span>
          </router-link>
        </li>

        <!-- SEÇÃO 2: GESTÃO DO ARTISTA -->
        <li class="menu-title">
          <span>Gestão do Artista</span>
        </li>

        <li class="nav-item">
          <router-link to="/musicos/agenda" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/agenda') }">
            <i class="mdi mdi-calendar-month-outline"></i>
            <span>Minha Agenda</span>
          </router-link>
        </li>

        <li class="nav-item">
          <router-link to="/musicos/pacotes" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/pacotes') }">
            <i class="mdi mdi-package-variant-closed"></i>
            <span>Pacotes de Shows</span>
          </router-link>
        </li>

        <li class="nav-item">
          <router-link to="/musicos/portfolio" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/portfolio') }">
            <i class="mdi mdi-image-multiple-outline"></i>
            <span>Meu Portfólio / EPK</span>
          </router-link>
        </li>

        <!-- SEÇÃO 3: CONFIGURAÇÕES E FINANÇAS -->
        <li class="menu-title">
          <span>Configurações e Finanças</span>
        </li>

        <li class="nav-item">
          <router-link to="/musicos/logistica" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/logistica') }">
            <i class="mdi mdi-truck-delivery-outline"></i>
            <span>Taxas de Deslocamento</span>
          </router-link>
        </li>

        <li class="nav-item">
          <router-link to="/musicos/carteira" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/carteira') }">
            <i class="mdi mdi-wallet-outline"></i>
            <span>Carteira de Recebimentos</span>
          </router-link>
        </li>

        <li class="nav-item">
          <router-link to="/musicos/assinatura" class="nav-link menu-link" :class="{ active: isRouteActive('/musicos/assinatura', true) }">
            <i class="mdi mdi-credit-card-clock-outline"></i>
            <span>Minha Assinatura</span>
          </router-link>
        </li>

        <!-- CATEGORIA INDEPENDENTE DE RECURSOS DE INTELIGÊNCIA ARTIFICIAL -->
        <li class="menu-title"><span data-key="t-ia">Inteligência Artificial</span></li>
    
        <li class="nav-item">
            <router-link to="/musicos/recursos-ia" class="nav-link menu-link d-flex align-items-center gap-2" :class="{ active: isRouteActive('/musicos/recursos-ia') }">
                <i class="ri-brain-line"></i> 
                <span data-key="t-recursos-ia" class="font-monospace text-uppercase">Seven Shows IA</span>
            </router-link>
        </li>
      </ul>
    </template>
  </BContainer>
</template>


<style scoped>
/* Estado visual único e automático para a rota atual do menu do músico. */
#navbar-nav .nav-link.menu-link {
  position: relative;
  border-radius: 7px;
  margin: 2px 10px;
  color: #9fb0b9;
  transition: background-color .18s ease, color .18s ease, transform .18s ease;
}

#navbar-nav .nav-link.menu-link i,
#navbar-nav .nav-link.menu-link span {
  color: inherit !important;
}

#navbar-nav .nav-link.menu-link:hover {
  color: #dce7eb;
  background: rgba(255,255,255,.055);
}

#navbar-nav .nav-link.menu-link.active {
  color: #ffffff !important;
  background: rgba(0, 188, 188, .14);
  box-shadow: inset 3px 0 0 #00b8b8;
}

#navbar-nav .nav-link.menu-link.active i {
  color: #22d3d3 !important;
}
</style>
