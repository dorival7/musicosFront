<!-- eslint-disable vue/no-parsing-error -->
<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="layout-wrapper landing seven-portal" style="display: block !important; position: relative; width: 100%; min-height: 100vh; background-color: #0a0b10 !important; padding-top: 90px;">
    
    <NavbarPublic />

    <!-- FEEDBACK DE CARREGAMENTO -->
    <div v-if="loading" class="text-center py-5 mt-5">
      <div class="spinner-border text-primary" role="status"></div>
      <p class="text-muted mt-2 font-monospace fs-13">Buscando informações do artista...</p>
    </div>

    <div v-else-if="artista" class="animate__animated animate__fadeIn">
      
      <!-- HERO BANNER: CAPA DO ARTISTA PREMIUM -->
       <div class="position-relative border-bottom border-light border-opacity-5 overflow-hidden" style="height: 420px; background-color: #0a0b10;">
        
        <!-- 📸 FOTO DE CAPA REAL: Removida a opacidade baixa para trazer nitidez total e cores vivas -->
        <img 
          :src="(artista.fotoCapaUrl || artista.FotoCapaUrl) ? obterUrlImagem(artista.fotoCapaUrl || artista.FotoCapaUrl) : require('@/assets/images/banner-artist-default.jpg')" 
          alt="Capa do Artista" 
          class="w-100 h-100 object-fit-cover position-absolute top-0 start-0 animate__animated animate__fadeIn"
          style="opacity: 1; z-index: 1;"
        />
        
        <!-- 🔥 GRADIENTE SÊNIOR: Escurece cirurgicamente apenas a base para dar contraste ao texto branco -->
        <div class="position-absolute w-100 h-100 top-0 start-0" style="background: linear-gradient(to bottom, rgba(10,11,16,0.1) 0%, rgba(10,11,16,0.4) 50%, #0a0b10 100%); z-index: 2;"></div>

        <!-- INFORMAÇÕES TEXTUAIS EM RELEVO NO RODAPÉ DO BANNER -->
        <BContainer class="h-100 position-relative d-flex align-items-end pb-4" style="z-index: 3;">
          <div class="text-center text-md-start w-100 animate__animated animate__fadeInUp">
            
            <div class="d-flex flex-wrap gap-2 justify-content-center justify-content-md-start mb-2">
              <span class="badge bg-primary fw-bold font-monospace text-uppercase fs-11 rounded-pill px-3 py-1 shadow-sm">
                {{ artista.estiloMusical || artista.EstiloMusical || 'Geral' }}
              </span>
              <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-20 fw-bold font-monospace text-uppercase fs-11 rounded-pill px-3 py-1 shadow-sm">
                {{ artista.formatoArtístico || artista.FormatoArtístico || 'Banda' }}
              </span>
            </div>
            
            <h1 class="text-white fw-bold font-monospace text-uppercase display-5 mb-2" style="letter-spacing: -1px; text-shadow: 0 2px 8px rgba(0,0,0,0.8);">
              {{ artista.nomeBanda || artista.NomeBanda || 'Atração Sem Nome' }}
            </h1>
            
            <p class="font-monospace fs-14 mb-3 fw-semibold artist-slogan" style="color: #ff6c22 !important; text-shadow: 0 1px 4px rgba(0,0,0,0.8);">
              🔥 {{ artista.slogan || artista.Slogan || 'Show disponível para contratação direta' }}
            </p>

            <a href="#formatos-show" class="btn hero-cta rounded-pill fw-bold text-uppercase font-monospace px-4 py-2">
              Ver formatos de show <i class="ri-arrow-down-line ms-1"></i>
            </a>

          </div>
        </BContainer>
      </div>

      <!-- CORPO DA TELA: ENGENHARIA DE DUAS COLUNAS -->
      <BContainer class="py-5">
        <BRow class="g-4">
          
          <!-- COLUNA ESQUERDA: BIOGRAFIA (65%) -->
          <BCol lg="8" class="text-start">
            <div class="card modern-card p-4 border border-light border-opacity-10 shadow-sm mb-4 artist-story-card" style="background-color: #131520 !important; border-radius: 16px !important;">
              <div class="section-kicker font-monospace text-uppercase mb-2">Conheça a atração</div>
              <h4 class="text-white fw-bold font-monospace text-uppercase fs-18 mb-3" style="letter-spacing: 0.5px;">
                <i class="ri-user-voice-line text-primary me-2"></i> Nossa História
              </h4>
              <!-- 🛠️ CORREÇÃO DE CHAVE: Lê a biografia real em texto longo do banco -->
              <p class="text-muted fs-14 lh-base font-monospace" style="color: #ced4da !important; white-space: pre-line;">
                {{ artista.biografia || artista.Biografia || 'O artista ainda não disponibilizou uma biografia pública.' }}
              </p>
            </div>

            <!-- 📸 PORTFÓLIO DE PALCO: Galeria de Fotos e Player de Vídeo Real do MariaDB -->
            <div class="card modern-card p-4 border border-light border-opacity-10 shadow-sm mb-4 artist-portfolio-card" style="background-color: #131520 !important; border-radius: 16px !important;">
              <div class="section-kicker font-monospace text-uppercase mb-2">Portfólio de palco</div>
              <h4 class="text-white fw-bold font-monospace text-uppercase fs-18 mb-2" style="letter-spacing: 0.5px;">
                <i class="ri-image-gallery-line text-primary me-2"></i> Veja a banda no palco
              </h4>
              <p class="portfolio-intro font-monospace mb-4">Assista aos vídeos e conheça alguns momentos dos shows antes de escolher o formato ideal para o seu evento.</p>
              <div v-if="videosPortfolio && videosPortfolio.length > 0" class="mb-3 animate__animated animate__fadeIn">
                <div class="ratio ratio-16x9 rounded-3 overflow-hidden border border-light border-opacity-10 bg-dark shadow-sm">
                  
                <iframe 
                    :src="'https://www.youtube.com/embed/' + videosPortfolio[videoAtivoIndex].youtubeId + '?playsinline=1&rel=0'" 
                    title="Vídeo Principal do Artista" 
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                    referrerpolicy="strict-origin-when-cross-origin"
                    allowfullscreen
                    class="w-100 h-100 border-0"
                  ></iframe>

                </div>
              </div>

              <!-- 🖼️ 2. ESTEIRA HORIZONTAL DE THUMBNAILS -->
              <div v-if="videosPortfolio && videosPortfolio.length > 1" class="d-flex flex-wrap gap-2 mb-4 font-monospace artist-video-thumbs">
                <div 
                  v-for="(video, index) in videosPortfolio" 
                  :key="video.id"
                  @click="videoAtivoIndex = index"
                  class="rounded-2 overflow-hidden border border-light border-opacity-10 position-relative p-0 artist-video-thumb"
                  :class="{'thumb-active': videoAtivoIndex === index}"
                  style="width: 100px; height: 60px; cursor: pointer; transition: all 0.2s ease; opacity: 0.6; background-color: #0a0b10;"
                >
                  <img 
                    :src="'https://img.youtube.com/vi/' + video.youtubeId + '/mqdefault.jpg'" 
                    alt="Miniatura do Clipe" 
                    class="w-100 h-100 object-fit-cover"
                  />
                  <span class="position-absolute bottom-0 end-0 bg-dark bg-opacity-75 text-white fs-9 px-1 rounded-start">
                    #{{ index + 1 }}
                  </span>
                </div>
              </div>

              <!-- SEPARADOR VISUAL -->
              <div v-if="videosPortfolio.length > 0 && fotosPortfolio.length > 0" class="my-4 opacity-10">
                <hr class="bg-white" />
              </div>

              <!-- 🖼️ 4. GRID DE IMAGENS SECUNDÁRIAS -->
              <div class="row g-3 artist-photo-grid" v-if="fotosPortfolio && fotosPortfolio.length > 0">
                <div 
                  class="col-sm-4 col-6 artist-photo-col" 
                  v-for="midia in fotosPortfolio" 
                  :key="midia.id || midia.Id"
                  @click="selecionarFoto(midia)"
                >
                  <div class="rounded-3 overflow-hidden border border-light border-opacity-10 position-relative bg-dark-subtle shadow-sm artist-photo-tile" :class="{ 'photo-active': (midia.id || midia.Id) === fotoAtivaId }" style="height: 140px; cursor: pointer;">
                    <img 
                      :src="obterUrlImagem(midia.mediaUrl || midia.MediaUrl)" 
                      alt="Foto do Show" 
                      class="w-100 h-100 object-fit-cover artist-portfolio-img"
                    />
                  </div>
                </div>
              </div>

              <!-- FALLBACK -->
              <div v-if="videosPortfolio.length === 0 && fotosPortfolio.length === 0" class="text-center py-4 opacity-50 font-monospace">
                <i class="ri-camera-lens-line fs-24 mb-2 d-block text-primary"></i>
                <p class="small mb-0 fs-12">Nenhuma foto ou vídeo cadastrado no portfólio deste artista.</p>
              </div>
            </div>

          </BCol>

          <!-- COLUNA DIREITA: E-COMMERCE DE PACOTES COM CONTRATAÇÃO DIRETA (35%) -->
          <BCol lg="4" class="text-start" id="formatos-show">
            <div class="position-sticky" style="top: 100px;">
              
              <div class="card modern-card p-3 border border-light border-opacity-10 shadow-sm mb-4 text-center artist-region-card" style="background-color: #131520 !important; border-radius: 16px !important;">
                <!-- 🛠️ CORREÇÃO DE CHAVE: Puxa a cidade atendida e UF reais -->
                <p class="text-light small mb-0 font-monospace fs-13">
                  <i class="ri-map-pin-line text-primary fs-16 me-1 align-middle"></i> 
                  Região Base: <strong class="text-white">{{ artista.cidadeAtendida || artista.CidadeAtendida || 'Não Informada' }} <span v-if="artista.state || artista.State"> - {{ artista.state || artista.State }}</span></strong>
                </p>
              </div>

              <div class="formats-heading px-1 mb-3">
                <span class="section-kicker font-monospace text-uppercase d-block mb-1">Escolha como quer viver o show</span>
                <h4 class="text-white fw-bold font-monospace text-uppercase fs-17 mb-1" style="letter-spacing: 0.5px;">
                  ⚡ Escolha o Formato do Show
                </h4>
                <p class="font-monospace mb-0 formats-subtitle">Compare as opções e avance para consultar os detalhes da contratação.</p>
              </div>

              <!-- 🛠️ CORREÇÃO DE CHAVE: Varre e renderiza o array de pacotes reais em minúsculo ou maiúsculo -->
              <div class="d-flex flex-column gap-3" v-if="(artista.pacotes && artista.pacotes.length > 0) || (artista.Pacotes && artista.Pacotes.length > 0)">
                <div v-for="pacote in (artista.pacotes || artista.Pacotes)" :key="pacote.id || pacote.Id" class="card modern-card package-card p-4 border border-light border-opacity-10 shadow-md h-auto" style="background-color: #131520 !important; border-radius: 16px !important;">
                  <div class="d-flex flex-column align-items-start mb-3">
                    <h5 class="text-white fw-bold font-monospace text-uppercase fs-15 mb-2 text-wrap w-100" style="letter-spacing: -0.3px; line-height: 1.3;">
                      {{ pacote.title || pacote.Title }}
                    </h5>
                    <span class="badge bg-primary-subtle text-primary font-monospace fs-10 py-1 px-2 rounded-2 animate__animated animate__fadeIn">
                      <i class="ri-time-line me-1"></i> Duração: {{ pacote.durationMinutes || pacote.DurationMinutes }} min
                    </span>
                  </div>
                  
                  <p class="text-muted small font-monospace fs-12 mb-3 lh-base text-truncate-3" style="color: #a3a3a3 !important; min-height: 54px;">
                    {{ pacote.description || pacote.Description || 'Sem especificações adicionais de estrutura.' }}
                  </p>

                  <div class="d-flex justify-content-between align-items-center pt-3 border-top border-light border-opacity-5 mt-auto">
                    <div>
                      <span class="text-white-50 d-block font-monospace fs-10 text-uppercase">Cachê Fixo</span>
                      <strong class="text-primary font-monospace fs-17">{{ formatCurrency(pacote.basePrice || pacote.BasePrice) }}</strong>
                    </div>
                    <button 
                      @click="$router.push('/checkout/contratacao/' + (pacote.id || pacote.Id))"
                      class="btn btn-primary fw-bold text-uppercase fs-12 font-monospace px-3 rounded-pill shadow-sm"
                      style="background-color: #ff6c22 !important; border-color: #ff6c22 !important; height: 36px;"
                    >
                      Escolher este show <i class="ri-arrow-right-line ms-1"></i>
                    </button>
                  </div>
                </div>
              </div>

              <div class="card modern-card p-4 text-center border border-dashed border-light border-opacity-10" style="background-color: #131520 !important; border-radius: 16px !important;" v-else>
                <i class="ri-calendar-close-line text-primary display-6 mb-2 opacity-30"></i>
                <h6 class="text-white font-monospace fs-13 text-uppercase mb-1">Nenhum Pacote Ativo</h6>
                <p class="text-muted small mb-0 fs-12">O músico não possui formatos configurados para venda imediata.</p>
              </div>

            </div>
          </BCol>

        </BRow>
      </BContainer>
    </div>

    <!-- TELA DE PERFIL NÃO ENCONTRADO -->
    <div v-else class="text-center py-5 mt-5 container">
      <div class="card modern-card p-5 border border-dashed border-light border-opacity-10 rounded-4">
        <i class="ri-user-unfollow-line text-primary display-4 mb-3 opacity-30"></i>
        <h4 class="text-white font-monospace text-uppercase fs-16">Artista não localizado no portal</h4>
        <p class="text-muted small mb-3">O link pode estar quebrado ou a atração mudou de endereço.</p>
        <router-link to="/artistas" class="btn btn-outline-primary btn-sm rounded-pill fw-bold text-uppercase font-monospace px-4 mx-auto">
          Voltar ao Catálogo
        </router-link>
      </div>
    </div>

    <!-- GALERIA LIGHTBOX: independente do player de vídeos e da posição da página -->
    <Teleport to="body">
      <div
        v-if="fotoAtivaGrande"
        class="artist-lightbox"
        role="dialog"
        aria-modal="true"
        aria-label="Galeria de fotos do artista"
        @click.self="fecharGaleria"
        @touchstart.passive="iniciarSwipe"
        @touchend.passive="finalizarSwipe"
      >
        <button type="button" class="artist-lightbox-close" @click="fecharGaleria" aria-label="Fechar galeria">
          <i class="ri-close-line"></i>
        </button>

        <div class="artist-lightbox-shell">
          <div class="artist-lightbox-media">
            <img :src="fotoAtivaGrande" :alt="fotoAtivaLegenda || 'Foto do artista'" />

            <button
              v-if="fotosPortfolio.length > 1"
              type="button"
              class="artist-lightbox-nav artist-lightbox-prev"
              @click.stop="fotoAnterior"
              aria-label="Foto anterior"
            >
              <i class="ri-arrow-left-s-line"></i>
            </button>
            <button
              v-if="fotosPortfolio.length > 1"
              type="button"
              class="artist-lightbox-nav artist-lightbox-next"
              @click.stop="proximaFoto"
              aria-label="Próxima foto"
            >
              <i class="ri-arrow-right-s-line"></i>
            </button>
          </div>

          <aside class="artist-lightbox-info font-monospace">
            <div class="artist-lightbox-brand">
              <span class="artist-lightbox-kicker">PORTFÓLIO DE PALCO</span>
              <strong>{{ artista.nomeBanda || artista.NomeBanda || 'Artista' }}</strong>
            </div>
            <div class="artist-lightbox-caption">
              {{ fotoAtivaLegenda || 'Foto do portfólio' }}
            </div>
            <div class="artist-lightbox-counter">
              {{ fotoAtivaIndex + 1 }} / {{ fotosPortfolio.length }}
            </div>
          </aside>
        </div>
      </div>
    </Teleport>

  </div>
