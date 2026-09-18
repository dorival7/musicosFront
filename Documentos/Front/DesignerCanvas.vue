<template>
  <div ref="canvasContainer" class="designer-canvas-container">

    <!-- GALERIA DE BACKGROUNDS -->
    <div class="background-gallery">
      <div class="background-gallery-header">
        <div>
          <strong>Fundo do cartaz</strong>
          <small>Troque o cenário sem perder os dados ou a foto.</small>
        </div>
        <span>{{ backgroundAtual.nome }}</span>
      </div>

      <div class="background-gallery-items">
        <button
          v-for="background in backgroundsDisponiveis"
          :key="background.id"
          type="button"
          class="background-card"
          :class="{ active: backgroundSelecionadoId === background.id }"
          @click="selecionarBackground(background.id)"
        >
          <div class="background-thumb">
            <img
              v-if="background.src"
              :src="background.src"
              :alt="background.nome"
            />
            <div v-else class="background-thumb-procedural"></div>
            <span v-if="backgroundSelecionadoId === background.id" class="background-check">✓</span>
          </div>
          <span class="background-name">{{ background.nome }}</span>
        </button>
      </div>
    </div>

    <div class="canvas-scale-wrapper" :style="wrapperStyle">
      <v-stage ref="stage" :config="stageConfig">

        <!-- CAMADA 1: BACKGROUND E ATMOSFERA -->
        <v-layer>
          <!-- Background estático escolhido na galeria -->
          <v-image
            v-if="backgroundImage"
            :config="backgroundImageConfig"
          />

          <!-- Fallback procedural clássico -->
          <v-group v-else>
            <v-rect :config="backgroundConfig" />
            <v-circle :config="sunOuterGlowConfig" />
            <v-circle :config="sunGlowConfig" />
            <v-circle :config="sunCoreConfig" />
            <v-line :config="lightBeamLeftConfig" />
            <v-line :config="lightBeamRightConfig" />
            <v-circle :config="ambientGlowLeftConfig" />
            <v-circle :config="ambientGlowRightConfig" />
          </v-group>

          <!-- Overlay mantém leitura dos textos sobre qualquer imagem -->
          <v-rect
            v-if="backgroundImage"
            :config="backgroundImageOverlayConfig"
          />

          <v-rect :config="bottomShadeConfig" />
        </v-layer>

        <!-- CAMADA 2: IMAGENS DO USUÁRIO -->
        <v-layer>
          <v-group
            v-if="imagensRenderizadas.length === 0"
            @click="$emit('pedir-upload')"
            @tap="$emit('pedir-upload')"
          >
            <v-rect :config="artistPhotoPlaceholderConfig" />
            <v-text :config="artistPhotoIconConfig" />
            <v-text :config="{ ...artistPhotoLabelConfig, text: '+ ADICIONAR FOTO' }" />
          </v-group>

          <v-image
            v-for="item in imagensRenderizadas"
            :key="item.elementId"
            :ref="`imagem-${item.elementId}`"
            :config="configImagemUsuario(item)"
            @click="selecionarImagem(item.elementId)"
            @tap="selecionarImagem(item.elementId)"
            @dragend="finalizarDragImagem(item.elementId, $event)"
            @transformend="finalizarTransformImagem(item.elementId, $event)"
          />

          <v-transformer
            ref="transformerImagem"
            :config="transformerImagemConfig"
          />
        </v-layer>

        <!-- CAMADA 3: CONTEÚDO / FOREGROUND -->
        <v-layer>

          <!-- DATA -->
          <v-group>
            <v-text :config="dateConfig" />
            <v-rect :config="weekdayBackgroundConfig" />
            <v-text :config="weekdayConfig" />
          </v-group>

          <!-- CHAMADA -->
          <v-group>
            <v-text v-if="dados.chamada" :config="callConfig" />
            <v-line v-if="dados.chamada" :config="callUnderlineConfig" />
          </v-group>

          <!-- SHOW COM / ASSINATURA ARTÍSTICA -->
          <v-group>
            <v-line :config="showBrushConfig" />
            <v-text :config="showLabelConfig" />
            <v-line :config="showLabelUnderlineConfig" />

            <v-line :config="artistBrushConfig" />
            <v-text :config="artistShadowConfig" />
            <v-text :config="artistConfig" />
            <v-line :config="artistUnderlineConfig" />
          </v-group>

          <!-- PLACA RÚSTICA DO ESTABELECIMENTO -->
          <v-group>
            <v-line :config="signShadowConfig" />
            <v-line :config="signOuterConfig" />
            <v-line :config="signInnerConfig" />
            <v-text :config="logoMonogramConfig" />
            <v-line :config="signDividerConfig" />
            <v-text :config="establishmentConfig" />
          </v-group>

          <!-- CIDADE / HORÁRIO -->
          <v-group>
            <v-text :config="cityTimeConfig" />
          </v-group>

          <!-- INFORMAÇÃO EXTRA -->
          <v-group v-if="dados.extra">
            <v-rect :config="extraBackgroundConfig" />
            <v-text :config="extraConfig" />
          </v-group>

        </v-layer>

      </v-stage>
    </div>
  </div>
