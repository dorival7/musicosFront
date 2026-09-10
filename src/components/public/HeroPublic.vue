<!-- eslint-disable vue/no-parsing-error -->
<template>
  <section class="section pb-0 position-relative overflow-hidden" id="hero" style="padding-top: 140px; padding-bottom: 40px; background-color: #0a0b10 !important;">
    <!-- PADRÃO DE FUNDO SUTIL DO VELZON -->
    <div class="bg-overlay bg-overlay-pattern opacity-25"></div>
    
    <div class="container position-relative z-1">
      <div class="row justify-content-center text-center">
        <div class="col-lg-10 col-sm-12">
          
          <!-- BRANDING & SLOGAN DE CONVERSÃO PREMIUM -->
          <div class="mt-2 animate__animated animate__fadeIn">
            <!-- 🛠️ CORREÇÃO DA BORDA BRANCA: Badge escuro com borda e texto brilhando em Laranja Neon -->
            <span class="badge border border-primary border-opacity-20 text-primary fw-bold text-uppercase px-3 py-2 rounded-pill fs-13 mb-3 font-monospace" style="background-color: rgba(255, 108, 34, 0.05) !important; letter-spacing: 1px;">
              ⚡ MAIS DE 500 ARTISTAS PRONTOS PARA O SEU SHOW
            </span>
            <h1 class="display-4 fw-bold text-white mb-3 lh-base font-monospace text-uppercase" style="letter-spacing: -1px;">
              O ARTISTA PERFEITO PARA O SEU EVENTO, <br />
              <span class="text-primary">A UM CLIQUE DE DISTÂNCIA.</span>
            </h1>
            <p class="lead text-muted lh-base mx-auto mb-5 fs-18 fw-medium" style="max-width: 800px; color: #d1d5db !important;">
              Sem ligações cansativas, sem burocracia e com cachê 100% protegido. Escolha o estilo, simule o frete pelo CEP de forma automática e feche o contrato digital com garantia jurídica absoluta.
            </p>
          </div>

          <!-- BARRA DE BUSCA EXPANDIDA COM LEITURA PERFEITA -->
          <div class="card bg-dark border border-light border-opacity-10 shadow-lg rounded-3 p-4 mb-5 mx-auto animate__animated animate__fadeInUp" style="max-width: 920px; background-color: #161925 !important;">
            <form @submit.prevent="handleSearchArtists">
              <div class="row g-3 align-items-center">
                
                <!-- INPUT 1: ESTILO OU NOME -->
                <div class="col-md-5 text-start">
                  <label class="form-label text-white fw-bold font-monospace mb-2 ps-1 text-uppercase fs-13" style="letter-spacing: 1px;">
                    🔑 O que você procura?
                  </label>
                  <div class="input-group bg-dark-subtle rounded border border-light border-opacity-10 p-2" style="background-color: #0e1017 !important;">
                    <span class="input-group-text bg-transparent border-0 text-primary pe-0 fs-18"><i class="ri-music-2-line"></i></span>
                    <input 
                      type="text" 
                      class="form-control bg-transparent border-0 text-white fs-16 placeholder-muted font-monospace fw-semibold" 
                      placeholder="Ex: Sertanejo, Rock, Banda..."
                      v-model="searchQuery.style"
                    />
                  </div>
                </div>

                <!-- DIVISOR VISUAL VERTICAL -->
                <div class="col-md-1 d-none d-md-block text-center opacity-10">
                  <div class="vr bg-white mx-auto" style="height: 55px; margin-top: 25px;"></div>
                </div>

                <!-- INPUT 2: DATA DO SHOW -->
                <div class="col-md-4 text-start">
                  <label class="form-label text-white fw-bold font-monospace mb-2 ps-1 text-uppercase fs-13" style="letter-spacing: 1px;">
                    📅 Quando será o evento?
                  </label>
                  <div class="input-group bg-dark-subtle rounded border border-light border-opacity-10 p-2" style="background-color: #0e1017 !important;">
                    <span class="input-group-text bg-transparent border-0 text-primary pe-0 fs-18"><i class="ri-calendar-todo-line"></i></span>
                    <input 
                      type="date" 
                      class="form-control bg-transparent border-0 text-white fs-16 font-monospace fw-semibold" 
                      v-model="searchQuery.date"
                    />
                  </div>
                </div>

                <!-- BOTÃO MESTRE DE DISPARO -->
                <div class="col-md-2" style="margin-top: 36px;">
                  <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm font-monospace text-uppercase fs-15 d-flex align-items-center justify-content-center gap-1" style="height: 52px;">
                    <i class="ri-search-2-line"></i> Buscar
                  </button>
                </div>

              </div>
            </form>
          </div>

          <!-- SELO INFERIOR COM FONTES ENCORPADAS -->
          <div class="mb-5 pb-3 animate__animated animate__fadeInUp">
            <h4 class="text-white fs-16 text-uppercase font-monospace fw-bold mb-2" style="letter-spacing: 2px;">
              🔥 AQUI VOCÊ ENCONTRA OS MELHORES ARTISTAS E BANDAS DO BRASIL!
            </h4>
            <p class="text-light small mb-0 fs-13" style="opacity: 0.8;">Músicos verificados, com portfólio digital completo e prontos para o seu espetáculo.</p>
          </div>

        </div>
      </div>
    </div>

    <!-- CURVA DE FECHAMENTO GEOMÉTRICA ORIGINAL -->
    <div class="position-absolute start-0 end-0 bottom-0 hero-shape-svg z-0 opacity-5">
      <svg xmlns="http://w3.org" version="1.1" viewBox="0 0 1440 120">
        <g fill="none">
          <path d="M 0,118 C 288,98.6 1152,40.4 1440,21L1440 140L0 140z" fill="#ffffff"></path>
        </g>
      </svg>
    </div>
  </section>
</template>

<script>
export default {
  name: "HeroPublic",
  data() {
    return {
      searchQuery: {
        style: "",
        date: ""
      }
    };
  },
  methods: {
    handleSearchArtists() {
      if (this.searchQuery.date) {
        const escolhida = new Date(this.searchQuery.date + 'T00:00:00');
        const hoje = new Date();
        hoje.setHours(0,0,0,0);
        
        if (escolhida < hoje) {
          alert("Por favor, escolha uma data futura para o seu evento.");
          this.searchQuery.date = "";
          return;
        }
      }

      this.$router.push({
        path: "/casting",
        query: { 
          q: this.searchQuery.style || undefined, 
          data: this.searchQuery.date || undefined 
        }
      });
    }
  }
};
</script>

<style scoped>
.placeholder-muted::placeholder {
  color: #6c727f !important;
  opacity: 0.9;
}
input[type="date"]::-webkit-calendar-picker-indicator {
  filter: invert(1);
  cursor: pointer;
}
input:focus {
  box-shadow: none !important;
  outline: none !important;
}
</style>
