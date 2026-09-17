import { createApp } from 'vue';
import App from './App.vue';
import router from "./router";
import AOS from 'aos';
import 'aos/dist/aos.css';
import i18n from './i18n';
import store from "./state/store";
import VueKonva from "vue-konva";

import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';

import BootstrapVueNext from 'bootstrap-vue-next';
import vClickOutside from "click-outside-vue3";
import VueApexCharts from "vue3-apexcharts";
import { vMaska } from "maska";

import VueFeather from 'vue-feather';
import axios from 'axios'; // Importação explícita do motor de rede Axios

import '@/assets/scss/config/material/app.scss';
import '@/assets/scss/mermaid.min.css';
import 'bootstrap/dist/js/bootstrap.bundle';

// ====================================================================
// INTERCEPTADOR GLOBAL DE RESPOSTAS AXIOS: TRATAMENTO DE SESSÃO EXPIRADA (401)
// ====================================================================
axios.interceptors.response.use(
  (response) => {
    // Se a API .NET 10 responder com sucesso, apenas repassa os dados normais para as telas
    return response;
  },
  (error) => {
    // Captura o erro 401 (Unauthorized) no ato e desvia a rota para o Login
    if (error.response && error.response.status === 401) {
      console.warn("Sessão expirada capturada pelo Interceptor. Redirecionando para o login...");
      
      // Limpa os resquícios locais para desatar o nó de autenticação
      localStorage.removeItem('jwt');
      localStorage.removeItem('profileStatus');
      
      // Força o roteador a empurrar a tela do músico de volta para o Login de forma automática
      router.push('/login');
    }
    return Promise.reject(error);
  }
);

// DESATIVADO: FakeBackend chumbado de fábrica do Velzon removido do chassi
// import { configureFakeBackend } from './helpers/fake-backend';
// configureFakeBackend();

AOS.init({
    easing: 'ease-out-back',
    duration: 1000
});

createApp(App)
    .use(VueKonva)
    .use(store)
    .use(router)
    .use(VueApexCharts)
    .use(BootstrapVueNext)
    .component(VueFeather.type, VueFeather)
    .directive("maska", vMaska)
    .use(i18n)
    .use(VueSweetalert2)
    .use(vClickOutside).mount('#app');
