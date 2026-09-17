<template>
  <div ref="canvasContainer" class="designer-canvas-container">
    <div class="canvas-scale-wrapper" :style="wrapperStyle">
      <v-stage ref="stage" :config="stageConfig">
        <!-- =====================================================
             FUNDO
             ===================================================== -->
        <v-layer>

          <!-- FOTO REAL -->
          <v-group v-if="artistImageConfig" :config="artistPhotoClipConfig">
            <v-image :config="artistImageConfig" />
          </v-group>

          <!-- PLACEHOLDER -->
          <template v-else>

            <v-rect :config="artistPhotoPlaceholderConfig" />

            <v-text :config="artistPhotoIconConfig" />

            <v-text :config="artistPhotoLabelConfig" />

          </template>

        </v-layer>

        <!-- =====================================================
             ÁREA DA FOTO DO ARTISTA

             Ainda é placeholder.
             Depois será substituída pela foto real.
             ===================================================== -->
        <v-layer>

          <!-- FOTO CARREGADA -->
          <v-group v-if="artistImage" :config="artistPhotoClipConfig">
            <v-image v-if="artistImageConfig" :config="artistImageConfig" />
          </v-group>

          <!-- PLACEHOLDER SOMENTE QUANDO NÃO EXISTE FOTO -->
          <v-group v-else>
            <v-rect :config="artistPhotoPlaceholderConfig" />

            <v-text :config="artistPhotoIconConfig" />

            <v-text :config="artistPhotoLabelConfig" />
          </v-group>

        </v-layer>

        <!-- =====================================================
             DATA
             ===================================================== -->
        <v-layer>

          <v-text :config="dateConfig" />

          <v-rect :config="weekdayBackgroundConfig" />

          <v-text :config="weekdayConfig" />

        </v-layer>

        <!-- =====================================================
             CHAMADA
             ===================================================== -->
        <v-layer>

          <v-text v-if="dados.chamada" :config="callConfig" />

          <v-line v-if="dados.chamada" :config="callUnderlineConfig" />

        </v-layer>

        <!-- =====================================================
             ARTISTA
             ===================================================== -->
        <v-layer>

          <v-text :config="showLabelConfig" />

          <v-text :config="artistShadowConfig" />

          <v-text :config="artistConfig" />

        </v-layer>

        <!-- =====================================================
             LOGO DO ESTABELECIMENTO
             ===================================================== -->
        <v-layer>

          <v-circle :config="logoShadowConfig" />

          <v-circle :config="logoCircleConfig" />

          <v-circle :config="logoInnerCircleConfig" />

          <v-text :config="logoMonogramConfig" />

        </v-layer>

        <!-- =====================================================
             LOCAL
             ===================================================== -->
        <v-layer>

          <v-rect :config="establishmentBackgroundConfig" />

          <v-text :config="establishmentConfig" />

          <v-text :config="cityConfig" />

          <v-text v-if="dados.horario" :config="timeConfig" />

        </v-layer>

        <!-- =====================================================
             INFORMAÇÃO EXTRA
             ===================================================== -->
        <v-layer>

          <v-rect v-if="dados.extra" :config="extraBackgroundConfig" />

          <v-text v-if="dados.extra" :config="extraConfig" />

        </v-layer>

      </v-stage>
    </div>
  </div>
</template>

<script>
import sertanejoSunset from
  "./templates/sertanejoSunset";

