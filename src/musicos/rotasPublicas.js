// 🏛️ ESTEIRA PÚBLICA SEVENSHOWS: Rotas modularizadas dentro da pasta de músicos
export default [
  {
    path: "/visualizar-lp",
    name: "VisualizarLandingOriginal",
    component: () => import("@/views/landing/index.vue"),
    meta: {
      layout: "public",
      public: true,
      title: "Visualizar Landing Page"
    }
  },
  {
    path: "/quero-vender",
    name: "SouMusico",
    component: () => import("@/views/public/musicos/SouMusico.vue"),
    meta: {
      layout: "public",
      public: true, // Libera o acesso agnóstico para qualquer visitante/músico deslogado
      title: "Quero Vender Shows - SevenShows"
    }
  },
  {
    path: "/artistas",
    name: "CatalogoArtistasPublic",
    component: () => import("@/views/public/CastingView.vue"),
    meta: {
      layout: "public",
      public: true,
      title: "Encontrar Músicos & Bandas"
    }
  },
  {
    path: "/artista/:slug",
    name: "PerfilArtistaPublico",
    component: () => import("@/views/public/ArtistaPerfilPublico.vue"),
    meta: {
      layout: "public",
      public: true,
      title: "Perfil do Artista - SevenShows"
    }
  },
  {
    path: "/parceiros/:slug",
    name: "ParceiroPublico",
    component: () => import("@/views/public/parceiros/ParceiroPublico.vue"),
    meta: { layout: "public", public: true, title: "Parceiro Seven Shows" }
  },
  {
    path: "/checkout/contratacao/:pacoteId",
    name: "CheckoutContratacao",
    component: () => import("@/views/public/checkout/CheckoutContratacao.vue"),
    meta: {
      layout: "public",
      public: true,
      title: "Contratar Atração - SevenShows"
    }
  },
  {
    path: "/contratante/dashboard",
    name: "DashboardContratante",
    component: () => import("@/views/public/contratante/DashboardContratante.vue"),
    meta: {
      layout: "public", // ⚡ Garante o carregamento com a NavbarPublic limpa e sem menus escuros de músicos
      public: true,     // 🔓 Deixa a rota acessível ao interceptador para validação manual
      title: "Painel do Contratante - SevenShows"
    },
    beforeEnter: (to, from, next) => {
      // 🛡️ GUARDA DE SEGURANÇA SÊNIOR: Bloqueia o acesso se não houver o rastro global ativo
      const tokenAtivo = localStorage.getItem("jwt");
      const dadosUsuarioStr = localStorage.getItem("user");

      if (tokenAtivo && dadosUsuarioStr) {
        next(); // Autoriza a entrada limpa no chassi do painel
      } else {
        console.warn("⚠️ [ROUTER] Acesso recusado. Sessão do contratante inexistente ou expirada.");
        next("/"); // Chuta o usuário sem credenciais de volta para a Home
      }
    }
  }
];
