<template>
  <div class="designer-canvas-shell">
    <div ref="wrap" class="canvas-wrap" @click.self="limparSelecao">
      <v-stage ref="stage" :config="{ width: 1080, height: 1920, scaleX: escala, scaleY: escala }"
        :style="{ width: (1080 * escala) + 'px', height: (1920 * escala) + 'px' }"
        @mousedown="aoClicarStage" @touchstart="aoClicarStage">
        <v-layer>
          <v-rect :config="{ id: 'canvas-background-hit', x: 0, y: 0, width: 1080, height: 1920, fill: '#1a0f0b', listening: true }" />
          <v-image v-if="backgroundImage"
            :config="{ image: backgroundImage, x: 0, y: 0, width: 1080, height: 1920, listening: false }" />
          <template v-else>
            <v-rect
              :config="{ x: 0, y: 0, width: 1080, height: 1920, fillLinearGradientStartPoint: { x: 0, y: 0 }, fillLinearGradientEndPoint: { x: 0, y: 1920 }, fillLinearGradientColorStops: [0, '#2b160f', .48, '#8a4322', 1, '#120b09'], listening: false }" />
          </template>
        </v-layer>

        <v-layer>
          <v-rect v-if="imagens.length === 0" :config="placeholderRect" @click="pedirUpload" @tap="pedirUpload" />
          <v-text v-if="imagens.length === 0" :config="placeholderText" @click="pedirUpload" @tap="pedirUpload" />

          <template v-for="forma in formas" :key="forma.elementId">
            <v-circle v-if="forma.forma === 'circulo'" :config="formaCirculoConfig(forma)"
              @click="selecionarForma(forma)" @tap="selecionarForma(forma)"
              @dragend="dragForma(forma, $event)" @transformend="transformForma(forma, $event)" />
            <v-rect v-else :config="formaRectConfig(forma)"
              @click="selecionarForma(forma)" @tap="selecionarForma(forma)"
              @dragend="dragForma(forma, $event)" @transformend="transformForma(forma, $event)" />
          </template>

          <template v-for="img in imagens" :key="img.elementId">
            <v-image :config="imagemConfig(img)"
              @click="selecionarImagem(img)" @tap="selecionarImagem(img)"
              @dragmove="acompanharImagemSelecionada(img, $event)"
              @dragend="dragImagem(img, $event)"
              @transformend="transformImagem(img, $event)" />

          </template>
          <v-group :config="grupoConfig('data')" @click="selecionarTexto('data')" @tap="selecionarTexto('data')"
            @dragend="dragTexto('data', $event)" @transformend="transformTexto('data', $event)">
            <v-rect :config="fundoConfig('data')" />
            <v-text :config="textoConfig('data', dataFormatada)"
              @dblclick="editarTextoNoCanvas('data')" @dbltap="editarTextoNoCanvas('data')" />
          </v-group>

          <v-group :config="grupoConfig('weekday')" @click="selecionarTexto('weekday')"
            @tap="selecionarTexto('weekday')" @dragend="dragTexto('weekday', $event)"
            @transformend="transformTexto('weekday', $event)">
            <v-rect :config="fundoConfig('weekday')" />
            <v-text :config="textoConfig('weekday', weekday)"
              @dblclick="editarTextoNoCanvas('weekday')" @dbltap="editarTextoNoCanvas('weekday')" />
          </v-group>

          <v-group :config="grupoConfig('chamada')" @click="selecionarTexto('chamada')"
            @tap="selecionarTexto('chamada')" @dragend="dragTexto('chamada', $event)"
            @transformend="transformTexto('chamada', $event)">
            <v-rect :config="fundoConfig('chamada')" />
            <v-text :config="textoConfig('chamada', dados.chamada)"
              @dblclick="editarTextoNoCanvas('chamada')" @dbltap="editarTextoNoCanvas('chamada')" />
          </v-group>

          <v-group :config="grupoConfig('showLabel')" @click="selecionarTexto('showLabel')"
            @tap="selecionarTexto('showLabel')" @dragend="dragTexto('showLabel', $event)"
            @transformend="transformTexto('showLabel', $event)">
            <v-rect :config="fundoConfig('showLabel')" />
            <v-text :config="textoConfig('showLabel', estilos.showLabel?.textoOverride || 'SHOW COM')"
              @dblclick="editarTextoNoCanvas('showLabel')" @dbltap="editarTextoNoCanvas('showLabel')" />
          </v-group>

          <v-group :config="grupoConfig('artista')" @click="selecionarTexto('artista')"
            @tap="selecionarTexto('artista')" @dragend="dragTexto('artista', $event)"
            @transformend="transformTexto('artista', $event)">
            <v-rect :config="fundoConfig('artista')" />
            <v-text :config="textoConfig('artista', dados.artista)"
              @dblclick="editarTextoNoCanvas('artista')" @dbltap="editarTextoNoCanvas('artista')" />
          </v-group>

          <v-group :config="grupoConfig('estabelecimento')" @click="selecionarTexto('estabelecimento')"
            @tap="selecionarTexto('estabelecimento')" @dragend="dragTexto('estabelecimento', $event)"
            @transformend="transformTexto('estabelecimento', $event)">
            <v-rect :config="fundoConfig('estabelecimento')" />
            <v-text :config="textoConfig('estabelecimento', dados.local)"
              @dblclick="editarTextoNoCanvas('estabelecimento')" @dbltap="editarTextoNoCanvas('estabelecimento')" />
          </v-group>

          <v-group :config="grupoConfig('cidadeHorario')" @click="selecionarTexto('cidadeHorario')"
            @tap="selecionarTexto('cidadeHorario')" @dragend="dragTexto('cidadeHorario', $event)"
            @transformend="transformTexto('cidadeHorario', $event)">
            <v-rect :config="fundoConfig('cidadeHorario')" />
            <v-text
              :config="textoConfig('cidadeHorario', estilos.cidadeHorario?.textoOverride || `${dados.cidade} • ${dados.horario}`)"
              @dblclick="editarTextoNoCanvas('cidadeHorario')" @dbltap="editarTextoNoCanvas('cidadeHorario')" />
          </v-group>

          <v-group :config="grupoConfig('extra')" @click="selecionarTexto('extra')" @tap="selecionarTexto('extra')"
            @dragend="dragTexto('extra', $event)" @transformend="transformTexto('extra', $event)">
            <v-rect :config="fundoConfig('extra')" />
            <v-text :config="textoConfig('extra', dados.extra)"
              @dblclick="editarTextoNoCanvas('extra')" @dbltap="editarTextoNoCanvas('extra')" />
          </v-group>

          <v-group
            v-for="livre in textosLivres"
            v-show="!estilos[livre.id]?.oculto"
            :key="livre.id"
            :config="grupoConfig(livre.id)"
            @click="selecionarTexto(livre.id)"
            @tap="selecionarTexto(livre.id)"
            @dragend="dragTexto(livre.id, $event)"
            @transformend="transformTexto(livre.id, $event)"
          >
            <v-rect :config="fundoConfig(livre.id)" />
            <v-text
              :config="textoConfig(livre.id, estilos[livre.id]?.textoOverride || livre.texto)"
              @dblclick="editarTextoNoCanvas(livre.id)"
              @dbltap="editarTextoNoCanvas(livre.id)"
            />
          </v-group>

          <v-transformer ref="transformer" :config="transformerConfig" />

          <!-- Mobile UI: existe somente UM botão excluir, ligado à imagem selecionada. -->
          <v-group v-if="mobileMode && imagemSelecionadaAtual"
            :config="deleteImageButtonConfig(imagemSelecionadaAtual)"
            @click="excluirImagemSelecionada(imagemSelecionadaAtual)"
            @tap="excluirImagemSelecionada(imagemSelecionadaAtual)">
            <v-circle :config="{ x: 0, y: 0, radius: 34, fill: '#dc3545', stroke: '#ffffff', strokeWidth: 6 }" />
            <v-text :config="{ x: -18, y: -25, width: 36, height: 50, text: '×', align: 'center', verticalAlign: 'middle', fill: '#ffffff', fontSize: 42, fontStyle: 'bold' }" />
          </v-group>
          <v-group v-if="mobileMode && textoSelecionadoAtual"
            ref="textDeleteButton"
            :config="deleteTextButtonConfig(textoSelecionadoAtual)"
            @click="excluirTextoSelecionado(textoSelecionadoAtual)"
            @tap="excluirTextoSelecionado(textoSelecionadoAtual)">
            <v-circle :config="{ x: 0, y: 0, radius: 34, fill: '#dc3545', stroke: '#ffffff', strokeWidth: 6 }" />
            <v-text :config="{ x: -18, y: -25, width: 36, height: 50, text: '×', align: 'center', verticalAlign: 'middle', fill: '#ffffff', fontSize: 42, fontStyle: 'bold' }" />
          </v-group>
          <v-group v-if="mobileMode && formaSelecionadaAtual"
            ref="shapeDeleteButton"
            :config="deleteShapeButtonConfig(formaSelecionadaAtual)"
            @click="excluirFormaSelecionada(formaSelecionadaAtual)"
            @tap="excluirFormaSelecionada(formaSelecionadaAtual)">
            <v-circle :config="{ x: 0, y: 0, radius: 34, fill: '#dc3545', stroke: '#ffffff', strokeWidth: 6 }" />
            <v-text :config="{ x: -18, y: -25, width: 36, height: 50, text: '×', align: 'center', verticalAlign: 'middle', fill: '#ffffff', fontSize: 42, fontStyle: 'bold' }" />
          </v-group>
        </v-layer>
      </v-stage>
    </div>
    <small class="d-block text-center text-muted mt-2">Clique em um texto ou imagem para editar • arraste para mover •
      use
      as alças para redimensionar e girar</small>
  </div>