</template>

<script>
import "@/assets/scss/public-theme.css";
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import axios from "axios";

export default {
  name: "ArtistaPerfilPublico",
  components: { NavbarPublic },
  data() {
    return {
      loading: false,
      artista: null,
      fotosPortfolio: [],
      videosPortfolio: [],
      videoAtivoIndex: 0,
      fotoAtivaGrande: "",
      fotoAtivaId: null,
      fotoAtivaIndex: -1,
      fotoAtivaLegenda: "",
      touchInicioX: null,
      bodyOverflowAnterior: ""
    };
  },
  methods: {
    obterUrlImagem(urlRelativa) {
      if (!urlRelativa) return "";

      const ajustarHostLocal = (url) => {
        if (typeof window === "undefined") return url;
        try {
          const parsed = new URL(url, window.location.origin);
          if (["localhost", "127.0.0.1", "::1"].includes(parsed.hostname)) {
            parsed.hostname = window.location.hostname;
          }
          return parsed.toString();
        } catch (e) {
          return url;
        }
      };

      if (urlRelativa.startsWith("http://") || urlRelativa.startsWith("https://")) {
        return ajustarHostLocal(urlRelativa);
      }

      let base = process.env.VUE_APP_API_BASE_URL || "";
      base = ajustarHostLocal(base);
      if (base.endsWith("/api")) base = base.substring(0, base.length - 4);
      else if (base.endsWith("/api/")) base = base.substring(0, base.length - 5);

      const urlLimpa = urlRelativa.startsWith("/") ? urlRelativa : "/" + urlRelativa;
      return base + urlLimpa;
    },
    selecionarFoto(midia) {
      if (!midia) return;
      const id = midia.id || midia.Id || null;
      const index = this.fotosPortfolio.findIndex(f => (f.id || f.Id) === id);
      this.fotoAtivaId = id;
      this.fotoAtivaIndex = index >= 0 ? index : 0;
      this.fotoAtivaGrande = this.obterUrlImagem(midia.mediaUrl || midia.MediaUrl);
      this.fotoAtivaLegenda = midia.caption || midia.Caption || "";
      if (typeof document !== "undefined") {
        // Guarda o estado anterior somente na abertura inicial do lightbox.
        // Ao navegar entre fotos, o body já está com overflow hidden e não
        // devemos sobrescrever o valor original que será restaurado ao fechar.
        if (document.body.style.overflow !== "hidden") {
          this.bodyOverflowAnterior = document.body.style.overflow || "";
        }
        document.body.style.overflow = "hidden";
      }
    },
    fotoAnterior() {
      if (!this.fotosPortfolio.length) return;
      const atual = this.fotoAtivaIndex >= 0 ? this.fotoAtivaIndex : 0;
      const novoIndex = (atual - 1 + this.fotosPortfolio.length) % this.fotosPortfolio.length;
      this.selecionarFoto(this.fotosPortfolio[novoIndex]);
    },
    proximaFoto() {
      if (!this.fotosPortfolio.length) return;
      const atual = this.fotoAtivaIndex >= 0 ? this.fotoAtivaIndex : 0;
      const novoIndex = (atual + 1) % this.fotosPortfolio.length;
      this.selecionarFoto(this.fotosPortfolio[novoIndex]);
    },
    fecharGaleria() {
      this.fotoAtivaGrande = "";
      this.fotoAtivaId = null;
      this.fotoAtivaIndex = -1;
      this.fotoAtivaLegenda = "";
      this.touchInicioX = null;
      if (typeof document !== "undefined") document.body.style.overflow = this.bodyOverflowAnterior;
    },
    aoPressionarTecla(event) {
      if (!this.fotoAtivaGrande) return;
      if (event.key === "Escape") this.fecharGaleria();
      else if (event.key === "ArrowLeft") this.fotoAnterior();
      else if (event.key === "ArrowRight") this.proximaFoto();
    },
    iniciarSwipe(event) {
      this.touchInicioX = event.changedTouches && event.changedTouches[0] ? event.changedTouches[0].clientX : null;
    },
    finalizarSwipe(event) {
      if (this.touchInicioX === null || !event.changedTouches || !event.changedTouches[0]) return;
      const delta = event.changedTouches[0].clientX - this.touchInicioX;
      this.touchInicioX = null;
      if (Math.abs(delta) < 45) return;
      if (delta < 0) this.proximaFoto();
      else this.fotoAnterior();
    },
    converterLinkYoutube(urlOriginal) {
      if (!urlOriginal) return "";
      try {
        const valor = urlOriginal.trim();

        // Aceita também um ID puro já normalizado.
        if (/^[a-zA-Z0-9_-]{11}$/.test(valor)) return valor;

        const url = new URL(valor);
        const host = url.hostname.replace(/^www\./, "");
        let id = "";

        if (host === "youtu.be") {
          id = url.pathname.split("/").filter(Boolean)[0] || "";
        } else if (host === "youtube.com" || host === "m.youtube.com") {
          if (url.pathname === "/watch") {
            id = url.searchParams.get("v") || "";
          } else {
            const partes = url.pathname.split("/").filter(Boolean);
            if (["embed", "shorts", "live"].includes(partes[0])) {
              id = partes[1] || "";
            }
          }
        }

        return /^[a-zA-Z0-9_-]{11}$/.test(id) ? id : "";
      } catch (e) {
        console.error("Falha ao isolar ID do YouTube:", e);
        return "";
      }
    },
    async carregarPerfilPorSlug() {
      this.loading = true;
      try {
        const slug = this.$route.params.slug;
        const response = await axios.get(process.env.VUE_APP_API_BASE_URL + "/public/artists/" + slug);
        
        if (response.data) {
          this.artista = response.data;
          const listaMidias = response.data.medias || response.data.Medias || [];


          console.log("Medias", response.data);
          
          this.fotosPortfolio = listaMidias.filter(m => {
            const tipo = (m.mediaType || m.MediaType || m.mediatype || "").toString().toLowerCase();
            return tipo === "photo";
          });
          
          const registrosVideos = listaMidias.filter(m => {
            const tipo = (m.mediaType || m.MediaType || m.mediatype || "").toString().toLowerCase();
            return tipo === "video";
          });

          this.videosPortfolio = registrosVideos
            .map(v => {
              const urlBruta = v.mediaUrl || v.MediaUrl || v.mediaurl || "";
              return {
                id: v.id || v.Id,
                youtubeId: this.converterLinkYoutube(urlBruta) // Guarda o ID bruto isolado
              };
            })
            .filter(v => v.youtubeId !== "");
        }
      } catch (error) {
        console.error("Falha ao recuperar os dados públicos do artista:", error);
      } finally {
        this.loading = false;
      }
    },
    formatCurrency(value) {
      if (!value || value === 0) return "Sob Consulta";
      return new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value);
    },
    dispararCheckout(pacoteId) {
      // 🚀 RESOLVIDO: Redireciona usando estritamente o GUID recebido no clique do botão
      if (pacoteId) {
        this.$router.push("/checkout/contratacao/" + pacoteId);
      }
    }

  },
  mounted() {
    this.carregarPerfilPorSlug();
    window.addEventListener("keydown", this.aoPressionarTecla);
  },
  beforeUnmount() {
    window.removeEventListener("keydown", this.aoPressionarTecla);
    if (typeof document !== "undefined") {
      document.body.style.overflow = this.bodyOverflowAnterior || "";
      document.body.classList.remove("artist-lightbox-open");
    }
  }
};
</script>