export default {
  name: "DesignerCanvas",

  props: {
    dados: {
      type: Object,
      required: true
    },
    fotoArtista: {
      type: Object,
      required: true
    }
  },

  data() {
    return {
      template: sertanejoSunset,
      previewWidth: 360,
      artistImage: null
    };
  },
  watch: {
    "fotoArtista.src": {
      immediate: true,

      handler(novoSrc) {
        this.carregarFotoArtista(
          novoSrc
        );
      }
    }
  },
  computed: {
    artistPhotoClipConfig() {
      const area =
        this.template.layers.artistPhoto;

      return {
        clipX: area.x,
        clipY: area.y,
        clipWidth: area.width,
        clipHeight: area.height
      };
    },
    scale() {
      return (
        this.previewWidth /
        this.template.width
      );
    },

    stageConfig() {
      return {
        width: this.template.width,
        height: this.template.height,
        scaleX: this.scale,
        scaleY: this.scale
      };
    },

    wrapperStyle() {
      return {
        width:
          `${this.template.width * this.scale}px`,

        height:
          `${this.template.height * this.scale}px`
      };
    },

    dataFormatada() {
      if (!this.dados.data) {
        return "00/00";
      }

      const partes =
        this.dados.data.split("-");

      if (partes.length !== 3) {
        return this.dados.data;
      }

      return `${partes[2]}/${partes[1]}`;
    },

    diaSemana() {
      if (!this.dados.data) {
        return "";
      }

      const partes =
        this.dados.data.split("-");

      if (partes.length !== 3) {
        return "";
      }

      const data =
        new Date(
          Number(partes[0]),
          Number(partes[1]) - 1,
          Number(partes[2])
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

      return dias[data.getDay()];
    },

    monogramaEstabelecimento() {
      const nome =
        (this.dados.local || "")
          .trim();

      if (!nome) {
        return "7S";
      }

      const palavras =
        nome
          .replace(
            /[^A-Za-zÀ-ÿ0-9\s]/g,
            " "
          )
          .split(/\s+/)
          .filter(Boolean);

      const ignorar = [
        "DE",
        "DA",
        "DO",
        "DAS",
        "DOS",
        "E"
      ];

      const uteis =
        palavras.filter(
          palavra =>
            !ignorar.includes(
              palavra.toUpperCase()
            )
        );

      if (uteis.length === 0) {
        return nome
          .substring(0, 2)
          .toUpperCase();
      }

      if (uteis.length === 1) {
        return uteis[0]
          .substring(0, 2)
          .toUpperCase();
      }

      return uteis
        .slice(0, 3)
        .map(
          palavra =>
            palavra.charAt(0)
        )
        .join("")
        .toUpperCase();
    },

    artistFontSize() {
      const nome =
        this.dados.artista ||
        "SEU NOME ARTÍSTICO";

      const tamanho =
        nome.length;

      if (tamanho <= 12) {
        return 125;
      }

      if (tamanho <= 20) {
        return 105;
      }

      if (tamanho <= 30) {
        return 82;
      }

      if (tamanho <= 40) {
        return 68;
      }

      return 55;
    },

    establishmentFontSize() {
      const local =
        this.dados.local ||
        "LOCAL DO SHOW";

      if (local.length <= 18) {
        return 58;
      }

      if (local.length <= 28) {
        return 48;
      }

      return 40;
    },

    backgroundConfig() {
      return {
        x: 0,
        y: 0,

        width:
          this.template.width,

        height:
          this.template.height,

        fillLinearGradientStartPoint: {
          x: 0,
          y: 0
        },

        fillLinearGradientEndPoint: {
          x: 0,
          y: this.template.height
        },

        fillLinearGradientColorStops: [
          0,
          this.template.colors.backgroundTop,

          0.45,
          this.template.colors.backgroundMiddle,

          1,
          this.template.colors.backgroundBottom
        ]
      };
    },

    sunGlowConfig() {
      return {
        x: 760,
        y: 560,
        radius: 330,

        fill:
          "rgba(255, 170, 50, 0.20)",

        shadowColor:
          "#ff9d25",

        shadowBlur: 130,

        shadowOpacity: 0.65
      };
    },

    bottomShadeConfig() {
      return {
        x: 0,
        y: 1050,

        width: 1080,
        height: 870,

        fillLinearGradientStartPoint: {
          x: 0,
          y: 0
        },

        fillLinearGradientEndPoint: {
          x: 0,
          y: 870
        },

        fillLinearGradientColorStops: [
          0,
          "rgba(0,0,0,0)",

          1,
          "rgba(0,0,0,0.88)"
        ]
      };
    },

    artistPhotoPlaceholderConfig() {
      const p =
        this.template.layers.artistPhoto;

      return {
        x: p.x,
        y: p.y,
        width: p.width,
        height: p.height,

        cornerRadius: 25,

        fill:
          "rgba(255,255,255,0.04)",

        stroke:
          "rgba(255,255,255,0.13)",

        strokeWidth: 4,

        dash: [
          20,
          15
        ]
      };
    },

    artistPhotoIconConfig() {
      return {
        x: 390,
        y: 630,

        width: 300,

        text: "📷",

        fontSize: 100,

        align: "center",

        opacity: 0.65
      };
    },

    artistPhotoLabelConfig() {
      return {
        x: 290,
        y: 760,

        width: 500,

        text:
          "FOTO DO ARTISTA",

        fontFamily:
          "Arial",

        fontSize: 30,

        fontStyle: "bold",

        fill:
          "rgba(255,255,255,0.55)",

        align: "center"
      };
    },

    dateConfig() {
      const p =
        this.template.layers.date;

      return {
        x: p.x,
        y: p.y,

        width: p.width,

        text:
          this.dataFormatada,

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.yellow,

        shadowColor:
          "#000000",

        shadowBlur: 4,

        shadowOffset: {
          x: 5,
          y: 5
        },

        shadowOpacity: 0.7
      };
    },

    weekdayBackgroundConfig() {
      const p =
        this.template.layers.weekday;

      return {
        x: p.x,
        y: p.y,

        width: p.width,
        height: p.height,

        fill:
          this.template.colors.yellow,

        rotation: -2
      };
    },

    weekdayConfig() {
      const p =
        this.template.layers.weekday;

      return {
        x: p.x + 10,
        y: p.y + 14,

        width:
          p.width - 20,

        text:
          this.diaSemana,

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.dark,

        align:
          "center",

        rotation: -2
      };
    },

    callConfig() {
      const p =
        this.template.layers.call;

      return {
        x: p.x,
        y: p.y,

        width: p.width,

        text:
          this.dados.chamada,

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold italic",

        fill:
          this.template.colors.white,

        align:
          "center",

        rotation:
          p.rotation,

        lineHeight: 1.05,

        shadowColor:
          "#000",

        shadowBlur: 4,

        shadowOffset: {
          x: 4,
          y: 4
        }
      };
    },

    callUnderlineConfig() {
      return {
        points: [
          720,
          270,
          970,
          250
        ],

        stroke:
          this.template.colors.yellow,

        strokeWidth: 15,

        lineCap:
          "round",

        rotation: -2
      };
    },

    showLabelConfig() {
      const p =
        this.template.layers.showLabel;

      return {
        x: p.x,
        y: p.y,

        width: p.width,

        text:
          "SHOW COM",

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.white,

        align:
          "center"
      };
    },

    artistShadowConfig() {
      const p =
        this.template.layers.artist;

      return {
        x: p.x + 7,
        y: p.y + 9,

        width: p.width,
        height: p.height,

        text:
          this.dados.artista ||
          "SEU NOME ARTÍSTICO",

        fontFamily:
          "Arial",

        fontSize:
          this.artistFontSize,

        fontStyle:
          "bold italic",

        fill:
          "#000000",

        align:
          "center",

        verticalAlign:
          "middle"
      };
    },

    artistConfig() {
      const p =
        this.template.layers.artist;

      return {
        x: p.x,
        y: p.y,

        width: p.width,
        height: p.height,

        text:
          this.dados.artista ||
          "SEU NOME ARTÍSTICO",

        fontFamily:
          "Arial",

        fontSize:
          this.artistFontSize,

        fontStyle:
          "bold italic",

        fill:
          this.template.colors.white,

        stroke:
          "#111111",

        strokeWidth: 4,

        align:
          "center",

        verticalAlign:
          "middle",

        shadowColor:
          "#000000",

        shadowBlur: 12,

        shadowOffset: {
          x: 8,
          y: 10
        },

        shadowOpacity: 0.8
      };
    },

    logoShadowConfig() {
      const p =
        this.template.layers
          .establishmentLogo;

      return {
        x:
          p.x +
          p.width / 2 +
          8,

        y:
          p.y +
          p.height / 2 +
          12,

        radius:
          p.width / 2,

        fill:
          "rgba(0,0,0,0.55)"
      };
    },

    logoCircleConfig() {
      const p =
        this.template.layers
          .establishmentLogo;

      return {
        x:
          p.x +
          p.width / 2,

        y:
          p.y +
          p.height / 2,

        radius:
          p.width / 2,

        fill:
          "#ffffff",

        stroke:
          this.template.colors.yellow,

        strokeWidth: 10
      };
    },

    logoInnerCircleConfig() {
      const p =
        this.template.layers
          .establishmentLogo;

      return {
        x:
          p.x +
          p.width / 2,

        y:
          p.y +
          p.height / 2,

        radius:
          p.width / 2 - 22,

        fill:
          this.template.colors.wood
      };
    },

    logoMonogramConfig() {
      const p =
        this.template.layers
          .establishmentLogo;

      return {
        x: p.x,
        y: p.y + 63,

        width: p.width,

        text:
          this.monogramaEstabelecimento,

        fontFamily:
          "Arial",

        fontSize: 58,

        fontStyle:
          "bold",

        fill:
          this.template.colors.white,

        align:
          "center"
      };
    },

    establishmentBackgroundConfig() {
      const p =
        this.template.layers.establishment;

      return {
        x: p.x,
        y: p.y,

        width: p.width,
        height: p.height,

        fill:
          this.template.colors.wood,

        stroke:
          "rgba(255,255,255,0.45)",

        strokeWidth: 3
      };
    },

    establishmentConfig() {
      const p =
        this.template.layers.establishment;

      return {
        x: p.x + 20,
        y: p.y,

        width:
          p.width - 40,

        height:
          p.height,

        text:
          (
            this.dados.local ||
            "LOCAL DO SHOW"
          ).toUpperCase(),

        fontFamily:
          "Arial",

        fontSize:
          this.establishmentFontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.white,

        align:
          "center",

        verticalAlign:
          "middle"
      };
    },

    cityConfig() {
      const p =
        this.template.layers.city;

      return {
        x: p.x,
        y: p.y,

        width: p.width,

        text:
          this.dados.cidade ||
          "CIDADE - UF",

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.white,

        align:
          "center"
      };
    },

    timeConfig() {
      const p =
        this.template.layers.time;

      return {
        x: p.x,
        y: p.y,

        width: p.width,

        text:
          this.dados.horario,

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.yellow,

        align:
          "center"
      };
    },

    extraBackgroundConfig() {
      const p =
        this.template.layers.extra;

      return {
        x: p.x,
        y: p.y,

        width: p.width,
        height: p.height,

        fill:
          this.template.colors.red,

        rotation: -1
      };
    },

    extraConfig() {
      const p =
        this.template.layers.extra;

      return {
        x: p.x + 20,
        y: p.y + 15,

        width:
          p.width - 40,

        text:
          this.dados.extra.toUpperCase(),

        fontFamily:
          "Arial",

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.template.colors.white,

        align:
          "center",

        rotation: -1
      };
    },
    artistImageConfig() {
      if (!this.artistImage) {
        return null;
      }

      const area =
        this.template.layers.artistPhoto;

      const larguraImagem =
        this.artistImage.naturalWidth ||
        this.artistImage.width;

      const alturaImagem =
        this.artistImage.naturalHeight ||
        this.artistImage.height;

      if (
        !larguraImagem ||
        !alturaImagem
      ) {
        return null;
      }

      /*
       * Escala base = CONTAIN.
       *
       * Diferente do "cover" anterior,
       * agora a fotografia inteira cabe
       * dentro da área reservada.
       */
      const escalaBase =
        Math.min(
          area.width / larguraImagem,
          area.height / alturaImagem
        );

      const zoom =
        Number(this.fotoArtista.zoom) || 1;

      const escalaFinal =
        escalaBase * zoom;

      const larguraFinal =
        larguraImagem * escalaFinal;

      const alturaFinal =
        alturaImagem * escalaFinal;

      return {
        image: this.artistImage,

        x:
          area.x +
          area.width / 2 -
          larguraFinal / 2 +
          Number(this.fotoArtista.x || 0),

        y:
          area.y +
          area.height / 2 -
          alturaFinal / 2 +
          Number(this.fotoArtista.y || 0),

        width:
          larguraFinal,

        height:
          alturaFinal
      };
    },
  },

  mounted() {
    this.calcularTamanhoPreview();

    window.addEventListener(
      "resize",
      this.calcularTamanhoPreview
    );
  },

  beforeUnmount() {
    window.removeEventListener(
      "resize",
      this.calcularTamanhoPreview
    );
  },

  methods: {
    calcularTamanhoPreview() {
      this.$nextTick(() => {
        const container =
          this.$refs.canvasContainer;

        if (!container) {
          return;
        }

        const larguraDisponivel =
          container.clientWidth - 30;

        this.previewWidth =
          Math.min(
            420,
            Math.max(
              260,
              larguraDisponivel
            )
          );
      });
    },

    obterStage() {
      if (!this.$refs.stage) {
        return null;
      }

      return this.$refs.stage.getNode();
    },
    carregarFotoArtista(src) {
      if (!src) {
        this.artistImage = null;
        return;
      }

      const imagem = new Image();

      imagem.onload = () => {
        this.artistImage = imagem;
      };

      imagem.onerror = () => {
        console.error(
          "[SEVEN DESIGNER] Não foi possível carregar a foto do artista."
        );

        this.artistImage = null;
      };

      imagem.src = src;
    },
  }
};
</script>

<style scoped>
.designer-canvas-container {
  width: 100%;

  min-height: 680px;

  display: flex;
  justify-content: center;
  align-items: flex-start;

  padding: 22px 15px;

  overflow: hidden;

  border-radius: 8px;

  background-color: #e9ecef;

  background-image:
    linear-gradient(45deg,
      #dfe2e6 25%,
      transparent 25%),
    linear-gradient(-45deg,
      #dfe2e6 25%,
      transparent 25%),
    linear-gradient(45deg,
      transparent 75%,
      #dfe2e6 75%),
    linear-gradient(-45deg,
      transparent 75%,
      #dfe2e6 75%);

  background-size:
    24px 24px;

  background-position:
    0 0,
    0 12px,
    12px -12px,
    -12px 0;
}

.canvas-scale-wrapper {
  flex: 0 0 auto;

  background: #111;

  box-shadow:
    0 20px 45px rgba(0, 0, 0, 0.30);
}
</style>