</template>

<script>
import backgrounds from "./backgrounds/backgrounds";
import { obterFontePorId } from "./fonts/fonts";

const POS = {
  data: { x: 78, y: 85, w: 390, h: 150, size: 118, align: "left" },
  weekday: { x: 82, y: 230, w: 245, h: 72, size: 42, align: "center" },
  chamada: { x: 625, y: 120, w: 370, h: 180, size: 58, align: "center" },
  showLabel: { x: 150, y: 1070, w: 330, h: 90, size: 58, align: "center" },
  artista: { x: 95, y: 1180, w: 890, h: 190, size: 125, align: "center" },
  estabelecimento: { x: 135, y: 1430, w: 810, h: 150, size: 72, align: "center" },
  cidadeHorario: { x: 140, y: 1610, w: 800, h: 90, size: 47, align: "center" },
  extra: { x: 245, y: 1740, w: 590, h: 100, size: 54, align: "center" }
};

export default {
  name: "DesignerCanvas",
  emits: ["selecionar", "atualizar-imagem", "atualizar-forma", "atualizar-texto-layout", "editar-texto", "pedir-upload", "remover-imagem", "remover-forma", "remover-texto", "imagem-carregada"],
  props: {
    dados: { type: Object, required: true },
    imagens: { type: Array, default: () => [] },
    formas: { type: Array, default: () => [] },
    estilos: { type: Object, required: true },
    textosLivres: { type: Array, default: () => [] },
    backgroundId: { type: String, default: "show-luzes-01" },
    mobileMode: { type: Boolean, default: false }
  },
  data() {
    return {
      escala: .38, backgrounds, backgroundImage: null,
      imagensCarregadas: {}, selecionado: null, imagemSelecionadaPosicaoLive: null
    }
  },
  computed: {
    imagemSelecionadaAtual() {
      if (!this.mobileMode || this.selecionado?.tipo !== "imagem") return null;
      return this.imagens.find(img => img.elementId === this.selecionado.id) || null;
    },
    textoSelecionadoAtual() {
      if (!this.mobileMode || this.selecionado?.tipo !== "texto") return null;
      return this.selecionado.id || null;
    },
    formaSelecionadaAtual() {
      if (!this.mobileMode || this.selecionado?.tipo !== "forma") return null;
      return this.formas.find(f => f.elementId === this.selecionado.id) || null;
    },
    backgroundAtual() { return this.backgrounds.find(b => b.id === this.backgroundId) || this.backgrounds[0] },
    dataFormatada() { if (!this.dados.data) return ""; const [, m, d] = this.dados.data.split("-"); return `${d}/${m}` },
    weekday() {
      if (this.estilos.weekday?.textoOverride) return this.estilos.weekday.textoOverride;
      if (!this.dados.data) return "";
      const ds = ["DOMINGO", "SEGUNDA", "TERÇA", "QUARTA", "QUINTA", "SEXTA", "SÁBADO"];
      return ds[new Date(`${this.dados.data}T12:00:00`).getDay()];
    },
    placeholderRect() { return { x: 110, y: 330, width: 860, height: 700, stroke: "#ffffff", strokeWidth: 4, dash: [20, 14], cornerRadius: 25, fill: "rgba(255,255,255,.06)", listening: true } },
    placeholderText() { return { x: 210, y: 650, width: 660, text: "+ FOTO DO ARTISTA", fontSize: 52, fontStyle: "bold", align: "center", fill: "#ffffff", listening: true } },
    transformerConfig() {
      const f = this.selecionado?.tipo === "forma" ? this.formas.find(x => x.elementId === this.selecionado.id) : null;
      const keepRatio = this.selecionado?.tipo === "imagem" || f?.forma === "quadrado" || f?.forma === "circulo";
      return { rotateEnabled:true, keepRatio, flipEnabled:false, enabledAnchors:["top-left","top-right","bottom-left","bottom-right"], borderStroke:"#ffc107", anchorStroke:"#111", anchorFill:"#ffc107", anchorSize:20, anchorCornerRadius:10 };
    }
  },
  watch: {
    estilos: {
      deep: true,
      handler() {
        Object.keys(this.estilos || {}).forEach(id => this.garantirFonte(id));
        this.$nextTick(() => {
          this.$refs.stage?.getNode?.()?.batchDraw();
          this.atualizarOrdemCamadas();
          this.atualizarTransformer();
        });
      }
    },
    imagens: { deep: true, immediate: true, handler() { this.carregarImagens(); this.$nextTick(() => this.atualizarOrdemCamadas()); } },
    formas: { deep: true, handler() { this.$nextTick(() => this.atualizarOrdemCamadas()); } },
    textosLivres: { deep: true, handler() { this.$nextTick(() => this.atualizarOrdemCamadas()); } },
    backgroundId: { immediate: true, handler() { this.carregarBackground() } }
  },
  mounted() {
    window.addEventListener("resize", this.ajustarEscala);
    window.addEventListener("keydown", this.aoPressionarTecla);
    this.ajustarEscala();
    Object.keys(this.estilos || {}).forEach(id => this.garantirFonte(id));
  },
  beforeUnmount() {
    window.removeEventListener("resize", this.ajustarEscala);
    window.removeEventListener("keydown", this.aoPressionarTecla);
  },
  updated() {
    // Sincronização final do frame declarativo do vue-konva.
    requestAnimationFrame(() => {
      this.atualizarOrdemCamadas();
      const btn = this.$refs.textDeleteButton?.getNode?.();
      btn?.setAttrs?.(this.deleteTextButtonConfig(this.textoSelecionadoAtual));
      btn?.moveToTop?.();

      const shapeBtn = this.$refs.shapeDeleteButton?.getNode?.();
      shapeBtn?.setAttrs?.(this.deleteShapeButtonConfig(this.formaSelecionadaAtual));
      shapeBtn?.moveToTop?.();

      (shapeBtn || btn)?.getLayer?.()?.batchDraw?.();
    });
  },
  methods: {
    deleteShapeButtonConfig(forma) {
      const st = this.$refs.stage?.getNode?.();
      const node = st?.findOne?.(`#${forma?.elementId}`);
      if (!node) return { x: 0, y: 0, visible: false, listening: false };
      const box = node.getClientRect({
        relativeTo: node.getLayer(),
        skipTransform: false,
        skipShadow: true,
        skipStroke: true
      });
      const radius = 34;
      return {
        x: box.x + box.width - radius * 0.15,
        y: box.y + radius * 0.15,
        visible: true,
        listening: true
      };
    },
    excluirFormaSelecionada(forma) {
      if (!forma?.elementId) return;
      this.$emit("remover-forma", forma.elementId);
      this.limparSelecao();
    },
    deleteTextButtonConfig(id) {
      const st = this.$refs.stage?.getNode?.();
      const node = st?.findOne?.(`#${this.nodeId(id)}`);
      if (!node) return { x: 0, y: 0, visible: false, listening: false };

      // O botão usa o mesmo retângulo visual que o Transformer desenha.
      // Como o Group e o botão pertencem ao mesmo layer, estas coordenadas
      // acompanham corretamente posição, escala e rotação do texto.
      const box = node.getClientRect({
        relativeTo: node.getLayer(),
        skipTransform: false,
        skipShadow: true,
        skipStroke: true
      });

      const radius = 34;
      return {
        x: box.x + box.width - radius * 0.15,
        y: box.y + radius * 0.15,
        visible: true,
        listening: true
      };
    },
    excluirTextoSelecionado(id) {
      if (!id) return;
      this.$emit("remover-texto", id);
      this.limparSelecao();
    },
    deleteImageButtonConfig(img) {
      const live = this.imagemSelecionadaPosicaoLive?.elementId === img.elementId
        ? this.imagemSelecionadaPosicaoLive
        : null;
      return {
        x: Number(live?.x ?? img.x ?? 0) + Number(live?.width ?? img.width ?? 0),
        y: Number(live?.y ?? img.y ?? 0),
        listening: true
      };
    },
    excluirImagemSelecionada(img) {
      if (!img?.elementId) return;
      this.$emit("remover-imagem", img.elementId);
      this.limparSelecao();
    },
    aoClicarStage(event) {
      const target = event?.target;
      if (!target) return;

      // Fundo/base do Stage = clique fora de qualquer elemento editável.
      if (target === target.getStage?.() || target.id?.() === "canvas-background-hit") {
        this.limparSelecao();
      }
    },
    aoPressionarTecla(event) {
      if (!["Delete", "Backspace"].includes(event.key)) return;

      const tag = document.activeElement?.tagName?.toLowerCase();
      if (["input", "textarea", "select"].includes(tag)) return;

      if (this.selecionado?.tipo === "imagem") {
        event.preventDefault();
        this.$emit("remover-imagem", this.selecionado.id);
        this.limparSelecao();
      } else if (this.selecionado?.tipo === "forma") {
        event.preventDefault();
        this.$emit("remover-forma", this.selecionado.id);
        this.limparSelecao();
      }
    },
    editarTextoNoCanvas(id) {
      this.selecionarTexto(id);
      this.iniciarEdicaoInline(id);
    },

    iniciarEdicaoInline(id) {
      const stage = this.$refs.stage?.getNode?.();
      if (!stage) return;

      const group = stage.findOne(`#${this.nodeId(id)}`);
      if (!group) return;

      const textNode = group.findOne("Text");
      if (!textNode) return;

      const stageBox = stage.container().getBoundingClientRect();
      const abs = textNode.getAbsolutePosition();
      const scale = this.escala;
      const p = this.layout(id);

      const textarea = document.createElement("textarea");
      textarea.value = this.textoAtual(id);
      textarea.className = "seven-inline-text-editor";
      textarea.style.position = "fixed";
      textarea.style.left = `${stageBox.left + abs.x * scale}px`;
      textarea.style.top = `${stageBox.top + abs.y * scale}px`;
      textarea.style.width = `${Math.max(120, p.w * scale)}px`;
      textarea.style.height = `${Math.max(38, p.h * scale)}px`;
      textarea.style.fontFamily = this.fonte(id);
      textarea.style.fontSize = `${Math.max(16, p.size * scale)}px`;
      textarea.style.color = "#111827";
      textarea.style.background = "rgba(255,255,255,.96)";
      textarea.style.border = "2px solid #7c3aed"; textarea.style.boxShadow = "0 8px 24px rgba(16,24,40,.20)";
      textarea.style.borderRadius = "7px";
      textarea.style.padding = "4px 7px";
      textarea.style.zIndex = "9999";
      textarea.style.resize = "none"; textarea.style.overflow = "hidden";
      textarea.style.outline = "none";
      textarea.style.textAlign = p.align || "center";

      document.body.appendChild(textarea);

      const actions = document.createElement("div");
      actions.style.position = "fixed";
      actions.style.left = textarea.style.left;
      actions.style.top = `calc(${textarea.style.top} + ${textarea.style.height} + 6px)`;
      actions.style.zIndex = "10000";
      actions.style.display = "flex";
      actions.style.gap = "6px";
      actions.style.padding = "5px";
      actions.style.borderRadius = "9px";
      actions.style.background = "#fff";
      actions.style.boxShadow = "0 6px 18px rgba(16,24,40,.18)";

      const concluir = document.createElement("button");
      concluir.type = "button";
      concluir.textContent = "✓ Concluir";
      concluir.style.cssText = "border:0;border-radius:7px;padding:6px 10px;background:#7c3aed;color:#fff;font-weight:700";

      const cancelar = document.createElement("button");
      cancelar.type = "button";
      cancelar.textContent = "Cancelar";
      cancelar.style.cssText = "border:1px solid #d0d5dd;border-radius:7px;padding:6px 10px;background:#fff;font-weight:700";

      actions.appendChild(concluir);
      actions.appendChild(cancelar);
      document.body.appendChild(actions);

      textarea.focus();
      textarea.select();

      const original = textarea.value;
      let finalizado = false;

      const finalizar = (salvar = true) => {
        if (finalizado) return;
        finalizado = true;

        if (salvar) {
          const valor = textarea.value;
          this.$emit("editar-texto", { id, texto: valor, inline: true });
        } else {
          this.$emit("editar-texto", { id, texto: original, cancelado: true });
        }

        textarea.remove();
        actions.remove();
      };

      concluir.addEventListener("mousedown", e => e.preventDefault());
      cancelar.addEventListener("mousedown", e => e.preventDefault());
      concluir.addEventListener("click", () => finalizar(true));
      cancelar.addEventListener("click", () => finalizar(false));

      textarea.addEventListener("keydown", e => {
        if (e.key === "Escape") {
          e.preventDefault();
          finalizar(false);
        } else if (e.key === "Enter" && (e.ctrlKey || e.metaKey)) {
          e.preventDefault();
          finalizar(true);
        }
      });

      // Clique fora confirma; o usuário não precisa conhecer nenhum atalho.
      textarea.addEventListener("blur", () => {
        setTimeout(() => {
          if (!finalizado && !actions.contains(document.activeElement)) finalizar(true);
        }, 0);
      });
    },
    ajustarEscala() { this.$nextTick(() => { const w = this.$refs.wrap?.clientWidth || 430; this.escala = Math.min(.5, (w - 8) / 1080) }) },
    pedirUpload() { this.$emit("pedir-upload") },
    carregarBackground() {
      const bg = this.backgroundAtual; if (!bg || bg.tipo !== "imagem") { this.backgroundImage = null; return }
      const im = new Image(); im.onload = () => { this.backgroundImage = im }; im.src = bg.src;
    },
    carregarImagens() {
      const valid = new Set(this.imagens.map(i => i.elementId));
      Object.keys(this.imagensCarregadas).forEach(k => { if (!valid.has(k)) delete this.imagensCarregadas[k] });
      this.imagens.forEach(item => {
        if (!item.src) return;
        const atual = this.imagensCarregadas[item.elementId];
        if (atual?.__src === item.src) return;
        const im = new Image();
        // Deliberadamente SEM crossOrigin: o arquivo vem do wwwroot da própria API e
        // o crossOrigin estava impedindo o Konva de carregar no ambiente atual.
        im.__src = item.src;
        im.onload = () => {
          this.imagensCarregadas = { ...this.imagensCarregadas, [item.elementId]: im };
          this.$emit("imagem-carregada", { elementId: item.elementId, src: item.src });

          if (!item.aspectRatio && im.naturalWidth && im.naturalHeight) {
            const ratio = im.naturalWidth / im.naturalHeight;
            const largura = item.width || 760;
            const altura = largura / ratio;

            this.$emit("atualizar-imagem", {
              elementId: item.elementId,
              width: largura,
              height: altura,
              aspectRatio: ratio
            });
          }

          this.$nextTick(() => this.redraw());
        };
        im.onerror = () => console.error("[SEVEN DESIGNER] Não foi possível carregar:", item.src);
        im.src = item.src;
      });
    },
    redraw() { this.$refs.stage?.getNode?.()?.batchDraw(); this.atualizarTransformer() },
    async garantirFonte(id) {
      const family = this.fonte(id);
      if (!family || !document.fonts?.load) return;
      try {
        await document.fonts.load(`48px "${family}"`);
        this.$refs.stage?.getNode?.()?.batchDraw();
      } catch (e) {
        console.warn("[SEVEN DESIGNER] Fonte não carregada:", family, e);
      }
    },
    imagemConfig(i) { return { id: i.elementId, zIndex: Number(i.zIndex ?? 0), image: this.imagensCarregadas[i.elementId] || null, x: i.x, y: i.y, width: i.width, height: i.height, rotation: i.rotation || 0, draggable: true, listening: true } },
    formaBaseConfig(f) {
      return {
        id:f.elementId, zIndex:Number(f.zIndex ?? 0), x:f.x, y:f.y, rotation:f.rotation || 0,
        fill:f.cor || "#ffffff", stroke:f.corBorda || "#111111",
        strokeWidth:Number(f.espessuraBorda || 0), opacity:f.opacidade ?? .85,
        shadowEnabled:Boolean(f.sombra), shadowColor:f.corSombra || "#000000",
        shadowBlur:Number(f.blurSombra || 20), shadowOffsetX:Number(f.offsetSombraX ?? 10),
        shadowOffsetY:Number(f.offsetSombraY ?? 10), shadowOpacity:f.sombra ? .45 : 0,
        draggable:true, listening:true
      };
    },
    formaRectConfig(f) { return { ...this.formaBaseConfig(f), width:f.width, height:f.height, cornerRadius:f.cornerRadius || 0 }; },
    formaCirculoConfig(f) {
      const d = Math.min(f.width, f.height);
      return { ...this.formaBaseConfig(f), radius:d/2, offsetX:-d/2, offsetY:-d/2 };
    },
    selecionarForma(f) {
      this.selecionado = { id:f.elementId, tipo:"forma" };
      this.$emit("selecionar", { id:f.elementId, tipo:"forma" });
      this.$nextTick(() => this.atualizarTransformer());
    },
    dragForma(f,e) { this.$emit("atualizar-forma", { elementId:f.elementId, x:e.target.x(), y:e.target.y() }); },
    transformForma(f,e) {
      const n=e.target, sx=Math.max(.1,n.scaleX()), sy=Math.max(.1,n.scaleY());
      const width=Math.max(30,f.width*sx), height=Math.max(30,f.height*sy);
      n.scale({x:1,y:1});
      this.$emit("atualizar-forma",{elementId:f.elementId,x:n.x(),y:n.y(),width,height,rotation:n.rotation()});
      this.$nextTick(() => this.atualizarTransformer());
    },
    selecionarImagem(i) { this.selecionado = { id: i.elementId, tipo: "imagem" }; this.$emit("selecionar", { id: i.elementId, tipo: "imagem" }); this.$nextTick(() => this.atualizarTransformer()) },
    textoAtual(id) {
      const map = { data: this.dataFormatada, weekday: this.weekday, chamada: this.dados.chamada, showLabel: this.estilos.showLabel?.textoOverride || "SHOW COM", artista: this.dados.artista, estabelecimento: this.dados.local, cidadeHorario: this.estilos.cidadeHorario?.textoOverride || `${this.dados.cidade} • ${this.dados.horario}`, extra: this.dados.extra };
      if (map[id] !== undefined) return map[id];
      if (id?.startsWith("livre-")) {
        return this.estilos[id]?.textoOverride ||
          this.textosLivres.find(t => t.id === id)?.texto || "";
      }
      return "";
    },
    selecionarTexto(id) { this.selecionado = { id, tipo: "texto" }; this.$emit("selecionar", { id, tipo: "texto", texto: this.textoAtual(id) }); this.$nextTick(() => this.atualizarTransformer()) },
    selecionarExterno(id, tipo) { this.selecionado = id ? { id, tipo } : null; this.$nextTick(() => this.atualizarTransformer()) },
    limparSelecao() {
      this.selecionado = null;
      this.$emit("selecionar", { id: null, tipo: null });
      this.$nextTick(() => {
        this.atualizarTransformer();
        this.atualizarOrdemCamadas();
        requestAnimationFrame(() => this.atualizarOrdemCamadas());
      });
    },
    nodeId(id) { return `el-${id}` },
    layout(id) {
      const fallback = { x: 300, y: 900, w: 480, h: 100, size: 58, align: "center", rotation: 0 };
      return { ...(POS[id] || fallback), ...(this.estilos[id]?.layout || {}) };
    },
    grupoConfig(id) {
      const p = this.layout(id);
      return {
        id: this.nodeId(id),
        zIndex: Number(p.zIndex ?? 0),
        x: p.x,
        y: p.y,
        rotation: p.rotation || 0,
        scaleX: p.scaleX || 1,
        scaleY: p.scaleY || 1,
        draggable: true,
        listening: true,
        visible: !this.estilos[id]?.oculto
      };
    },
    fonte(id) { return obterFontePorId(this.estilos[id]?.fontId)?.family || "Arial" },
    textoConfig(id, text) { const p = this.layout(id); return { x: 0, y: 0, width: p.w, height: p.h, text, fontFamily: this.fonte(id), fontSize: p.size, fill: this.estilos[id]?.corTexto || "#fff", align: p.align || "center", verticalAlign: "middle", fontStyle: id === "data" ? "bold" : "normal", listening: true, wrap: "word" } },
    fundoConfig(id) {
      const p = this.layout(id);
      const ativo = Boolean(this.estilos[id]?.temFundo);
      return {
        x:0, y:0, width:p.w, height:p.h,
        fill:this.estilos[id]?.corFundo || "#000000",
        cornerRadius:this.estilos[id]?.cornerRadius ?? (id === "estabelecimento" ? 14 : 4),
        opacity:ativo ? (this.estilos[id]?.fundoOpacity ?? (id === "estabelecimento" ? .94 : .9)) : 0,
        visible:ativo, listening:false
      };
    },
    atualizarTransformer() {
      const tr = this.$refs.transformer?.getNode?.(); const st = this.$refs.stage?.getNode?.(); if (!tr || !st) return;
      if (!this.selecionado) { tr.nodes([]); tr.getLayer()?.batchDraw(); return }
      const node = st.findOne(`#${this.nodeId(this.selecionado.id)}`) || st.findOne(`#${this.selecionado.id}`);
      tr.nodes(node ? [node] : []); tr.getLayer()?.batchDraw();
    },
    alinharSelecionado(alinhamento) {
      const st = this.$refs.stage?.getNode?.();
      if (!st || !this.selecionado) return;

      const node =
        st.findOne(`#${this.nodeId(this.selecionado.id)}`) ||
        st.findOne(`#${this.selecionado.id}`);

      if (!node) return;

      const box = node.getClientRect({ skipTransform: false });
      const escalaX = node.scaleX?.() || 1;
      const escalaY = node.scaleY?.() || 1;

      if (alinhamento === "left") node.x(node.x() - box.x);
      else if (alinhamento === "center") node.x(node.x() + (540 - (box.x + box.width / 2)));
      else if (alinhamento === "right") node.x(node.x() + (1080 - (box.x + box.width)));
      else if (alinhamento === "top") node.y(node.y() - box.y);
      else if (alinhamento === "middle") node.y(node.y() + (960 - (box.y + box.height / 2)));
      else if (alinhamento === "bottom") node.y(node.y() + (1920 - (box.y + box.height)));

      if (this.selecionado.tipo === "imagem") {
        this.$emit("atualizar-imagem", {
          elementId: this.selecionado.id,
          x: node.x(),
          y: node.y()
        });
      } else if (this.selecionado.tipo === "forma") {
        this.$emit("atualizar-forma", { elementId:this.selecionado.id, x:node.x(), y:node.y() });
      } else {
        const p = this.layout(this.selecionado.id);
        this.$emit("atualizar-texto-layout", {
          id: this.selecionado.id,
          layout: {
            ...p,
            x: node.x(),
            y: node.y(),
            scaleX: escalaX,
            scaleY: escalaY,
            rotation: node.rotation()
          }
        });
      }

      node.getLayer()?.batchDraw();
      this.$nextTick(() => this.atualizarTransformer());
    },

    atualizarOrdemCamadas() {
      const st = this.$refs.stage?.getNode?.();
      if (!st) return;

      const contentLayer = this.$refs.transformer?.getNode?.()?.getLayer?.();
      if (!contentLayer) return;

      const nodes = [];
      this.formas.forEach((f, index) => {
        const node = contentLayer.findOne(`#${f.elementId}`);
        if (node) nodes.push({ node, z: Number.isFinite(Number(f.zIndex)) ? Number(f.zIndex) : 10 + index });
      });
      this.imagens.forEach((i, index) => {
        const node = contentLayer.findOne(`#${i.elementId}`);
        if (node) nodes.push({ node, z: Number.isFinite(Number(i.zIndex)) ? Number(i.zIndex) : 100 + index });
      });
      Object.keys(this.estilos || {}).forEach((id, index) => {
        const node = contentLayer.findOne(`#${this.nodeId(id)}`);
        if (!node) return;
        const z = Number(this.estilos[id]?.layout?.zIndex);
        nodes.push({ node, z: Number.isFinite(z) ? z : 200 + index });
      });

      // Aplica a ordem persistida aos nós reais do Konva.
      nodes.sort((a, b) => a.z - b.z).forEach((item, index) => item.node.zIndex(index));

      // Transformer e controles são UI, portanto ficam sempre acima da pilha do cartaz.
      const transformer = this.$refs.transformer?.getNode?.();
      transformer?.moveToTop();
      transformer?.getLayer?.()?.batchDraw?.();
      st.batchDraw();
    },

    aplicarOrdemCamadasAgora() {
      // Vue-Konva pode reaplicar a ordem declarativa no mesmo ciclo.
      // Reaplica após o patch atual e novamente no próximo frame.
      this.atualizarOrdemCamadas();
      this.$nextTick(() => {
        this.atualizarOrdemCamadas();
        requestAnimationFrame(() => {
          this.atualizarOrdemCamadas();
          this.atualizarTransformer();
        });
      });
    },
    moverSelecionado() {
      this.aplicarOrdemCamadasAgora();
    },
    acompanharImagemSelecionada(i, e) {
      if (!this.mobileMode || this.selecionado?.id !== i.elementId) return;
      this.imagemSelecionadaPosicaoLive = {
        elementId: i.elementId,
        x: e.target.x(),
        y: e.target.y(),
        width: e.target.width()
      };
    },
    dragImagem(i, e) {
      this.$emit("atualizar-imagem", { elementId: i.elementId, x: e.target.x(), y: e.target.y() });
      this.$nextTick(() => { this.imagemSelecionadaPosicaoLive = null; });
    },
    transformImagem(i, e) {
      const n = e.target;
      const sx = n.scaleX();
      let w = Math.max(40, n.width() * sx);
      let h;

      if (i.aspectRatio) {
        h = w / i.aspectRatio;
      } else {
        const sy = n.scaleY();
        h = Math.max(40, n.height() * sy);
      }

      n.scale({ x: 1, y: 1 });
      n.size({ width: w, height: h });

      this.$emit("atualizar-imagem", {
        elementId: i.elementId,
        x: n.x(),
        y: n.y(),
        width: w,
        height: h,
        rotation: n.rotation()
      });

      this.$nextTick(() => this.atualizarTransformer());
    },
    dragTexto(id, e) { const p = this.layout(id); this.$emit("atualizar-texto-layout", { id, layout: { ...p, x: e.target.x(), y: e.target.y() } }) },
    transformTexto(id, e) {
      const n = e.target;
      const p = this.layout(id);

      const novo = {
        ...p,
        x: n.x(),
        y: n.y(),
        scaleX: Math.max(0.15, n.scaleX()),
        scaleY: Math.max(0.15, n.scaleY()),
        rotation: n.rotation()
      };

      this.$emit("atualizar-texto-layout", { id, layout: novo });
      this.$nextTick(() => this.atualizarTransformer());
    }
  }
};
</script>

<style scoped>
.designer-canvas-shell {
  width: 100%
}

.background-picker {
  padding: 14px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #fff
}

.bg-choice {
  width: 92px;
  border: 2px solid transparent;
  border-radius: 10px;
  background: #fff;
  padding: 5px
}

.bg-choice.active {
  border-color: #ffc107
}

.bg-choice img,
.procedural-thumb {
  display: block;
  width: 78px;
  height: 105px;
  object-fit: cover;
  border-radius: 7px
}

.procedural-thumb {
  background: linear-gradient(#2b160f, #8a4322, #120b09)
}

.bg-choice small {
  display: block;
  margin-top: 4px;
  font-weight: 700
}

.canvas-wrap {
  width: 100%;
  overflow: hidden;
  display: flex;
  justify-content: center;
  padding: 4px;
  background-image: linear-gradient(45deg, #e8e8e8 25%, transparent 25%), linear-gradient(-45deg, #e8e8e8 25%, transparent 25%), linear-gradient(45deg, transparent 75%, #e8e8e8 75%), linear-gradient(-45deg, transparent 75%, #e8e8e8 75%);
  background-size: 20px 20px;
  background-position: 0 0, 0 10px, 10px -10px, -10px 0
}
</style>
