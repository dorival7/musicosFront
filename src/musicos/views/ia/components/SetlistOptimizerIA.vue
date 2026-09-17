<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="card p-4 border border-light shadow-sm text-start bg-white mt-4" style="border-radius: 12px !important;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h5 class="text-dark fw-bold font-monospace text-uppercase mb-1 fs-15" style="letter-spacing: 0.5px;">
          <span style="color: #ff6c22;">🎸</span> Otimizador de Repertório (Setlist Smart)
        </h5>
        <p class="text-muted small mb-0 font-monospace fs-12">Monte o show estratégico ideal conectando os estilos e o perfil do público em tempo real via Groq / Llama 3</p>
      </div>
      <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-20 font-monospace px-3 py-1 fs-11 rounded-pill">
        LIVE API / GROQ
      </span>
    </div>

    <div class="row g-4">
      <!-- COLUNA DA ESQUERDA: ENTRADA DE DADOS -->
      <div class="col-lg-5">
        <div class="mb-3">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-2">
            Selecione até 3 Estilos Musicais ({{ estilosSelecionados.length }}/3)
          </label>
          <div class="d-flex flex-wrap gap-2">
            <button 
              type="button" 
              v-for="estilo in listaEstilosDisponiveis" 
              :key="estilo"
              @click="alternarSelecaoEstilo(estilo)"
              class="btn btn-sm font-monospace text-uppercase fs-11 py-1 px-3 fw-medium"
              :class="estilosSelecionados.includes(estilo) ? 'btn-primary' : 'btn-light border border-light text-muted'"
              style="border-radius: 20px !important;"
              :disabled="!estilosSelecionados.includes(estilo) && estilosSelecionados.length >= 3"
            >
              {{ estilo }}
            </button>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">Perfil do Público / Conceito do Evento</label>
          <textarea class="form-control bg-light border-light text-dark font-monospace fs-13" v-model="form.perfilPublico" rows="3" placeholder="Ex: Festa de aniversário de 40 anos, público focado em clássicos nacionais e internacionais que gosta de dançar..."></textarea>
        </div>

        <div class="mb-4">
          <label class="form-label text-secondary fw-semibold font-monospace text-uppercase fs-11 mb-1">Quantidade de Músicas Desejada</label>
          <select class="form-select bg-light border-light text-dark font-monospace fs-13 py-2" v-model="form.qtdMusicas">
            <option :value="10">10 Músicas (Show Pocket)</option>
            <option :value="15">15 Músicas (Show Padrão 1h)</option>
            <option :value="20">20 Músicas (Show Estendido 1h30)</option>
          </select>
        </div>

        <div class="d-grid">
          <button type="button" @click="gerarSetlistComIAReal" class="btn btn-primary fw-bold font-monospace text-uppercase fs-13" style="height: 44px; background-color: #ff6c22 !important; border-color: #ff6c22 !important; box-shadow: 0 4px 12px rgba(255,108,34,0.15);" :disabled="loadingSetlist">
            <i class="ri-pulse-line me-1"></i> {{ loadingSetlist ? 'Processando Llama 3 no Groq...' : 'Gerar Repertório via IA' }}
          </button>
        </div>
      </div>

      <!-- COLUNA DA DIREITA: RESULTADO DA TIMELINE DA IA -->
      <div class="col-lg-7">
        <div class="p-3 border border-light rounded-3 bg-light" style="min-height: 410px; max-height: 490px; overflow-y: auto;">
          
          <div v-if="!setlistResultado && !loadingSetlist" class="d-flex flex-column align-items-center justify-content-center text-center h-100 py-5">
            <i class="ri-music-2-line text-muted display-6 mb-2 opacity-30"></i>
            <p class="text-muted font-monospace fs-12 mb-0">Insira as configurações e dispare a IA real da Groq para montar a grade de alta retenção.</p>
          </div>

          <div v-if="loadingSetlist" class="d-flex flex-column align-items-center justify-content-center text-center h-100 py-5">
            <div class="spinner-border text-primary mb-3" role="status" style="color: #ff6c22 !important;"></div>
            <p class="text-dark fw-bold font-monospace fs-13 mb-1 text-uppercase">Buscando inteligência musical ao vivo...</p>
            <p class="text-muted font-monospace fs-11 mb-0">Computando picos harmônicos e fator de engajamento no Groq...</p>
          </div>

          <div v-if="setlistResultado && !loadingSetlist" class="animate__animated animate__fadeIn text-start">
            <div class="alert alert-info border-0 p-3 mb-3 bg-primary bg-opacity-10 text-primary font-monospace fs-12 rounded">
              💡 <strong>Diretriz Estratégica:</strong> {{ setlistResultado.resumoEstrategico }}
            </div>

            <div class="timeline-setlist d-flex flex-column gap-3">
              <div v-for="item in setlistResultado.sugestaoSetlist" :key="item.ordem" class="p-3 bg-white border border-light rounded shadow-sm">
                <div class="d-flex justify-content-between align-items-start mb-1">
                  <div>
                    <span class="badge bg-dark font-monospace me-2 text-white fs-11" style="background-color: #161925 !important;">#{{ item.ordem }}</span>
                    <strong class="text-dark fs-14 font-monospace text-uppercase">{{ item.titulo }}</strong>
                    <span class="text-muted font-monospace small d-block mt-0.5">Por: {{ item.artistaOriginal }}</span>
                  </div>
                  <span class="badge font-monospace fs-10 px-2 py-0.5 rounded bg-danger bg-opacity-10 text-danger border border-danger border-opacity-10">
                    💥 {{ item.curvaEnergia }}
                  </span>
                </div>
                <p class="text-muted mb-0 font-monospace fs-11 lh-base mt-2 border-top border-light pt-2" style="color: #6c757d !important;">
                  🎯 <strong>Retenção:</strong> {{ item.justificativaIA }}
                </p>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "SetlistOptimizerIA",
  data() {
    return {
      loadingSetlist: false,
      setlistResultado: null,
      estilosSelecionados: [],
      listaEstilosDisponiveis: ["Pop Rock", "Sertanejo", "Pagode / Samba", "MPB", "Axé", "Forró", "Reggae", "Indie / Folk", "Flashback"],
      form: { perfilPublico: "", qtdMusicas: 15 }
    };
  },
  methods: {
    alternarSelecaoEstilo(estilo) {
      if (this.estilosSelecionados.includes(estilo)) {
        this.estilosSelecionados = this.estilosSelecionados.filter(item => item !== estilo);
      } else {
        if (this.estilosSelecionados.length < 3) this.estilosSelecionados.push(estilo);
      }
    },

    // 🧠 DISPARADOR COM TELEMETRIA ATIVA: Varre e expõe o ciclo de vida do clique no console
    async gerarSetlistComIAReal() {
      console.log("==================================================");
      console.log("⚡ [RAIO-X IA] GATILHO DE CLIQUE DISPARADO COM SUCESSO!");
      console.log("==================================================");

      if (this.estilosSelecionados.length === 0 || !this.form.perfilPublico.trim()) {
        console.warn("🛑 [RAIO-X IA] Abortado: Filtros obrigatórios não preenchidos.");
        return;
      }

      this.loadingSetlist = true;
      this.setlistResultado = null;

      try {
        // 🔬 1. AUDITORIA DA URL BASE DO CHASSI
        console.log("🔬 1. Checando VUE_APP_API_BASE_URL:", process.env.VUE_APP_API_BASE_URL);
        
        const urlFinal = `${process.env.VUE_APP_API_BASE_URL}/artists/ia/optimize-setlist`;
        console.log("🎯 2. URL Final calculada para o post:", urlFinal);

        // 🔬 2. AUDITORIA DO CORPO DO PAYLOAD
        const payload = {
          estilos: this.estilosSelecionados,
          perfilPublico: this.form.perfilPublico,
          qtdMusicas: this.form.qtdMusicas
        };
        console.log("📦 3. Payload JSON estruturado pronto:", JSON.stringify(payload));

        // 🔬 3. AUDITORIA CIRÚRGICA DO TOKEN JWT
        const tokenBruto = localStorage.getItem('jwt');
        console.log("🔑 4. Conteúdo bruto lido da chave 'jwt':", tokenBruto);

        if (!tokenBruto) {
          console.error("❌ 4.1 ERRO CRÍTICO LOCAL: O token 'jwt' veio nulo ou inexistente no LocalStorage!");
          alert("⚠️ Falha local: Não localizamos o seu token 'jwt' no navegador. Por favor, refaça o login.");
          this.loadingSetlist = false;
          return;
        }

        const configHeaders = {
          headers: { 
            Authorization: `Bearer ${tokenBruto}`
          }
        };
        console.log("⚙️ 5. Objeto de configuração do cabeçalho montado com sucesso.");

        console.log("🚀 6. Executando a linha física do 'axios.post' agora...");
        
        // EXECUÇÃO REAL DO DISPARO DE REDE AGAINST O .NET 10
        const response = await axios.post(urlFinal, payload, configHeaders);
        
        console.log("✅ 7. RESPOSTA RECEBIDA DO BACKEND COM STATUS 200!", response.data);
        this.setlistResultado = response.data;

      } catch (error) {
        console.error("🚨 [RAIO-X IA] CAPTURA DE EXCEÇÃO INSTANTÂNEA NO CATCH:", error);
        
        if (error.response) {
          console.error("📊 Detalhes da Resposta de erro do Servidor:", error.response.status, error.response.data);
          alert(`❌ Falha na esteira (HTTP ${error.response.status}). Verifique a aba Network.`);
        } else if (error.request) {
          console.error("📡 A requisição foi feita localmente, mas nenhuma resposta voltou da rede:", error.request);
          alert("❌ O servidor .NET está fora do ar ou recusou a conexão local.");
        } else {
          console.error("💥 Erro nativo interno na montagem do interpretador JS:", error.message);
          alert(`❌ Falha interna local no Vue: ${error.message}`);
        }
      } finally {
        this.loadingSetlist = false;
        console.log("==================================================");
      }
    }
  }
};
</script>