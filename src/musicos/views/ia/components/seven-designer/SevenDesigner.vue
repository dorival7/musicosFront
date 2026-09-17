<template>
  <div class="seven-designer">

    <!-- CABEÇALHO -->
    <div class="card border-0 shadow-sm mb-3">
      <div class="card-body px-4 py-3">

        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
          <div>
            <div class="d-flex align-items-center gap-2 mb-1">
              <span class="designer-icon">
                🎨
              </span>

              <h5 class="mb-0 fw-bold text-dark">
                Seven Designer
              </h5>

              <span class="badge designer-badge">
                NOVO
              </span>
            </div>

            <p class="text-muted mb-0 small">
              Crie cartazes profissionais para divulgar
              seus shows no WhatsApp e Instagram.
            </p>
          </div>

          <div class="designer-format">
            <span class="text-muted small">
              Formato
            </span>

            <strong>
              Story 1080 × 1920
            </strong>
          </div>
        </div>

      </div>
    </div>

    <!-- ÁREA PRINCIPAL -->
    <div class="row g-3">

      <!-- CONTROLES -->
      <div class="col-xl-4 col-lg-5">

        <div class="card border-0 shadow-sm h-100">
          <div class="card-body p-4">

            <div class="mb-4">
              <span class="step-label">
                PASSO 1
              </span>

              <h6 class="fw-bold text-dark mt-2 mb-1">
                Informações do cartaz
              </h6>

              <p class="text-muted small mb-0">
                Nesta primeira versão vamos utilizar
                informações preenchidas manualmente.
              </p>
            </div>

            <!-- ARTISTA -->
            <div class="mb-3">
              <label class="form-label designer-label">
                Nome artístico
              </label>

              <input
                v-model="cartaz.artista"
                type="text"
                class="form-control"
                placeholder="Ex.: Banda Quatro"
              />
            </div>

            <!-- DATA / HORÁRIO -->
            <div class="row">

              <div class="col-md-7">
                <div class="mb-3">
                  <label class="form-label designer-label">
                    Data
                  </label>

                  <input
                    v-model="cartaz.data"
                    type="date"
                    class="form-control"
                  />
                </div>
              </div>

              <div class="col-md-5">
                <div class="mb-3">
                  <label class="form-label designer-label">
                    Horário
                  </label>

                  <input
                    v-model="cartaz.horario"
                    type="time"
                    class="form-control"
                  />
                </div>
              </div>

            </div>

            <!-- LOCAL -->
            <div class="mb-3">
              <label class="form-label designer-label">
                Local do show
              </label>

              <input
                v-model="cartaz.local"
                type="text"
                class="form-control"
                placeholder="Ex.: Fazenda Monte Belo"
              />
            </div>

            <!-- CIDADE -->
            <div class="mb-3">
              <label class="form-label designer-label">
                Cidade
              </label>

              <input
                v-model="cartaz.cidade"
                type="text"
                class="form-control"
                placeholder="Ex.: Maringá - PR"
              />
            </div>

            <!-- CHAMADA -->
            <div class="mb-3">
              <label class="form-label designer-label">
                Chamada
              </label>

              <input
                v-model="cartaz.chamada"
                type="text"
                class="form-control"
                maxlength="60"
                placeholder="Ex.: Música boa é aqui!"
              />
            </div>

            <!-- EXTRA -->
            <div class="mb-4">
              <label class="form-label designer-label">
                Informação adicional
              </label>

              <input
                v-model="cartaz.extra"
                type="text"
                class="form-control"
                maxlength="60"
                placeholder="Ex.: Entrada gratuita"
              />
            </div>

            <!-- =====================================================
                 FOTO DO ARTISTA
                 ===================================================== -->
            <div class="designer-photo-control">

              <label class="form-label designer-label">
                Foto do artista
              </label>

              <input
                ref="inputFotoArtista"
                type="file"
                accept="image/png,image/jpeg,image/webp"
                class="d-none"
                @change="selecionarFotoArtista"
              />

              <!-- SEM FOTO -->
              <button
                v-if="!fotoArtista.src"
                type="button"
                class="photo-upload-button"
                @click="abrirSeletorFoto"
              >
                <span class="photo-upload-icon">
                  📷
                </span>

                <strong>
                  Escolher foto do artista
                </strong>

                <small>
                  JPG, PNG ou WEBP
                </small>
              </button>

              <!-- COM FOTO -->
              <div
                v-else
                class="photo-editor"
              >

                <!-- ARQUIVO -->
                <div class="photo-selected">

                  <div class="photo-file-info">
                    <strong>
                      Foto selecionada
                    </strong>

                    <small>
                      {{ fotoArtista.nomeArquivo }}
                    </small>
                  </div>

                  <button
                    type="button"
                    class="btn btn-sm btn-light border"
                    :disabled="removendoBackground"
                    @click="abrirSeletorFoto"
                  >
                    Trocar
                  </button>

                </div>

                <!-- =================================================
                     REMOÇÃO DE FUNDO
                     ================================================= -->

                <!-- AINDA NÃO PROCESSADA -->
                <div
                  v-if="
                    !fotoArtista.backgroundRemovedSrc &&
                    !removendoBackground
                  "
                  class="background-removal-area"
                >

                  <button
                    type="button"
                    class="remove-background-button"
                    @click="removerFundoFoto"
                  >
                    <span class="remove-background-icon">
                      ✨
                    </span>

                    <span>
                      <strong>
                        Remover fundo
                      </strong>

                      <small>
                        Processamento feito no seu dispositivo
                      </small>
                    </span>
                  </button>

                </div>

                <!-- PROCESSANDO -->
                <div
                  v-if="removendoBackground"
                  class="background-processing"
                >

                  <div class="processing-header">

                    <div>
                      <strong>
                        ✨ Removendo fundo...
                      </strong>

                      <small>
                        {{ mensagemProcessamento }}
                      </small>
                    </div>

                    <span
                      v-if="progressoBackground !== null"
                      class="processing-percent"
                    >
                      {{ progressoBackground }}%
                    </span>

                  </div>

                  <div class="designer-progress">
                    <div
                      class="designer-progress-bar"
                      :class="{
                        'designer-progress-indeterminate':
                          progressoBackground === null
                      }"
                      :style="
                        progressoBackground !== null
                          ? {
                              width:
                                progressoBackground + '%'
                            }
                          : {}
                      "
                    ></div>
                  </div>

                  <p class="processing-help mb-0">
                    No primeiro uso o modelo precisa ser
                    carregado no navegador. Os próximos
                    processamentos tendem a ser mais rápidos.
                  </p>

                </div>

                <!-- PROCESSADA -->
                <div
                  v-if="
                    fotoArtista.backgroundRemovedSrc &&
                    !removendoBackground
                  "
                  class="background-success"
                >

                  <div class="background-success-title">
                    <span class="success-check">
                      ✓
                    </span>

                    <div>
                      <strong>
                        Fundo removido
                      </strong>

                      <small>
                        Escolha qual versão deseja usar no cartaz.
                      </small>
                    </div>
                  </div>

                  <div class="photo-version-switch">

                    <button
                      type="button"
                      :class="{
                        active:
                          !fotoArtista.usarSemFundo
                      }"
                      @click="usarFotoOriginal"
                    >
                      Original
                    </button>

                    <button
                      type="button"
                      :class="{
                        active:
                          fotoArtista.usarSemFundo
                      }"
                      @click="usarFotoSemFundo"
                    >
                      Sem fundo
                    </button>

                  </div>

                </div>

                <!-- ERRO -->
                <div
                  v-if="
                    erroBackground &&
                    !removendoBackground
                  "
                  class="background-error"
                >
                  <strong>
                    Não foi possível remover o fundo.
                  </strong>

                  <span>
                    {{ erroBackground }}
                  </span>

                  <button
                    type="button"
                    class="btn btn-sm btn-outline-danger mt-2"
                    @click="removerFundoFoto"
                  >
                    Tentar novamente
                  </button>
                </div>

                <!-- =================================================
                     ZOOM
                     ================================================= -->
                <div class="photo-setting">

                  <div class="photo-setting-header">
                    <span>
                      Zoom
                    </span>

                    <strong>
                      {{ Math.round(fotoArtista.zoom * 100) }}%
                    </strong>
                  </div>

                  <input
                    v-model.number="fotoArtista.zoom"
                    type="range"
                    min="0.25"
                    max="3"
                    step="0.05"
                    class="form-range"
                  />

                </div>

                <!-- =================================================
                     POSIÇÃO
                     ================================================= -->
                <div class="photo-setting">

                  <div class="photo-setting-header">
                    <span>
                      Posição da foto
                    </span>
                  </div>

                  <div class="photo-position-controls">

                    <div></div>

                    <button
                      type="button"
                      title="Mover para cima"
                      @click="moverFoto(0, -15)"
                    >
                      ↑
                    </button>

                    <div></div>

                    <button
                      type="button"
                      title="Mover para esquerda"
                      @click="moverFoto(-15, 0)"
                    >
                      ←
                    </button>

                    <button
                      type="button"
                      class="center-button"
                      title="Centralizar"
                      @click="centralizarFoto"
                    >
                      ●
                    </button>

                    <button
                      type="button"
                      title="Mover para direita"
                      @click="moverFoto(15, 0)"
                    >
                      →
                    </button>

                    <div></div>

                    <button
                      type="button"
                      title="Mover para baixo"
                      @click="moverFoto(0, 15)"
                    >
                      ↓
                    </button>

                    <div></div>

                  </div>

                </div>

                <!-- REMOVER FOTO -->
                <button
                  type="button"
                  class="btn btn-sm btn-outline-danger w-100 mt-3"
                  :disabled="removendoBackground"
                  @click="removerFotoArtista"
                >
                  Remover foto
                </button>

              </div>

            </div>

          </div>
        </div>

      </div>

      <!-- =========================================================
           PREVIEW
           ========================================================= -->
      <div class="col-xl-8 col-lg-7">

        <div class="card border-0 shadow-sm">
          <div class="card-body p-4">

            <div class="d-flex justify-content-between align-items-center mb-3">

              <div>
                <span class="step-label">
                  PREVIEW
                </span>

                <h6 class="fw-bold text-dark mt-2 mb-0">
                  Seu cartaz
                </h6>
              </div>

              <span class="badge bg-light text-muted border">
                Sertanejo Sunset
              </span>

            </div>

            <div class="preview-workspace">
              <DesignerCanvas
                :dados="cartaz"
                :foto-artista="fotoArtista"
              />
            </div>

            <div class="designer-notice mt-3">
              <span>
                ℹ️
              </span>

              <div>
                <strong>
                  Protótipo do Seven Designer
                </strong>

                <p class="mb-0">
                  O motor do cartaz trabalha em 1080 × 1920
                  e será evoluído com templates profissionais,
                  camadas gráficas e recursos de composição.
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

