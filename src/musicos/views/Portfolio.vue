<script>
import axios from 'axios';
import Cropper from 'cropperjs';
import 'cropperjs/dist/cropper.css';
import Swal from 'sweetalert2';

export default {
  name: "PortfolioMediaKit",
  data() {
    return {
      loading: true,
      savingCover: false,
      savingPhoto: false,
      savingVideo: false,
      successMessage: null,
      errorMessage: null,
      coverUrl: null,
      photosList: [],
      videosList: [],
      maxPhotosCount: 5, 
      videoForm: { videoUrl: "", caption: "" },
      editingItem: null,
      editingMediaItem: null,
      editCaptionText: "",
      cropper: null,
      cropType: null,
      imageSrcToCrop: null,
      showCropModal: false,
      videosExpanded: false,
      videoFormExpanded: false
    };
  },
  watch: {
    successMessage(value) {
      if (!value) return;
      Swal.fire({ icon: 'success', title: 'Pronto', text: String(value), timer: 2200, showConfirmButton: false });
      this.successMessage = null;
    },
    errorMessage(value) {
      if (!value) return;
      Swal.fire({ icon: 'error', title: 'Atenção', text: typeof value === 'string' ? value : 'Não foi possível concluir a operação.', confirmButtonText: 'OK' });
      this.errorMessage = null;
    }
  },
  methods: {
    resolveMediaUrl(mediaPath) {
      if (!mediaPath) return "";

      const configuredBase = process.env.VUE_APP_API_BASE_URL || "";
      const currentHost = window.location.hostname;

      const normalizeStaticMediaUrl = (rawUrl) => {
        try {
          const parsed = new URL(rawUrl, window.location.origin);

          // Em desenvolvimento, o celular acessa o front pelo IP da máquina.
          // Mantemos protocolo/porta da API e trocamos apenas localhost pelo host atual.
          if ((parsed.hostname === "localhost" || parsed.hostname === "127.0.0.1") && currentHost !== "localhost" && currentHost !== "127.0.0.1") {
            parsed.hostname = currentHost;
          }

          // Arquivos de wwwroot/uploads são estáticos e não passam pelo prefixo /api.
          parsed.pathname = parsed.pathname.replace(/^\/api(?=\/uploads(?:\/|$))/i, "");
          return parsed.toString();
        } catch (_) {
          return rawUrl;
        }
      };

      if (/^https?:\/\//i.test(mediaPath)) {
        return normalizeStaticMediaUrl(mediaPath);
      }

      const path = String(mediaPath).startsWith("/") ? String(mediaPath) : `/${mediaPath}`;
      const baseUrl = normalizeStaticMediaUrl(configuredBase || window.location.origin);

      try {
        const base = new URL(baseUrl, window.location.origin);
        if (/^\/uploads(?:\/|$)/i.test(path)) {
          base.pathname = base.pathname.replace(/\/api\/?$/i, "");
        }
        return new URL(`${base.pathname.replace(/\/$/, "")}${path}`, `${base.protocol}//${base.host}`).toString();
      } catch (_) {
        return `${String(baseUrl).replace(/\/api\/?$/i, "").replace(/\/$/, "")}${path}`;
      }
    },
    async loadMediaInventory() {
      this.loading = true;
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/media`, config);
        this.coverUrl = response.data.coverUrl || null;
        this.photosList = response.data.photos || [];
        this.videosList = response.data.videos || [];
        this.maxPhotosCount = response.data.maxPhotosCount || 5;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.errorMessage = "Erro ao sincronizar mídias com o banco.";
      }
    },
    handleFileSelection(event, type) {
      const file = event.target.files[0];
      if (!file) return;
      if (file.size > 10 * 1024 * 1024) {
        this.errorMessage = "Arquivo rejeitado! O limite máximo permitido é de 10MB.";
        event.target.value = "";
        return;
      }
      if (!file.type.match('image.*')) {
        this.errorMessage = "Por favor, selecione arquivos de imagem válidos.";
        event.target.value = "";
        return;
      }
      this.cropType = type;
      this.successMessage = null;
      this.errorMessage = null;
      this.imageSrcToCrop = URL.createObjectURL(file);
      this.showCropModal = true;
      event.target.value = "";
      this.$nextTick(() => { this.initializeCropperInstance(); });
    },
    initializeCropperInstance() {
      if (this.cropper) this.cropper.destroy();
      const imageElement = this.$refs.imageToCropRef;
      const targetAspectRatio = this.cropType === 'Cover' ? (16 / 5) : (1 / 1);
      this.cropper = new Cropper(imageElement, {
        aspectRatio: targetAspectRatio,
        viewMode: 1,
        dragMode: 'move',
        background: true,
        responsive: true,
        autoCropArea: 1
      });
    }

    ,
    handleConfirmCrop() {
      if (!this.cropper) return;
      const canvasOptions = this.cropType === 'Cover' 
        ? { width: 1920, height: 600, imageSmoothingQuality: 'high' }
        : { width: 1080, height: 1080, imageSmoothingQuality: 'high' };

      const croppedCanvas = this.cropper.getCroppedCanvas(canvasOptions);
      croppedCanvas.toBlob(async (blob) => {
        if (!blob) {
          this.errorMessage = "Erro ao processar o recorte.";
          return;
        }
        const finalFile = new File([blob], `${this.cropType.toLowerCase()}_processed.jpg`, { type: "image/jpeg" });
        this.showCropModal = false;
        if (this.cropper) this.cropper.destroy();
        this.cropper = null;

        if (this.cropType === 'Cover') {
          await this.uploadCroppedCover(finalFile);
        } else {
          await this.uploadCroppedPhoto(finalFile);
        }
      }, "image/jpeg", 0.85);
    },
    async uploadCroppedCover(file) {
      this.savingCover = true;
      const formData = new FormData();
      formData.append("file", file);
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" } };
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/media/cover`, formData, config);
        this.successMessage = "Foto de capa recortada e aplicada com sucesso!";
        await this.syncOnboardingStatus();
      } catch (error) {
        this.savingCover = false;
        this.errorMessage = "Falha ao enviar arquivo de capa recortado.";
      }
    },
    async uploadCroppedPhoto(file) {
      this.savingPhoto = true;
      const formData = new FormData();
      formData.append("file", file);
      formData.append("caption", "");
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}`, "Content-Type": "multipart/form-data" } };
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/media/photos`, formData, config);
        this.successMessage = "Foto quadrada processada e adicionada!";
        await this.syncOnboardingStatus();
      } catch (error) {
        this.savingPhoto = false;
        this.errorMessage = error.response?.data || "Erro ao subir imagem.";
      }
    },
    handleCancelCrop() {
      this.showCropModal = false;
      if (this.cropper) this.cropper.destroy();
      this.cropper = null;
      this.imageSrcToCrop = null;
    },
    async handleAddVideo() {
      this.savingVideo = true;
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        await axios.post(`${process.env.VUE_APP_API_BASE_URL}/tenants/videos`, this.videoForm, config);
        this.successMessage = "Vídeo do YouTube cadastrado com sucesso!";
        this.videoForm.videoUrl = "";
        this.videoForm.caption = "";
        await this.syncOnboardingStatus();
      } catch (error) {
        this.savingVideo = false;
        this.errorMessage = error.response?.data || "Erro ao salvar link do vídeo.";
      }
    },
    startEditCaption(item) {
      this.editingItem = item.id;
      this.editingMediaItem = item;
      this.editCaptionText = item.caption || "";
    },
    cancelEditCaption() {
      this.editingItem = null;
      this.editingMediaItem = null;
      this.editCaptionText = "";
    },
    async handleSaveEdit(item, type) {
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        if (type === 'Photo') {
          await axios.put(`${process.env.VUE_APP_API_BASE_URL}/tenants/media/photos/${item.id}`, { caption: this.editCaptionText }, config);
        } else if (type === 'Video') {
          await axios.put(`${process.env.VUE_APP_API_BASE_URL}/tenants/videos/${item.id}`, { videoUrl: item.mediaUrl, caption: this.editCaptionText }, config);
        }
        this.successMessage = "Informações atualizadas com sucesso!";
        this.cancelEditCaption();
        await this.loadMediaInventory();
      } catch (error) {
        this.errorMessage = "Erro ao tentar atualizar os dados.";
      }
    },
    async handleDeleteMedia(id) {
      const result = await Swal.fire({
        icon: "warning",
        title: "Remover mídia?",
        text: "Esta ação removerá o item do seu portfólio.",
        showCancelButton: true,
        confirmButtonText: "Sim, remover",
        cancelButtonText: "Cancelar",
        reverseButtons: true
      });
      if (!result.isConfirmed) return;
      this.successMessage = null;
      this.errorMessage = null;
      try {
        const token = localStorage.getItem('jwt');
        const config = { headers: { Authorization: `Bearer ${token}` } };
        await axios.delete(`${process.env.VUE_APP_API_BASE_URL}/tenants/media/${id}`, config);
        this.successMessage = "Mídia removida com sucesso!";
        await this.syncOnboardingStatus();
      } catch (error) {
        this.errorMessage = "Erro ao processar a remoção no servidor C#.";
      }
    },
    async syncOnboardingStatus() {
      const token = localStorage.getItem('jwt');
      const config = { headers: { Authorization: `Bearer ${token}` } };
      await this.loadMediaInventory();
      const profileRes = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/tenants/me`, config);
      const novoStatus = profileRes.data.profileStatus;
      localStorage.setItem('profileStatus', novoStatus);
      this.savingCover = false;
      this.savingPhoto = false;
      this.savingVideo = false;
    }
  },
  mounted() {
    this.loadMediaInventory();
  }
};
</script>



<template>
  <div>
    <!-- TÍTULO DA PÁGINA -->
    <div class="row">
      <div class="col-12">
        <div class="page-title-box d-sm-flex align-items-center justify-content-between">
          <h4 class="mb-sm-0 text-primary">Portfólio / Media Kit</h4>
        </div>
      </div>
    </div>

    <!-- ANIMAÇÃO DE CARREGAMENTO (LOADING) -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary avatar-sm" role="status"></div>
      <p class="text-muted mt-2">Buscando mídias no banco de dados MySQL...</p>
    </div>

    <!-- CONTEÚDO OPERACIONAL INTEGRADO -->
    <div v-else class="row portfolio-mobile-content">
      
      <!-- SEÇÃO 1: FOTO DE CAPA DO PORTFÓLIO (100% HORIZONTAL) -->
      <div class="col-12 mb-3 cover-section">
        <div class="card overflow-hidden profile-project-card shadow-sm border-0 portfolio-cover-card">
          <div class="card-header bg-light border-0 d-flex justify-content-between align-items-center p-3">
            <div>
              <h5 class="card-title mb-1 text-dark fw-bold"><i class="ri-image-line me-1 text-primary"></i> Imagem de Capa do Media Kit</h5>
              <small class="text-muted d-block">Dimensão ideal: 1920x600px (Horizontal / Widescreen). Máximo 10MB.</small>
            </div>
            <div>
              <!-- Redireciona o evento @change para a nossa função de validação e disparo do Crop -->
              <input type="file" id="coverFileInput" class="d-none" @change="handleFileSelection($event, 'Cover')" accept="image/*" />
              <label for="coverFileInput" class="btn btn-sm btn-primary mb-0 shadow-none" :disabled="savingCover">
                <i class="ri-upload-cloud-2-line me-1 align-middle" v-if="!savingCover"></i>
                {{ savingCover ? "Processando..." : (coverUrl ? "Trocar Imagem de Capa" : "Subir Imagem de Capa") }}
              </label>
            </div>
          </div>
          <div class="card-body p-0 position-relative bg-dark d-flex align-items-center justify-content-center" style="min-height: 240px; max-height: 300px; overflow: hidden;">
            <img v-if="coverUrl" :src="resolveMediaUrl(coverUrl)" class="img-fluid w-100 object-fit-cover h-100" style="position: absolute; top:0; left:0;" alt="Capa do Artista" />
            <div v-else class="text-center p-5 text-white-50">
              <i class="ri-image-add-line fs-36 d-block mb-2"></i>
              <p class="mb-0 fs-13">Nenhuma imagem de capa cadastrada para este painel.</p>
            </div>
          </div>
        </div>
      </div>
      <!-- SEÇÃO 2: GALERIA DE FOTOS DA EQUIPE OU SHOW (COLUNA ESQUERDA) -->
      <div class="col-xl-7 col-lg-6 mb-3 gallery-section">
        <div class="card h-100 portfolio-section-card">
          <div class="card-header bg-transparent border-0 d-flex justify-content-between align-items-center p-3">
            <div>
              <h5 class="card-title mb-1 text-dark fw-bold">
                <i class="ri-gallery-line me-1 text-success"></i> Galeria de Fotos
                <!-- TAG REATIVA DE CONTROLE DE VAGAS RESTANTES DO PLANO -->
                <span :class="photosList.length >= maxPhotosCount ? 'badge bg-danger-subtle text-danger ms-2 fs-12' : 'badge bg-info-subtle text-info ms-2 fs-12'">
                  {{ photosList.length >= maxPhotosCount ? 'Limite Atingido' : `Restam ${maxPhotosCount - photosList.length} vagas` }}
                </span>
              </h5>
              <small class="text-muted d-block">Dimensão ideal: 1080x1080px (Quadrado / Instagram). Limite do seu plano: {{ maxPhotosCount }} fotos.</small>
            </div>
            <div>
              <input type="file" id="photoFileInput" class="d-none" @change="handleFileSelection($event, 'Photo')" accept="image/*" :disabled="photosList.length >= maxPhotosCount" />
              <!-- O BOTÃO DE UPLOAD FICA DESATIVADO E MUDA DE COR AUTOMATICAMENTE CASO RETORNE 0 VAGAS -->
              <label for="photoFileInput" :class="photosList.length >= maxPhotosCount ? 'btn btn-sm btn-soft-secondary mb-0 disabled' : 'btn btn-sm btn-success mb-0 shadow-none'" :disabled="savingPhoto || photosList.length >= maxPhotosCount">
                <i class="ri-add-line me-1 align-middle" v-if="!savingPhoto"></i>
                {{ savingPhoto ? "Subindo Foto..." : "Adicionar à Galeria" }}
              </label>
            </div>
          </div>
          <div class="card-body">
            
            <!-- GRADE (GRID) DE FOTOS EM CARTÕES SEPARADOS -->
            <div class="row row-cols-xxl-3 row-cols-md-2 row-cols-2 g-2 gallery-grid" v-if="photosList.length > 0">
              <div class="col" v-for="item in photosList" :key="item.id">
                <div class="card border shadow-none mb-0 overflow-hidden h-100 project-card">
                  <div class="bg-light d-flex align-items-center justify-content-center border-bottom" style="height: 160px; overflow: hidden; position: relative;">
                    <img :src="resolveMediaUrl(item.mediaUrl)" class="w-100 h-100 object-fit-cover" alt="Galeria" />
                    <!-- Botão Flutuante de Exclusão Humanizado -->
                    <button type="button" class="btn btn-danger btn-sm rounded-circle position-absolute top-0 end-0 m-2 p-0 d-flex align-items-center justify-content-center shadow" style="width: 26px; height: 26px;" @click="handleDeleteMedia(item.id)" title="Deletar da Galeria">
                      <i class="ri-delete-bin-line fs-12"></i>
                    </button>
                  </div>
                  <div class="p-2 card-body d-flex flex-column justify-content-between">
                    
                    <div class="d-flex justify-content-between align-items-center">
                      <p class="text-muted small mb-0 text-truncate fw-medium pe-2">{{ item.caption || "Sem legenda ativa..." }}</p>
                      <button type="button" class="btn btn-link btn-sm text-info p-0 shadow-none" @click="startEditCaption(item)" title="Editar Legenda">
                        <i class="ri-pencil-line"></i>
                      </button>
                    </div>

                  </div>
                </div>
              </div>
            </div>

            <!-- PLACEHOLDER VAZIO -->
            <div v-else class="text-center py-5 border rounded bg-light border-dashed">
              <i class="ri-picture-in-picture-line text-muted fs-32 mb-2 d-block"></i>
              <p class="text-muted mb-0 fs-13">Sua galeria está vazia. Adicione fotos marcantes da sua jornada!</p>
            </div>

          </div>
        </div>
      </div>

      <!-- SEÇÃO 3: CATÁLOGO DE LINKS DO YOUTUBE (COLUNA DIREITA) -->
      <div class="col-xl-5 col-lg-6 mb-3 videos-section">
        <div class="card h-100 portfolio-section-card">
          <button type="button" class="card-header bg-transparent border-0 p-3 w-100 text-start video-accordion-toggle" @click="videosExpanded = !videosExpanded">
            <h5 class="card-title mb-1 text-dark fw-bold d-flex align-items-center">
              <i class="ri-youtube-line me-1 text-danger"></i> Vídeos de Divulgação
              <!-- BADGE REATIVA DO LIMITE DE VÍDEOS -->
              <span :class="videosList.length >= 3 ? 'badge bg-danger-subtle text-danger ms-2 fs-12' : 'badge bg-info-subtle text-info ms-2 fs-12'">
                {{ videosList.length >= 3 ? 'Limite Atingido' : `Restam ${3 - videosList.length} vagas` }}
              </span>
            </h5>
            <small class="text-muted d-block">Fixe até 3 links de apresentações ou clipes musicais no seu perfil.</small>
            <i class="ms-auto fs-20" :class="videosExpanded ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
          </button>
          <div v-show="videosExpanded" class="card-body">
            
            <!-- FORMULÁRIO TEXTUAL DE INSERÇÃO -->
            <button v-if="videosList.length < 3 && !videoFormExpanded" type="button" class="btn btn-soft-danger w-100 mb-3 fw-semibold" @click="videoFormExpanded = true"><i class="ri-add-circle-line me-1"></i> Adicionar vídeo</button>
            <form v-if="videosList.length < 3 && videoFormExpanded" @submit.prevent="handleAddVideo" class="row g-2 mb-4 p-3 bg-light border rounded">
              <div class="col-12">
                <label class="form-label small fw-semibold text-muted mb-1">Link Completo do Vídeo</label>
                <input type="url" class="form-control form-control-sm" v-model="videoForm.videoUrl" placeholder="Ex: https://youtube.com..." required />
              </div>
              <div class="col-12 mb-2">
                <label class="form-label small fw-semibold text-muted mb-1">Título / Legenda Explicativa</label>
                <input type="text" class="form-control form-control-sm" v-model="videoForm.caption" placeholder="Ex: Clipe Oficial, Ao vivo na Arena..." required />
              </div>
              <div class="col-12">
                <button type="submit" class="btn btn-danger btn-sm w-100 shadow-sm" :disabled="savingVideo">
                  <i class="ri-add-circle-line me-1 align-middle" v-if="!savingVideo"></i>
                  {{ savingVideo ? "Processando no C#..." : "Adicionar Link do YouTube" }}
                </button>
              </div>
            </form>

            <!-- AVISO VISUAL SE O MÚSICO JÁ ENCHEU AS VAGAS DE VÍDEO -->
            <div v-else class="alert alert-warning p-3 border-dashed border-warning rounded mb-4 text-center" role="alert">
              <h6 class="fw-bold text-warning mb-1"><i class="ri-information-line me-1"></i> Catálogo de Vídeos Preenchido</h6>
              <p class="fs-12 mb-0 text-muted">Você atingiu o limite de 3 links. Para adicionar um novo clipe, remova um dos links abaixo.</p>
            </div>

            <!-- LISTAGEM DE LINKS SALVOS NO MYSQL -->
            <div class="d-flex flex-column gap-2" v-if="videosList.length > 0">
              <div class="p-3 border rounded shadow-none bg-white d-flex align-items-center justify-content-between" v-for="item in videosList" :key="item.id">
                <div class="flex-grow-1 pe-3 overflow-hidden">
                  <h6 class="fs-13 mb-1 fw-bold text-dark text-truncate">{{ item.caption }}</h6>
                  <a :href="item.mediaUrl" target="_blank" class="text-danger small font-monospace text-truncate d-block"><i class="ri-link-m me-1"></i>Link do YouTube</a>
                </div>
                <div class="flex-shrink-0">
                  <button type="button" class="btn btn-sm btn-soft-danger shadow-none btn-icon rounded" @click="handleDeleteMedia(item.id)" title="Remover Link">
                    <i class="ri-delete-bin-line"></i>
                  </button>
                </div>
              </div>
            </div>

            <!-- PLACEHOLDER VAZIO -->
            <div v-else class="text-center py-5 border rounded bg-light border-dashed">
              <i class="ri-video-line text-muted fs-32 mb-2 d-block"></i>
              <p class="text-muted mb-0 fs-13">Nenhum vídeo cadastrado no catálogo.</p>
            </div>

          </div>
        </div>
      </div>

    </div>

    <!-- MODAL DE EDIÇÃO DE LEGENDA -->
    <div class="modal fade show d-block caption-edit-modal" tabindex="-1" role="dialog" v-if="editingItem && editingMediaItem" @click.self="cancelEditCaption">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content border-0 shadow-lg">
          <div class="modal-header">
            <h5 class="modal-title fw-bold"><i class="ri-pencil-line text-info me-1"></i> Editar legenda da foto</h5>
            <button type="button" class="btn-close" @click="cancelEditCaption" aria-label="Fechar"></button>
          </div>
          <div class="modal-body">
            <label class="form-label fw-semibold">Legenda</label>
            <input type="text" class="form-control" v-model="editCaptionText" placeholder="Digite a legenda da foto..." maxlength="180" @keyup.enter="handleSaveEdit(editingMediaItem, 'Photo')" />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" @click="cancelEditCaption">Cancelar</button>
            <button type="button" class="btn btn-success" @click="handleSaveEdit(editingMediaItem, 'Photo')">
              <i class="ri-save-line me-1"></i> Salvar legenda
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ============================================================== -->
    <!-- JANELA MODAL DO BOOTSTRAP PARA CORTE VISUAL EM TEMPO REAL      -->
    <!-- ============================================================== -->
    <div class="modal fade show d-block" tabindex="-1" role="dialog" v-if="showCropModal" style="background: rgba(0,0,0,0.85); z-index: 1050;">
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content border-0 shadow-lg bg-dark text-white">
          <div class="modal-header border-secondary p-3">
            <h5 class="modal-title fw-bold text-white">
              <i class="ri-crop-2-line text-primary me-1"></i> 
              Ajustar Enquadramento da {{ cropType === 'Cover' ? 'Imagem de Capa' : 'Foto da Galeria' }}
            </h5>
            <button type="button" class="btn-close btn-close-white" @click="handleCancelCrop" aria-label="Close"></button>
          </div>
          <div class="modal-body p-0 bg-black d-flex align-items-center justify-content-center" style="max-height: 500px; overflow: hidden;">
            <!-- Tag alvo interceptada pelo ciclo de vida do CropperJS no script -->
            <img ref="imageToCropRef" :src="imageSrcToCrop" class="img-fluid" style="max-width: 100%; display: block;" alt="Preview" />
          </div>
          <div class="modal-footer border-secondary p-2 d-flex justify-content-between">
            <button type="button" class="btn btn-sm btn-outline-light" @click="handleCancelCrop">Cancelar</button>
            <button type="button" class="btn btn-sm btn-primary px-4 fw-bold shadow" @click="handleConfirmCrop">
              <i class="ri-scissors-cut-line me-1"></i> Confirmar Ajuste e Enviar
            </button>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<style scoped>
.caption-edit-modal { background: rgba(0, 0, 0, 0.55); z-index: 1060; }
.caption-edit-modal .modal-dialog { max-width: 520px; padding: 12px; }
@media (max-width: 767.98px) {
  .caption-edit-modal .modal-dialog { margin: 0 auto; padding: 16px; }
  .caption-edit-modal .modal-footer { gap: 8px; }
  .caption-edit-modal .modal-footer .btn { flex: 1 1 0; min-height: 44px; }
  .caption-edit-modal .form-control { min-height: 46px; font-size: 16px; }
  .portfolio-mobile-content { margin-left: -6px; margin-right: -6px; }
  .portfolio-mobile-content > [class*="col-"] { padding-left: 6px; padding-right: 6px; }
  .portfolio-section-card, .portfolio-cover-card { border-radius: 10px; margin-bottom: 0; }
  .portfolio-section-card > .card-header, .portfolio-cover-card > .card-header { padding: 12px !important; }
  .portfolio-section-card > .card-body { padding: 12px; }
  .portfolio-cover-card .card-header, .gallery-section .card-header { gap: 10px; align-items: stretch !important; flex-direction: column; }
  .portfolio-cover-card .card-header > div, .gallery-section .card-header > div { width: 100%; min-width: 0; }
  .portfolio-cover-card .card-title, .portfolio-section-card .card-title { font-size: 15px; line-height: 1.25; }
  .portfolio-cover-card .card-header small, .portfolio-section-card .card-header small { font-size: 11px; line-height: 1.4; white-space: normal; }
  .portfolio-cover-card .card-body { min-height: 120px !important; max-height: 150px !important; }
  .portfolio-cover-card label.btn, .gallery-section label.btn { min-height: 40px; width: 100%; display: inline-flex; align-items: center; justify-content: center; font-size: 12px; }
  .gallery-section .card-title { display: flex; flex-wrap: wrap; align-items: center; gap: 6px; }
  .gallery-section .card-title .badge { margin-left: 0 !important; }
  .gallery-section .card-body { padding: 10px !important; }
  .gallery-grid { --vz-gutter-x: 10px; --vz-gutter-y: 10px; }
  .gallery-grid .project-card .bg-light { height: 135px !important; }
  .gallery-grid .card-body { min-width: 0; min-height: 42px; padding: 8px !important; }
  .gallery-grid .text-truncate { font-size: 11px; min-width: 0; }
  .video-accordion-toggle { color: inherit; border-radius: 10px 10px 0 0; position: relative; padding-right: 42px !important; }
  .video-accordion-toggle .card-title { flex-wrap: wrap; gap: 6px; padding-right: 0; }
  .video-accordion-toggle .card-title .badge { margin-left: 0 !important; }
  .video-accordion-toggle > i:last-child { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); }
  .video-accordion-toggle:focus { outline: none; box-shadow: none; }
  .videos-section .form-control { min-height: 44px; font-size: 14px; }
  .videos-section .btn { min-height: 42px; }
}
@media (max-width: 359.98px) {
  .portfolio-mobile-content { margin-left: -6px; margin-right: -6px; }
  .portfolio-section-card > .card-header, .portfolio-cover-card > .card-header { padding: 10px !important; }
  .portfolio-section-card > .card-body { padding: 8px !important; }
  .gallery-grid { --vz-gutter-x: 8px; --vz-gutter-y: 8px; }
  .gallery-grid .project-card .bg-light { height: 122px !important; }
  .gallery-grid .text-truncate { font-size: 10px; }
}
</style>
