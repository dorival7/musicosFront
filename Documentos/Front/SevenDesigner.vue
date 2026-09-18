<template>
  <div class="seven-designer">
    <div class="card border-0 shadow-sm mb-3">
      <div class="card-body px-4 py-3">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <div class="d-flex align-items-center gap-2 mb-1">
              <span class="designer-icon">🎨</span>
              <h5 class="mb-0 fw-bold text-dark">Seven Designer</h5>
              <span class="badge designer-badge">NOVO</span>
            </div>
            <p class="text-muted mb-0 small">
              O template já vem montado. Use seus uploads e personalize somente o que desejar.
            </p>
          </div>
          <div class="designer-format">
            <span class="text-muted small">Formato</span>
            <strong>Story 1080 × 1920</strong>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-xl-4 col-lg-5">
        <div class="card border-0 shadow-sm mb-3">
          <div class="card-body p-3">
            <div class="uploads-header">
              <div>
                <strong>Meus uploads</strong>
                <small>Fotos, logos e imagens do músico.</small>
              </div>
              <span class="uploads-count">{{ usados }} / {{ limite }}</span>
            </div>

            <input
              ref="inputUpload"
              type="file"
              accept="image/png,image/jpeg,image/webp"
              class="d-none"
              @change="enviarUpload"
            />

            <button
              type="button"
              class="btn btn-warning w-100 fw-bold mb-3"
              :disabled="enviando || !podeEnviar"
              @click="$refs.inputUpload?.click()"
            >
              {{ enviando ? "Enviando..." : "+ Enviar nova imagem" }}
            </button>

            <div v-if="erroUploads" class="alert alert-danger py-2 small">
              {{ erroUploads }}
            </div>

            <div v-if="carregando" class="text-muted small py-3 text-center">
              Carregando seus uploads...
            </div>

            <div v-else-if="assets.length === 0" class="uploads-empty">
              <strong>Nenhuma imagem enviada</strong>
              <small>Envie uma foto ou logo para começar.</small>
            </div>

            <div v-else class="uploads-grid">
              <div v-for="asset in assets" :key="asset.id" class="upload-item">
                <button
                  type="button"
                  class="upload-thumb"
                  title="Adicionar ao cartaz"
                  @click="adicionarAoCartaz(asset)"
                >
                  <img :src="urlAsset(asset.originalUrl)" :alt="asset.originalFileName" />
                  <span>+ Cartaz</span>
                </button>
                <button
                  type="button"
                  class="upload-delete"
                  title="Excluir dos uploads"
                  @click="excluirUpload(asset)"
                >
                  ×
                </button>
              </div>
            </div>

            <div v-if="!podeEnviar && limite > 0" class="limit-warning">
              Limite atingido. Exclua uma imagem dos uploads para liberar espaço.
            </div>
          </div>
        </div>

        <div class="card border-0 shadow-sm">
          <div class="card-body p-3">
            <strong class="d-block mb-1">Dados do template</strong>
            <small class="text-muted d-block mb-3">
              Mantidos nesta etapa para o template abrir pronto. A edição direta no canvas será ligada em seguida.
            </small>

            <input v-model="cartaz.artista" class="form-control mb-2" placeholder="Nome artístico" />
            <div class="row g-2">
              <div class="col-7"><input v-model="cartaz.data" type="date" class="form-control" /></div>
              <div class="col-5"><input v-model="cartaz.horario" type="time" class="form-control" /></div>
            </div>
            <input v-model="cartaz.local" class="form-control mt-2" placeholder="Local do show" />
            <input v-model="cartaz.cidade" class="form-control mt-2" placeholder="Cidade" />
            <input v-model="cartaz.chamada" class="form-control mt-2" placeholder="Chamada" />
            <input v-model="cartaz.extra" class="form-control mt-2" placeholder="Informação adicional" />
          </div>
        </div>
      </div>

      <div class="col-xl-8 col-lg-7">
        <div class="card border-0 shadow-sm">
          <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div>
                <span class="step-label">EDITOR VISUAL</span>
                <h6 class="fw-bold text-dark mt-2 mb-0">Seu cartaz</h6>
              </div>
              <span class="badge bg-light text-muted border">Sertanejo Sunset</span>
            </div>

            <div v-if="elementoSelecionado?.tipo === 'imagem'" class="context-toolbar mb-3">
              <div class="context-title">
                <strong>Imagem selecionada</strong>
                <small>{{ elementoSelecionado.nome || "Imagem" }}</small>
              </div>

              <button
                v-if="!elementoSelecionado.backgroundRemovedSrc"
                type="button"
                class="btn btn-sm btn-dark"
                :disabled="removendoBackground"
                @click="removerFundoSelecionada"
              >
                {{ removendoBackground ? "Processando..." : "✨ Remover fundo" }}
              </button>

              <template v-else>
                <button type="button" class="btn btn-sm btn-outline-secondary" @click="usarOriginalSelecionada">
                  Original
                </button>
                <button type="button" class="btn btn-sm btn-outline-dark" @click="usarSemFundoSelecionada">
                  Sem fundo
                </button>
              </template>

              <button type="button" class="btn btn-sm btn-outline-secondary" @click="duplicarSelecionada">
                Duplicar
              </button>
              <button type="button" class="btn btn-sm btn-outline-danger" @click="removerDoCartaz">
                Remover do cartaz
              </button>
            </div>

            <div v-if="erroBackground" class="alert alert-danger py-2 small">
              {{ erroBackground }}
            </div>

            <div class="preview-workspace">
              <DesignerCanvas
                ref="designerCanvas"
                :dados="cartaz"
                :imagens="imagensCartaz"
                @selecionar-elemento="selecionarElemento"
                @atualizar-imagem="atualizarImagem"
                @pedir-upload="$refs.inputUpload?.click()"
              />
            </div>

            <div class="designer-notice mt-3">
              <span>ℹ️</span>
              <div>
                <strong>Template assistido</strong>
                <p class="mb-0">
                  O cartaz já abre com a composição profissional. As imagens adicionadas podem ser movidas,
                  redimensionadas e removidas sem alterar o template original.
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
import DesignerCanvas from "./DesignerCanvas.vue";
import { removerBackground, liberarBackgroundUrl } from "./services/backgroundRemovalService";
import {
  listarDesignerAssets,
  enviarDesignerAsset,
  excluirDesignerAsset,
  urlDesignerAsset
} from "./services/designerAssetsService";