import {
  removerBackground,
  liberarBackgroundUrl
} from "./services/backgroundRemovalService";


export default {

  name: "SevenDesigner",

  components: {
    DesignerCanvas
  },


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


      /*
       * ============================================================
       * FOTO DO ARTISTA
       * ============================================================
       *
       * A estrutura já está preparada para persistência futura.
       *
       * arquivo:
       *   File original enquanto estivermos trabalhando localmente.
       *
       * originalSrc:
       *   URL temporária da foto original.
       *
       * backgroundRemovedSrc:
       *   URL temporária do PNG transparente produzido pelo MODNet.
       *
       * src:
       *   versão atualmente exibida pelo DesignerCanvas.
       */
      fotoArtista: {

        arquivo: null,

        nomeArquivo: "",

        originalSrc: null,

        backgroundRemovedSrc: null,

        usarSemFundo: false,

        /*
         * Mantemos src porque o DesignerCanvas
         * atual já trabalha com essa propriedade.
         */
        src: null,

        zoom: 1,

        x: 0,

        y: 0
      },


      /*
       * ============================================================
       * REMOÇÃO DE FUNDO
       * ============================================================
       */
      removendoBackground: false,

      progressoBackground: null,

      mensagemProcessamento:
        "Preparando o modelo...",

      erroBackground: null
    };
  },


  computed: {

    dataFormatada() {

      if (!this.cartaz.data) {
        return "00/00";
      }

      const partes =
        this.cartaz.data.split("-");

      if (partes.length !== 3) {
        return this.cartaz.data;
      }

      return `${partes[2]}/${partes[1]}`;
    },


    diaSemana() {

      if (!this.cartaz.data) {
        return "";
      }

      const partes =
        this.cartaz.data.split("-");

      if (partes.length !== 3) {
        return "";
      }

      const ano =
        Number(partes[0]);

      const mes =
        Number(partes[1]) - 1;

      const dia =
        Number(partes[2]);

      const data =
        new Date(
          ano,
          mes,
          dia
        );

      const dias = [
        "DOMINGO",
        "SEGUNDA-FEIRA",
        "TERÇA-FEIRA",
        "QUARTA-FEIRA",
        "QUINTA-FEIRA",
        "SEXTA-FEIRA",
        "SÁBADO"
      ];

      return dias[
        data.getDay()
      ];
    }

  },


  methods: {

    /*
     * ============================================================
     * ABRIR SELETOR
     * ============================================================
     */
    abrirSeletorFoto() {

      if (this.removendoBackground) {
        return;
      }

      const input =
        this.$refs.inputFotoArtista;

      if (input) {
        input.click();
      }

    },


    /*
     * ============================================================
     * SELECIONAR FOTO
     * ============================================================
     */
    selecionarFotoArtista(event) {

      const arquivo =
        event.target.files &&
        event.target.files[0];

      if (!arquivo) {
        return;
      }


      const tiposPermitidos = [
        "image/jpeg",
        "image/png",
        "image/webp"
      ];


      if (
        !tiposPermitidos.includes(
          arquivo.type
        )
      ) {

        alert(
          "Selecione uma imagem JPG, PNG ou WEBP."
        );

        event.target.value = "";

        return;
      }


      const tamanhoMaximo =
        12 * 1024 * 1024;


      if (
        arquivo.size >
        tamanhoMaximo
      ) {

        alert(
          "A imagem deve possuir no máximo 12 MB."
        );

        event.target.value = "";

        return;
      }


      /*
       * Antes de carregar uma nova foto,
       * liberamos as URLs da anterior.
       */
      this.liberarUrlsFoto();


      const originalSrc =
        URL.createObjectURL(
          arquivo
        );


      this.fotoArtista.arquivo =
        arquivo;

      this.fotoArtista.nomeArquivo =
        arquivo.name;

      this.fotoArtista.originalSrc =
        originalSrc;

      this.fotoArtista.backgroundRemovedSrc =
        null;

      this.fotoArtista.usarSemFundo =
        false;

      /*
       * O Canvas continua trabalhando
       * apenas com fotoArtista.src.
       */
      this.fotoArtista.src =
        originalSrc;


      /*
       * Novo arquivo = novo enquadramento.
       */
      this.fotoArtista.zoom = 1;

      this.fotoArtista.x = 0;

      this.fotoArtista.y = 0;


      /*
       * Limpa estados anteriores.
       */
      this.removendoBackground =
        false;

      this.progressoBackground =
        null;

      this.mensagemProcessamento =
        "Preparando o modelo...";

      this.erroBackground =
        null;


      /*
       * Permite selecionar novamente
       * o mesmo arquivo posteriormente.
       */
      event.target.value = "";
    },


    /*
     * ============================================================
     * REMOVER FUNDO
     * ============================================================
     */
    async removerFundoFoto() {

      if (
        !this.fotoArtista.arquivo ||
        this.removendoBackground
      ) {
        return;
      }


      this.removendoBackground =
        true;

      this.erroBackground =
        null;

      this.progressoBackground =
        null;

      this.mensagemProcessamento =
        "Preparando o modelo...";


      try {

        const resultado =
          await removerBackground(
            this.fotoArtista.arquivo,
            {
              onProgress:
                this.atualizarProgressoBackground
            }
          );


        /*
         * Caso já exista uma versão
         * processada, libera a antiga.
         */
        if (
          this.fotoArtista.backgroundRemovedSrc &&
          this.fotoArtista.backgroundRemovedSrc !==
            resultado.url
        ) {

          liberarBackgroundUrl(
            this.fotoArtista.backgroundRemovedSrc
          );

        }


        this.fotoArtista.backgroundRemovedSrc =
          resultado.url;


        /*
         * Assim que termina, já mostramos
         * automaticamente a versão recortada.
         */
        this.fotoArtista.usarSemFundo =
          true;

        this.fotoArtista.src =
          resultado.url;


        this.progressoBackground =
          100;

        this.mensagemProcessamento =
          "Fundo removido com sucesso.";

      }
      catch (erro) {

        console.error(
          "[SEVEN DESIGNER] Erro na remoção de fundo:",
          erro
        );


        this.erroBackground =
          this.obterMensagemErroBackground(
            erro
          );


        /*
         * Em caso de erro, mantemos
         * a fotografia original.
         */
        this.fotoArtista.usarSemFundo =
          false;

        this.fotoArtista.src =
          this.fotoArtista.originalSrc;

      }
      finally {

        this.removendoBackground =
          false;

      }

    },


    /*
     * ============================================================
     * PROGRESSO DO MODELO
     * ============================================================
     */
    atualizarProgressoBackground(evento) {

      if (!evento) {
        return;
      }


      /*
       * Transformers.js pode emitir eventos
       * diferentes durante download/carregamento.
       */
      const status =
        evento.status || "";


      if (
        status === "initiate"
      ) {

        this.mensagemProcessamento =
          "Preparando arquivos do modelo...";

      }
      else if (
        status === "download"
      ) {

        this.mensagemProcessamento =
          "Baixando modelo de remoção de fundo...";

      }
      else if (
        status === "progress"
      ) {

        this.mensagemProcessamento =
          "Baixando modelo de remoção de fundo...";

      }
      else if (
        status === "done"
      ) {

        this.mensagemProcessamento =
          "Processando a fotografia...";

      }
      else if (
        status === "ready"
      ) {

        this.mensagemProcessamento =
          "Modelo carregado. Processando fotografia...";

      }


      /*
       * Algumas versões fornecem progress.
       */
      if (
        typeof evento.progress ===
        "number"
      ) {

        const valor =
          Math.round(
            evento.progress
          );


        this.progressoBackground =
          Math.max(
            0,
            Math.min(
              100,
              valor
            )
          );


        return;
      }


      /*
       * Outras fornecem loaded / total.
       */
      if (
        typeof evento.loaded ===
          "number" &&
        typeof evento.total ===
          "number" &&
        evento.total > 0
      ) {

        const percentual =
          Math.round(
            (
              evento.loaded /
              evento.total
            ) * 100
          );


        this.progressoBackground =
          Math.max(
            0,
            Math.min(
              100,
              percentual
            )
          );


        return;
      }


      /*
       * Sem informação numérica:
       * usamos barra indeterminada.
       */
      this.progressoBackground =
        null;
    },


    /*
     * ============================================================
     * MENSAGEM DE ERRO AMIGÁVEL
     * ============================================================
     */
    obterMensagemErroBackground(
      erro
    ) {

      if (!erro) {

        return (
          "Ocorreu um erro inesperado durante o processamento."
        );

      }


      const mensagem =
        erro.message ||
        String(erro);


      if (
        mensagem
          .toLowerCase()
          .includes("memory")
      ) {

        return (
          "O navegador não possui memória suficiente para processar esta imagem."
        );

      }


      if (
        mensagem
          .toLowerCase()
          .includes("network") ||
        mensagem
          .toLowerCase()
          .includes("fetch")
      ) {

        return (
          "Não foi possível carregar o modelo. Verifique sua conexão e tente novamente."
        );

      }


      return mensagem;
    },


    /*
     * ============================================================
     * ALTERNAR ORIGINAL / SEM FUNDO
     * ============================================================
     */
    usarFotoOriginal() {

      if (
        !this.fotoArtista.originalSrc
      ) {
        return;
      }


      this.fotoArtista.usarSemFundo =
        false;

      this.fotoArtista.src =
        this.fotoArtista.originalSrc;
    },


    usarFotoSemFundo() {

      if (
        !this.fotoArtista.backgroundRemovedSrc
      ) {
        return;
      }


      this.fotoArtista.usarSemFundo =
        true;

      this.fotoArtista.src =
        this.fotoArtista.backgroundRemovedSrc;
    },


    /*
     * ============================================================
     * POSICIONAMENTO
     * ============================================================
     */
    moverFoto(x, y) {

      this.fotoArtista.x += x;

      this.fotoArtista.y += y;

    },


    centralizarFoto() {

      this.fotoArtista.x = 0;

      this.fotoArtista.y = 0;

    },


    /*
     * ============================================================
     * LIBERAR URLs
     * ============================================================
     */
    liberarUrlsFoto() {

      const original =
        this.fotoArtista.originalSrc;

      const removida =
        this.fotoArtista.backgroundRemovedSrc;


      if (
        original &&
        original.startsWith("blob:")
      ) {

        URL.revokeObjectURL(
          original
        );

      }


      if (
        removida &&
        removida.startsWith("blob:") &&
        removida !== original
      ) {

        liberarBackgroundUrl(
          removida
        );

      }

    },


    /*
     * ============================================================
     * REMOVER FOTO
     * ============================================================
     */
    removerFotoArtista() {

      if (
        this.removendoBackground
      ) {
        return;
      }


      this.liberarUrlsFoto();


      this.fotoArtista.arquivo =
        null;

      this.fotoArtista.nomeArquivo =
        "";

      this.fotoArtista.originalSrc =
        null;

      this.fotoArtista.backgroundRemovedSrc =
        null;

      this.fotoArtista.usarSemFundo =
        false;

      this.fotoArtista.src =
        null;

      this.fotoArtista.zoom =
        1;

      this.fotoArtista.x =
        0;

      this.fotoArtista.y =
        0;


      this.progressoBackground =
        null;

      this.mensagemProcessamento =
        "Preparando o modelo...";

      this.erroBackground =
        null;

    }

  },


  /*
   * ==============================================================
   * LIMPEZA AO SAIR DO COMPONENTE
   * ==============================================================
   */
  beforeUnmount() {

    this.liberarUrlsFoto();

  }

};
</script>


