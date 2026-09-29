<template>
  <div class="card cifra-main-card border border-light shadow-sm text-start bg-white mt-4">
    <!-- ========================================================= -->
    <!-- CABEÇALHO -->
    <!-- ========================================================= -->
    <div class="cifra-header">
      <div>
        <h5 class="text-dark fw-bold font-monospace text-uppercase mb-1 fs-15" style="letter-spacing: 0.5px;">
          <span class="header-guitar">🎸</span>
          GERADOR & TRANSPOSITOR DE CIFRAS
        </h5>

        <p class="text-muted small mb-0 font-monospace fs-12">
          Busque qualquer música e mude o tom com a inteligência da Seven Shows
        </p>
      </div>

      <span
        class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-20 font-monospace px-3 py-1 fs-11 rounded-pill live-badge">
        TECNOLOGIA SEVEN SHOWS IA
      </span>
    </div>


    <!-- ========================================================= -->
    <!-- PAINEL DE CONTROLE -->
    <!-- ========================================================= -->
    <div class="control-panel">

      <div class="row g-3 align-items-end">

        <!-- NOME DA MÚSICA -->
        <div class="col-lg-4 col-md-6">
          <label class="control-label">
            Nome da Música
          </label>

          <input type="text" class="form-control control-input" v-model="form.nomeMusica"
            placeholder="Ex: Rumo a Goiânia" @keyup.enter="gerarCifraMusicaReal" />
        </div>


        <!-- CANTOR / BANDA -->
        <div class="col-lg-4 col-md-6">
          <label class="control-label">
            Cantor / Banda

            <span class="text-muted fw-normal">
              (Opcional)
            </span>
          </label>

          <input type="text" class="form-control control-input" v-model="form.nomeArtista"
            placeholder="Ex: Leandro e Leonardo" @keyup.enter="gerarCifraMusicaReal" />
        </div>


        <!-- BOTÃO BUSCAR -->
        <div class="col-lg-4 col-md-12">
          <button type="button" @click="gerarCifraMusicaReal" class="btn btn-primary search-button w-100"
            :disabled="loadingCifra">
            <span v-if="loadingCifra && !carregandoRelacionada" class="spinner-border spinner-border-sm me-2"
              role="status"></span>

            <i v-else class="ri-music-fill me-2"></i>

            {{
              loadingCifra && !carregandoRelacionada
                ? 'Buscando Cifra...'
                : 'Buscar Música'
            }}
          </button>
        </div>

      </div>


      <!-- ======================================================= -->
      <!-- TRANSPOSITOR -->
      <!-- ======================================================= -->
      <div class="transpose-panel">

        <div class="transpose-info">
          <div>
            <div class="control-label mb-1">
              Tom desejado para cantar
            </div>

            <div class="transpose-description">
              <template v-if="cifraResultado">
                Clique em um tom para transpor a cifra
              </template>

              <template v-else>
                Os tons serão habilitados após carregar uma cifra
              </template>
            </div>
          </div>

          <div v-if="cifraResultado && form.tomDesejado" class="current-tone-info">
            <span class="current-tone-label">
              TOM ATUAL
            </span>

            <span class="current-tone-value">
              {{ form.tomDesejado }}
            </span>
          </div>
        </div>


        <!-- 12 TONS -->
        <div class="tone-grid">
          <button type="button" v-for="tom in listaTonsDisponiveis" :key="tom" @click="transporCifraTomIa(tom)"
            class="tone-button" :class="{
              'tone-button-active':
                normalizarTomParaBotao(form.tomDesejado) === tom
            }" :disabled="!podeTranspor || loadingCifra">
            {{ tom }}
          </button>
        </div>

      </div>

    </div>


    <!-- ========================================================= -->
    <!-- MÚSICAS RELACIONADAS -->
    <!-- ========================================================= -->
    <div v-if="
      cifraResultado &&
      cifraResultado.relacionadas &&
      cifraResultado.relacionadas.length > 0
    " class="related-section">
      <div class="related-header">
        <div>
          <div class="related-title">
            <i class="ri-play-list-add-line me-2"></i>
            Músicas relacionadas
          </div>

          <div class="related-subtitle">
            Clique para abrir outra cifra diretamente
          </div>
        </div>

        <div class="related-count">
          {{ cifraResultado.relacionadas.length }}
          sugestões
        </div>
      </div>


      <!-- FAIXA HORIZONTAL -->
      <div class="related-scroll">

        <button v-for="(item, index) in cifraResultado.relacionadas" :key="item.url || index" type="button"
          class="related-song-card" :class="{
            'related-song-disabled': loadingCifra
          }" @click="carregarMusicaRelacionada(item)" :disabled="loadingCifra">
          <div class="related-song-content">

            <div class="related-song-text">
              <div class="related-song-name">
                {{ item.titulo }}
              </div>

              <div class="related-song-artist">
                {{ item.artista }}
              </div>
            </div>

            <div class="related-song-arrow">
              <i class="ri-arrow-right-s-line"></i>
            </div>

          </div>
        </button>

      </div>
    </div>


    <!-- ========================================================= -->
    <!-- ÁREA DA CIFRA -->
    <!-- ========================================================= -->
    <div class="cifra-area">

      <!-- ======================================================= -->
      <!-- ESTADO INICIAL -->
      <!-- ======================================================= -->
      <div v-if="!cifraResultado && !loadingCifra" class="empty-state">
        <div class="empty-icon">
          <i class="ri-file-music-line"></i>
        </div>

        <div class="empty-title">
          Pronto para buscar uma cifra
        </div>

        <div class="empty-description">
          Digite o nome da música e clique em
          <strong>Buscar Música</strong>.
        </div>
      </div>


      <!-- ======================================================= -->
      <!-- CARREGAMENTO -->
      <!-- ======================================================= -->
      <div v-if="loadingCifra" class="loading-state">
        <div class="spinner-border mb-3" role="status" style="color: #ff6c22;"></div>

        <div class="loading-title">
          {{
            carregandoRelacionada
              ? 'Carregando música relacionada...'
              : 'Conectando ao Maestro do Seven Shows...'
          }}
        </div>

        <div class="loading-description">
          {{
            carregandoRelacionada
              ? 'Acessando a cifra diretamente no catálogo.'
              : 'Localizando a música e preparando a cifra.'
          }}
        </div>
      </div>


      <!-- ======================================================= -->
      <!-- CIFRA CARREGADA -->
      <!-- ======================================================= -->
      <div v-if="cifraResultado && !loadingCifra" class="cifra-document animate__animated animate__fadeIn">

        <!-- CABEÇALHO DA MÚSICA -->
        <div class="song-header">

          <div class="song-identification">
            <h4 class="song-title">
              {{ cifraResultado.musica }}
            </h4>

            <div class="song-artist">
              <i class="ri-user-voice-line me-1"></i>

              Artista Original:

              <strong>
                {{ cifraResultado.artista }}
              </strong>
            </div>
          </div>


          <div class="song-header-actions song-header-actions-desktop">
            <button
              type="button"
              class="export-pdf-button"
              title="Exportar cifra para PDF"
              @click="exportarCifraPdf"
            >
              <i class="ri-file-pdf-2-line me-1"></i>
              Exportar PDF
            </button>

            <div class="song-tone-badge">
              <i class="ri-music-2-line me-1"></i>

              TOM:
              {{ cifraResultado.tomOriginal }}
            </div>
          </div>

          <!-- UX mobile recuperada da versão validada v38/v40 -->
          <div class="song-mobile-tools">
            <button
              type="button"
              class="export-pdf-button mobile-export-pdf"
              title="Exportar cifra para PDF"
              @click="exportarCifraPdf"
            >
              <i class="ri-file-pdf-2-line me-1"></i>
              Exportar PDF
            </button>

            <div class="mobile-tone-row">
              <div class="song-tone-badge mobile-current-tone">
                <i class="ri-music-2-line me-1"></i>
                TOM ATUAL: {{ form.tomDesejado || cifraResultado.tomOriginal }}
              </div>

              <button
                type="button"
                class="mobile-change-tone-button"
                @click="mostrarTonsMobile = !mostrarTonsMobile"
              >
                <i class="ri-music-2-line me-1"></i>
                Alterar tom
              </button>
            </div>

            <div v-if="mostrarTonsMobile" class="mobile-tone-picker">
              <button
                type="button"
                v-for="tom in listaTonsDisponiveis"
                :key="'mobile-' + tom"
                @click="transporCifraTomMobile(tom)"
                class="tone-button"
                :class="{
                  'tone-button-active':
                    normalizarTomParaBotao(form.tomDesejado) === tom
                }"
                :disabled="!podeTranspor || loadingCifra"
              >
                {{ tom }}
              </button>
            </div>
          </div>

        </div>


        <!-- ===================================================== -->
        <!-- CIFRA -->
        <!-- ===================================================== -->
        <div class="cifra-scroll">

          <pre class="cifra-pre cifra-pre-desktop">{{ cifraResultado.cifraCompleta }}</pre>

          <pre class="cifra-pre cifra-pre-mobile" v-html="cifraMobileHtml"></pre>

        </div>

      </div>

    </div>

  </div>