export default {
  name: "SevenDesigner",
  components: { DesignerCanvas },

  data() {
    return {
      cartaz: {
        artista: "Banda Quatro",
        data: "2026-09-18",
        horario: "20:30",
        local: "Fazenda Monte Belo",
        cidade: "Maringá - PR",
        chamada: "Música boa é aqui!",
        extra: "Show ao vivo"
      },

      assets: [],
      usados: 0,
      limite: 10,
      podeEnviar: true,
      carregando: false,
      enviando: false,
      erroUploads: null,

      imagensCartaz: [],
      elementoSelecionadoId: null,

      removendoBackground: false,
      erroBackground: null
    };
  },

  computed: {
    elementoSelecionado() {
      return this.imagensCartaz.find(x => x.elementId === this.elementoSelecionadoId) || null;
    }
  },

  mounted() {
    this.carregarUploads();
  },

  beforeUnmount() {
    for (const imagem of this.imagensCartaz) {
      if (imagem.backgroundRemovedSrc?.startsWith("blob:")) {
        liberarBackgroundUrl(imagem.backgroundRemovedSrc);
      }
    }
  },

  methods: {
    urlAsset(url) {
      return urlDesignerAsset(url);
    },

    async carregarUploads() {
      this.carregando = true;
      this.erroUploads = null;

      try {
        const resposta = await listarDesignerAssets();
        this.assets = resposta?.items || [];
        this.usados = Number(resposta?.used || 0);
        this.limite = Number(resposta?.limit || 0);
        this.podeEnviar = Boolean(resposta?.canUpload);
      } catch (erro) {
        this.erroUploads = erro?.message || "Não foi possível carregar seus uploads.";
      } finally {
        this.carregando = false;
      }
    },

    async enviarUpload(event) {
      const file = event.target.files?.[0];
      event.target.value = "";

      if (!file || this.enviando) return;

      this.enviando = true;
      this.erroUploads = null;

      try {
        await enviarDesignerAsset(file);
        await this.carregarUploads();
      } catch (erro) {
        this.erroUploads = erro?.message || "Não foi possível enviar a imagem.";
      } finally {
        this.enviando = false;
      }
    },

    async excluirUpload(asset) {
      const emUso = this.imagensCartaz.some(x => x.assetId === asset.id);

      if (emUso) {
        alert("Remova primeiro essa imagem do cartaz. Depois você poderá excluí-la dos uploads.");
        return;
      }

      if (!window.confirm(`Excluir "${asset.originalFileName}" dos seus uploads?`)) {
        return;
      }

      try {
        await excluirDesignerAsset(asset.id);
        await this.carregarUploads();
      } catch (erro) {
        this.erroUploads = erro?.message || "Não foi possível excluir a imagem.";
      }
    },

    adicionarAoCartaz(asset) {
      const quantidade = this.imagensCartaz.length;

      if (quantidade >= 5) {
        alert("Este cartaz permite até 5 imagens nesta versão.");
        return;
      }

      const elementId = `img-${Date.now()}-${Math.random().toString(16).slice(2)}`;

      this.imagensCartaz.push({
        elementId,
        tipo: "imagem",
        assetId: asset.id,
        nome: asset.originalFileName,
        arquivo: null,
        originalSrc: this.urlAsset(asset.originalUrl),
        backgroundRemovedSrc: asset.backgroundRemovedUrl
          ? this.urlAsset(asset.backgroundRemovedUrl)
          : null,
        src: this.urlAsset(asset.backgroundRemovedUrl || asset.originalUrl),
        usarSemFundo: Boolean(asset.backgroundRemovedUrl),

        // A primeira imagem recebe a posição recomendada pelo template.
        // As seguintes entram levemente deslocadas para ficarem visíveis.
        x: 110 + (quantidade * 35),
        y: 300 + (quantidade * 35),
        width: quantidade === 0 ? 860 : 520,
        height: quantidade === 0 ? 920 : 620,
        rotation: 0
      });

      this.elementoSelecionadoId = elementId;
    },

    selecionarElemento(id) {
      this.elementoSelecionadoId = id;
    },

    atualizarImagem(payload) {
      const indice = this.imagensCartaz.findIndex(x => x.elementId === payload.elementId);
      if (indice < 0) return;

      this.imagensCartaz[indice] = {
        ...this.imagensCartaz[indice],
        ...payload
      };
    },

    async obterArquivoOriginal(imagem) {
      if (imagem.arquivo instanceof File) {
        return imagem.arquivo;
      }

      const resposta = await fetch(imagem.originalSrc);
      if (!resposta.ok) {
        throw new Error("Não foi possível carregar a imagem original.");
      }

      const blob = await resposta.blob();

      return new File(
        [blob],
        imagem.nome || "imagem.jpg",
        { type: blob.type || "image/jpeg" }
      );
    },

    async removerFundoSelecionada() {
      const imagem = this.elementoSelecionado;
      if (!imagem || this.removendoBackground) return;

      this.removendoBackground = true;
      this.erroBackground = null;

      try {
        const arquivo = await this.obterArquivoOriginal(imagem);
        const resultado = await removerBackground(arquivo);

        if (
          imagem.backgroundRemovedSrc?.startsWith("blob:") &&
          imagem.backgroundRemovedSrc !== resultado.url
        ) {
          liberarBackgroundUrl(imagem.backgroundRemovedSrc);
        }

        this.atualizarImagem({
          elementId: imagem.elementId,
          arquivo,
          backgroundRemovedSrc: resultado.url,
          src: resultado.url,
          usarSemFundo: true
        });
      } catch (erro) {
        this.erroBackground = erro?.message || "Não foi possível remover o fundo.";
      } finally {
        this.removendoBackground = false;
      }
    },

    usarOriginalSelecionada() {
      const imagem = this.elementoSelecionado;
      if (!imagem) return;

      this.atualizarImagem({
        elementId: imagem.elementId,
        src: imagem.originalSrc,
        usarSemFundo: false
      });
    },

    usarSemFundoSelecionada() {
      const imagem = this.elementoSelecionado;
      if (!imagem?.backgroundRemovedSrc) return;

      this.atualizarImagem({
        elementId: imagem.elementId,
        src: imagem.backgroundRemovedSrc,
        usarSemFundo: true
      });
    },

    duplicarSelecionada() {
      const imagem = this.elementoSelecionado;
      if (!imagem) return;

      if (this.imagensCartaz.length >= 5) {
        alert("Este cartaz permite até 5 imagens nesta versão.");
        return;
      }

      const copia = {
        ...imagem,
        elementId: `img-${Date.now()}-${Math.random().toString(16).slice(2)}`,
        x: imagem.x + 45,
        y: imagem.y + 45
      };

      this.imagensCartaz.push(copia);
      this.elementoSelecionadoId = copia.elementId;
    },

    removerDoCartaz() {
      const imagem = this.elementoSelecionado;
      if (!imagem) return;

      this.imagensCartaz = this.imagensCartaz.filter(x => x.elementId !== imagem.elementId);
      this.elementoSelecionadoId = null;
    }
  }
};
</script>

