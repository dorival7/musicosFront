<script>
import simplebar from "simplebar-vue";
import NavBar from "@/components/nav-bar";
import Footer from "@/components/footer";
import AdminMenu from "../components/AdminMenu.vue";

export default {
  name: "AdminLayout",
  components: { simplebar, NavBar, Footer, AdminMenu },
  watch: {
    "$route.fullPath"() {
      this.normalizeUiState();
    }
  },
  created() {
    document.body.removeAttribute("data-layout");
    document.body.removeAttribute("data-topbar");
    document.body.removeAttribute("data-layout-size");
  },
  mounted() {
    document.documentElement.setAttribute("data-layout", "vertical");
    document.documentElement.setAttribute("data-sidebar", "dark");
    if (!document.documentElement.getAttribute("data-sidebar-size")) {
      document.documentElement.setAttribute("data-sidebar-size", window.innerWidth < 1025 ? "sm" : "lg");
    }
    this.normalizeUiState();
  },
  beforeUnmount() {
    this.normalizeUiState();
  },
  methods: {
    normalizeUiState() {
      // Nunca deixa uma camada global de Bootstrap/sidebar bloquear a navegação
      document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());
      document.body.classList.remove("modal-open", "vertical-sidebar-enable", "right-bar-enabled");
      document.body.style.removeProperty("overflow");
      document.body.style.removeProperty("padding-right");
    },
    toggleMenu() {
      if (window.innerWidth >= 992) {
        document.body.classList.toggle("vertical-collpsed");
        document.body.classList.remove("vertical-sidebar-enable");
      } else {
        document.body.classList.remove("vertical-collpsed");
        document.body.classList.toggle("vertical-sidebar-enable");
      }
    },
    toggleRightSidebar() {
      document.body.classList.toggle("right-bar-enabled");
    },
    closeMobileSidebar() {
      document.body.classList.remove("vertical-sidebar-enable");
    }
  }
};
</script>

<template>
  <div id="layout-wrapper">
    <NavBar />
    <div>
      <div class="app-menu navbar-menu">
        <div class="navbar-brand-box">
          <router-link to="/admin/dashboard" class="logo logo-light">
            <span class="logo-sm"><img src="@/assets/images/logo-sm.png" height="22" /></span>
            <span class="logo-lg"><img src="@/assets/images/logo-light.png" height="32" /></span>
          </router-link>
        </div>
        <simplebar id="scrollbar" class="h-100"><AdminMenu /></simplebar>
        <div class="sidebar-background"></div>
      </div>
      <div id="admin-overlay" class="vertical-overlay" @click="closeMobileSidebar"></div>
    </div>

    <div class="main-content">
      <div class="page-content">
        <div class="container-fluid">
          <div class="alert alert-info border-0 shadow-sm d-flex align-items-center gap-2">
            <i class="ri-shield-star-line fs-20"></i>
            <div>
              <strong>Administração Global Seven Shows</strong>
              <div class="small">Ambiente exclusivo SuperAdmin</div>
            </div>
          </div>
          <router-view />
        </div>
      </div>
      <Footer />
    </div>
  </div>
</template>