<style scoped>

/* ================================================================
   BASE
   ================================================================ */

.seven-designer {
  width: 100%;
}


.designer-icon {
  font-size: 24px;
}


.designer-badge {
  background: #ff6c22;
  color: #fff;

  font-size: 9px;
  letter-spacing: 0.8px;
}


.designer-format {
  display: flex;
  flex-direction: column;

  text-align: right;

  line-height: 1.3;
}


.designer-format strong {
  color: #ff6c22;

  font-size: 13px;
}


.step-label {
  color: #ff6c22;

  font-size: 10px;
  font-weight: 800;

  letter-spacing: 1.2px;
}


.designer-label {
  color: #495057;

  font-size: 12px;
  font-weight: 700;
}


.form-control:focus {
  border-color: #ff9a66;

  box-shadow:
    0 0 0 0.2rem
    rgba(255, 108, 34, 0.12);
}


/* ================================================================
   FOTO
   ================================================================ */

.designer-photo-control {
  width: 100%;
}


.photo-upload-button {
  width: 100%;
  min-height: 125px;

  border:
    2px dashed
    #d7dce2;

  border-radius: 8px;

  background: #f8f9fa;

  display: flex;
  flex-direction: column;

  align-items: center;
  justify-content: center;

  cursor: pointer;

  transition:
    all 0.2s ease;
}