<style scoped>
.text-truncate-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
/* Efeito sutil de seleção na miniatura ativa */
.thumb-active {
  border-color: #ff6c22 !important;
  box-shadow: 0 0 10px rgba(255, 108, 34, 0.4) !important;
  opacity: 1 !important;
}

html { scroll-behavior: smooth; }

.hero-cta {
  color: #fff !important;
  background: rgba(10, 11, 16, 0.72) !important;
  border: 1px solid rgba(255, 108, 34, 0.75) !important;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.28);
  transition: transform .2s ease, background-color .2s ease, box-shadow .2s ease;
}
.hero-cta:hover {
  background: #ff6c22 !important;
  transform: translateY(-2px);
  box-shadow: 0 10px 26px rgba(255, 108, 34, 0.25);
}
.artist-slogan { max-width: 900px; }
.section-kicker {
  color: #ff6c22;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 1.1px;
}
.portfolio-intro,
.formats-subtitle {
  color: #aeb6c4;
  font-size: 13px;
  line-height: 1.6;
}
.package-card {
  transition: transform .2s ease, border-color .2s ease, box-shadow .2s ease;
}
.package-card:hover {
  transform: translateY(-3px);
  border-color: rgba(255, 108, 34, 0.42) !important;
  box-shadow: 0 12px 30px rgba(0,0,0,.24) !important;
}
.package-card .btn-primary {
  min-width: 168px;
}
.artist-portfolio-img {
  transition: transform .25s ease, filter .25s ease;
}
.artist-portfolio-img:hover {
  transform: scale(1.035);
  filter: brightness(1.08);
}
/* Lightbox da galeria: mantém o vídeo intacto e abre a foto no viewport atual. */
.artist-lightbox {
  position: fixed;
  inset: 0;
  z-index: 10050;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28px;
  background: rgba(3, 4, 8, .94);
  backdrop-filter: blur(8px);
}
.artist-lightbox-shell {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 330px;
  width: min(1180px, 94vw);
  height: min(82vh, 820px);
  overflow: hidden;
  border: 1px solid rgba(255,255,255,.12);
  border-radius: 16px;
  background: #0d0f16;
  box-shadow: 0 24px 80px rgba(0,0,0,.6);
}
.artist-lightbox-media {
  position: relative;
  min-width: 0;
  min-height: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #050609;
}
.artist-lightbox-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: contain;
}
.artist-lightbox-info {
  display: flex;
  flex-direction: column;
  padding: 28px 24px 22px;
  border-left: 1px solid rgba(255,255,255,.1);
  color: #fff;
  background: #11141d;
}
.artist-lightbox-brand { display: flex; flex-direction: column; gap: 6px; font-size: 14px; }
.artist-lightbox-brand strong { font-size: 16px; text-transform: uppercase; }
.artist-lightbox-kicker { color: #ff6c22; font-size: 10px; font-weight: 800; letter-spacing: 1px; }
.artist-lightbox-caption {
  margin-top: 28px;
  color: #d4d7df;
  font-size: 13px;
  line-height: 1.7;
  white-space: pre-line;
  overflow-y: auto;
}
.artist-lightbox-counter { margin-top: auto; padding-top: 20px; color: #ff8a50; font-size: 12px; font-weight: 800; }
.artist-lightbox-close {
  position: fixed;
  top: 18px;
  right: 22px;
  z-index: 2;
  width: 44px;
  height: 44px;
  border: 1px solid rgba(255,255,255,.18);
  border-radius: 50%;
  background: rgba(16,18,25,.9);
  color: #fff;
  font-size: 26px;
  line-height: 1;
  cursor: pointer;
}
.artist-lightbox-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 58px;
  border: 1px solid rgba(255,255,255,.18);
  border-radius: 10px;
  background: rgba(7,9,14,.78);
  color: #fff;
  font-size: 30px;
  cursor: pointer;
}
.artist-lightbox-prev { left: 16px; }
.artist-lightbox-next { right: 16px; }
.artist-photo-tile.photo-active {
  border-color: #ff6c22 !important;
  box-shadow: 0 0 0 1px rgba(255,108,34,.45), 0 8px 20px rgba(0,0,0,.3) !important;
}

#formatos-show { scroll-margin-top: 110px; }

@media (max-width: 991.98px) {
  .hero-cta { width: 100%; max-width: 330px; }
  #formatos-show { scroll-margin-top: 90px; }
}

/* Vitrine pública — refinamento exclusivo para mobile */
@media (max-width: 767.98px) {
  /* Mantém a jornada Conhecer -> Ver -> Contratar, mas usa melhor os 390px. */
  .seven-portal > .container {
    padding-left: 10px !important;
    padding-right: 10px !important;
    padding-top: 28px !important;
    padding-bottom: 34px !important;
  }

  .artist-story-card {
    padding: 18px !important;
    margin-bottom: 18px !important;
  }

  .artist-portfolio-card {
    padding: 14px 10px 12px !important;
    margin-bottom: 22px !important;
  }
  .artist-portfolio-card > .section-kicker,
  .artist-portfolio-card > h4,
  .artist-portfolio-card > .portfolio-intro {
    margin-left: 6px;
    margin-right: 6px;
  }
  .artist-portfolio-card .ratio {
    border-radius: 12px !important;
  }

  /* Vídeos viram uma esteira real: thumbnails maiores e swipe horizontal. */
  .artist-video-thumbs {
    flex-wrap: nowrap !important;
    overflow-x: auto;
    overflow-y: hidden;
    gap: 10px !important;
    padding: 2px 2px 8px;
    margin-bottom: 16px !important;
    scroll-snap-type: x proximity;
    scrollbar-width: none;
    -webkit-overflow-scrolling: touch;
  }
  .artist-video-thumbs::-webkit-scrollbar { display: none; }
  .artist-video-thumb {
    width: 142px !important;
    height: 80px !important;
    min-width: 142px;
    flex: 0 0 142px;
    scroll-snap-align: start;
    opacity: .78 !important;
    border-radius: 10px !important;
  }
  .artist-video-thumb.thumb-active { opacity: 1 !important; }

  /* Fotos ocupam quase toda a largura e ganham presença de portfólio. */
  .artist-photo-grid {
    --bs-gutter-x: 10px;
    --bs-gutter-y: 10px;
    margin-left: -2px !important;
    margin-right: -2px !important;
  }
  .artist-photo-col { padding-left: 5px !important; padding-right: 5px !important; }
  .artist-photo-tile {
    height: 154px !important;
    border-radius: 10px !important;
  }



  .artist-region-card {
    margin-top: 2px;
    margin-bottom: 18px !important;
  }
  .formats-heading { margin-bottom: 14px !important; }

  .package-card { padding: 18px !important; }
  .package-card .btn-primary { min-width: 0; }
}

@media (max-width: 767.98px) {
  .artist-lightbox { padding: 0; align-items: stretch; background: #050609; }
  .artist-lightbox-shell {
    grid-template-columns: 1fr;
    grid-template-rows: minmax(0, 1fr) auto;
    width: 100vw;
    height: 100dvh;
    border: 0;
    border-radius: 0;
  }
  .artist-lightbox-media { min-height: 0; padding-top: 48px; }
  .artist-lightbox-media img { object-fit: contain; }
  .artist-lightbox-info {
    max-height: 30vh;
    padding: 14px 18px 16px;
    border-left: 0;
    border-top: 1px solid rgba(255,255,255,.1);
  }
  .artist-lightbox-brand { gap: 3px; }
  .artist-lightbox-brand strong { font-size: 13px; }
  .artist-lightbox-caption { margin-top: 10px; font-size: 12px; line-height: 1.55; }
  .artist-lightbox-counter { padding-top: 10px; }
  .artist-lightbox-close { top: 10px; right: 10px; width: 38px; height: 38px; font-size: 23px; }
  .artist-lightbox-nav { width: 40px; height: 50px; font-size: 26px; background: rgba(7,9,14,.7); }
  .artist-lightbox-prev { left: 8px; }
  .artist-lightbox-next { right: 8px; }
}

</style>


