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
          <div class="catalog-header mb-4 text-start">
            <div class="catalog-title">
              <h3 class="text-white fw-bold font-monospace text-uppercase fs-20 mb-1" style="letter-spacing: -0.5px;">Catálogo de Atrações</h3>
              <p class="text-muted small mb-0 fs-13">{{ artistasFiltrados.length }} artistas encontrados</p>
            </div>

            <div class="artist-search-wrap">
              <div class="artist-search">
                <i class="ri-map-pin-2-line"></i>
                <input v-model="termoBusca" type="text" autocomplete="off"
                  aria-label="Onde será o seu evento?"
                  placeholder="Onde será o seu evento? Digite 3 letras..."
                  @input="buscarCidades" @focus="buscaComFoco = true"
                  @blur="fecharAutocomplete" @keydown.esc="sugestoes = []" />
                <button v-if="termoBusca" type="button" class="artist-search-clear"
                  aria-label="Limpar local" @mousedown.prevent @click="limparFiltroGeografico">
                  <i class="ri-close-line"></i>
                </button>
              </div>
              <div v-if="buscaComFoco && Array.isArray(sugestoes) && sugestoes.length > 0" class="artist-autocomplete">
                <button v-for="(cidade, index) in sugestoes" :key="'cidade-top-' + index"
                  type="button" class="artist-autocomplete-item" @mousedown.prevent="selecionarCidade(cidade)">
                  <span class="artist-autocomplete-icon"><i class="ri-map-pin-line"></i></span>
                  <span class="artist-autocomplete-copy">
                    <strong>{{ cidade }}</strong>
                    <small>Buscar artistas próximos ao local do show</small>
                  </span>
                  <i class="ri-arrow-right-up-line artist-autocomplete-arrow"></i>
                </button>
              </div>
            </div>

            <div class="artist-name-search mt-2">
              <i class="ri-search-line"></i>
              <input
                v-model="termoBuscaTexto"
                type="text"
                autocomplete="off"
                aria-label="Buscar pelo nome do artista ou banda"
                placeholder="Ou busque pelo nome do artista ou banda..."
              />
              <button
                v-if="termoBuscaTexto"
                type="button"
                class="artist-search-clear"
                aria-label="Limpar nome"
                @click="termoBuscaTexto = ''"
              >
                <i class="ri-close-line"></i>
              </button>
            </div>
          </div>

          <!-- GRID RESPONSIVO CONECTADO AO BACKEND -->
          <BRow class="g-4" v-if="artistasFiltrados.length > 0">
            <BCol lg="4" md="6" sm="12" v-for="artista in artistasFiltrados" :key="artista.Id || artista.id" class="d-flex">
              
              <!-- CARD FLUIDO COM ALTURA FIXA IGUALADA (d-flex flex-column w-100) -->
              <div class="modern-card artist-result-card overflow-hidden d-flex flex-column w-100" @click="handleNavigateToArtist(artista.slug || artista.Slug)" style="cursor: pointer; border-radius: 16px !important;">
                
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
                  
                  <!-- SLOGAN: só ocupa espaço quando o artista cadastrou conteúdo -->
                  <p
                    v-if="artista.slogan || artista.Slogan"
                    class="text-muted small mb-3 text-truncate-2 font-monospace fs-12 lh-base artist-slogan"
                  >
                    {{ artista.slogan || artista.Slogan }}
                  </p>
                  
                  <!-- 🗺️ LOCALIZAÇÃO ASSENTADA E COMPUTAÇÃO DE DISTÂNCIA DINÂMICA -->
                  <div class="mt-auto mb-3">
                    <p class="text-muted small mb-1 d-flex align-items-center gap-1 fs-13" style="color: #ced4da !important;">
                      <i class="ri-map-pin-line text-primary fs-15"></i> Atende: 
                      <!-- 🛠️ CORREÇÃO CIRÚRGICA: Exibe a Região Atendida Comercial no Card -->
                      {{ artista.regiaoAtendida || artista.RegiaoAtendida || artista.cidadeAtendida || artista.CidadeAtendida }} 
                      <span v-if="artista.state || artista.State"> - {{ artista.state || artista.State }}</span>
                    </p>
                    
                    <!-- BADGE PREMIUM DE DISTÂNCIA LOGÍSTICA REAL CALCULADA PELO .NET 10 -->
                    <span 
                      v-if="artista.distanciaCalculada !== undefined || artista.DistanciaCalculada !== undefined" 
                      class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-20 fw-bold font-monospace fs-11 rounded d-inline-flex align-items-center gap-1 py-1 px-2 mt-1"
                    >
                      🚗 A {{ artista.distanciaCalculada ?? artista.DistanciaCalculada }} km do seu evento
                    </span>
                  </div>
                  
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
          <div v-else class="text-center py-5 border border-dashed border-light border-opacity-10 rounded-4 modern-card m-2" style="background-color: #131520 !important;">
            <i class="ri-user-search-line text-primary display-5 mb-3 d-block opacity-40" style="color: #ff6c22 !important;"></i>
            <h5 class="text-white font-monospace text-uppercase fs-14">Nenhum artista disponível nesta região no momento</h5>
            <p class="text-muted small mb-0 px-3 font-monospace" style="color: #9ca3af !important;">
              Não encontramos músicos cadastrados em um raio de 100 km de <span class="text-primary fw-bold">{{ this.$route.query.cidade }} - {{ this.$route.query.uf }}</span>.
            </p>
            <p class="text-muted small mb-3 px-3 font-monospace" style="color: #9ca3af !important; margin-top: 4px;">
              Que tal expandir a sua busca para conferir bandas de outras regiões que atendem todo o Brasil?
            </p>

            <!-- 🎯 BOTÃO MESTRE DE RETORNO: Destrava a vitrine aberta sem recarregar a rede -->
            <button 
              type="button" 
              @click="limparFiltroGeografico" 
              class="btn btn-primary fw-bold text-uppercase font-monospace fs-13 px-4 py-2 mt-2 animate__animated animate__pulse animate__infinite" 
              style="border-radius: 20px !important; background-color: #ff6c22 !important; border-color: #ff6c22 !important; box-shadow: 0 4px 12px rgba(255,108,34,0.2);"
            >
              <i class="ri-refresh-line me-1"></i> Ver Catálogo Completo do Brasil
            </button>
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
      sugestoes: [],
      termoBusca: "",
      debounceCidadeTimer: null,
      loading: false,
      artistasLista: [], // 🆕 DINÂMICO: Recebe a carga geral ou filtrada por raio geográfico
      filtrosDisponiveis: {
        estilos: ["Sertanejo", "Rock", "Pagode", "Pop", "MPB"],
        ufs: ["SP", "PR", "RJ", "MG", "SC"]
      },
      filtrosAtivos: {
        estilos: [],
        uf: ""
      },
      // 🕵️‍♂️ REATIVIDADE TEXTUAL: Suporta buscas por nomes de bandas vindas da Home
      termoBuscaTexto: "",
      buscaComFoco: false
    };
  },
  computed: {
    // 🛠️ FILTRAGEM HÍBRIDA EVOLUÍDA: Varre categorias laterais e pesquisa textual simultaneamente
    artistasFiltrados() {
      return this.artistasLista.filter(art => {
        const nomeReal = art.nomeBanda || art.NomeBanda || "";
        
        // 🔒 TRAVA CRÍTICA: Se for o administrador do sistema, ignora e remove da listagem
        if (nomeReal.toUpperCase().includes("ADMINISTRADOR")) {
          return false;
        }

        const estiloReal = art.estiloMusical || art.EstiloMusical || "";
        const stateReal = art.state || art.State || "";
        const sloganReal = art.slogan || art.Slogan || "";
        
        // Se a busca já veio filtrada por Raio do C#, o front ignora a trava rígida de UF lateral
        const possuiFiltroRaio = this.$route.query.cidade && this.$route.query.uf;
        const bateUF = possuiFiltroRaio || !this.filtrosAtivos.uf || stateReal.toUpperCase() === this.filtrosAtivos.uf.toUpperCase();
        
        const bateEstilo = this.filtrosAtivos.estilos.length === 0 || this.filtrosAtivos.estilos.includes(estiloReal);
        
        // Validação da busca textual livre (Nome da banda, estilo ou slogan)
        let bateTexto = true;
        if (this.termoBuscaTexto) {
          const termo = this.termoBuscaTexto.toUpperCase().trim();
          bateTexto = nomeReal.toUpperCase().includes(termo) || 
                      sloganReal.toUpperCase().includes(termo) || 
                      estiloReal.toUpperCase().includes(termo);
        }
        
        return bateEstilo && bateUF && bateTexto;
      });
    }
  },
  methods: {
    // AUTOCOMPLETE GEOGRÁFICO — MESMO ENDPOINT DA HOME/LP
    buscarCidades() {
      clearTimeout(this.debounceCidadeTimer);
      const termo = (this.termoBusca || "").trim();

      if (termo.length < 3) {
        this.sugestoes = [];
        return;
      }

      this.debounceCidadeTimer = setTimeout(() => {
        this.consultarMunicipiosApi(termo);
      }, 300);
    },

    async consultarMunicipiosApi(termo) {
      try {
        const response = await axios.get(
          `${process.env.VUE_APP_API_BASE_URL}/public/artists/cities/autocomplete`,
          { params: { termo } }
        );
        this.sugestoes = Array.isArray(response.data) ? response.data : [];
        this.buscaComFoco = true;
      } catch (error) {
        console.error("Falha ao carregar autocomplete de cidades:", error);
        this.sugestoes = [];
      }
    },

    selecionarCidade(cidade) {
      this.termoBusca = cidade;
      this.sugestoes = [];
      this.buscaComFoco = false;

      const partes = String(cidade).split(" - ");
      const query = {
        cidade: (partes[0] || "").trim(),
        uf: partes.length >= 2 ? partes[partes.length - 1].trim().toUpperCase() : "PR"
      };

      this.$router.push({ path: "/artistas", query }).then(() => {
        this.processarCargaCatalogo();
      });
    },

    fecharAutocomplete() {
      window.setTimeout(() => {
        this.buscaComFoco = false;
        this.sugestoes = [];
      }, 120);
    },
    limparFiltroGeografico() {
      console.log("🧹 [VITRINE] Limpando filtros geográficos de raio por contingência de clique.");
      
      // Limpa os estados textuais locais de suporte
      this.termoBusca = "";
      this.sugestoes = [];
      this.termoBuscaTexto = "";
      this.filtrosAtivos.uf = "";
      this.filtrosAtivos.estilos = [];

      // Remove os parâmetros de query string da URL atual do navegador de forma limpa
      this.$router.push({ path: '/artistas', query: {} }).then(() => {
        // Dispara a re-execução da carga puxando a lista de bandas aberta geral do .NET 10
        this.processarCargaCatalogo();
      });
    },
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

    // 🧠 DISPARADOR LOGÍSTICO: Decide qual esteira de dados acionar com base na URL
    async processarCargaCatalogo() {
      this.loading = true;
      const queryCidade = this.$route.query.cidade;
      const queryUf = this.$route.query.uf;
      const queryTexto = this.$route.query.q;

      if (queryCidade && queryUf) {
        this.termoBusca = `${queryCidade} - ${queryUf}`;
      }

      if (queryTexto) {
        this.termoBuscaTexto = queryTexto.trim();
      }

      try {
        if (queryCidade && queryUf) {
          console.log(`📡 [LOGÍSTICA] Buscando artistas num raio de 100km de: ${queryCidade} - ${queryUf}`);
          
          // 🛠️ SANITIZAÇÃO DE STRINGS: Remove acentos e caracteres especiais para casar 1:1 com o Seed do banco
          const cidadeLimpa = queryCidade
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "") // Arranca os acentos (Ex: "Santo Antônio" vira "Santo Antonio")
            .replace(/[^a-zA-Z0-9\s]/g, "") // Remove ruídos de pontuação
            .trim();

          // Codifica de forma segura para trafegar os espaços na rota HTTP (Ex: "Santo Antonio" vira "Santo%20Antonio")
          const cidadeCodificada = encodeURIComponent(cidadeLimpa);
          
          const urlRaio = `${process.env.VUE_APP_API_BASE_URL}/public/artists/search-raio?cidade=${cidadeCodificada}&uf=${queryUf.trim()}`;
          
          const response = await axios.get(urlRaio);
          this.artistasLista = response.data || [];
          
          // Sincroniza o seletor lateral com o estado pesquisado
          this.filtrosAtivos.uf = queryUf.toUpperCase().trim();
        } else {
          // Busca aberta tradicional
          const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/public/artists`);
          this.artistasLista = response.data || [];
        }
      } catch (error) {
        console.error("Falha técnica ao tentar processar a esteira do catálogo público:", error);
      } finally {
        this.loading = false;
      }
    },

    formatCurrency(value) {
      if (!value || value === 0) return "Consultar cachê";
      return new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value);
    },
    handleNavigateToArtist(slug) {
      if (!slug) return;
      this.$router.push(`/artista/${slug}`);
    }
  },
  mounted() {
    // 🚀 EXECUÇÃO ASSÍNCRONA: Avalia os parâmetros de rota e monta o grid na inicialização
    this.processarCargaCatalogo();
  }
};
</script>

<style scoped>

.artist-search-wrap {
  position: relative;
  width: min(360px, 100%);
}

.artist-search-wrap .artist-search {
  width: 100%;
}

.artist-autocomplete {
  position: absolute;
  z-index: 50;
  top: calc(100% + 8px);
  left: 0;
  right: 0;
  overflow: hidden;
  background: #10121b;
  border: 1px solid rgba(255,108,34,.45);
  border-radius: 13px;
  box-shadow: 0 18px 42px rgba(0,0,0,.48);
}

.artist-autocomplete-item {
  width: 100%;
  min-height: 58px;
  display: flex;
  align-items: center;
  gap: 11px;
  padding: 10px 12px;
  border: 0;
  border-bottom: 1px solid rgba(255,255,255,.07);
  background: transparent;
  color: #fff;
  text-align: left;
  cursor: pointer;
}

.artist-autocomplete-item:last-child {
  border-bottom: 0;
}

.artist-autocomplete-item:hover,
.artist-autocomplete-item:focus {
  outline: 0;
  background: rgba(255,108,34,.10);
}

.artist-autocomplete-icon {
  width: 34px;
  height: 34px;
  flex: 0 0 34px;
  display: grid;
  place-items: center;
  border-radius: 9px;
  background: rgba(255,108,34,.12);
  color: #ff6c22;
  font-size: 17px;
}

.artist-autocomplete-copy {
  min-width: 0;
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 2px;
}

.artist-autocomplete-copy strong {
  overflow: hidden;
  color: #f7f7f8;
  font-size: 13px;
  font-family: monospace;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.artist-autocomplete-copy small {
  color: #8f98aa;
  font-size: 11px;
}

.artist-autocomplete-arrow {
  color: #ff6c22;
  opacity: .72;
}

.catalog-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 22px;
}

.artist-search {
  width: min(360px, 100%);
  height: 44px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 13px;
  background: #10121b;
  border: 1px solid rgba(255,255,255,.11);
  border-radius: 12px;
  transition: border-color .2s ease, box-shadow .2s ease, background-color .2s ease;
}

.artist-search:focus-within {
  background: #12151f;
  border-color: rgba(255,108,34,.62);
  box-shadow: 0 0 0 3px rgba(255,108,34,.08);
}

.artist-search > i {
  color: #ff6c22;
  font-size: 18px;
  flex: 0 0 auto;
}

.artist-search input {
  width: 100%;
  min-width: 0;
  border: 0;
  outline: 0;
  background: transparent;
  color: #fff;
  font-size: 13px;
  font-family: monospace;
}

.artist-search input::placeholder {
  color: #7f8798;
}

.artist-search-clear {
  border: 0;
  background: transparent;
  color: #9ca3af;
  padding: 2px;
  line-height: 1;
  cursor: pointer;
}

.artist-search-clear:hover {
  color: #fff;
}

.artist-result-card {
  border: 1px solid rgba(255,255,255,.13) !important;
  transition: transform .2s ease, border-color .2s ease, box-shadow .2s ease;
}

.artist-result-card:hover {
  transform: translateY(-4px);
  border-color: rgba(255,108,34,.72) !important;
  box-shadow: 0 14px 32px rgba(0,0,0,.34), 0 0 0 1px rgba(255,108,34,.08);
}

.artist-result-card:hover .artist-card-img {
  transform: scale(1.025);
}

.artist-card-img {
  transition: transform .28s ease;
}

.artist-slogan {
  color: #9ca3af !important;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

@media (max-width: 767.98px) {
  .catalog-header {
    align-items: stretch;
    flex-direction: column;
  }

  .artist-search-wrap,
  .artist-search {
    width: 100%;
  }
}

.artist-name-search {
  position: relative;
  display: flex;
  align-items: center;
  min-height: 42px;
  border: 1px solid rgba(255, 107, 32, 0.35);
  border-radius: 12px;
  background: rgba(18, 20, 31, 0.92);
  padding: 0 42px 0 44px;
}
.artist-name-search > i {
  position: absolute;
  left: 16px;
  color: #ff6b20;
  font-size: 18px;
}
.artist-name-search input {
  width: 100%;
  border: 0;
  outline: 0;
  background: transparent;
  color: #fff;
  font-family: inherit;
  font-size: 13px;
}
.artist-name-search input::placeholder {
  color: rgba(255,255,255,.45);
}

</style>