.photo-upload-button:hover {
  border-color: #ff6c22;

  background: #fff8f4;
}


.photo-upload-icon {
  font-size: 28px;

  margin-bottom: 5px;
}


.photo-upload-button strong {
  color: #343a40;

  font-size: 13px;
}


.photo-upload-button small {
  color: #878a99;

  margin-top: 3px;
}


.photo-editor {
  border:
    1px solid
    #e1e5e9;

  border-radius: 8px;

  background: #f8f9fa;

  padding: 14px;
}


.photo-selected {
  display: flex;

  align-items: center;
  justify-content: space-between;

  gap: 10px;

  padding-bottom: 12px;

  border-bottom:
    1px solid
    #e1e5e9;
}


.photo-file-info {
  min-width: 0;

  flex: 1;
}


.photo-selected strong,
.photo-selected small {
  display: block;
}


.photo-selected strong {
  color: #343a40;

  font-size: 12px;
}


.photo-selected small {
  max-width: 210px;

  color: #878a99;

  overflow: hidden;

  text-overflow: ellipsis;

  white-space: nowrap;
}


/* ================================================================
   REMOVER BACKGROUND
   ================================================================ */

.background-removal-area {
  margin-top: 14px;
}


.remove-background-button {
  width: 100%;

  border:
    1px solid
    #ffcfb6;

  border-radius: 7px;

  background: #fff8f4;

  color: #343a40;

  padding: 11px 12px;

  display: flex;

  align-items: center;

  gap: 10px;

  text-align: left;

  cursor: pointer;

  transition:
    all 0.2s ease;
}


