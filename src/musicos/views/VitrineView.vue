<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="p-2">
    <form @submit.prevent="salvarDadosVitrine">
      <div class="row g-4">
        
        <!-- CAMPO 1: ESTILO MUSICAL -->
        <div class="col-md-6 text-start">
          <label class="form-label fw-bold text-uppercase fs-12 mb-2" style="letter-spacing: 0.5px;">🎵 Gênero / Estilo de Som</label>
          <select class="form-select border border-secondary border-opacity-20 fw-medium fs-14 py-2 rounded-3" v-model="form.estiloMusical">
            <option value="">Selecione o seu estilo principal</option>
            <option value="Sertanejo">Sertanejo / Modão</option>
            <option value="Rock">Rock (Clássico / Pop / Metal)</option>
            <option value="Pagode">Pagode / Samba</option>
            <option value="Pop">Pop / Reggae</option>
            <option value="MPB">MPB / Acústico</option>
          </select>
        </div>

        <!-- CAMPO 2: FORMATO ARTÍSTICO -->
        <div class="col-md-6 text-start">
          <label class="form-label fw-bold text-uppercase fs-12 mb-2" style="letter-spacing: 0.5px;">🎤 Formato da Atração</label>
          <select class="form-select border border-secondary border-opacity-20 fw-medium fs-14 py-2 rounded-3" v-model="form.formatoArtístico">
            <option value="">Selecione o formato de palco</option>
            <option value="Banda">Banda Completa</option>
            <option value="Dupla">Dupla / Trio</option>
            <option value="Solo">Artista Solo / Voz e Violão</option>
          </select>
        </div>

        <!-- CAMPO 3: SLOGAN DE IMPACTO -->
        <div class="col-12 text-start">
          <label class="form-label fw-bold text-uppercase fs-12 mb-2" style="letter-spacing: 0.5px;">🔥 Slogan ou Frase Magnética de Venda</label>
          <div class="input-group rounded border border-secondary border-opacity-20 p-1">
            <span class="input-group-text bg-transparent border-0 text-primary pe-0 fs-16"><i class="ri-flashlight-line"></i></span>
            <input 
              type="text" 
              class="form-control bg-transparent border-0 fs-14 fw-semibold" 
              placeholder="Ex: O melhor do pop rock nacional com energia máxima para ferver a pista do seu evento..."
              v-model="form.slogan"
              maxlength="255"
            />
          </div>
          <div class="text-end text-muted small mt-1 fs-11">{{ form.slogan.length }}/255 caracteres</div>
        </div>

        <!-- CAMPO 4: BIOGRAFIA -->
        <div class="col-12 text-start">
          <label class="form-label fw-bold text-uppercase fs-12 mb-2" style="letter-spacing: 0.5px;">📝 História da Banda / Trajetória Artística</label>
          <textarea 
            class="form-control border border-secondary border-opacity-20 fs-14 py-2 rounded-3" 
            rows="6" 
            placeholder="Conte aqui sua história completa, conquistas importantes, tempo de estrada e o diferencial do seu espetáculo para encantar os contratantes..."
            v-model="form.biografia"
            style="resize: none; line-height: 1.6;"
          ></textarea>
        </div>

        <!-- SEPARADOR VISUAL SUTIL -->
        <div class="col-12 my-1 opacity-25">
          <hr />
        </div>

        <!-- CONTAINER DO BOTÃO DE SALVAMENTO -->
        <div class="col-12 d-flex justify-content-end">
          <button type="submit" class="btn btn-primary fw-bold px-5 text-uppercase fs-14 d-flex align-items-center justify-content-center gap-2 rounded-pill shadow-sm" style="height: 46px; background-color: #ff6c22 !important; border-color: #ff6c22 !important;" :disabled="loading">
            <span v-if="loading" class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
            <i v-else class="ri-save-3-line fs-16"></i> 
            {{ loading ? 'Salvando...' : 'Salvar Minha Vitrine' }}
          </button>
        </div>

      </div>
    </form>
  </div>
</template>

<script>
import axios from "axios";
// 🛠️ MATE O ALERTA BRUTO: Importa o SweetAlert2 de fábrica instalado no package.json do Velzon
import Swal from "sweetalert2";

export default {
  name: "VitrineComponente",
  data() {
    return {
      loading: false,
      form: {
        estiloMusical: "",
        formatoArtístico: "",
        slogan: "",
        biografia: ""
      }
    };
  },
  methods: {
    async carregarDadosIniciais() {
      this.loading = true;
      try {
        const token = localStorage.getItem('token') || localStorage.getItem('user_token');
        const config = {};
        if (token) {
          config.headers = {
            Authorization: `Bearer ${token}`
          };
        }

        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/vitrine`, config);
        
        if (response.data) {
          this.form.estiloMusical = response.data.estiloMusical || response.data.EstiloMusical || "";
          this.form.formatoArtístico = response.data.formatoArtístico || response.data.FormatoArtístico || "";
          this.form.slogan = response.data.slogan || response.data.Slogan || "";
          this.form.biografia = response.data.biografia || response.data.Biografia || "";
        }
      } catch (error) {
        console.error("Erro ao carregar dados iniciais da vitrine dedicada:", error);
      } finally {
        this.loading = false;
      }
    },

    async salvarDadosVitrine() {
      this.loading = true;
      try {
        const dadosPayload = {
          EstiloMusical: this.form.estiloMusical,
          FormatoArtístico: this.form.formatoArtístico,
          Slogan: this.form.slogan,
          Biografia: this.form.biografia
        };

        const response = await axios.put(`${process.env.VUE_APP_API_BASE_URL}/tenants/vitrine`, dadosPayload);
        
        // 🚀 CHAMADA EXPLÍCITA: Dispara a janela flutuante nativa do Velzon
        Swal.fire({
          title: "Sucesso!",
          text: response.data.mensagem || "Sua vitrine pública foi gravada com sucesso total!",
          icon: "success",
          confirmButtonColor: "#ff6c22", // Laranja oficial SevenShows
          confirmButtonText: "Fechar",
          customClass: {
            popup: 'rounded-3' // Força cantos arredondados no padrão do painel
          }
        });

      } catch (error) {
        console.error("Erro na esteira de persistência da vitrine:", error);
        const mensagemReal = error.response?.data?.mensagem || error.message || "Erro de autorização.";
        
        // Dispara o alerta de erro estilizado do Velzon
        Swal.fire({
          title: "Pane Técnica!",
          text: "Falha na gravação: " + mensagemReal,
          icon: "error",
          confirmButtonColor: "#de350b",
          confirmButtonText: "Entendido"
        });
      } finally {
        this.loading = false;
      }
    }
  },
  mounted() {
    this.carregarDadosIniciais();
  }
};
</script>

<style scoped>
input:focus, select:focus, textarea:focus {
  box-shadow: none !important;
  outline: none !important;
  border-color: #ff6c22 !important;
}
</style>
