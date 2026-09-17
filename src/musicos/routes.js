export default [
  {
    path: "/musicos",
    component: () => import("../layouts/vertical.vue"), // O chassi mestre que desenha as barras, topo e faixas
    meta: { authRequired: true },
    children: [
      {
        path: "dashboard",
        name: "musicos-dashboard",
        meta: { title: "Visão Geral", authRequired: true },
        component: () => import("../musicos/views/Dashboard.vue")
      },
      {
        path: "recursos-ia",
        name: "musicos-recursos-ia",
        meta: { title: "Recursos de IA", authRequired: true },
        component: () => import("../musicos/views/ia/HubRecursosIA.vue")
      },
      {
        path: "minha-vitrine",
        name: "MinhaVitrineAdmin",
        component: () => import("../musicos/views/VitrineView.vue"),
        meta: {
          title: "Configurar Vitrine Pública",
          requiresAuth: true // Garante a proteção por token JWT do .NET 10
        }
      },
      {
        path: "agenda",
        name: "musicos-agenda",
        meta: { title: "Minha Agenda", authRequired: true },
        component: () => import("../musicos/views/Agenda.vue")
      },
      {
        path: "carteira",
        name: "musicos-carteira",
        meta: { title: "Carteira Digital", authRequired: true },
        component: () => import("../musicos/views/Carteira.vue")
      },
      {
        path: "logistica",
        name: "musicos-logistica",
        meta: { title: "Configurações de Logística", authRequired: true },
        component: () => import("../musicos/views/Logistica.vue")
      },
      {
        path: "pacotes",
        name: "musicos-pacotes",
        meta: { title: "Formatos de Shows", authRequired: true },
        component: () => import("../musicos/views/Pacotes.vue")
      },
      {
        path: "portfolio",
        name: "musicos-portfolio",
        meta: { title: "Meu Portfólio / EPK", authRequired: true },
        component: () => import("../musicos/views/PortifolioMestre.vue")
      },
      {
        path: "assinatura",
        name: "musicos-assinatura",
        meta: { title: "Minha Assinatura", authRequired: true },
        component: () => import("../musicos/views/Assinatura.vue")
      },

      // 🆕 INJEÇÃO FILHA: Rota aninhada de forma legítima no chassi mestre
      // Força a renderização correta das barras de menus ao redor do layout de migração!
      {
        path: "assinatura/migrar",
        name: "musicos-assinatura-migrar",
        meta: { title: "Alterar Plano de Assinatura", authRequired: true },
        component: () => import("../musicos/views/MigrarPlanos.vue")
      }
    ]
  }
];