.remove-background-button:hover {
  border-color: #ff6c22;

  background: #fff1e9;
}


.remove-background-icon {
  width: 35px;
  height: 35px;

  border-radius: 50%;

  background: #ff6c22;

  display: flex;

  align-items: center;
  justify-content: center;

  flex-shrink: 0;

  font-size: 16px;
}


.remove-background-button strong {
  display: block;

  color: #343a40;

  font-size: 12px;
}


.remove-background-button small {
  display: block;

  color: #878a99;

  font-size: 10px;

  margin-top: 1px;
}


/* ================================================================
   PROCESSAMENTO
   ================================================================ */

.background-processing {
  margin-top: 14px;

  padding: 12px;

  border:
    1px solid
    #ffe0cf;

  border-radius: 7px;

  background: #fff8f4;
}


.processing-header {
  display: flex;

  align-items: flex-start;
  justify-content: space-between;

  gap: 10px;
}


.processing-header strong {
  display: block;

  color: #343a40;

  font-size: 12px;
}


.processing-header small {
  display: block;

  color: #878a99;

  font-size: 10px;

  margin-top: 2px;
}


.processing-percent {
  color: #ff6c22;

  font-size: 11px;
  font-weight: 800;
}


.designer-progress {
  position: relative;

  width: 100%;
  height: 6px;

  overflow: hidden;

  margin-top: 10px;

  border-radius: 10px;

  background: #ffe0cf;
}


