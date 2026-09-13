<template>
  <!-- 🛠️ RESOLUÇÃO COMPLETA: Remove as amarras do Velzon e força a visibilidade contínua do topo -->
  <div class="seven-portal"
    style="display: block !important; position: relative; width: 100%; min-height: 100vh; background-color: #0a0b10 !important;">

    <!-- COMPONENTE 1: MENU SUPERIOR NACIONALIZADO -->
    <NavbarPublic />

    <div class="vertical-overlay" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent.show"></div>

    <!-- COMPONENTE 2: ABERTURA HERO COM BARRA DE BUSCA EM LINHA -->
    <HeroPublic />

    <!-- CARROSSEL DE ARTISTAS EM DESTAQUE (MANTIDO DO DESIGN BASE) -->
    <div class="pt-5 mt-5">
      <BContainer>
        <BRow>
          <BCol lg="12">
            <div class="text-center mt-5">
              <h5 class="fs-20 text-white font-monospace text-uppercase mb-1" style="letter-spacing: 0.5px;">
                Artistas em <span class="text-primary text-decoration-underline">Destaque</span> na Plataforma
              </h5>
              <p class="text-muted small mb-4">Conheça algumas das grandes atrações disponíveis para o seu espetáculo
              </p>

              <div class="trusted-client-slider mt-sm-5 mt-4 mb-sm-5 mb-4">

                <!-- SWIPER REATIVO INTEGRADO AO ECOSSISTEMA SEVENSHOWS -->
                <swiper class="swiper responsive-swiper rounded gallery-light pb-4" :loop="artistasLista.length > 4"
                  :autoplay="{ delay: 3000, disableOnInteraction: false }" :modules="[Autoplay]" :slidesPerView="1"
                  :spaceBetween="20" :breakpoints="{
                    640: { slidesPerView: 2, spaceBetween: 20 },
                    768: { slidesPerView: 3, spaceBetween: 30 },
                    1200: { slidesPerView: 4, spaceBetween: 30 }
                  }">
                  <!-- LAÇO REATIVO: Renderiza um slide para cada músico do MariaDB -->
                  <swiper-slide v-for="artista in artistasLista" :key="artista.Id || artista.id">
                    <div class="modern-card overflow-hidden d-flex flex-column w-100 test-start"
                      @click="handleNavigateToArtist(artista.slug || artista.Slug)"
                      style="cursor: pointer; border-radius: 16px !important; text-align: left; background-color: #131520; min-height: 380px;">
                      <!-- CONTAINER FOTO DE CAPA COM DIMENSÕES MISTAS -->
                      <div class="position-relative overflow-hidden border-bottom border-light border-opacity-5"
                        style="height: 180px; min-height: 180px; background-color: #141622;">
                        <img
                          :src="(artista.fotoCapaUrl || artista.FotoCapaUrl) ? obterUrlImagem(artista.fotoCapaUrl || artista.FotoCapaUrl) : require('@/assets/images/banner-artist-default.jpg')"
                          alt="Foto de Capa" class="w-100 h-100 object-fit-cover artist-card-img" />

                        <!-- BADGES DE IDENTIFICAÇÃO SOBRE A IMAGEM -->
                        <div class="position-absolute top-0 end-0 m-2 d-flex flex-row gap-1 align-items-start"
                          style="z-index: 3;">
                          <span
                            class="badge bg-primary fw-bold font-monospace text-uppercase fs-10 rounded-pill shadow-sm py-1 px-2"
                            style="background-color: #ff6c22 !important; letter-spacing: 0.5px;">
                            {{ artista.estiloMusical || artista.EstiloMusical || 'Geral' }}
                          </span>
                          <span
                            class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-20 fw-bold font-monospace text-uppercase fs-10 rounded-pill shadow-sm py-1 px-2"
                            style="background-color: rgba(41,156,219,0.1) !important; color: #299cdb !important; border-color: rgba(41,156,219,0.2) !important;">
                            {{ artista.formatoArtístico || artista.FormatoArtístico || 'Banda' }}
                          </span>
                        </div>
                      </div>

                      <!-- CONTEÚDO CORRIGIDO COM ESTRUTURA SEM PREÇOS -->
                      <div class="p-3 d-flex flex-column flex-grow-1">
                        <h5 class="text-white fw-bold font-monospace text-uppercase fs-15 text-truncate mb-1"
                          style="letter-spacing: -0.5px; margin-top: 0;">
                          {{ artista.nomeBanda || artista.NomeBanda || 'Atração Sem Nome' }}
                        </h5>

                        <!-- SLOGAN LIMITADO A DUAS LINHAS -->
                        <p class="text-muted small mb-3 text-truncate-2 font-monospace fs-12 lh-base"
                          style="color: #9ca3af !important; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 36px; margin-bottom: 15px;">
                          {{ artista.slogan || artista.Slogan || 'Nenhum slogan comercial cadastrado.' }}
                        </p>

                        <!-- LOCALIZAÇÃO PURA ANCORANDO O RODAPÉ DO CARD -->
                        <p class="text-muted small mb-0 d-flex align-items-center gap-1 fs-13 mt-auto"
                          style="color: #ced4da !important; margin-bottom: 0;">
                          <i class="ri-map-pin-line fs-15" style="color: #ff6c22;"></i> Atende:
                          {{ artista.cidadeAtendida || artista.CidadeAtendida || 'Não informada' }}
                          <span v-if="artista.state || artista.State"> - {{ artista.state || artista.State }}</span>
                        </p>
                      </div>
                    </div>
                  </swiper-slide>
                </swiper>

                <!-- BOTÃO INSTITUCIONAL DE NAVEGAÇÃO -->
                <div class="text-center mt-4 animate__animated animate__fadeInUp">
                  <router-link to="/artistas"
                    class="btn btn-outline-primary btn-lg fw-bold px-5 text-uppercase font-monospace fs-14"
                    style="height: 50px; border-radius: 25px !important; display: inline-flex; align-items: center; justify-content: center; letter-spacing: 0.5px;">
                    <i class="ri-user-search-line me-2 fs-18"></i> Ver Todos os Artistas Cadastrados
                  </router-link>
                </div>

              </div>
            </div>
          </BCol>
        </BRow>
      </BContainer>
    </div>

    <!-- SEÇÃO DA TRÍADE DE SEGURANÇA SEVENSHOWS -->
    <section class="section" id="seguranca">
      <BContainer>
        <BRow class="justify-content-center">
          <BCol lg="8">
            <div class="text-center mb-5">
              <h1 class="mb-3 ff-secondary fw-semibold lh-base text-white">Contratação Segura com
                Tecnologia de Ponta</h1>
              <p class="text-muted fs-15">Garantimos transparência absoluta e proteção jurídica para
                contratantes e músicos em cada evento realizado no país.</p>
            </div>
          </BCol>
        </BRow>

        <BRow class="g-3">
          <BCol lg="4">
            <div class="d-flex p-3 card-h border-0 rounded-3 p-4" style="background-color: #131520;">
              <div class="flex-shrink-0 me-3">
                <div class="avatar-sm icon-effect">
                  <div class="avatar-title bg-transparent text-primary rounded-circle">
                    <i class="ri-lock-password-line fs-36"></i>
                  </div>
                </div>
              </div>
              <div class="flex-grow-1">
                <h5 class="fs-18 fw-bold text-white">Custódia do Cachê</h5>
                <p class="text-muted my-3 ff-secondary small">O pagamento fica guardado de forma
                  protegida e só é liberado para a conta do músico após a realização física do show.
                </p>
              </div>
            </div>
          </BCol>
          <BCol lg="4">
            <div class="d-flex p-3 card-h border-0 rounded-3 p-4" style="background-color: #131520;">
              <div class="flex-shrink-0 me-3">
                <div class="avatar-sm icon-effect">
                  <div class="avatar-title bg-transparent text-primary rounded-circle">
                    <i class="ri-file-shield-2-line fs-36"></i>
                  </div>
                </div>
              </div>
              <div class="flex-grow-1">
                <h5 class="fs-18 fw-bold text-white">Contrato Automatizado</h5>
                <p class="text-muted my-3 ff-secondary small">Geração digital e instantânea de termos de
                  prestação de serviços com validade jurídica assegurada para ambas as partes.</p>
              </div>
            </div>
          </BCol>
          <BCol lg="4">
            <div class="d-flex p-3 card-h border-0 rounded-3 p-4" style="background-color: #131520;">
              <div class="flex-shrink-0 me-3">
                <div class="avatar-sm icon-effect">
                  <div class="avatar-title bg-transparent text-primary rounded-circle">
                    <i class="ri-calendar-check-line fs-36"></i>
                  </div>
                </div>
              </div>
              <div class="flex-grow-1">
                <h5 class="fs-18 fw-bold text-white">Agenda Blindada</h5>
                <p class="text-muted my-3 ff-secondary small">Sincronização reativa em tempo real
                  diretamente com o banco de dados do artista, eliminando riscos de choque de
                  horários.</p>
              </div>
            </div>
          </BCol>
        </BRow>
      </BContainer>
    </section>
    <!-- ==================================================================== -->
    <!-- SEÇÃO 1: COMO FUNCIONA PARA CONTRATANTES (LINHA DO TEMPO VISUAL)     -->
    <!-- ==================================================================== -->
    <section class="section border-top border-light border-opacity-5" id="como-funciona"
      style="padding-top: 80px; padding-bottom: 80px;">
      <BContainer>
        <BRow class="justify-content-center">
          <BCol lg="8">
            <div class="text-center mb-5 animate__animated animate__fadeIn">
              <span
                class="badge bg-primary-subtle text-primary fw-bold text-uppercase px-3 py-2 rounded-pill fs-11 mb-2">
                🛡️ O MELHOR PARA O SEU EVENTO!!!
              </span>
              <h2 class="mb-3 fw-bold text-white display-6">Contratar uma Banda nunca foi tão Simples</h2>
              <p class="text-muted fs-15">Esqueça ligações cansativas e burocracia. No SevenShows você
                resolve tudo em poucos minutos com total transparência.</p>
            </div>
          </BCol>
        </BRow>

        <BRow class="g-4">
          <!-- PASSO 01 -->
          <BCol lg="4" md="6">
            <div class="p-4 rounded-3 h-100 position-relative border border-light border-opacity-5 modern-card"
              style="background-color: #131520; cursor: pointer;" @click="$router.push('/artistas')">
              <div
                class="display-4 text-primary font-monospace fw-bold position-absolute opacity-10 end-0 top-0 me-3 mt-2"
                style="font-size: 64px;">01</div>
              <div
                class="avatar-sm bg-soft-primary text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center"
                style="width: 45px; height: 45px; background-color: rgba(255, 108, 34, 0.1) !important;">
                <i class="ri-search-eye-line fs-20"></i>
              </div>
              <h5 class="text-white fw-bold fs-16 mb-2">Explore & Escolha</h5>
              <p class="text-muted mb-0 small" style="color: #9ca3af !important;">Clique aqui para acessar
                o nosso catálogo completo. Filtre nosso casting por gênero musical, faixa de preço e
                região antes de mandar a proposta.</p>
            </div>
          </BCol>

          <!-- PASSO 02 -->
          <BCol lg="4" md="6">
            <div class="p-4 rounded-3 h-100 position-relative border border-light border-opacity-5"
              style="background-color: #131520;">
              <div
                class="display-4 text-primary font-monospace fw-bold position-absolute opacity-10 end-0 top-0 me-3 mt-2"
                style="font-size: 64px;">02</div>
              <div
                class="avatar-sm bg-soft-primary text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center"
                style="width: 45px; height: 45px;">
                <i class="ri-map-pin-time-line fs-20"></i>
              </div>
              <h5 class="text-white fw-bold fs-16 mb-2">Calcule a Logística</h5>
              <p class="text-muted mb-0 small">Selecione o pacote desejado e informe o CEP do evento. O
                sistema consulta as tabelas do músico e calcula o frete por KM reativamente.</p>
            </div>
          </BCol>

          <!-- PASSO 03 -->
          <BCol lg="4" md="6">
            <div class="p-4 rounded-3 h-100 position-relative border border-light border-opacity-5"
              style="background-color: #131520;">
              <div
                class="display-4 text-primary font-monospace fw-bold position-absolute opacity-10 end-0 top-0 me-3 mt-2"
                style="font-size: 64px;">03</div>
              <div
                class="avatar-sm bg-soft-primary text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center"
                style="width: 45px; height: 45px;">
                <i class="ri-bank-card-line fs-20"></i>
              </div>
              <h5 class="text-white fw-bold fs-16 mb-2">Pagamento Seguro</h5>
              <p class="text-muted mb-0 small">Efetue o pagamento via PIX ou cartão. O cachê fica retido
                em custódia bancária segura e só é liberado para o músico após o show.</p>
            </div>
          </BCol>
        </BRow>
      </BContainer>
    </section>

    <!-- ==================================================================== -->
    <!-- SEÇÃO: ÁREA DO MÚSICO (VITRINE ESTILIZADA DE ALTA CONVERSÃO)         -->
    <!-- ==================================================================== -->
    <section class="section border-top border-light border-opacity-5" id="vantagens-musico"
      style="padding-top: 100px; padding-bottom: 100px; background-color: #0a0b10 !important;">
      <BContainer>
        <BRow class="justify-content-center">

          <!-- CONTEÚDO EM TELA CHEIA INTEGRADO -->
          <BCol lg="10" class="text-center">
            <span
              class="badge border border-primary border-opacity-30 text-primary fw-bold text-uppercase px-3 py-2 rounded-pill fs-12 mb-3 font-monospace modern-badge"
              style="background-color: rgba(255, 108, 34, 0.08) !important; letter-spacing: 1px;">
              🚀 Multiplique Seus Contratos
            </span>

            <h2 class="text-white fw-bold display-5 mb-3 font-monospace text-uppercase main-title-glow"
              style="letter-spacing: -1px;">
              Você é Cantor, Músico ou <br />
              Tem uma <span class="text-primary text-gradient-orange">Banda?</span>
            </h2>

            <!-- 🛠️ CORREÇÃO CIRÚRGICA DO TEXTO: DESTAQUE IMPACTANTE E ARREDONDADO -->
            <h3 class="text-white fw-bold fs-26 my-4 font-monospace text-uppercase"
              style="color: #ff6c22 !important; letter-spacing: 0.5px;">
              🔥 VENDA MUITO MAIS SHOWS E LOTE SUA AGENDA!
            </h3>

            <h5 class="text-light fw-medium fs-18 mb-5 lh-base mx-auto text-muted-custom"
              style="max-width: 780px; opacity: 0.95; color: #ced4da !important;">
              Melhore a gestão da sua carreira e seja visto por milhares de contratantes, donos de bares,
              organizadores de casamentos e produtores que buscam o seu estilo de som todos os dias.
            </h5>

            <p class="text-muted fs-16 mb-5 mx-auto"
              style="max-width: 840px; color: #a3a3a3 !important; line-height: 1.7;">
              Chega de ficar esperando mensagens no WhatsApp ou dependendo apenas de indicações. No
              SevenShows, você ganha uma **Vitrine Digital Irresistível** e um **Painel de Controle
              Inteligente** exclusivo para acompanhar propostas em tempo real, ver seus históricos de
              extratos e garantir datas fechadas de forma rápida e segura.
            </p>

            <!-- 🛠️ ELEMENTOS COMPLETAMENTE ESTILIZADOS: BORDAS ARREDONDADAS E FLUTUAÇÃO NEON -->
            <BRow class="text-start g-4 mb-5 justify-content-center">

              <!-- BENEFÍCIO 1 -->
              <BCol md="6" lg="4">
                <div class="p-4 h-100 modern-card">
                  <div
                    class="avatar-sm text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center modern-icon-wrapper">
                    <i class="ri-rocket-line fs-22"></i>
                  </div>
                  <h5 class="text-white fw-bold fs-17 mb-2">Acelerador de Shows</h5>
                  <p class="text-muted small mb-0 fs-14" style="line-height: 1.6; color: #a3a3a3 !important;">Sua banda
                    em destaque no
                    maior catálogo do país. Contratantes filtram por preço e estilo de som e fecham
                    o agendamento direto pelo portal de forma automática.</p>
                </div>
              </BCol>

              <!-- BENEFÍCIO 2 -->
              <BCol md="6" lg="4">
                <div class="p-4 h-100 modern-card">
                  <div
                    class="avatar-sm text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center modern-icon-wrapper">
                    <i class="ri-money-dollar-circle-line fs-22"></i>
                  </div>
                  <h5 class="text-white fw-bold fs-17 mb-2">Recebimento Garantido</h5>
                  <p class="text-muted small mb-0 fs-14" style="line-height: 1.6; color: #a3a3a3 !important;">O cliente
                    realiza o
                    pagamento e o valor do seu cachê fica guardado com total segurança. Você sobe ao
                    palco focado no espetáculo, sabendo que seu dinheiro já está garantido.</p>
                </div>
              </BCol>

              <!-- BENEFÍCIO 3 -->
              <BCol md="6" lg="4">
                <div class="p-4 h-100 modern-card">
                  <div
                    class="avatar-sm text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center modern-icon-wrapper">
                    <i class="ri-calendar-todo-line fs-22"></i>
                  </div>
                  <h5 class="text-white fw-bold fs-17 mb-2">Controle Digital da Agenda</h5>
                  <p class="text-muted small mb-0 fs-14" style="line-height: 1.6; color: #a3a3a3 !important;">Gerencie
                    datas livres e
                    bloqueie dias de folga ou compromissos particulares. O sistema atualiza sua
                    vitrine em tempo real, evitando qualquer tipo de choque de horários.</p>
                </div>
              </BCol>

            </BRow>

            <!-- BOTÃO MESTRE IMPONENTE COM CANTOS CURVOS E NEON -->
            <div class="mt-4">
              <router-link to="/quero-vender"
                class="btn btn-primary btn-lg fw-bold px-5 text-uppercase font-monospace fs-14 modern-action-button">
                <i class="ri-flashlight-line me-2 fs-18"></i> Impulsionar Minha Agenda Agora
              </router-link>
            </div>

          </BCol>
        </BRow>
      </BContainer>
    </section>


  </div>
