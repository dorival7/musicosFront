<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="layout-wrapper landing seven-portal" style="display: block !important; position: relative; width: 100%; min-height: 100vh; background-color: #0a0b10 !important; padding-top: 120px;">
    
    <!-- MENU SUPERIOR FIXO -->
    <NavbarPublic />

    <BContainer class="py-4">
      <BRow class="g-4">
        
        <!-- ==================================================================== -->
        <!-- 🧭 LADO ESQUERDO: FILTROS LATERAIS (STICKY AVANÇADO)                 -->
        <!-- ==================================================================== -->
        <BCol lg="3" md="4" class="text-start">
          <div class="card modern-card p-4 border border-light border-opacity-10 shadow-lg position-sticky" style="top: 100px; background-color: #131520 !important;">
            <h5 class="text-white fw-bold font-monospace mb-4 text-uppercase fs-14" style="letter-spacing: 0.5px;">
              <i class="ri-filter-3-line text-primary me-1"></i> Filtrar Artistas
            </h5>
            
            <!-- FILTRO 1: ESTILO MUSICAL -->
            <div class="mb-4">
              <label class="form-label text-white fw-bold font-monospace text-uppercase fs-12 mb-2" style="letter-spacing: 0.5px; opacity: 0.9;">🎵 Estilo de Som</label>
              <div class="d-flex flex-column gap-2 ps-1">
                <div class="form-check" v-for="estilo in filtrosDisponiveis.estilos" :key="estilo">
                  <input class="form-check-input text-primary" type="checkbox" :id="estilo" v-model="filtrosAtivos.estilos" :value="estilo">
                  <label class="form-check-label text-muted small fw-medium" :for="estilo" style="color: #ced4da !important;">{{ estilo }}</label>
                </div>
              </div>
            </div>

            <!-- FILTRO 2: REGIÃO / UF -->
            <div class="mb-4">
              <label class="form-label text-white fw-bold font-monospace text-uppercase fs-12 mb-2" style="letter-spacing: 0.5px; opacity: 0.9;">📍 Estado / UF</label>
              <select class="form-select bg-dark border border-light border-opacity-10 text-white font-monospace fs-13" v-model="filtrosAtivos.uf" style="background-color: #0e1017 !important;">
                <option value="">Todos os Estados</option>
                <option v-for="uf in filtrosDisponiveis.ufs" :key="uf" :value="uf">{{ uf }}</option>
              </select>
            </div>
          </div>
        </BCol>

        <!-- ==================================================================== -->
        <!-- 🖼️ LADO DIREITO: GALERIA DE ARTISTAS (GRID DE CARDS ARREDONDADOS)    -->
        <!-- ==================================================================== -->
        <BCol lg="9" md="8">
          <div class="d-flex justify-content-between align-items-center mb-4 text-start">
            <div>
              <h3 class="text-white fw-bold font-monospace text-uppercase fs-20 mb-1" style="letter-spacing: -0.5px;">Catálogo de Atrações</h3>
              <!-- 🆕 DINÂMICO: Mostra a contagem real baseada nos registros do MariaDB -->
              <p class="text-muted small mb-0 fs-13">Exibindo {{ artistasFiltrados.length }} artistas disponíveis para o seu show</p>
            </div>
          </div>

          <!-- GRID RESPONSIVO CONECTADO AO BACKEND -->
          <BRow class="g-4" v-if="artistasFiltrados.length > 0">
            <BCol lg="4" md="6" sm="12" v-for="artista in artistasFiltrados" :key="artista.Id || artista.id" class="d-flex">
              
              <!-- CARD FLUIDO COM ALTURA FIXA IGUALADA (d-flex flex-column w-100) -->
              <div class="modern-card overflow-hidden d-flex flex-column w-100" @click="handleNavigateToArtist(artista.slug || artista.Slug)" style="cursor: pointer; border-radius: 16px !important;">
                
                <!-- CONTAINER DA FOTO DE CAPA CALIBRADA NAS DIMENSÕES EXATAS DO PAINEL -->
                <div class="position-relative overflow-hidden border-bottom border-light border-opacity-5" style="height: 180px; min-height: 180px; background-color: #141622;">
                  
                  <!-- 🆕 BANNER GENÉRICO INTELIGENTE: Puxa a foto do .NET ou injeta o asset padrão se estiver em branco -->
                  <img 
                    :src="(artista.fotoCapaUrl || artista.FotoCapaUrl) ? obterUrlImagem(artista.fotoCapaUrl || artista.FotoCapaUrl) : require('@/assets/images/banner-artist-default.jpg')" 
                    alt="Foto de Capa" 
                    class="w-100 h-100 object-fit-cover artist-card-img" 
                  />
                  
                  <!-- ENVELOPE DE PROTEÇÃO DOS BADGES COMPACTOS -->
                  <div class="position-absolute top-0 end-0 m-2 d-flex flex-row gap-1 align-items-start" style="z-index: 3;">
                    <span class="badge bg-primary fw-bold font-monospace text-uppercase fs-10 rounded-pill shadow-sm py-1 px-2" style="letter-spacing: 0.5px;">
                      {{ artista.estiloMusical || artista.EstiloMusical || 'Geral' }}
                    </span>
                    <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-20 fw-bold font-monospace text-uppercase fs-10 rounded-pill shadow-sm py-1 px-2">
                      {{ artista.formatoArtístico || artista.FormatoArtístico || 'Banda' }}
                    </span>
                  </div>
                </div>

                <!-- CONTEÚDO EXPANDIDO COM ESTRUTURA FLEX EM NÓS (flex-grow-1) -->
                <div class="p-3 text-start d-flex flex-column flex-grow-1">
                  <h5 class="text-white fw-bold font-monospace text-uppercase fs-15 text-truncate mb-1" style="letter-spacing: -0.5px;">
                    {{ artista.nomeBanda || artista.NomeBanda || 'Atração Sem Nome' }}
                  </h5>
                  
                  <!-- SLOGAN LIMITADO A DUAS LINHAS COM ESPAÇAMENTO FIXO -->
                  <p class="text-muted small mb-3 text-truncate-2 font-monospace fs-12 lh-base" style="color: #9ca3af !important; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 36px;">
                    {{ artista.slogan || artista.Slogan || 'Nenhum slogan comercial cadastrado.' }}
                  </p>
                  
                  <!-- LOCALIZAÇÃO ASSENTADA NO RODAPÉ DO BLOCO -->
                  <p class="text-muted small mb-3 d-flex align-items-center gap-1 fs-13 mt-auto" style="color: #ced4da !important;">
                    <i class="ri-map-pin-line text-primary fs-15"></i> Atende: 
                    {{ artista.cidadeAtendida || artista.CidadeAtendida || 'Não informada' }} 
                    <span v-if="artista.state || artista.State"> - {{ artista.state || artista.State }}</span>
                  </p>
                  
                  <div class="d-flex justify-content-between align-items-center pt-2 border-top border-light border-opacity-5">
                    <span class="text-white-50 font-monospace fs-11 text-uppercase" style="letter-spacing: 0.5px;">A partir de</span>
                    <span class="text-primary font-monospace fw-bold fs-16">
                      {{ formatCurrency(artista.precoBase || artista.PrecoBase) }}
                    </span>
                  </div>
                </div>

              </div>
            </BCol>
          </BRow>

          <!-- TELA DE LOADING OU NENHUM RESULTADO -->
          <div v-else class="text-center py-5 border border-dashed border-light border-opacity-10 rounded-4 modern-card m-2">
            <i class="ri-user-search-line text-primary display-5 mb-3 d-block opacity-40"></i>
            <h5 class="text-white font-monospace text-uppercase fs-14">Nenhum artista disponível no momento</h5>
            <p class="text-muted small mb-0 px-3">Tente desmarcar algumas opções do painel lateral ou verifique se há músicos ativos no banco.</p>
          </div>
        </BCol>

      </BRow>
    </BContainer>
  </div>