.designer-progress-bar {
  height: 100%;

  border-radius: 10px;

  background: #ff6c22;

  transition:
    width 0.2s ease;
}


.designer-progress-indeterminate {
  position: absolute;

  width: 35%;

  animation:
    sevenDesignerProgress
    1.2s
    ease-in-out
    infinite;
}


@keyframes sevenDesignerProgress {

  0% {
    left: -35%;
  }

  100% {
    left: 100%;
  }

}


.processing-help {
  color: #878a99;

  font-size: 9px;

  line-height: 1.4;

  margin-top: 8px;
}


/* ================================================================
   BACKGROUND REMOVIDO
   ================================================================ */

.background-success {
  margin-top: 14px;

  padding: 12px;

  border:
    1px solid
    #bfe6ce;

  border-radius: 7px;

  background: #f2fbf5;
}


.background-success-title {
  display: flex;

  align-items: center;

  gap: 8px;
}


.success-check {
  width: 28px;
  height: 28px;

  border-radius: 50%;

  background: #198754;

  color: #fff;

  display: flex;

  align-items: center;
  justify-content: center;

  flex-shrink: 0;

  font-size: 14px;
  font-weight: 900;
}


.background-success-title strong {
  display: block;

  color: #24643c;

  font-size: 12px;
}


.background-success-title small {
  display: block;

  color: #6c8d77;

  font-size: 10px;

  margin-top: 1px;
}