</template>
<script>
/* eslint-disable no-unused-vars */
/* eslint-disable vue/no-unused-components */
import { Autoplay, Navigation, Pagination } from "swiper/modules";
import { Swiper, SwiperSlide } from "swiper/vue";
import axios from "axios"; // 🆕 IMPORTADO: Ativa o barramento HTTP público anônimo
import "swiper/css";
import "swiper/css/autoplay";
import 'swiper/css/navigation';
import 'swiper/css/pagination';

import "@/assets/scss/public-theme.css";
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import HeroPublic from "@/components/public/HeroPublic.vue";

export default {
    data() {
        return {
            Autoplay, Navigation, Pagination,
            artistasLista: [], // 🆕 DINÂMICO: Recebe a lista viva de bandas do MariaDB
            loading: false
        };
    },
    components: {
        Swiper,
        SwiperSlide,
        NavbarPublic,
        HeroPublic
    },
    methods: {
        // 🆕 INTEGRADO: Varre a API pública e popula o carrossel reativamente
        async carregarArtistasDestaque() {
            this.loading = true;
            try {
                const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/public/artists`);
                if (response.data) {
                    // Filtra o administrador direto na recepção da carga para blindagem dupla
                    this.artistasLista = response.data.filter(art => {
                        const nomeReal = art.nomeBanda || art.NomeBanda || "";
                        return !nomeReal.toUpperCase().includes("ADMINISTRADOR");
                    });
                }
            } catch (error) {
                console.error("Falha técnica ao tentar consumir a esteira de destaques na Home:", error);
            } finally {
                this.loading = false;
            }
        },

        // 🆕 INTEGRADO: Formata o caminho físico de mídias de forma idêntica ao catálogo
        obterUrlImagem(urlRelativa) {
            if (!urlRelativa) return "";
            if (urlRelativa.startsWith("http://") || urlRelativa.startsWith("https://")) {
                return urlRelativa;
            }
            let base = process.env.VUE_APP_API_BASE_URL || "";
            if (base.endsWith("/api")) {
                base = base.substring(0, base.length - 4);
            } else if (base.endsWith("/api/")) {
                base = base.substring(0, base.length - 5);
            }
            const urlLimpa = urlRelativa.startsWith("/") ? urlRelativa : "/" + urlRelativa;
            return `${base}${urlLimpa}`;
        },

        // 🆕 INTEGRADO: Redireciona o contratante para a tela interna do músico selecionado
        handleNavigateToArtist(slug) {
            if (!slug) return;
            this.$router.push(`/artista/${slug}`);
        },

        topFunction() {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        },
        monthly() {
            const highlightedItems = document.querySelectorAll(".month");
            highlightedItems.forEach(function (userItem) {
                userItem.style.display = "block";
            });
            const highlightedItems2 = document.querySelectorAll(".annual");
            highlightedItems2.forEach(function (userItem) {
                userItem.style.display = "none";
            });
        },
        anually() {
            const highlightedItems = document.querySelectorAll(".month");
            highlightedItems.forEach(function (userItem) {
                userItem.style.display = "none";
            });
            const highlightedItems2 = document.querySelectorAll(".annual");
            highlightedItems2.forEach(function (userItem) {
                userItem.style.display = "block";
            });
        },
        scrollToSection(sectionId) {
            const element = document.getElementById(sectionId);
            if (element) {
                element.scrollIntoView({ behavior: 'smooth' });
            }
        }
    },
    unmounted() {
        window.removeEventListener('scroll', this.setActiveSection);
    },
    mounted() {
        // 🚀 DISPARO AUTOMÁTICO: Consome a esteira do banco de dados na inicialização
        this.carregarArtistasDestaque();

        window.addEventListener('scroll', this.setActiveSection);
        let backtoTop = document.getElementById("back-to-top");

        if (backtoTop) {
            backtoTop = document.getElementById("back-to-top");
            window.onscroll = function () {
                if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
                    backtoTop.style.display = "block";
                } else {
                    backtoTop.style.display = "none";
                }
            };
        }

        this.monthly();

        window.addEventListener('scroll', function (ev) {
            ev.preventDefault();
            var navbar = document.getElementById("navbar");
            if (navbar) {
                if (document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50) {
                    navbar.classList.add("is-sticky");
                } else {
                    navbar.classList.remove("is-sticky");
                }
            }
        });

        const currentYearEl = document.querySelector('.currentyear');
        if (currentYearEl) {
            currentYearEl.innerHTML = new Date().getFullYear() + " © SevenShows";
        }
    },
};
</script>
