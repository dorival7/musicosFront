/* eslint-disable */
import { createWebHistory, createRouter } from "vue-router";
import axios from 'axios';
import appConfig from "../../app.config";

// 🚀 HUB DE ROTAS SEVENSHOWS (MODULARIZADO DENTRO DE MUSICOS)
import musicosRoutes from "../musicos/routes";
import publicRoutes from "../musicos/rotasPublicas";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    ...publicRoutes,
    ...musicosRoutes,
    
    {
      path: "/",
      name: "login-root",
      component: () => import("../views/account/login.vue")
    },
    {
      path: "/login",
      name: "login",
      component: () => import("../views/account/login.vue")
    },
    {
      path: "/login-cliente",
      name: "login-cliente",
      component: () => import("../views/account/login-cliente.vue")
    }
  ],
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition;
    return { top: 0, left: 0 };
  },
});

// ====================================================================
// INTERCEPTADOR GLOBAL DE SEGURANÇA SEVENSHOWS (NAVIGATION GUARD DEFINITIVO)
// ====================================================================
router.beforeEach(async (routeTo, routeFrom, next) => {
  
  // 🚀 INJETADO: BLINDAGEM AUTOMÁTICA CONTRA REDIRECIONAMENTOS FORÇADOS E LOGOFFS LATERAIS
  if (routeTo.path === '/login') {
    const vinhaDoPainelDoMusico = routeFrom.path && routeFrom.path.includes('/musicos/');
    
    // Se o usuário não vinha da área privada do artista, desvia o logoff forçado para a Home pública
    if (!vinhaDoPainelDoMusico) {
      return next('/');
    }
  }

  // --- Mantém intacta toda a estrutura original validada e aprovada do projeto ---
  const title = routeTo.meta?.title;
  if (title) {
    document.title = `${title} | ${appConfig.title}`;
  }

  const authRequired = routeTo.matched.some((route) => route.meta?.authRequired);

  // Se a rota for pública (catálogo, perfil, checkout), libera o acesso na hora sem travas de login
  if (!authRequired) return next();

  const token = localStorage.getItem('jwt');

  // TRAVA DE LOGIN PRIVADA
  if (!token) {
    return next({ name: 'login', query: { redirectFrom: routeTo.fullPath } });
  }

  axios.defaults.headers.common['authorization'] = 'Bearer ' + token;

  // Liberdade total para os fluxos internos
  next();
});

export default router;