.photo-version-switch {
  display: grid;

  grid-template-columns:
    1fr 1fr;

  gap: 6px;

  margin-top: 11px;
}


.photo-version-switch button {
  border:
    1px solid
    #cfd6dc;

  border-radius: 5px;

  background: #fff;

  color: #6c757d;

  padding: 7px 8px;

  font-size: 10px;
  font-weight: 800;

  cursor: pointer;

  transition:
    all 0.15s ease;
}


.photo-version-switch button:hover {
  border-color: #ff6c22;

  color: #ff6c22;
}


.photo-version-switch button.active {
  border-color: #ff6c22;

  background: #ff6c22;

  color: #fff;
}


/* ================================================================
   ERRO
   ================================================================ */

.background-error {
  margin-top: 14px;

  padding: 11px;

  border:
    1px solid
    #f2c2c7;

  border-radius: 7px;

  background: #fff5f6;
}


.background-error strong {
  display: block;

  color: #a52a35;

  font-size: 11px;
}


.background-error span {
  display: block;

  color: #8a6266;

  font-size: 10px;

  line-height: 1.4;

  margin-top: 3px;
}


/* ================================================================
   ZOOM / POSIÇÃO
   ================================================================ */

.photo-setting {
  margin-top: 15px;
}


.photo-setting-header {
  display: flex;

  align-items: center;
  justify-content: space-between;

  margin-bottom: 8px;

  color: #495057;

  font-size: 11px;
}


