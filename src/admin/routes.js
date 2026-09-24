export default [
  {
    path: "/admin",
    component: () => import("../admin/layouts/AdminLayout.vue"),
    meta: { authRequired: true, role: "SuperAdmin" },
    redirect: "/admin/dashboard",
    children: [
      { path: "dashboard", name: "admin-dashboard", meta: { title: "Administração SaaS", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/dashboard/Index.vue") },
      { path: "tenants", name: "admin-tenants", meta: { title: "Músicos / Tenants", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/tenants/Index.vue") },
      { path: "contratantes", name: "admin-contratantes", meta: { title: "Contratantes", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/contratantes/Index.vue") },
      { path: "planos", name: "admin-planos", meta: { title: "Planos SaaS", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/planos/Index.vue") },
      { path: "assinaturas", name: "admin-assinaturas", meta: { title: "Assinaturas SaaS", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/assinaturas/Index.vue") },
      { path: "financeiro", name: "admin-financeiro", meta: { title: "Financeiro", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/financeiro/Index.vue") },
      { path: "shows", name: "admin-shows", meta: { title: "Shows / Contratações", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/shows/Index.vue") },
      { path: "publicidade", name: "admin-publicidade", meta: { title: "Publicidade", authRequired: true, role: "SuperAdmin" }, component: () => import("../admin/views/publicidade/Index.vue") }
    ]
  }
];