</template>
<script>
import sertanejoSunset from
  "./templates/sertanejoSunset";

import {
  obterBackgroundPorId,
  obterBackgroundsDoTemplate
} from "./backgrounds/backgrounds";

import fonts, { obterFontePorId } from "./fonts/fonts";

export default {
  name: "DesignerCanvas",

  props: {
    dados: {
      type: Object,
      required: true
    },
    imagens: {
      type: Array,
      default: () => []
    }
  },

  data() {
    return {
      template: sertanejoSunset,
      previewWidth: 360,
      artistImage: null,
      imagensCarregadas: {},
      imagemSelecionadaId: null,
      fontsReady: 0,
      backgroundSelecionadoId: "show-luzes-01",
      backgroundImage: null,
      elementoTextoSelecionado: "artista",
      fontesDisponiveis: fonts,
      coresRapidas: ["#FFFFFF", "#FFE000", "#111111", "#ED1C24", "#D4A24C", "#29B6F6", "#FF7A00", "#E040FB"],
      estilosTextoPadrao: {
        data: { fontId: "bebas-neue", color: "#FFE000" },
        weekday: { fontId: "oswald", color: "#111111" },
        chamada: { fontId: "pacifico", color: "#FFFFFF" },
        showLabel: { fontId: "permanent-marker", color: "#FFFFFF" },
        artista: { fontId: "permanent-marker", color: "#FFFFFF" },
        estabelecimento: { fontId: "bebas-neue", color: "#FFF4DD" },
        cidadeHorario: { fontId: "oswald", color: "#FFFFFF" },
        extra: { fontId: "permanent-marker", color: "#FFFFFF" }
      },
      estilosTexto: {}
    };
  },
  watch: {
    imagens: {
      immediate: true,
      deep: true,
      handler() {
        this.sincronizarImagens();
      }
    },

    backgroundSelecionadoId: {
      immediate: true,
      handler() {
        this.carregarBackgroundSelecionado();
      }
    }
  },

  computed: {
    imagensRenderizadas() {
      return this.imagens
        .map(item => ({
          ...item,
          image: this.imagensCarregadas[item.elementId] || null
        }))
        .filter(item => item.image);
    },

    transformerImagemConfig() {
      return {
        rotateEnabled: true,
        keepRatio: true,
        flipEnabled: false,
        enabledAnchors: [
          "top-left",
          "top-right",
          "bottom-left",
          "bottom-right"
        ],
        borderStroke: "#ffc107",
        anchorStroke: "#111111",
        anchorFill: "#ffc107",
        anchorSize: 18,
        anchorCornerRadius: 9
      };
    },

    elementosTexto() {
      return [
        { id: "data", nome: "Data" },
        { id: "weekday", nome: "Dia da semana" },
        { id: "chamada", nome: "Chamada" },
        { id: "showLabel", nome: "SHOW COM" },
        { id: "artista", nome: "Nome artístico" },
        { id: "estabelecimento", nome: "Estabelecimento" },
        { id: "cidadeHorario", nome: "Cidade / horário" },
        { id: "extra", nome: "Informação extra" }
      ];
    },

    estiloAtual() {
      return this.estilosTexto[this.elementoTextoSelecionado] || { fontId: "oswald", color: "#FFFFFF" };
    },

    backgroundsDisponiveis() {
      return obterBackgroundsDoTemplate(
        this.template.id
      );
    },

    backgroundAtual() {
      return obterBackgroundPorId(
        this.backgroundSelecionadoId
      );
    },

    backgroundImageConfig() {
      if (!this.backgroundImage) {
        return null;
      }

      const larguraImagem =
        this.backgroundImage.naturalWidth ||
        this.backgroundImage.width;

      const alturaImagem =
        this.backgroundImage.naturalHeight ||
        this.backgroundImage.height;

      if (!larguraImagem || !alturaImagem) {
        return null;
      }

      // COVER: preenche 1080x1920 sem deformar a arte.
      const escala = Math.max(
        this.template.width / larguraImagem,
        this.template.height / alturaImagem
      );

      const larguraFinal = larguraImagem * escala;
      const alturaFinal = alturaImagem * escala;

      return {
        image: this.backgroundImage,
        x: (this.template.width - larguraFinal) / 2,
        y: (this.template.height - alturaFinal) / 2,
        width: larguraFinal,
        height: alturaFinal
      };
    },

    backgroundImageOverlayConfig() {
      return {
        x: 0,
        y: 0,
        width: this.template.width,
        height: this.template.height,
        fillLinearGradientStartPoint: { x: 0, y: 0 },
        fillLinearGradientEndPoint: { x: 0, y: this.template.height },
        fillLinearGradientColorStops: [
          0, "rgba(0,0,0,0.08)",
          0.45, "rgba(0,0,0,0.05)",
          0.72, "rgba(0,0,0,0.22)",
          1, "rgba(0,0,0,0.58)"
        ]
      };
    },

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
      void this.fontsReady;

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

    sunOuterGlowConfig() {
      return {
        x: 700,
        y: 500,
        radius: 285,
        fill: "rgba(255, 132, 28, 0.025)",
        shadowColor: "#ff8a24",
        shadowBlur: 190,
        shadowOpacity: 0.32
      };
    },

    sunCoreConfig() {
      return {
        x: 700,
        y: 505,
        radius: 150,
        fillRadialGradientStartPoint: { x: 0, y: 0 },
        fillRadialGradientStartRadius: 0,
        fillRadialGradientEndPoint: { x: 0, y: 0 },
        fillRadialGradientEndRadius: 150,
        fillRadialGradientColorStops: [
          0, "rgba(255, 218, 145, 0.26)",
          0.38, "rgba(255, 171, 75, 0.17)",
          0.72, "rgba(255, 126, 34, 0.08)",
          1, "rgba(255, 110, 20, 0)"
        ],
        shadowColor: "#ff9d35",
        shadowBlur: 90,
        shadowOpacity: 0.25
      };
    },

    lightBeamLeftConfig() {
      return {
        points: [70, 760, 465, 1010],
        stroke: "rgba(255, 177, 78, 0.032)",
        strokeWidth: 72,
        lineCap: "round",
        shadowColor: "#ff9d35",
        shadowBlur: 85,
        shadowOpacity: 0.14
      };
    },

    lightBeamRightConfig() {
      return {
        points: [1010, 700, 660, 1030],
        stroke: "rgba(255, 166, 67, 0.028)",
        strokeWidth: 64,
        lineCap: "round",
        shadowColor: "#ff9d35",
        shadowBlur: 80,
        shadowOpacity: 0.13
      };
    },

    ambientGlowLeftConfig() {
      return {
        x: 120, y: 1040, radius: 250,
        fill: "rgba(255,128,35,0.018)",
        shadowColor: "#ff7a20", shadowBlur: 120, shadowOpacity: 0.28
      };
    },

    ambientGlowRightConfig() {
      return {
        x: 980, y: 1120, radius: 270,
        fill: "rgba(255,177,70,0.016)",
        shadowColor: "#ff9f2f", shadowBlur: 130, shadowOpacity: 0.24
      };
    },

    sunGlowConfig() {
      return {
        x: 700,
        y: 510,
        radius: 215,
        fill: "rgba(255, 157, 48, 0.055)",
        shadowColor: "#ff9d25",
        shadowBlur: 145,
        shadowOpacity: 0.35
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
          this.fonteDoEstilo("data"),

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.corDoEstilo("data"),

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
          this.fonteDoEstilo("weekday"),

        fontSize:
          p.fontSize,

        fontStyle:
          "bold",

        fill:
          this.corDoEstilo("weekday"),

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
          this.fonteDoEstilo("chamada"),

        fontSize:
          Math.max(38, p.fontSize - 4),

        fontStyle:
          "normal",

        fill:
          this.corDoEstilo("chamada"),

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

    showBrushConfig() {
      return {
        points: [255, 1136, 380, 1118, 620, 1126, 812, 1108],
        stroke: "rgba(5,5,5,0.94)",
        strokeWidth: 88,
        lineCap: "round",
        lineJoin: "round",
        tension: 0.12,
        rotation: -2,
        shadowColor: "#000000",
        shadowBlur: 14,
        shadowOpacity: 0.55
      };
    },

    showLabelUnderlineConfig() {
      return {
        points: [390, 1172, 680, 1158],
        stroke: this.template.colors.yellow,
        strokeWidth: 12,
        lineCap: "round",
        rotation: -2
      };
    },

    showLabelConfig() {
      const p = this.template.layers.showLabel;
      return {
        x: p.x, y: p.y - 3, width: p.width,
        text: "SHOW COM",
        fontFamily: this.fonteDoEstilo("showLabel"),
        fontSize: 54,
        fill: this.corDoEstilo("showLabel"),
        align: "center",
        rotation: -2,
        shadowColor: "#000000",
        shadowBlur: 5,
        shadowOpacity: 0.7
      };
    },

    artistBrushConfig() {
      const p = this.template.layers.artist;
      return {
        points: [105, p.y + 112, 265, p.y + 86, 515, p.y + 103, 770, p.y + 76, 975, p.y + 96],
        stroke: "rgba(4,4,4,0.90)",
        strokeWidth: 150,
        lineCap: "round",
        lineJoin: "round",
        tension: 0.18,
        rotation: -1,
        shadowColor: "#000000",
        shadowBlur: 22,
        shadowOpacity: 0.65
      };
    },

    artistShadowConfig() {
      const p = this.template.layers.artist;
      return {
        x: p.x + 8, y: p.y + 10, width: p.width, height: p.height,
        text: this.dados.artista || "SEU NOME ARTÍSTICO",
        fontFamily: this.fonteDoEstilo("artista"),
        fontSize: Math.round(this.artistFontSize * 1.03),
        fill: "rgba(0,0,0,0.95)",
        align: "center", verticalAlign: "middle", rotation: -1.5
      };
    },

    artistConfig() {
      const p = this.template.layers.artist;
      return {
        x: p.x, y: p.y, width: p.width, height: p.height,
        text: this.dados.artista || "SEU NOME ARTÍSTICO",
        fontFamily: this.fonteDoEstilo("artista"),
        fontSize: Math.round(this.artistFontSize * 1.03),
        fill: this.corDoEstilo("artista"),
        stroke: "rgba(255,255,255,0.10)", strokeWidth: 1,
        align: "center", verticalAlign: "middle", rotation: -1.5,
        shadowColor: "#000000", shadowBlur: 8,
        shadowOffset: { x: 5, y: 7 }, shadowOpacity: 0.75
      };
    },

    artistUnderlineConfig() {
      const p = this.template.layers.artist;
      return {
        points: [235, p.y + p.height - 2, 835, p.y + p.height - 18],
        stroke: this.template.colors.yellow,
        strokeWidth: 12, lineCap: "round", rotation: -1,
        shadowColor: "#000000", shadowBlur: 6, shadowOpacity: 0.45
      };
    },

    signPoints() {
      return [160, 1450, 250, 1392, 830, 1392, 920, 1450, 885, 1642, 195, 1642];
    },

    signShadowConfig() {
      return {
        points: this.signPoints.map((v, i) => v + (i % 2 === 0 ? 8 : 12)),
        closed: true, fill: "rgba(0,0,0,0.68)", stroke: "rgba(0,0,0,0.75)",
        strokeWidth: 12, lineJoin: "round"
      };
    },

    signOuterConfig() {
      return {
        points: this.signPoints, closed: true,
        fillLinearGradientStartPoint: { x: 0, y: 1392 },
        fillLinearGradientEndPoint: { x: 0, y: 1642 },
        fillLinearGradientColorStops: [0, "#754328", 0.48, "#4a2818", 1, "#24130d"],
        stroke: "#c58a4b", strokeWidth: 13, lineJoin: "round",
        shadowColor: "#000000", shadowBlur: 18, shadowOpacity: 0.55
      };
    },

    signInnerConfig() {
      return {
        points: [190, 1460, 270, 1420, 810, 1420, 890, 1460, 858, 1610, 222, 1610],
        closed: true, fill: "rgba(25,13,8,0.55)",
        stroke: "rgba(242,205,145,0.68)", strokeWidth: 4, lineJoin: "round"
      };
    },

    logoMonogramConfig() {
      return {
        x: 365, y: 1427, width: 350,
        text: this.monogramaEstabelecimento,
        fontFamily: "Bebas Neue", fontSize: 42,
        fill: "#f2d7a6", align: "center", letterSpacing: 7
      };
    },

    signDividerConfig() {
      return {
        points: [315, 1482, 765, 1482], stroke: "rgba(242,215,166,0.65)",
        strokeWidth: 3, lineCap: "round"
      };
    },

    establishmentConfig() {
      return {
        x: 205, y: 1495, width: 670, height: 105,
        text: (this.dados.local || "LOCAL DO SHOW").toUpperCase(),
        fontFamily: this.fonteDoEstilo("estabelecimento"), fontSize: Math.min(70, this.establishmentFontSize + 12),
        fill: this.corDoEstilo("estabelecimento"), align: "center", verticalAlign: "middle",
        letterSpacing: 2, shadowColor: "#000000", shadowBlur: 5, shadowOpacity: 0.7
      };
    },

    cityTimeConfig() {
      const cidade = this.dados.cidade || "CIDADE - UF";
      const hora = this.dados.horario || "";
      return {
        x: 120, y: 1668, width: 840,
        text: hora ? `${cidade.toUpperCase()}  •  ${hora}` : cidade.toUpperCase(),
        fontFamily: this.fonteDoEstilo("cidadeHorario"), fontSize: 38, fontStyle: "bold",
        fill: this.corDoEstilo("cidadeHorario"), align: "center", letterSpacing: 1.5
      };
    },

    extraBackgroundConfig() {
      const p = this.template.layers.extra;
      return {
        x: p.x - 10, y: 1755, width: p.width + 20, height: 86,
        fill: this.template.colors.red, rotation: -1.2,
        shadowColor: "#000000", shadowBlur: 14, shadowOffset: { x: 0, y: 8 }, shadowOpacity: 0.55
      };
    },

    extraConfig() {
      const p = this.template.layers.extra;
      return {
        x: p.x + 10, y: 1768, width: p.width - 20,
        text: (this.dados.extra || "").toUpperCase(),
        fontFamily: this.fonteDoEstilo("extra"), fontSize: 42,
        fill: this.corDoEstilo("extra"), align: "center", rotation: -1.2,
        shadowColor: "#7b0000", shadowBlur: 5, shadowOpacity: 0.65
      };
    },

    artistBackGlowConfig() {
      const img = this.artistCutoutImageConfig;

      if (!img) {
        return { visible: false };
      }

      return {
        x: img.x + img.width / 2,
        y: img.y + img.height * 0.36,
        radiusX: Math.max(150, img.width * 0.30),
        radiusY: Math.max(210, img.height * 0.30),
        fill: "rgba(255,166,72,0.025)",
        shadowColor: "#ff9d35",
        shadowBlur: 95,
        shadowOpacity: 0.18
      };
    },

    artistFloorShadowConfig() {
      const img = this.artistCutoutImageConfig;

      if (!img) {
        return { visible: false };
      }

      return {
        x: img.x + img.width / 2,
        y: img.y + img.height - 10,
        radiusX: Math.max(120, img.width * 0.22),
        radiusY: Math.max(25, img.height * 0.035),
        fill: "rgba(0,0,0,0.28)",
        shadowColor: "#000000",
        shadowBlur: 38,
        shadowOpacity: 0.38
      };
    },

    artistCutoutImageConfig() {
      if (!this.artistImageConfig) {
        return null;
      }

      const base = this.artistImageConfig;
      const fatorComposicao = 1.68;
      const novaLargura = base.width * fatorComposicao;
      const novaAltura = base.height * fatorComposicao;
      const centroX = base.x + base.width / 2;
      const centroY = base.y + base.height / 2;

      return {
        ...base,
        x: centroX - novaLargura / 2,
        y: centroY - novaAltura / 2 + 25,
        width: novaLargura,
        height: novaAltura,
        shadowColor: "#000000",
        shadowBlur: 20,
        shadowOffset: { x: 0, y: 12 },
        shadowOpacity: 0.32
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
    this.estilosTexto = JSON.parse(JSON.stringify(this.estilosTextoPadrao));
    this.carregarFontesArtisticas();
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
    sincronizarImagens() {
      const idsAtuais = new Set(this.imagens.map(x => x.elementId));

      Object.keys(this.imagensCarregadas).forEach(id => {
        if (!idsAtuais.has(id)) {
          delete this.imagensCarregadas[id];
        }
      });

      this.imagens.forEach(item => {
        if (!item?.elementId || !item?.src) return;

        const atual = this.imagensCarregadas[item.elementId];
        if (atual && atual.__sevenSrc === item.src) return;

        const imagem = new Image();
        imagem.crossOrigin = "anonymous";
        imagem.__sevenSrc = item.src;

        imagem.onload = () => {
          this.imagensCarregadas = {
            ...this.imagensCarregadas,
            [item.elementId]: imagem
          };
        };

        imagem.onerror = () => {
          console.error("[SEVEN DESIGNER] Não foi possível carregar:", item.src);
        };

        imagem.src = item.src;
      });

      this.$nextTick(() => this.atualizarTransformerImagem());
    },

    configImagemUsuario(item) {
      return {
        id: item.elementId,
        name: "designer-user-image",
        image: item.image,
        x: Number(item.x || 0),
        y: Number(item.y || 0),
        width: Number(item.width || 400),
        height: Number(item.height || 400),
        rotation: Number(item.rotation || 0),
        draggable: true,
        shadowColor: item.usarSemFundo ? "#000000" : undefined,
        shadowBlur: item.usarSemFundo ? 18 : 0,
        shadowOffset: item.usarSemFundo ? { x: 0, y: 10 } : { x: 0, y: 0 },
        shadowOpacity: item.usarSemFundo ? 0.28 : 0
      };
    },

    selecionarImagem(elementId) {
      this.imagemSelecionadaId = elementId;
      this.$emit("selecionar-elemento", elementId);
      this.$nextTick(() => this.atualizarTransformerImagem());
    },

    atualizarTransformerImagem() {
      const transformer = this.$refs.transformerImagem?.getNode?.();
      const stage = this.obterStage();

      if (!transformer || !stage) return;

      if (!this.imagemSelecionadaId) {
        transformer.nodes([]);
        transformer.getLayer()?.batchDraw();
        return;
      }

      const node = stage.findOne(`#${this.imagemSelecionadaId}`);

      transformer.nodes(node ? [node] : []);
      transformer.getLayer()?.batchDraw();
    },

    finalizarDragImagem(elementId, event) {
      const node = event.target;

      this.$emit("atualizar-imagem", {
        elementId,
        x: node.x(),
        y: node.y()
      });
    },

    finalizarTransformImagem(elementId, event) {
      const node = event.target;

      const scaleX = node.scaleX();
      const scaleY = node.scaleY();

      const width = Math.max(40, node.width() * scaleX);
      const height = Math.max(40, node.height() * scaleY);

      node.scaleX(1);
      node.scaleY(1);
      node.width(width);
      node.height(height);

      this.$emit("atualizar-imagem", {
        elementId,
        x: node.x(),
        y: node.y(),
        width,
        height,
        rotation: node.rotation()
      });

      this.$nextTick(() => this.atualizarTransformerImagem());
    },

    fonteDoEstilo(elemento) {
      void this.fontsReady;
      const estilo = this.estilosTexto[elemento] || this.estilosTextoPadrao[elemento];
      return obterFontePorId(estilo?.fontId).family;
    },

    corDoEstilo(elemento) {
      const estilo = this.estilosTexto[elemento] || this.estilosTextoPadrao[elemento];
      return estilo?.color || "#FFFFFF";
    },

    restaurarEstiloAtual() {
      const padrao = this.estilosTextoPadrao[this.elementoTextoSelecionado];
      if (!padrao) return;
      this.estilosTexto[this.elementoTextoSelecionado] = { ...padrao };
    },

    selecionarBackground(id) {
      if (this.backgroundSelecionadoId === id) {
        return;
      }

      this.backgroundSelecionadoId = id;
    },

    carregarBackgroundSelecionado() {
      const background = obterBackgroundPorId(
        this.backgroundSelecionadoId
      );

      if (!background || background.tipo === "procedural" || !background.src) {
        this.backgroundImage = null;
        return;
      }

      const imagem = new Image();

      imagem.onload = () => {
        this.backgroundImage = imagem;
      };

      imagem.onerror = () => {
        console.error(
          `[SEVEN DESIGNER] Não foi possível carregar o background: ${background.nome}`
        );
        this.backgroundImage = null;
      };

      imagem.src = background.src;
    },

    async carregarFontesArtisticas() {
      const linkId = "seven-designer-fonts";

      if (!document.getElementById(linkId)) {
        const link = document.createElement("link");
        link.id = linkId;
        link.rel = "stylesheet";
        link.href =
          "https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Oswald:wght@400;500;600;700&family=Pacifico&family=Permanent+Marker&family=Bangers&family=Righteous&family=Black+Ops+One&family=Rock+Salt&display=swap";
        document.head.appendChild(link);
      }

      if (!document.fonts) {
        return;
      }

      try {
        await Promise.all([
          document.fonts.load('48px "Bebas Neue"'),
          document.fonts.load('48px "Oswald"'),
          document.fonts.load('48px "Pacifico"'),
          document.fonts.load('48px "Permanent Marker"'),
          document.fonts.load('48px "Bangers"'),
          document.fonts.load('48px "Righteous"'),
          document.fonts.load('48px "Black Ops One"'),
          document.fonts.load('48px "Rock Salt"')
        ]);

        this.fontsReady += 1;

        await this.$nextTick();

        const stage = this.obterStage();
        if (stage) {
          stage.batchDraw();
        }
      } catch (erro) {
        console.warn(
          "[SEVEN DESIGNER] Não foi possível carregar todas as fontes artísticas.",
          erro
        );
      }
    },

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
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  gap: 18px;
  padding: 22px 15px;
  overflow: hidden;
  border-radius: 8px;
  background-color: #e9ecef;
  background-image:
    linear-gradient(45deg, #dfe2e6 25%, transparent 25%),
    linear-gradient(-45deg, #dfe2e6 25%, transparent 25%),
    linear-gradient(45deg, transparent 75%, #dfe2e6 75%),
    linear-gradient(-45deg, transparent 75%, #dfe2e6 75%);
  background-size: 24px 24px;
  background-position: 0 0, 0 12px, 12px -12px, -12px 0;
}

.background-gallery {
  width: min(100%, 620px);
  padding: 14px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.10);
}

.background-gallery-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.background-gallery-header strong,
.background-gallery-header small {
  display: block;
}

.background-gallery-header small {
  margin-top: 2px;
  color: #6c757d;
}

.background-gallery-header > span {
  padding: 5px 9px;
  border-radius: 999px;
  background: #f1f3f5;
  color: #495057;
  font-size: 12px;
  font-weight: 700;
}

.background-gallery-items {
  display: flex;
  gap: 10px;
  overflow-x: auto;
  padding-bottom: 3px;
}

.background-card {
  flex: 0 0 92px;
  padding: 0;
  border: 2px solid transparent;
  border-radius: 10px;
  background: transparent;
  text-align: left;
  cursor: pointer;
}

.background-card.active {
  border-color: #ffc107;
}

.background-thumb {
  position: relative;
  height: 116px;
  overflow: hidden;
  border-radius: 8px;
  background: #1c1c1c;
}

.background-thumb img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
}

.background-thumb-procedural {
  width: 100%;
  height: 100%;
  background: linear-gradient(180deg, #20252b 0%, #4b2a1c 52%, #100a07 100%);
}

.background-check {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 23px;
  height: 23px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: #ffc107;
  color: #111;
  font-weight: 900;
}

.background-name {
  display: block;
  padding: 6px 5px 5px;
  color: #343a40;
  font-size: 12px;
  font-weight: 700;
  text-align: center;
}

/* EDITOR DE TIPOGRAFIA */
.text-style-editor {
  width: min(100%, 620px);
  padding: 14px;
  border-radius: 12px;
  background: rgba(255,255,255,.96);
  box-shadow: 0 8px 24px rgba(0,0,0,.10);
}
.text-style-header { display:flex; justify-content:space-between; gap:12px; align-items:center; margin-bottom:12px; }
.text-style-header strong, .text-style-header small { display:block; }
.text-style-header small { color:#6c757d; margin-top:2px; }
.reset-style-btn { border:1px solid #dee2e6; background:#fff; border-radius:8px; padding:7px 10px; font-size:12px; font-weight:700; cursor:pointer; }
.text-style-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
.text-style-grid label > span, .quick-colors > span { display:block; font-size:11px; font-weight:800; color:#6c757d; text-transform:uppercase; margin-bottom:5px; }
.style-select, .color-hex { width:100%; height:38px; border:1px solid #ced4da; border-radius:8px; padding:0 9px; background:#fff; }
.color-field { grid-column:1 / -1; }
.color-control { display:flex; gap:8px; }
.color-picker { width:52px; height:38px; padding:2px; border:1px solid #ced4da; border-radius:8px; background:#fff; cursor:pointer; }
.quick-colors { margin-top:12px; }
.quick-color { width:28px; height:28px; border-radius:50%; border:2px solid #fff; box-shadow:0 0 0 1px #ced4da; margin-right:8px; cursor:pointer; }
.font-preview-row { display:flex; gap:7px; overflow-x:auto; margin-top:12px; padding:3px 1px 5px; }
.font-preview { flex:0 0 54px; height:42px; border:1px solid #dee2e6; border-radius:8px; background:#fff; font-size:22px; cursor:pointer; }
.font-preview.active { border-color:#ffc107; box-shadow:0 0 0 2px rgba(255,193,7,.22); }
@media (max-width: 520px) { .text-style-grid { grid-template-columns:1fr; } .color-field { grid-column:auto; } }

.canvas-scale-wrapper {
  flex: 0 0 auto;

  background: #111;

  box-shadow:
    0 20px 45px rgba(0, 0, 0, 0.30);
}
</style>