</template>


<script>
import axios from "axios";

export default {
  name: "GeradorCifrasIA",

  data() {
    return {
      loadingCifra: false,

      carregandoRelacionada: false,

      // Estado exclusivamente visual do seletor de tom mobile.
      mostrarTonsMobile: false,

      podeTranspor: false,

      cifraResultado: null,

      // Fonte original imutável da música carregada.
      cifraOriginalHtml: "",
      tomOriginalReal: "",

      // Entrada bruta corrente do único formatador mobile.
      cifraAtualHtml: "",

      // Única saída usada pelo renderer mobile.
      cifraMobileRender: "",
      cifraMobileOriginal: "",

      mobileCifraColumns: 0,

      cifraResizeObserver: null,

      listaTonsDisponiveis: [
        "C",
        "C#",
        "D",
        "D#",
        "E",
        "F",
        "F#",
        "G",
        "G#",
        "A",
        "A#",
        "B"
      ],

      form: {
        nomeMusica: "",
        nomeArtista: "",
        tomDesejado: ""
      }
    };
  },


  computed: {
    cifraMobileHtml() {
      return this.colorirAcordesCifraMobile(this.cifraMobile);
    },

    cifraMobile() {
      return this.cifraMobileRender;
    }
  },

  mounted() {
    this.atualizarLarguraCifraMobile();

    window.addEventListener(
      "resize",
      this.atualizarLarguraCifraMobile
    );

    this.$nextTick(() => {
      this.observarLarguraCifraMobile();
    });
  },

  beforeUnmount() {
    window.removeEventListener(
      "resize",
      this.atualizarLarguraCifraMobile
    );

    if (this.cifraResizeObserver) {
      this.cifraResizeObserver.disconnect();
      this.cifraResizeObserver = null;
    }
  },

  methods: {

    // Wrapper exclusivamente de UX mobile.
    // A transposição continua 100% no método funcional existente.
    async transporCifraTomMobile(tom) {
      await this.transporCifraTomIa(tom);
      this.mostrarTonsMobile = false;
    },

    // ==============================================================
    // SEVEN SHOWS v135 — ÚNICO FORMATADOR MOBILE
    // Recebe HTML bruto (original OU transposto), formata e renderiza.
    // ==============================================================
    formatarCifraMobile(cifraRecebida) {
      const htmlBruto = String(cifraRecebida || "");

      console.log("[HTML formatarCifraMobile]", cifraRecebida);

      const textoEstruturado =
        this.extrairTextoDoHtmlEstruturado(htmlBruto);

      const formatado =
        textoEstruturado && this.mobileCifraColumns
          ? this.reflowCifraMobile(
              textoEstruturado,
              this.mobileCifraColumns
            )
          : textoEstruturado;

      this.cifraMobileRender = formatado;

      // A matriz mobile original passa a ser a referência imutável
      // para todas as transposições. Ela já contém quebras e colunas corretas.
      if (
        this.cifraAtualHtml === this.cifraOriginalHtml ||
        !this.cifraMobileOriginal
      ) {
        this.cifraMobileOriginal = formatado;
      }

      

      return formatado;
    },

    // ==============================================================
    // SEVEN SHOWS — REFLOW RESPONSIVO DA CIFRA
    //
    // O desktop continua usando exatamente cifraCompleta.
    // No mobile, acorde e letra são tratados como um par de linhas.
    // Quando a letra precisa quebrar, a linha de acordes é recortada
    // nas mesmas colunas. Assim o acorde continua sobre o mesmo trecho
    // sem depender de uma música específica.
    // ==============================================================

    extrairTextoDoHtmlEstruturado(htmlEstruturado) {
      const html = String(htmlEstruturado || "");

      if (!html) {
        return "";
      }

      const container = document.createElement("div");
      container.innerHTML = html;

      const blocos = Array.from(
        container.querySelectorAll(":scope > div.kvMV")
      ).filter(bloco => {
        const possuiTexto =
          String(bloco.textContent || "").trim().length > 0;

        const possuiElemento =
          bloco.children.length > 0;

        return possuiTexto || possuiElemento;
      });

      if (!blocos.length) {
        return container.textContent.replace(/\r\n?/g, "\n");
      }

      const saida = [];

      blocos.forEach(bloco => {
        let linha = "";
        let colunaEstrutural = 0;

        const finalizarLinha = () => {
          saida.push(linha.replace(/\s+$/g, ""));
          linha = "";
          colunaEstrutural = 0;
        };

        const garantirColuna = coluna => {
          if (linha.length < coluna) {
            linha += " ".repeat(coluna - linha.length);
          }
        };

        Array.from(bloco.childNodes).forEach(node => {
          const ehAcorde =
            node.nodeType === Node.ELEMENT_NODE &&
            node instanceof HTMLElement &&
            node.hasAttribute("data-chord-name");

          if (ehAcorde) {
            const acordeAtual = String(
              node.getAttribute("data-chord-name") ||
              node.textContent ||
              ""
            );

            const acordeOriginal = String(
              node.getAttribute("data-chord-original-text") ||
              node.textContent ||
              acordeAtual
            );

            garantirColuna(colunaEstrutural);

            // Escreve o valor visual na âncora atual.
            // A posição da PRÓXIMA âncora continua sendo calculada
            // exclusivamente pela largura do acorde original.
            const prefixo = linha.slice(0, colunaEstrutural);
            const sufixoInicio =
              colunaEstrutural + acordeAtual.length;

            const sufixo =
              linha.length > sufixoInicio
                ? linha.slice(sufixoInicio)
                : "";

            linha =
              prefixo +
              acordeAtual +
              sufixo;

            colunaEstrutural += acordeOriginal.length;
            return;
          }

          const valor = String(node.textContent || "")
            .replace(/\r\n?/g, "\n");

          const partes = valor.split("\n");

          partes.forEach((parte, indice) => {
            if (parte) {
              garantirColuna(colunaEstrutural);

              const prefixo = linha.slice(0, colunaEstrutural);
              const sufixoInicio =
                colunaEstrutural + parte.length;

              const sufixo =
                linha.length > sufixoInicio
                  ? linha.slice(sufixoInicio)
                  : "";

              linha =
                prefixo +
                parte +
                sufixo;

              colunaEstrutural += parte.length;
            }

            if (indice < partes.length - 1) {
              finalizarLinha();
            }
          });
        });

        finalizarLinha();
      });

      return saida.join("\n");
    },

    observarLarguraCifraMobile() {
      if (typeof ResizeObserver === "undefined") {
        return;
      }

      const scroll =
        this.$el && this.$el.querySelector
          ? this.$el.querySelector(".cifra-scroll")
          : null;

      if (!scroll) {
        return;
      }

      if (this.cifraResizeObserver) {
        this.cifraResizeObserver.disconnect();
      }

      this.cifraResizeObserver =
        new ResizeObserver(() => {
          this.atualizarLarguraCifraMobile();
        });

      this.cifraResizeObserver.observe(scroll);
    },

    atualizarLarguraCifraMobile() {
      this.$nextTick(() => {
        const pre =
          this.$el && this.$el.querySelector
            ? this.$el.querySelector(".cifra-pre-mobile")
            : null;

        if (!pre) {
          return;
        }

        const estilo =
          window.getComputedStyle(pre);

        const scroll =
          pre.parentElement;

        if (!scroll) {
          return;
        }

        // A largura que realmente importa é a viewport da cifra.
        // Medir o próprio <pre> pode incorporar width/padding/box-model
        // de maneiras diferentes entre navegadores e antecipar a quebra.
        const larguraUtil =
          scroll.clientWidth -
          (parseFloat(estilo.paddingLeft) || 0) -
          (parseFloat(estilo.paddingRight) || 0);

        if (larguraUtil <= 0) {
          return;
        }

        // Mede no DOM com a MESMA fonte renderizada pelo <pre>.
        // Isso inclui a fonte efetiva, font-weight e letter-spacing reais,
        // evitando aproximações do canvas.
        const amostra =
          "0000000000000000000000000000000000000000000000000000000000000000";

        const medidor =
          document.createElement("span");

        medidor.textContent = amostra;
        medidor.style.position = "fixed";
        medidor.style.left = "-10000px";
        medidor.style.top = "-10000px";
        medidor.style.visibility = "hidden";
        medidor.style.whiteSpace = "pre";
        medidor.style.fontFamily = estilo.fontFamily;
        medidor.style.fontSize = estilo.fontSize;
        medidor.style.fontWeight = estilo.fontWeight;
        medidor.style.fontStyle = estilo.fontStyle;
        medidor.style.fontVariant = estilo.fontVariant;
        medidor.style.letterSpacing = estilo.letterSpacing;

        document.body.appendChild(medidor);

        const larguraCaractere =
          medidor.getBoundingClientRect().width / amostra.length;

        medidor.remove();

        if (larguraCaractere <= 0) {
          return;
        }

        // Usa todas as colunas que cabem fisicamente na viewport.
        // Não subtrai uma coluna artificial: a medição DOM já considera
        // o espaçamento real e o Math.floor impede ultrapassar o limite.
        const novasColunas = Math.max(
            12,
            Math.floor(larguraUtil / larguraCaractere)
          );
        const colunasMudaram =
          novasColunas !== this.mobileCifraColumns;

        this.mobileCifraColumns = novasColunas;

        if (
          this.cifraAtualHtml &&
          (
            colunasMudaram ||
            !this.cifraMobileRender
          )
        ) {
          // A matriz estrutural sempre nasce da cifra original.
          this.cifraAtualHtml =
            this.cifraOriginalHtml;
          this.cifraMobileOriginal = "";
          this.formatarCifraMobile(
            this.cifraOriginalHtml
          );
        }
      });
    },

    colorirAcordesCifraMobile(texto) {
      const escapar = valor =>
        String(valor ?? "")
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#039;");

      const regexAcorde = /^(?:\(?[A-G](?:#|b)?(?:m|maj|min|dim|aug|sus|add)?\d*(?:\([^)]*\))?(?:\/[A-G](?:#|b)?)?\)?|[-–—|:])+$/i;

      return String(texto || "")
        .split("\n")
        .map(linha => {
          const somenteAcordes = this.ehLinhaSomenteAcordes(linha);
          const temMarcador = /^\s*\[[^\]]+\]/.test(linha);

          if (!somenteAcordes && !temMarcador) {
            return escapar(linha);
          }

          const partes = linha.split(/(\s+)/);
          let marcadorEncerrado = !temMarcador;

          return partes.map(parte => {
            if (!parte || /^\s+$/.test(parte)) {
              return parte;
            }

            if (!marcadorEncerrado) {
              if (parte.includes("]")) {
                marcadorEncerrado = true;
              }
              return escapar(parte);
            }

            if (regexAcorde.test(parte)) {
              return `<span class="cifra-acorde">${escapar(parte)}</span>`;
            }

            return escapar(parte);
          }).join("");
        })
        .join("\n");
    },

    ehLinhaSomenteAcordes(linha) {
      const valor =
        String(linha || "").trim();

      if (!valor || valor.includes("[") || valor.includes("]")) {
        return false;
      }

      const tokens =
        valor.split(/\s+/).filter(Boolean);

      if (!tokens.length) {
        return false;
      }

      const acorde =
        /^(?:\(?[A-G](?:#|b)?(?:m|maj|min|dim|aug|sus|add)?\d*(?:\([^)]*\))?(?:\/[A-G](?:#|b)?)?\)?|[-–—|:])+$/i;

      return tokens.every(token => acorde.test(token));
    },

    calcularFaixasLetra(linha, limite) {
      const faixas = [];
      let inicio = 0;
      const tamanho = linha.length;

      if (!tamanho) {
        return [[0, 0]];
      }

      while (inicio < tamanho) {
        const fimMaximo = Math.min(inicio + limite, tamanho);
        let fim = fimMaximo;

        if (fimMaximo < tamanho) {
          // A quebra mobile segue a letra: usa o último espaço que cabe
          // fisicamente na linha. Só corta uma palavra quando ela própria
          // é maior que toda a largura disponível.
          const ultimoEspaco = linha.lastIndexOf(" ", fimMaximo);

          if (ultimoEspaco >= inicio) {
            fim = ultimoEspaco;
          }
        }

        if (fim <= inicio) {
          fim = fimMaximo;
        }

        faixas.push([inicio, fim]);
        inicio = fim;

        while (inicio < tamanho && linha[inicio] === " ") {
          inicio++;
        }
      }

      return faixas;
    },

    criarModeloLinhaCifra(linhaAcordes, linhaLetra) {
      const texto = String(linhaLetra || "");
      const linha = String(linhaAcordes || "");
      const acordes = [];
      const regex = /\S+/g;
      const encontrados = [];
      let match;

      while ((match = regex.exec(linha)) !== null) {
        encontrados.push({
          valor: match[0],
          coluna: match.index,
          fim: match.index + match[0].length
        });
      }

      // SEVEN SHOWS v115 — modelo de token baseado na estrutura que o
      // Cifra Club mantém no DOM: cada acorde conserva identidade, posição
      // original e, principalmente, o "trailing" original até o próximo
      // acorde. O trailing pertence ao token atual; não é recalculado a
      // partir do tamanho/nome do próximo acorde durante o reflow.
      encontrados.forEach((item, indice) => {
        const proximo = encontrados[indice + 1];
        const fimTrailing = proximo ? proximo.coluna : linha.length;

        acordes.push({
          valor: item.valor,
          indice,
          scopeId: `inline-chord-${indice}`,
          coluna: item.coluna,
          fim: item.fim,
          originalText: item.valor,
          originalTrailing: linha.slice(item.fim, fimTrailing)
        });
      });

      return {
        texto,
        acordes
      };
    },

    calcularFragmentosModelo(texto, limite) {
      const fragmentos = [];
      let inicio = 0;

      if (!texto.length) {
        return [{ inicio: 0, fim: 0, texto: "" }];
      }

      while (inicio < texto.length) {
        const fimMaximo = Math.min(inicio + limite, texto.length);
        let fim = fimMaximo;

        if (fimMaximo < texto.length) {
          const ultimoEspaco = texto.lastIndexOf(" ", fimMaximo);

          if (ultimoEspaco >= inicio) {
            fim = ultimoEspaco;
          }
        }

        if (fim <= inicio) {
          fim = fimMaximo;
        }

        const proximoInicioBruto = fim;
        let proximoInicio = proximoInicioBruto;

        while (proximoInicio < texto.length && texto[proximoInicio] === " ") {
          proximoInicio++;
        }

        fragmentos.push({
          inicio,
          fim,
          proximoInicio,
          texto: texto.slice(inicio, fim).replace(/\s+$/g, "")
        });

        inicio = proximoInicio;
      }

      return fragmentos;
    },

    localizarFragmentoDoAcorde(acorde, fragmentos) {
      if (!fragmentos.length) {
        return 0;
      }

      const coluna = acorde.coluna;

      // A propriedade do bloco é decidida SOMENTE pela âncora do próprio
      // acorde. O comprimento/nome do acorde e o próximo acorde não podem
      // mudar o bloco ao qual ele pertence.
      for (let i = 0; i < fragmentos.length; i++) {
        const atual = fragmentos[i];
        const proximo = fragmentos[i + 1];

        if (coluna >= atual.inicio && coluna < atual.fim) {
          const fimDoAcorde = coluna + acorde.valor.length;

          // O token é indivisível. Se ele encostar na fronteira física,
          // acompanha o fragmento seguinte por inteiro.
          if (proximo && fimDoAcorde >= atual.fim) {
            return i + 1;
          }

          return i;
        }

        // Espaços consumidos pela quebra pertencem ao próximo bloco visual.
        if (
          proximo &&
          coluna >= atual.fim &&
          coluna < proximo.inicio
        ) {
          return i + 1;
        }
      }

      return fragmentos.length - 1;
    },

    montarLinhaAcordesDoModelo(modelo, fragmentos, indiceFragmento) {
      const fragmento = fragmentos[indiceFragmento];
      const acordes = modelo.acordes.filter(
        acorde =>
          this.localizarFragmentoDoAcorde(acorde, fragmentos) ===
          indiceFragmento
      );

      if (!acordes.length) {
        return "";
      }

      // SEVEN SHOWS v115 — geometria equivalente ao DOM responsivo
      // observado no Cifra Club: a quebra pertence ao BLOCO e o primeiro
      // acorde do novo bloco nasce na fronteira visual anterior. A partir
      // dele, a distância para os acordes seguintes é o trailing ORIGINAL
      // do token anterior. Isso é essencial em casos como F# / B / B7: se
      // o primeiro acorde cruza a quebra e é trazido para x=0, todo o grupo
      // acompanha sem ser comprimido. Não existe regra por música/acorde.
      const origemVisual =
        indiceFragmento > 0
          ? fragmentos[indiceFragmento - 1].fim
          : fragmento.inicio;

      const primeiraColuna = Math.max(
        0,
        acordes[0].coluna - origemVisual
      );

      let linhaAcordes = " ".repeat(primeiraColuna);

      acordes.forEach((acorde, indice) => {
        linhaAcordes += acorde.originalText;

        if (indice < acordes.length - 1) {
          linhaAcordes += acorde.originalTrailing;
        }
      });

      return linhaAcordes.replace(/\s+$/g, "");
    },

    reflowParAcordeLetra(linhaAcordes, linhaLetra, limite) {
      const modelo = this.criarModeloLinhaCifra(
        linhaAcordes,
        linhaLetra
      );

      const fragmentos = this.calcularFragmentosModelo(
        modelo.texto,
        limite
      );

      const saida = [];

      fragmentos.forEach((fragmento, indice) => {
        const linhaAcordesFragmento =
          this.montarLinhaAcordesDoModelo(
            modelo,
            fragmentos,
            indice
          );

        if (linhaAcordesFragmento.trim()) {
          saida.push(linhaAcordesFragmento);
        }

        saida.push(fragmento.texto);
      });

      return saida;
    },

    reflowLinhaIsolada(linha, limite) {
      if (linha.length <= limite) {
        return [linha];
      }

      return this.calcularFaixasLetra(
        linha,
        limite
      ).map(([inicio, fim]) =>
        linha.slice(inicio, fim).replace(/\s+$/g, "")
      );
    },

    reflowCifraMobile(texto, limite) {
      const linhas =
        texto.split("\n");

      const saida = [];

      for (let i = 0; i < linhas.length; i++) {
        const atual = linhas[i];
        const proxima =
          i + 1 < linhas.length
            ? linhas[i + 1]
            : null;

        if (
          proxima !== null &&
          this.ehLinhaSomenteAcordes(atual) &&
          proxima.trim() !== "" &&
          !this.ehLinhaSomenteAcordes(proxima)
        ) {
          saida.push(
            ...this.reflowParAcordeLetra(
              atual,
              proxima,
              limite
            )
          );

          i++;
          continue;
        }

        saida.push(
          ...this.reflowLinhaIsolada(
            atual,
            limite
          )
        );
      }

      return saida.join("\n");
    },


    // ==============================================================
    // URL BASE DA API
    // ==============================================================

    obterBaseUrl() {
      let baseUrl =
        process.env.VUE_APP_API_BASE_URL ||
        "http://localhost:5297";

      if (baseUrl.endsWith("/")) {
        baseUrl =
          baseUrl.slice(
            0,
            -1
          );
      }

      return baseUrl;
    },


    // ==============================================================
    // CONFIGURAÇÃO DE AUTENTICAÇÃO
    // ==============================================================

    obterConfigAxios() {
      const token =
        localStorage.getItem("jwt");

      if (!token) {
        return null;
      }

      return {
        headers: {
          Authorization:
            "Bearer " + token,

          "Content-Type":
            "application/json"
        }
      };
    },


    // ==============================================================
    // APLICA RESULTADO DA CIFRA
    // ==============================================================

    aplicarResultadoCifra(dados) {
      this.cifraResultado = dados;

      // Só é definido quando uma NOVA música chega do .NET/Cifra Club.
      this.cifraOriginalHtml =
        String(dados?.htmlEstruturado || "");

      this.tomOriginalReal =
        String(dados?.tomOriginal || "");

      this.cifraAtualHtml =
        this.cifraOriginalHtml;

      // Nova música: elimina o render mobile anterior e reconstrói
      // a matriz a partir do novo htmlEstruturado recebido.
      this.cifraMobileRender = "";

      this.cifraMobileOriginal =
        this.formatarCifraMobile(
          this.cifraOriginalHtml
        );

      this.cifraMobileRender =
        this.cifraMobileOriginal;

      

      

      this.$nextTick(() => {
        this.atualizarLarguraCifraMobile();
});

      if (this.tomOriginalReal) {
        this.form.tomDesejado =
          this.tomOriginalReal;
        this.podeTranspor = true;
      } else {
        this.form.tomDesejado = "";
        this.podeTranspor = false;
      }
    },


    // ==============================================================
    // BUSCA NORMAL
    //
    // Vue
    // ↓
    // generate-cifra
    // ↓
    // Tavily
    // ↓
    // Cifra Club
    // ==============================================================

    async gerarCifraMusicaReal() {
      if (
        !this.form.nomeMusica ||
        this.form.nomeMusica.trim() === ""
      ) {
        alert(
          "⚠️ Por favor, digite o nome da música para realizar a busca."
        );

        return;
      }

      const config =
        this.obterConfigAxios();

      if (!config) {
        alert(
          "⚠️ Token de autenticação não localizado. Por favor, faça login novamente."
        );

        return;
      }

      this.loadingCifra =
        true;

      this.carregandoRelacionada =
        false;

      this.cifraResultado =
        null;

      this.podeTranspor =
        false;

      try {
        const baseUrl =
          this.obterBaseUrl();

        const urlFinal =
          baseUrl +
          "/artists/ia/generate-cifra";

        const payload = {
          nomeMusica:
            this.form.nomeMusica,

          nomeArtista:
            this.form.nomeArtista
        };

        const response =
          await axios.post(
            urlFinal,
            payload,
            config
          );

        

        // Resposta exatamente como chegou do .NET, antes de qualquer tratamento no Vue.
        

        

        this.aplicarResultadoCifra(
          response.data
        );

      } catch (error) {
        console.error(
          "🚨 [CIFRAS] Erro na busca:",
          error
        );

        const statusErro =
          error.response
            ? error.response.status
            : "LOCAL_REDE";

        if (
          error.response &&
          error.response.data &&
          error.response.data.mensagem
        ) {
          alert(
            "❌ Erro da IA: " +
            error.response.data.mensagem
          );

        } else if (
          statusErro === 401
        ) {
          alert(
            "❌ Falha de autenticação (Erro 401). O seu token 'jwt' pode ter expirado no servidor."
          );

        } else {
          alert(
            "❌ Falha técnica de rede (Status HTTP: " +
            statusErro +
            "). Verifique o console ou a aba Network."
          );
        }

      } finally {
        this.loadingCifra =
          false;
      }
    },


    // ==============================================================
    // MÚSICA RELACIONADA
    //
    // NÃO USA TAVILY
    //
    // item.url
    // ↓
    // generate-cifra-related
    // ↓
    // Cifra Club diretamente
    // ==============================================================

    async carregarMusicaRelacionada(item) {
      if (this.loadingCifra) {
        return;
      }

      if (
        !item ||
        !item.url
      ) {
        console.error(
          "🚨 Música relacionada sem URL:",
          item
        );

        alert(
          "❌ Esta música relacionada não possui uma URL válida."
        );

        return;
      }

      const config =
        this.obterConfigAxios();

      if (!config) {
        alert(
          "⚠️ Token de autenticação não localizado. Faça login novamente."
        );

        return;
      }

      this.loadingCifra =
        true;

      this.carregandoRelacionada =
        true;

      this.podeTranspor =
        false;

      try {
        const baseUrl =
          this.obterBaseUrl();

        const urlFinal =
          baseUrl +
          "/artists/ia/generate-cifra-related";

        const payload = {
          url:
            item.url
        };

        const response =
          await axios.post(
            urlFinal,
            payload,
            config
          );

        // Resposta exatamente como chegou do .NET, antes de qualquer tratamento no Vue.
        

        

        this.form.nomeMusica =
          response.data.musica ||
          item.titulo ||
          "";

        this.form.nomeArtista =
          response.data.artista ||
          item.artista ||
          "";

        this.aplicarResultadoCifra(
          response.data
        );

      } catch (error) {
        console.error(
          "🚨 [RELACIONADA] Falha ao carregar:",
          error
        );

        const statusErro =
          error.response
            ? error.response.status
            : "LOCAL_REDE";

        const mensagem =
          error.response?.data?.mensagem ||
          error.response?.data?.erro;

        if (mensagem) {
          alert(
            "❌ " + mensagem
          );

        } else if (
          statusErro === 401
        ) {
          alert(
            "❌ Falha de autenticação (Erro 401). Faça login novamente."
          );

        } else {
          alert(
            "❌ Não foi possível carregar a música relacionada. Status HTTP: " +
            statusErro
          );
        }

      } finally {
        this.loadingCifra =
          false;

        this.carregandoRelacionada =
          false;
      }
    },


    // ==============================================================
    // EXPORTAR CIFRA PARA PDF
    // ==============================================================

    exportarCifraPdf() {
      if (
        !this.cifraResultado ||
        !this.cifraResultado.cifraCompleta
      ) {
        alert("⚠️ Nenhuma cifra disponível para exportar.");
        return;
      }

      const escaparHtml = (valor) =>
        String(valor ?? "")
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#039;");

      const musica = escaparHtml(
        this.cifraResultado.musica || "Cifra"
      );

      const artista = escaparHtml(
        this.cifraResultado.artista || ""
      );

      const tom = escaparHtml(
        this.cifraResultado.tomOriginal ||
        this.form.tomDesejado ||
        "-"
      );

      // IMPORTANTE:
      // Não compactar, trimar ou reconstruir a cifra.
      // Os espaços fazem parte da posição horizontal dos acordes.
      const cifra = escaparHtml(
        this.cifraResultado.cifraCompleta
      );

      const janela = window.open(
        "",
        "_blank",
        "width=1000,height=800"
      );

      if (!janela) {
        alert(
          "⚠️ O navegador bloqueou a janela de exportação. Permita pop-ups para o Seven Shows e tente novamente."
        );
        return;
      }

      janela.document.open();
      janela.document.write(`<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <title>${musica} - Cifra</title>
  <style>
    @page {
      size: A4 portrait;
      margin: 16mm 15mm 17mm;
    }

    * {
      box-sizing: border-box;
    }

    html,
    body {
      margin: 0;
      padding: 0;
      background: #ffffff;
      color: #111111;
    }

    body {
      font-family: Arial, Helvetica, sans-serif;
      padding: 24px;
    }

    .acoes {
      position: sticky;
      top: 0;
      z-index: 10;
      display: flex;
      justify-content: flex-end;
      margin: -8px -8px 18px;
      padding: 8px;
      background: rgba(255, 255, 255, 0.96);
      border-bottom: 1px solid #e3e7ea;
    }

    .btn-imprimir {
      border: 0;
      border-radius: 7px;
      padding: 9px 14px;
      background: #198754;
      color: #ffffff;
      font: 700 13px Arial, Helvetica, sans-serif;
      cursor: pointer;
    }

    .pagina {
      width: min(100%, 210mm);
      margin: 0 auto;
      padding: 16mm 15mm 17mm;
      background: #ffffff;
      box-shadow: 0 2px 18px rgba(0, 0, 0, 0.12);
    }

    .cabecalho {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 20px;
      padding-bottom: 10px;
      margin-bottom: 16px;
      border-bottom: 1px solid #cfd4d8;
    }

    .titulo {
      margin: 0 0 5px;
      font-size: 18px;
      font-weight: 800;
      text-transform: uppercase;
    }

    .artista {
      font-size: 10px;
      color: #444444;
    }

    .tom {
      flex: 0 0 auto;
      padding: 6px 10px;
      border: 1px solid #333333;
      border-radius: 4px;
      font: 700 10px "Courier New", Courier, monospace;
      white-space: nowrap;
    }

    .cifra {
      margin: 0;
      padding: 0;
      border: 0;
      background: transparent;
      color: #000000;
      font-family: "Courier New", Courier, monospace;
      font-size: 9pt;
      font-weight: 400;
      line-height: 1.05;
      white-space: pre;
      tab-size: 4;
      overflow: visible;
    }

    @media print {
      body {
        padding: 0;
      }

      .acoes {
        display: none !important;
      }

      .pagina {
        width: auto;
        margin: 0;
        padding: 0;
        box-shadow: none;
      }

      .cifra {
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }
    }
  </style>
</head>
<body>
  <div class="acoes">
    <button class="btn-imprimir" type="button" onclick="window.print()">Imprimir / Salvar PDF</button>
  </div>

  <main class="pagina">
    <header class="cabecalho">
      <div>
        <h1 class="titulo">${musica}</h1>
        <div class="artista">Cantor: <strong>${artista}</strong></div>
      </div>
      <div class="tom">TOM: ${tom}</div>
    </header>

    <pre class="cifra">${cifra}</pre>
  </main>
</body>
</html>`);
      janela.document.close();
    },


    // ==============================================================
    // TRANSPOSIÇÃO LOCAL
    // ==============================================================

    extrairAcordesOriginaisParaTransposicao() {
      const container = document.createElement("div");
      container.innerHTML = String(this.cifraOriginalHtml || "");

      return Array.from(
        container.querySelectorAll("b[data-chord-name]")
      ).map(el =>
        String(
          el.getAttribute("data-chord-name") ||
          el.textContent ||
          ""
        ).trim()
      );
    },

    substituirAcordesNaCifraMobileOriginal(
      acordesOriginais,
      acordesTranspostos
    ) {
      let resultado = String(
        this.cifraMobileOriginal || ""
      );

      if (
        !resultado ||
        acordesOriginais.length !== acordesTranspostos.length
      ) {
        throw new Error(
          "Não foi possível aplicar a transposição sobre a cifra mobile original."
        );
      }

      // Substitui por ocorrência em ordem, preservando a coluna inicial.
      // Quando cresce, consome somente whitespace posterior.
      // Quando diminui, completa o slot com whitespace posterior.
      let cursor = 0;

      acordesOriginais.forEach((original, index) => {
        const novo = String(
          acordesTranspostos[index] || original
        ).trim();

        const escaped = String(original)
          .replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

        const regex = new RegExp(
          `(^|[\\s])(${escaped})(?=\\s|$)`,
          "gm"
        );

        regex.lastIndex = cursor;
        const match = regex.exec(resultado);

        if (!match) {
          throw new Error(
            `Acorde original não localizado na matriz mobile: ${original} (#${index}).`
          );
        }

        const inicio =
          match.index + match[1].length;
        const fim =
          inicio + original.length;
        const diferenca =
          novo.length - original.length;

        let antes = resultado.slice(0, inicio);
        let depois = resultado.slice(fim);

        if (diferenca < 0) {
          // Menor: devolve ao slot as colunas liberadas.
          depois =
            " ".repeat(Math.abs(diferenca)) +
            depois;
        } else if (diferenca > 0) {
          // Maior: consome apenas espaços imediatamente posteriores,
          // sem atravessar quebra de linha ou o próximo conteúdo.
          let remover = diferenca;
          let consumidos = 0;

          while (
            consumidos < depois.length &&
            remover > 0 &&
            depois[consumidos] === " "
          ) {
            consumidos += 1;
            remover -= 1;
          }

          depois = depois.slice(consumidos);
        }

        resultado =
          antes +
          novo +
          depois;

        cursor =
          inicio +
          novo.length +
          Math.max(0, -diferenca);
      });

      return resultado;
    },

    aplicarAcordesTranspostosNoHtmlOriginal(acordesTranspostos) {
      const container = document.createElement("div");
      container.innerHTML = String(this.cifraOriginalHtml || "");

      const elementos = Array.from(
        container.querySelectorAll("b[data-chord-name]")
      );

      if (elementos.length !== acordesTranspostos.length) {
        throw new Error(
          `Quantidade de acordes divergente: original=${elementos.length}, transposto=${acordesTranspostos.length}.`
        );
      }

      elementos.forEach((el, index) => {
        const acordeOriginal = String(
          el.getAttribute("data-chord-name") ||
          el.getAttribute("data-chord-original-text") ||
          el.textContent ||
          ""
        ).trim();

        const acordeNovo = String(
          acordesTranspostos[index] || acordeOriginal
        ).trim();

        const diferenca = acordeNovo.length - acordeOriginal.length;

        // data-chord-name guarda somente o acorde musical real.
        el.setAttribute("data-chord-name", acordeNovo);

        if (diferenca < 0) {
          // Acorde menor: completa a largura perdida DENTRO do <b>.
          // F# -> G  resulta em <b>G </b>
          // G#m -> C resulta em <b>C  </b>
          el.textContent =
            acordeNovo + "X".repeat(Math.abs(diferenca));
          return;
        }

        el.textContent = acordeNovo;

        if (diferenca === 0) {
          return;
        }

        // Acorde maior: consome a diferença do whitespace imediatamente
        // posterior ao </b>. Ex.: B -> C#m (+2): 9 espaços viram 7.
        let restante = diferenca;
        let node = el.nextSibling;

        while (node && restante > 0 && node.nodeType === Node.TEXT_NODE) {
          const texto = node.nodeValue || "";
          const match = texto.match(/^[ \t]+/);

          if (!match) {
            break;
          }

          const remover = Math.min(restante, match[0].length);
          node.nodeValue = texto.slice(remover);
          restante -= remover;
          node = node.nextSibling;
        }

        // Se não houver whitespace suficiente, o excedente é crescimento
        // real; o reflow mobile decide a quebra sem inventar espaço negativo.
      });

      return container.innerHTML;
    },

    async transporCifraTomIa(tomAlvo) {
      if (!this.cifraOriginalHtml || !this.tomOriginalReal) {
        alert(
          "❌ A cifra original ou o tom original não estão disponíveis."
        );
        return;
      }

      if (this.form.tomDesejado === tomAlvo) {
        return;
      }

      this.loadingCifra = true;

      const tomAnteriorVisual =
        this.form.tomDesejado;

      try {
        const baseUrl =
          this.obterBaseUrl();

        const urlFinal =
          baseUrl +
          "/artists/ia/transpose-cifra";

        // O HTML fica no Vue. O backend recebe somente os acordes.
        const acordesOriginais =
          this.extrairAcordesOriginaisParaTransposicao();

        const payload = {
          acordes: acordesOriginais,
          tomOriginal:
            this.tomOriginalReal,
          tomDesejado:
            tomAlvo
        };

        const config =
          this.obterConfigAxios();

        if (!config) {
          alert(
            "⚠️ Token de autenticação não localizado. Faça login novamente."
          );
          return;
        }

        //console.log("[ENVIADO]", payload);

        const response =
          await axios.post(
            urlFinal,
            payload,
            config
          );

        //console.log("[RECEBIDO]", response.data);

        

        

        const acordesTranspostos =
          Array.isArray(response.data?.acordes)
            ? response.data.acordes
            : [];

        if (!acordesTranspostos.length) {
          throw new Error(
            "O backend não retornou o array de acordes transpostos."
          );
        }

        // Sempre reconstrói a partir de uma cópia NOVA do HTML original.
        // A transposição agora é aplicada diretamente sobre a
        // matriz mobile ORIGINAL já formatada.
        const cifraMobileTransposta =
          this.substituirAcordesNaCifraMobileOriginal(
            acordesOriginais,
            acordesTranspostos
          );

        // Não passa novamente pelo formatarCifraMobile().
        this.cifraMobileRender =
          cifraMobileTransposta;

        // A transposição foi concluída: sincroniza o tom corrente
        // exibido na badge e o estado ativo do seletor.
        this.form.tomDesejado =
          tomAlvo;

      } catch (error) {
        console.error(
          "🚨 [TRANSPOSIÇÃO] Falha:",
          error
        );

        const mensagem =
          error.response?.data?.mensagem ||
          error.response?.data?.erro ||
          error.message ||
          "Não foi possível transpor a música.";

        alert("❌ " + mensagem);

        this.form.tomDesejado =
          tomAnteriorVisual;

      } finally {
        this.loadingCifra = false;
      }
    },
    normalizarTomParaBotao(tom) {
      if (!tom) {
        return "";
      }

      const equivalencias = {
        "Db": "C#",
        "Eb": "D#",
        "Gb": "F#",
        "Ab": "G#",
        "Bb": "A#",

        "C#": "C#",
        "D#": "D#",
        "F#": "F#",
        "G#": "G#",
        "A#": "A#",

        "C": "C",
        "D": "D",
        "E": "E",
        "F": "F",
        "G": "G",
        "A": "A",
        "B": "B"
      };

      return equivalencias[tom] || tom;
    },
  }
};
</script>

<style scoped>
/* ================================================================ */
/* CARD PRINCIPAL */
/* ================================================================ */

.cifra-main-card {
  border-radius: 16px !important;
  overflow: hidden;

  background:
    linear-gradient(180deg,
      #ffffff 0%,
      #fbfcfd 100%) !important;

  border: 1px solid #e6eaee !important;

  box-shadow:
    0 10px 35px rgba(31, 41, 55, 0.07) !important;
}


/* ================================================================ */
/* CABEÇALHO */
/* ================================================================ */

.cifra-header {
  padding: 25px 28px 21px;

  display: flex;
  justify-content: space-between;
  align-items: center;

  gap: 20px;

  background:
    linear-gradient(90deg,
      #ffffff 0%,
      #fff8f4 52%,
      #f2fbfc 100%);

  border-bottom: 1px solid #edf0f2;
}


.cifra-header h5 {
  font-size: 17px !important;

  color: #182230 !important;

  letter-spacing: 0.7px !important;
}


.cifra-header p {
  margin-top: 5px;

  color: #667085 !important;

  font-size: 13px !important;

  line-height: 1.5;
}


.header-guitar {
  display: inline-flex;

  align-items: center;
  justify-content: center;

  width: 31px;
  height: 31px;

  margin-right: 5px;

  background: #fff0e8;

  border-radius: 8px;

  color: #ff6c22;

  font-size: 18px;
}


.live-badge {
  flex-shrink: 0;

  padding: 7px 15px !important;

  background: #ecfbfc !important;

  border-color: #00a6b2 !important;

  color: #008b95 !important;

  font-size: 11px !important;

  font-weight: 700;

  box-shadow:
    0 2px 7px rgba(0, 166, 178, 0.08);
}


/* ================================================================ */
/* PAINEL DE CONTROLE */
/* ================================================================ */

.control-panel {
  margin: 20px 28px 0;

  padding: 21px;

  background:
    linear-gradient(135deg,
      #f7fafb 0%,
      #f1f8f9 100%);

  border: 1px solid #dfe8eb;

  border-radius: 12px;

  box-shadow:
    0 3px 12px rgba(31, 41, 55, 0.035);
}


.control-label {
  display: block;

  margin-bottom: 8px;

  color: #344054;

  font-family: monospace;

  font-size: 12px;

  font-weight: 800;

  text-transform: uppercase;

  letter-spacing: 0.4px;
}


.control-label::first-letter {
  color: #ff6c22;
}


.control-input {
  height: 46px;

  padding-left: 14px;
  padding-right: 14px;

  background: #ffffff !important;

  border: 1px solid #dbe4e7 !important;

  color: #182230 !important;

  font-family: monospace;

  font-size: 13px;

  font-weight: 500;

  border-radius: 8px !important;

  transition:
    border-color 0.15s ease,
    box-shadow 0.15s ease;
}


.control-input::placeholder {
  color: #98a2b3;

  opacity: 1;
}


.control-input:hover {
  border-color: #c8d6da !important;
}


.control-input:focus {
  border-color: #ff8a50 !important;

  box-shadow:
    0 0 0 3px rgba(255, 108, 34, 0.10) !important;
}


/* ================================================================ */
/* BOTÃO BUSCAR */
/* ================================================================ */

.search-button {
  height: 46px;

  background:
    linear-gradient(135deg,
      #ff742f,
      #ff5f14) !important;

  border-color: #ff6c22 !important;

  color: white !important;

  border-radius: 8px !important;

  font-family: monospace;

  font-size: 13px;

  font-weight: 800;

  text-transform: uppercase;

  letter-spacing: 0.2px;

  box-shadow:
    0 6px 15px rgba(255, 108, 34, 0.20);

  transition:
    transform 0.15s ease,
    box-shadow 0.15s ease,
    filter 0.15s ease;
}


.search-button:hover:not(:disabled) {
  filter: brightness(1.03);

  transform: translateY(-1px);

  box-shadow:
    0 8px 18px rgba(255, 108, 34, 0.27);
}


.search-button:active:not(:disabled) {
  transform: translateY(0);
}


/* ================================================================ */
/* TRANSPOSITOR */
/* ================================================================ */

.transpose-panel {
  margin-top: 19px;

  padding: 17px 17px 16px;

  background: #ffffff;

  border: 1px solid #e3eaed;

  border-radius: 9px;
}


.transpose-info {
  display: flex;

  justify-content: space-between;

  align-items: flex-end;

  gap: 15px;

  margin-bottom: 13px;
}


.transpose-description {
  color: #7c8798;

  font-family: monospace;

  font-size: 11px;

  line-height: 1.4;
}


.current-tone-info {
  display: flex;

  align-items: center;

  gap: 8px;

  font-family: monospace;
}


.current-tone-label {
  color: #7c8798;

  font-size: 10px;

  font-weight: 700;
}


.current-tone-value {
  min-width: 38px;

  padding: 6px 10px;

  background: #eefafa;

  border: 1px solid #00a6b2;

  color: #008d97;

  text-align: center;

  font-size: 12px;

  font-weight: 800;

  border-radius: 6px;
}


/* ================================================================ */
/* 12 TONS */
/* ================================================================ */

.tone-grid {
  display: grid;

  grid-template-columns:
    repeat(12, minmax(44px, 1fr));

  gap: 7px;
}


.tone-button {
  height: 39px;

  padding: 0 7px;

  border: 1px solid #dce5e8;

  background: #f9fbfc;

  color: #475467;

  border-radius: 7px;

  font-family: monospace;

  font-size: 12px;

  font-weight: 700;

  box-shadow:
    0 1px 3px rgba(16, 24, 40, 0.035);

  transition:
    background-color 0.15s ease,
    border-color 0.15s ease,
    color 0.15s ease,
    transform 0.15s ease,
    box-shadow 0.15s ease;
}


.tone-button:hover:not(:disabled) {
  background: #eefafa;

  border-color: #00a6b2;

  color: #008b95;

  transform: translateY(-2px);

  box-shadow:
    0 4px 8px rgba(0, 166, 178, 0.12);
}


.tone-button-active {
  background:
    linear-gradient(135deg,
      #00aab6,
      #00959f) !important;

  border-color: #009ca7 !important;

  color: #ffffff !important;

  box-shadow:
    0 4px 10px rgba(0, 166, 178, 0.25) !important;

  transform: translateY(-1px);
}


.tone-button:disabled {
  cursor: default;

  opacity: 0.50;
}


/* ================================================================ */
/* MÚSICAS RELACIONADAS */
/* ================================================================ */

.related-section {
  margin: 18px 28px 0;

  padding: 17px 18px 15px;

  border: 1px solid #e1e7ea;

  border-radius: 11px;

  background:
    linear-gradient(135deg,
      #fffaf7 0%,
      #ffffff 42%,
      #f5fbfc 100%);

  box-shadow:
    0 3px 11px rgba(31, 41, 55, 0.035);
}


.related-header {
  display: flex;

  justify-content: space-between;

  align-items: center;

  gap: 15px;

  margin-bottom: 13px;
}


.related-title {
  color: #263445;

  font-family: monospace;

  font-size: 13px;

  font-weight: 800;

  text-transform: uppercase;

  letter-spacing: 0.3px;
}


.related-title i {
  color: #ff6c22;

  font-size: 16px;
}


.related-subtitle {
  margin-top: 4px;

  color: #7c8798;

  font-family: monospace;

  font-size: 10px;
}


.related-count {
  padding: 5px 9px;

  background: #f2f5f6;

  border-radius: 20px;

  color: #667085;

  font-family: monospace;

  font-size: 10px;

  font-weight: 600;

  white-space: nowrap;
}


/* ================================================================ */
/* SCROLL HORIZONTAL DAS RELACIONADAS */
/* ================================================================ */

.related-scroll {
  display: flex;

  gap: 10px;

  overflow-x: auto;

  overflow-y: hidden;

  padding: 2px 1px 8px;

  scroll-behavior: smooth;

  scrollbar-width: thin;

  scrollbar-color:
    #aebbc0 #edf2f3;
}


.related-scroll::-webkit-scrollbar {
  height: 7px;
}


.related-scroll::-webkit-scrollbar-track {
  background: #edf2f3;

  border-radius: 10px;
}


.related-scroll::-webkit-scrollbar-thumb {
  background: #aebbc0;

  border-radius: 10px;
}


.related-scroll::-webkit-scrollbar-thumb:hover {
  background: #8d9da3;
}


.related-song-card {
  flex: 0 0 250px;

  min-width: 250px;

  padding: 12px 13px;

  border: 1px solid #dfe7ea;

  background: #ffffff;

  border-radius: 8px;

  text-align: left;

  cursor: pointer;

  box-shadow:
    0 2px 5px rgba(16, 24, 40, 0.035);

  transition:
    background-color 0.15s ease,
    border-color 0.15s ease,
    transform 0.15s ease,
    box-shadow 0.15s ease;
}


.related-song-card:nth-child(3n + 1) {
  border-top: 3px solid #ff7a38;
}


.related-song-card:nth-child(3n + 2) {
  border-top: 3px solid #00a6b2;
}


.related-song-card:nth-child(3n + 3) {
  border-top: 3px solid #55a06b;
}


.related-song-card:hover:not(:disabled) {
  background: #fffdfc;

  border-color: #ff9b69;

  transform: translateY(-2px);

  box-shadow:
    0 6px 14px rgba(31, 41, 55, 0.09);
}


.related-song-content {
  display: flex;

  justify-content: space-between;

  align-items: center;

  gap: 10px;
}


.related-song-text {
  min-width: 0;

  flex: 1;
}


.related-song-name {
  overflow: hidden;

  color: #1d2939;

  font-family: monospace;

  font-size: 12px;

  font-weight: 800;

  white-space: nowrap;

  text-overflow: ellipsis;
}


.related-song-artist {
  margin-top: 5px;

  overflow: hidden;

  color: #7c8798;

  font-family: monospace;

  font-size: 10px;

  font-weight: 500;

  white-space: nowrap;

  text-overflow: ellipsis;
}


.related-song-arrow {
  flex-shrink: 0;

  width: 27px;
  height: 27px;

  display: flex;

  align-items: center;
  justify-content: center;

  background: #f1f5f6;

  border-radius: 50%;

  color: #829097;

  font-size: 18px;

  transition:
    background-color 0.15s ease,
    color 0.15s ease;
}


.related-song-card:hover .related-song-arrow {
  background: #fff0e8;

  color: #ff6c22;
}


.related-song-disabled {
  opacity: 0.55;

  pointer-events: none;
}


/* ================================================================ */
/* ÁREA DA CIFRA */
/* ================================================================ */

.cifra-area {
  margin: 18px 28px 28px;

  min-height: 440px;

  padding: 13px;

  border: 1px solid #dce6e9;

  border-radius: 12px;

  background:
    linear-gradient(145deg,
      #eaf4f6 0%,
      #f3f8f9 100%);

  overflow: hidden;

  box-shadow:
    inset 0 1px 3px rgba(31, 41, 55, 0.025);
}


/* ================================================================ */
/* ESTADO VAZIO / CARREGAMENTO */
/* ================================================================ */

.empty-state,
.loading-state {
  min-height: 420px;

  display: flex;

  flex-direction: column;

  justify-content: center;

  align-items: center;

  padding: 35px;

  text-align: center;
}


.empty-icon {
  width: 65px;
  height: 65px;

  display: flex;

  align-items: center;
  justify-content: center;

  margin-bottom: 14px;

  background: #ffffff;

  border: 1px solid #e1e8ea;

  border-radius: 50%;

  color: #ff6c22;

  font-size: 31px;

  box-shadow:
    0 5px 15px rgba(31, 41, 55, 0.06);
}


.empty-title,
.loading-title {
  margin-bottom: 7px;

  color: #263445;

  font-family: monospace;

  font-size: 14px;

  font-weight: 800;

  text-transform: uppercase;
}


.empty-description,
.loading-description {
  color: #7c8798;

  font-family: monospace;

  font-size: 11px;
}


/* ================================================================ */
/* DOCUMENTO DA CIFRA */
/* ================================================================ */

.cifra-document {
  margin: 0;

  background: #ffffff;

  border: 1px solid #dfe6e9;

  border-radius: 9px;

  box-shadow:
    0 4px 13px rgba(16, 24, 40, 0.055);

  overflow: hidden;
}


/* ================================================================ */
/* CABEÇALHO DA MÚSICA */
/* ================================================================ */

.song-header {
  display: flex;

  justify-content: space-between;

  align-items: center;

  gap: 20px;

  padding: 17px 20px;

  background:
    linear-gradient(90deg,
      #ffffff 0%,
      #ffffff 70%,
      #f4fbf8 100%);

  border-bottom: 1px solid #e1e7e9;
}


.song-identification {
  min-width: 0;
}


.song-title {
  margin: 0 0 6px;

  overflow: hidden;

  color: #111827;

  font-family: monospace;

  font-size: 18px;

  font-weight: 900;

  text-transform: uppercase;

  letter-spacing: 0.5px;

  white-space: nowrap;

  text-overflow: ellipsis;
}


.song-title::first-letter {
  color: #ff6c22;
}


.song-artist {
  color: #667085;

  font-family: monospace;

  font-size: 11px;
}


.song-artist i {
  color: #00a6b2;

  font-size: 13px;
}


.song-artist strong {
  margin-left: 4px;

  color: #263445;

  font-weight: 800;
}


.song-header-actions {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 9px;
}

.export-pdf-button {
  height: 38px;
  padding: 0 14px;
  border: 1px solid #dc3545;
  border-radius: 7px;
  background: #ffffff;
  color: #c82333;
  font-family: monospace;
  font-size: 11px;
  font-weight: 800;
  text-transform: uppercase;
  cursor: pointer;
  transition: background 0.15s ease, color 0.15s ease, box-shadow 0.15s ease;
}

.export-pdf-button:hover {
  background: #dc3545;
  color: #ffffff;
  box-shadow: 0 4px 10px rgba(220, 53, 69, 0.18);
}

.song-tone-badge {
  flex-shrink: 0;

  padding: 10px 16px;

  background:
    linear-gradient(135deg,
      #1b925c,
      #137c4d);

  color: #ffffff;

  border-radius: 7px;

  font-family: monospace;

  font-size: 12px;

  font-weight: 800;

  text-transform: uppercase;

  box-shadow:
    0 4px 10px rgba(25, 135, 84, 0.20);
}


/* ================================================================ */
/* CIFRA */
/* ================================================================ */

.cifra-scroll {
  max-height: 650px;

  overflow: auto;

  background:
    linear-gradient(180deg,
      #f1f8f9 0%,
      #edf6f7 100%);

  scrollbar-width: thin;

  scrollbar-color:
    #8f9fa4 #dfeaec;
}


.cifra-scroll::-webkit-scrollbar {
  width: 9px;
  height: 9px;
}


.cifra-scroll::-webkit-scrollbar-track {
  background: #dfeaec;
}


.cifra-scroll::-webkit-scrollbar-thumb {
  background: #8f9fa4;

  border-radius: 10px;

  border: 2px solid #dfeaec;
}


.cifra-pre {
  min-width: max-content;

  margin: 0;

  padding: 27px 29px 38px;

  border: 0;

  background: transparent;

  color: #111827;

  font-family: monospace;

  /*
   * AUMENTAMOS SOMENTE O TAMANHO DA FONTE.
   *
   * NÃO ALTERAR white-space / line-height.
   * Eles preservam o alinhamento dos acordes.
   */
  font-size: 14px;

  font-weight: 500;

  white-space: pre;

  line-height: 1.0;

  letter-spacing: 0.5px;

  overflow: visible;
}

.cifra-pre-mobile {
  display: none;
}


/* ================================================================ */
/* TABLET */
/* ================================================================ */

@media (max-width: 991.98px) {

  .cifra-header {
    padding:
      20px;
  }


  .control-panel,
  .related-section,
  .cifra-area {
    margin-left:
      20px;

    margin-right:
      20px;
  }


  .tone-grid {
    grid-template-columns:
      repeat(6, 1fr);
  }


  .related-song-card {
    flex-basis:
      225px;

    min-width:
      225px;
  }


  .cifra-pre {
    font-size:
      13.5px;
  }

}


/* ================================================================ */
/* CELULAR */
/* ================================================================ */

@media (max-width: 575.98px) {

  .cifra-header {
    flex-direction:
      column;

    align-items:
      flex-start;

    gap:
      12px;

    padding:
      17px;
  }


  .cifra-header h5 {
    font-size:
      15px !important;
  }


  .cifra-header p {
    font-size:
      11px !important;
  }


  .live-badge {
    align-self:
      flex-start;
  }


  .control-panel,
  .related-section,
  .cifra-area {
    margin-left:
      12px;

    margin-right:
      12px;
  }


  .control-panel {
    padding:
      15px;
  }


  .transpose-info {
    align-items:
      flex-start;

    flex-direction:
      column;
  }


  .tone-grid {
    grid-template-columns:
      repeat(4, 1fr);
  }


  .tone-button {
    height:
      39px;

    font-size:
      12px;
  }


  .related-header {
    align-items:
      flex-start;
  }


  .related-count {
    display:
      none;
  }


  .related-song-card {
    flex-basis:
      205px;

    min-width:
      205px;
  }


  .song-header {
    align-items:
      flex-start;

    flex-direction:
      column;
  }


  .song-title {
    font-size:
      16px;

    white-space:
      normal;
  }


  .song-header-actions {
    width: 100%;
    align-items: stretch;
    flex-wrap: wrap;
  }

  .export-pdf-button {
    height: 39px;
  }

  .song-tone-badge {
    align-self:
      flex-start;
  }


  /*
   * SEVEN SHOWS v106 — blocos atômicos acorde/letra + âncora individual.
   *
   * A cifra é uma área de leitura musical: no celular ela deve aproveitar
   * toda a largura disponível do card. Removemos somente os recuos externos
   * específicos de .cifra-area; os demais blocos da página mantêm o padrão
   * visual já aprovado. O renderer continua medindo a largura real do
   * .cifra-scroll, portanto o reflow acompanha automaticamente 360/390/400px
   * (e demais larguras), sem qualquer constante específica de música.
   */
  .cifra-area {
    margin-left: 0;
    margin-right: 0;

    padding:
      7px;
  }


  /*
   * SEVEN SHOWS v91 — reflow mobile por colunas.
   *
   * Desktop continua intocado: usa cifraCompleta com white-space: pre.
   * No celular, o renderer mede a largura útil real e refaz somente as
   * quebras necessárias. Linhas de acordes e letra são quebradas nas mesmas
   * colunas para preservar a relação horizontal entre ambos.
   */
  .cifra-scroll {
    overflow-x: hidden;
  }

  .cifra-pre-desktop {
    display: none;
  }

  .cifra-pre-mobile {
    display: block;
    min-width: 0;
    width: 100%;
    max-width: 100%;

    /* v121 — aproveita a largura real do aparelho físico.
     * O recuo anterior de 18px por lado retirava 36px justamente da área
     * usada pelo cálculo de colunas e antecipava quebras em 360/375px. */
    padding:
      20px 8px 30px;

    /*
     * SEVEN SHOWS v97 — escala tipográfica mobile.
     * A própria medição DOM do renderer usa esta fonte renderizada
     * para recalcular quantas colunas realmente cabem na largura útil.
     */
    /*
     * SEVEN SHOWS v119 — tipografia realmente responsiva no aparelho.
     *
     * Em 390px preservamos os 15px já aprovados. Em viewports menores,
     * reduzimos progressivamente a fonte até 13px. Como o cálculo de
     * mobileCifraColumns mede a fonte REAL renderizada, o renderer passa
     * automaticamente a comportar mais colunas no celular físico e deixa
     * de quebrar frases que ainda cabem visualmente, sem alterar parser,
     * índices, acordes ou o backend.
     */
    /* v121 — escala pelo viewport físico, mantendo 15px em 390px e
     * permitindo 12px nos aparelhos estreitos. O cálculo JS continua
     * medindo a fonte efetivamente renderizada; não há hardcode de música. */
    font-size:
      clamp(12px, calc(10vw - 24px), 15px);

    /*
     * SEVEN SHOWS v117 — ajuste exclusivamente vertical.
     * Mantém integralmente a geometria horizontal aprovada da v115 e
     * aproxima acordes/letra sem criar os vazios excessivos da v116.
     */
    line-height:
      1.12;

    /*
     * O texto já chega refluído pelo renderer Seven Shows.
     * O navegador NÃO pode decidir novas quebras, pois isso
     * separaria novamente a letra da linha de acordes.
     */
    white-space: pre;
    overflow: visible;
  }

  /*
   * SEVEN SHOWS v118 — acordes mobile.
   * v-html não recebe o atributo scoped do componente; por isso a regra
   * precisa atravessar explicitamente o escopo a partir do elemento pai.
   * Alteração exclusivamente visual: não muda fonte, largura, espaços,
   * índices, parsing, reflow ou posicionamento dos acordes.
   */
  .cifra-pre-mobile :deep(.cifra-acorde) {
    color: #ff6c22;

    /* v123 — respiro vertical ampliado no acorde no mobile.
     * Ajuste exclusivamente vertical, preservando integralmente largura,
     * colunas, índices, reflow e posição horizontal aprovados na v122. */
    display: inline-block;
    padding-top: 6px;
  }

}


/* =========================================================
   MOBILE UX — recuperada da v38/v40 validada
   PDF separado; tom atual + Alterar tom compactos.
   Não interfere no renderer/formatador da cifra.
   ========================================================= */
.song-mobile-tools {
  display: none;
}

@media (max-width: 767.98px) {
  .song-header-actions-desktop {
    display: none !important;
  }

  .song-header {
    display: block !important;
  }

  .song-mobile-tools {
    display: block !important;
    margin-top: 10px;
  }

  .mobile-export-pdf {
    width: auto !important;
    min-height: 36px !important;
    padding: 7px 12px !important;
    font-size: 10px !important;
  }

  .mobile-tone-row {
    display: flex;
    align-items: center;
    gap: 7px;
    margin-top: 8px;
  }

  .mobile-current-tone,
  .mobile-change-tone-button {
    flex: 1 1 0;
    min-height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 7px;
    font-size: 10px;
    font-weight: 700;
    white-space: nowrap;
  }

  .mobile-change-tone-button {
    border: 1px solid #00a9b7;
    background: #fff;
    color: #008e9a;
    padding: 6px 9px;
  }

  .mobile-tone-picker {
    margin-top: 7px;
    padding: 8px;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 6px;
    border: 1px solid #dce5e8;
    border-radius: 9px;
    background: #fff;
  }

  .mobile-tone-picker .tone-button {
    min-height: 34px !important;
    height: 34px !important;
  }

  /* O transpositor grande continua disponível no desktop,
     mas fica oculto no mobile, como na UX validada. */
  .transpose-panel {
    display: none !important;
  }
}

</style>