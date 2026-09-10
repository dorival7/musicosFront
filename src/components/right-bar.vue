<script>
localStorage.setItem("rightbar_isopen", false);
import { layoutMethods, layoutComputed } from "@/state/helpers";
import simpleBar from "simplebar-vue";

/**
 * Right sidebar component - Higienizado para a Central de Avisos SevenShows
 */
export default {
  name: "RightBar",
  data() {
    return {
      show: false,
    };
  },
  methods: {
    ...layoutMethods,
    click() {
      this.show = !this.show;
    },
    topFunction() {
      document.body.scrollTop = 0;
      document.documentElement.scrollTop = 0;
    },
  },
  mounted() {
    let backtoTop = document.getElementById("back-to-top");
    if (backtoTop) {
      window.onscroll = function () {
        if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
          backtoTop.style.display = "block";
        } else {
          backtoTop.style.display = "none";
        }
      };
    }
    
    // Força o desligamento de preloaders fictícios da demo
    document.documentElement.setAttribute("data-preloader", "disable");
    var setpreloader = document.getElementById("preloader");
    if (setpreloader) {
      setpreloader.style.opacity = "0";
      setpreloader.style.visibility = "hidden";
    }
  },
  computed: {
    ...layoutComputed,
  },
  components: { simpleBar },
};
</script>

<template>
  <div>
    <!-- Preloader Estrutural de Inicialização -->
    <div id="preloader">
      <div id="status">
        <div class="spinner-border text-primary avatar-sm" role="status">
          <span class="visually-hidden">Carregando...</span>
        </div>
      </div>
    </div>

    <!-- Botão de Voltar ao Topo -->
    <BButton variant="danger" @click="topFunction" class="btn-icon" id="back-to-top">
      <i class="ri-arrow-up-line"></i>
    </BButton>

    <!-- 
      A engrenagem flutuante (.customizer-setting) foi FISICAMENTE REMOVIDA daqui.
      A barra lateral agora só abre de forma legítima quando disparada pelas notificações do topo.
    -->

    <!-- CHASSI DA BARRA LATERAL DIREITA: PRESERVADO PARA A CENTRAL DE AVISOS DO MÚSICO -->
    <BOffcanvas class="border-0" id="theme-settings-offcanvas" header-class="d-flex align-items-center bg-primary p-3" body-class="p-0" placement="end" v-model="show">
      <template #header>
        <div class="me-2">
          <h5 class="m-0 me-2 text-white">Central de Notificações</h5>
        </div>
        <button type="button" class="btn-close btn-close-white ms-auto" id="customizerclose-btn" @click="click"></button>
      </template>
      
      <simpleBar class="h-100">
        <div class="p-4">
          <!-- Feed de Eventos Futuros do Artista -->
          <h6 class="mb-3 fw-semibold text-uppercase fs-12 text-primary">Alertas Operacionais</h6>
          
          <div class="card bg-light border-0 shadow-none mb-3">
            <div class="card-body p-3">
              <div class="d-flex align-items-center">
                <div class="avatar-sm flex-shrink-0 me-3">
                  <div class="avatar-title bg-success-subtle text-success rounded fs-18">
                    <i class="ri-checkbox-circle-line"></i>
                  </div>
                </div>
                <div class="flex-grow-1">
                  <h6 class="fs-14 mb-1 fw-semibold">Painel Pronto</h6>
                  <p class="text-muted mb-0 fs-12">Seu ecossistema está 100% configurado nas cores oficiais.</p>
                </div>
              </div>
            </div>
          </div>

          <p class="text-muted text-center fs-12 mt-5">
            Nenhuma nova solicitação de show pendente no momento.
          </p>
        </div>
      </simpleBar>
    </BOffcanvas>
  </div>
</template>

<style lang="scss">
.b-overlay-wrap {
  .b-overlay {
    z-index: 1005 !important;
  }
}
</style>