.photo-position-controls {
  width: 120px;

  margin: 0 auto;

  display: grid;

  grid-template-columns:
    repeat(3, 36px);

  gap: 6px;
}


.photo-position-controls button {
  width: 36px;
  height: 36px;

  border:
    1px solid
    #d7dce2;

  border-radius: 5px;

  background: #fff;

  color: #495057;

  font-size: 16px;
  font-weight: bold;

  cursor: pointer;
}


.photo-position-controls button:hover {
  border-color: #ff6c22;

  color: #ff6c22;
}


.photo-position-controls .center-button {
  color: #ff6c22;
}


/* ================================================================
   PREVIEW
   ================================================================ */

.preview-workspace {
  min-height: 650px;

  background:
    linear-gradient(
      45deg,
      #eceef1 25%,
      transparent 25%
    ),
    linear-gradient(
      -45deg,
      #eceef1 25%,
      transparent 25%
    ),
    linear-gradient(
      45deg,
      transparent 75%,
      #eceef1 75%
    ),
    linear-gradient(
      -45deg,
      transparent 75%,
      #eceef1 75%
    );

  background-size:
    20px 20px;

  background-position:
    0 0,
    0 10px,
    10px -10px,
    -10px 0;

  border-radius: 8px;

  display: flex;

  align-items: center;
  justify-content: center;

  padding: 25px;
}


/* ================================================================
   AVISO
   ================================================================ */

.designer-notice {
  display: flex;

  gap: 10px;

  background: #fff8f4;

  border:
    1px solid
    #ffe0cf;

  border-radius: 6px;

  padding: 12px 14px;

  color: #6c757d;

  font-size: 11px;
}


.designer-notice strong {
  display: block;

  color: #495057;

  margin-bottom: 2px;
}


/* ================================================================
   RESPONSIVO
   ================================================================ */

@media (max-width: 991px) {

  .preview-workspace {
    min-height: 560px;
  }

}


@media (max-width: 575px) {

  .preview-workspace {
    min-height: auto;

    padding: 15px;
  }


  .designer-format {
    text-align: left;
  }


  .photo-selected {
    align-items: flex-start;
  }


  .photo-selected small {
    max-width: 160px;
  }

}

</style>