<style scoped>
.seven-designer { width: 100%; }
.designer-icon { font-size: 22px; }
.designer-badge { background: #fff3cd; color: #856404; }
.designer-format { display: flex; flex-direction: column; text-align: right; }
.step-label { font-size: 11px; font-weight: 800; letter-spacing: .08em; color: #6c757d; }

.uploads-header {
  display: flex; justify-content: space-between; gap: 12px; align-items: center; margin-bottom: 12px;
}
.uploads-header strong, .uploads-header small { display: block; }
.uploads-header small { color: #6c757d; margin-top: 2px; }
.uploads-count {
  flex: 0 0 auto; border-radius: 999px; background: #f1f3f5; padding: 5px 9px; font-size: 12px; font-weight: 800;
}
.uploads-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
.upload-item { position: relative; }
.upload-thumb {
  width: 100%; aspect-ratio: 1; padding: 0; overflow: hidden; border: 1px solid #dee2e6;
  border-radius: 10px; background: #f8f9fa; position: relative; cursor: pointer;
}
.upload-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
.upload-thumb span {
  position: absolute; left: 5px; right: 5px; bottom: 5px; padding: 3px 4px;
  border-radius: 6px; background: rgba(0,0,0,.68); color: white; font-size: 10px; font-weight: 800;
}
.upload-delete {
  position: absolute; top: -6px; right: -6px; width: 24px; height: 24px; border-radius: 50%;
  border: 2px solid white; background: #dc3545; color: white; font-weight: 900; line-height: 18px;
}
.uploads-empty {
  min-height: 120px; display: grid; place-content: center; text-align: center; border: 1px dashed #ced4da;
  border-radius: 10px; color: #6c757d; margin-bottom: 10px;
}
.uploads-empty strong, .uploads-empty small { display: block; }
.limit-warning { margin-top: 10px; font-size: 12px; color: #842029; background: #f8d7da; padding: 8px; border-radius: 8px; }

.context-toolbar {
  display: flex; flex-wrap: wrap; align-items: center; gap: 8px; padding: 10px;
  border: 1px solid #dee2e6; border-radius: 10px; background: #f8f9fa;
}
.context-title { margin-right: auto; min-width: 150px; }
.context-title strong, .context-title small { display: block; }
.context-title small { color: #6c757d; max-width: 240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.preview-workspace { width: 100%; }
.designer-notice {
  display: flex; gap: 10px; padding: 12px; border-radius: 10px; background: #f8f9fa; color: #495057;
}
.designer-notice strong { display: block; }
.designer-notice p { font-size: 12px; margin-top: 2px; }
</style>