</template>

<script>
import "@/assets/scss/public-theme.css";
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import axios from "axios"; // 🆕 IMPORTADO: Ativa a comunicação HTTP com a API pública

export default {
  name: "CastingView",
  components: { NavbarPublic },
  data() {
    return {
      loading: false,
      artistasLista: [], // 🆕 DINÂMICO: Inicia o array zerado aguardando o payload do banco
      filtrosDisponiveis: {
        estilos: ["Sertanejo", "Rock", "Pagode", "Pop", "MPB"],
        ufs: ["SP", "PR", "RJ", "MG", "SC"]
      },
      filtrosAtivos: {
        estilos: [],
        uf: ""
      }
    };
  },
  computed: {
    // 🛠️ REVISÃO DE REGRA DE NEGÓCIO: Adicionada a trava que esconde o administrador do catálogo
    artistasFiltrados() {
      return this.artistasLista.filter(art => {
        const nomeReal = art.nomeBanda || art.NomeBanda || "";
        
        // 🔒 TRAVA CRÍTICA: Se for o administrador do sistema, ignora e remove da listagem
        if (nomeReal.toUpperCase().includes("ADMINISTRADOR")) {
          return false;
        }

        const estiloReal = art.estiloMusical || art.EstiloMusical || "";
        const stateReal = art.state || art.State || "";
        
        const bateEstilo = this.filtrosAtivos.estilos.length === 0 || this.filtrosAtivos.estilos.includes(estiloReal);
        const bateUF = !this.filtrosAtivos.uf || stateReal === this.filtrosAtivos.uf;
        
        return bateEstilo && bateUF;
      });
    }
  },
  methods: {
    obterUrlImagem(urlRelativa) {
      if (!urlRelativa) return "";
      
      if (urlRelativa.startsWith("http://") || urlRelativa.startsWith("https://")) {
        return urlRelativa;
      }
      
      // Captura a URL base (ex: http://localhost:5297/api ou http://localhost:5297)
      let base = process.env.VUE_APP_API_BASE_URL || "";
      
      // Se a variável terminar com /api ou /api/, arranca fora para acessar a pasta estática raiz
      if (base.endsWith("/api")) {
        base = base.substring(0, base.length - 4);
      } else if (base.endsWith("/api/")) {
        base = base.substring(0, base.length - 5);
      }
      
      const urlLimpa = urlRelativa.startsWith("/") ? urlRelativa : "/" + urlRelativa;
      return `${base}${urlLimpa}`;
    },
    // 🆕 INTEGRADO: Varre a API pública anônima do .NET 10 e despeja no array local
    async carregarArtistasDoBanco() {
      this.loading = true;
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/public/artists`);
        if (response.data) {
          this.artistasLista = response.data;
        }
      } catch (error) {
        console.error("Falha técnica ao tentar consumir a esteira pública de artistas:", error);
      } finally {
        this.loading = false;
      }
    },
    formatCurrency(value) {
      if (!value || value === 0) return "Sob Consulta";
      return new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value);
    },
    handleNavigateToArtist(slug) {
      if (!slug) return;
      this.$router.push(`/artista/${slug}`);
    }
  },
  mounted() {
    // 🚀 DISPARO AUTOMÁTICO: Consome o endpoint público do .NET assim que a tela abre
    this.carregarArtistasDoBanco();
  }
};
</script>
