<template>
  <div class="sr-wrap">
    <template v-if="!repertorioAtivo">
      <div class="sr-top">
        <div><h5>🎵 Seven Repertório</h5><p>Crie repertórios e salve cada cifra exatamente no tom que será usado no show.</p></div>
        <button class="btn-primary-action" @click="abrirModalCriar">+ Criar Repertório</button>
      </div>

      <div class="sr-grid">
        <div v-for="r in repertorios" :key="r.id" class="rep-card rep-card-v45">
          <div class="rep-card-topline">
            <button type="button" class="rep-card-title" @click="abrir(r.id)">
              <strong>{{ r.nome }}</strong>
            </button>

            <div class="rep-card-actions">
              <button type="button" class="btn-light" @click.stop="editarDaLista(r)">✏️ Editar</button>
              <button type="button" class="btn-pdf" :disabled="!r.quantidadeMusicas" @click.stop="exportarDaLista(r)">📄 Gerar PDF</button>
              <button type="button" class="rep-card-delete-x" title="Excluir repertório" aria-label="Excluir repertório" @click.stop="excluirDaLista(r)">×</button>
            </div>
          </div>

          <button type="button" class="rep-card-info" @click="abrir(r.id)">
            <span>{{ r.quantidadeMusicas }} música(s)</span>
            <small v-if="r.descricao">{{ r.descricao }}</small>
          </button>
        </div>
        <div v-if="!carregando && !repertorios.length" class="empty">Você ainda não possui repertórios. Clique em <b>+ Criar Repertório</b>.</div>
      </div>
    </template>

    <template v-else>
      <div class="editor-head">
        <button class="btn-light" @click="fechar">← Meus Repertórios</button>
        <div class="editor-context">
          <div class="context-label">REPERTÓRIO ATUAL</div>
          <h4>🎵 {{ repertorioAtivo.nome }}</h4>
          <p v-if="repertorioAtivo.descricao">{{ repertorioAtivo.descricao }}</p>
          <span>{{ musicas.length }} música(s)</span>
        </div>

      </div>

      <div class="search-box">
        <h6>Adicionar música</h6>
        <div class="search-row">
          <input v-model="busca.nomeMusica" placeholder="Nome da música" @keyup.enter="buscarCifra" />
          <input v-model="busca.nomeArtista" placeholder="Artista (opcional)" @keyup.enter="buscarCifra" />
          <button class="btn-primary-action" :disabled="buscando" @click="buscarCifra">{{ buscando ? 'Buscando...' : 'Buscar cifra' }}</button>
        </div>
      </div>

      <div v-if="cifra" class="cifra-card">
        <div class="cifra-head">
          <div><h5>{{ cifra.musica }}</h5><span>{{ cifra.artista }}</span></div>

          <div class="cifra-actions-top cifra-actions-desktop">
            <div class="tone">TOM: {{ tomAtual }}</div>
            <button class="btn-primary-action" :disabled="salvando" @click="salvarNoRepertorio">{{ salvando ? 'Salvando...' : '+ Adicionar ao Repertório' }}</button>
          </div>
        </div>

        <div class="tons tons-desktop">
          <button v-for="tom in tons" :key="tom" :class="{ ativo: tom === tomAtual }" @click="transpor(tom)">{{ tom }}</button>
        </div>

        <div class="cifra-mobile-controls">
          <div class="mobile-tone-row">
            <div class="tone mobile-current-tone">🎵 TOM ATUAL: {{ tomAtual }}</div>
            <button type="button" class="mobile-change-tone" @click="mostrarTonsMobile = !mostrarTonsMobile">
              🎵 Alterar tom
            </button>
          </div>

          <div v-if="mostrarTonsMobile" class="mobile-tone-grid">
            <button
              v-for="tom in tons"
              :key="'mobile-' + tom"
              type="button"
              :class="{ ativo: tom === tomAtual }"
              :disabled="buscando"
              @click="transporMobile(tom)"
            >
              {{ tom }}
            </button>
          </div>

          <button class="btn-primary-action mobile-add-repertoire" :disabled="salvando" @click="salvarNoRepertorio">
            {{ salvando ? 'Salvando...' : '+ Adicionar ao Repertório' }}
          </button>
        </div>
        <div class="cifra-scroll repertorio-cifra-scroll">
          <pre class="cifra-pre cifra-pre-desktop repertorio-cifra-pre repertorio-cifra-desktop">{{ cifra.cifraCompleta }}</pre>
          <pre class="cifra-pre cifra-pre-mobile repertorio-cifra-pre repertorio-cifra-mobile" v-html="cifraMobileHtml"></pre>
        </div>
      </div>

      <div class="songs">
        <div class="songs-title"><h6>Músicas do repertório</h6><span>A ordem abaixo será a ordem do Palco 7 e do PDF.</span></div>
        <div v-for="(m, i) in musicas" :key="m.id" class="song-row">
          <div class="order">{{ i + 1 }}</div>
          <div class="song-info"><strong>{{ m.musica }}</strong><span>{{ m.artista }}</span></div>
          <div class="song-tone">{{ m.tomEscolhido }}</div>
          <div class="song-actions">
            <button :disabled="i === 0" @click="mover(i, -1)">↑</button><button :disabled="i === musicas.length - 1" @click="mover(i, 1)">↓</button><button class="trash" @click="removerMusica(m)">×</button>
          </div>
        </div>
        <div v-if="!musicas.length" class="empty small-empty">Pesquise uma cifra acima e adicione a primeira música.</div>
      </div>
    </template>

    <div v-if="modalRepertorio.aberto" class="modal-backdrop-custom" @mousedown.self="fecharModal">
      <div class="rep-modal" role="dialog" aria-modal="true" :aria-label="modalRepertorio.modo === 'editar' ? 'Editar repertório' : 'Criar novo repertório'">
        <div class="modal-head">
          <div><span class="modal-kicker">SEVEN REPERTÓRIO</span><h5>{{ modalRepertorio.modo === 'editar' ? 'Editar repertório' : 'Criar novo repertório' }}</h5></div>
          <button class="modal-close" type="button" @click="fecharModal">×</button>
        </div>
        <form @submit.prevent="salvarModalRepertorio">
          <label>Nome do repertório <b>*</b></label>
          <input ref="nomeRepertorioInput" v-model="modalRepertorio.nome" maxlength="120" placeholder="Ex.: Show de sábado" @keydown.esc.prevent="fecharModal" />
          <label>Descrição <span>(opcional)</span></label>
          <textarea v-model="modalRepertorio.descricao" maxlength="500" rows="3" placeholder="Ex.: Repertório sertanejo para o show de sábado" @keydown.esc.prevent="fecharModal"></textarea>
          <div class="modal-actions">
            <button type="button" class="btn-light" @click="fecharModal">Cancelar</button>
            <button type="submit" class="btn-primary-action" :disabled="modalRepertorio.salvando || !modalRepertorio.nome.trim()">{{ modalRepertorio.salvando ? 'Salvando...' : (modalRepertorio.modo === 'editar' ? 'Salvar alterações' : 'Criar Repertório') }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { listarRepertorios, obterRepertorio, criarRepertorio, atualizarRepertorio, excluirRepertorio, adicionarMusica, excluirMusica, reordenarMusicas } from "./services/repertoriosService";

export default {
  name: "SevenRepertorio",
  data() { return { mobileCifraColumns: 0, cifraResizeObserver: null, cifraMobileRender: "", cifraMobileOriginal: "", cifraOriginalHtml: "", repertorios: [], repertorioAtivo: null, musicas: [], carregando: false, buscando: false, salvando: false, cifra: null, tomAtual: "", tomOriginalBusca: "", mostrarTonsMobile: false, busca: { nomeMusica: "", nomeArtista: "" }, modalRepertorio: { aberto: false, modo: "criar", nome: "", descricao: "", salvando: false }, tons: ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"] }; },
  computed: {
    cifraMobileHtml() {
      return this.colorirAcordesCifraMobile(this.cifraMobile);
    },
    cifraMobile() {
      return this.cifraMobileRender;
    }
  },
  mounted() {
    this.carregar();
    this.atualizarLarguraCifraMobile();
    window.addEventListener("resize", this.atualizarLarguraCifraMobile);
    this.$nextTick(() => this.observarLarguraCifraMobile());
  },
  beforeUnmount() {
    window.removeEventListener("resize", this.atualizarLarguraCifraMobile);
    if (this.cifraResizeObserver) this.cifraResizeObserver.disconnect();
  },
  methods: {

    formatarCifraMobile(cifraRecebida) {
      const htmlBruto = String(cifraRecebida || "");

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
      if (!this.cifraMobileOriginal) {
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
          this.cifraOriginalHtml &&
          (
            colunasMudaram ||
            !this.cifraMobileRender
          )
        ) {
          // No Repertório a fonte estrutural é diretamente a cifra original.
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

    renderCifraLinhas(texto) {
      const escapeHtml = (valor) => String(valor ?? "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");

      const acorde = /^[A-G](?:#|b)?(?:(?:m|maj|min|dim|aug|sus|add)\d*)?(?:\([^)]*\))?(?:\/[A-G](?:#|b)?)?$/;
      const secao = /^\[[^\]]+\]$/;

      return String(texto ?? "")
        .replace(/\r\n?/g, "\n")
        .split("\n")
        .map((linha) => {
          if (linha === "") return '<div class="cifra-linha">&nbsp;</div>';

          const tokens = linha.trim().split(/\s+/).filter(Boolean);
          const somenteAcordes = tokens.length > 0 && tokens.every((token) =>
            acorde.test(token) || secao.test(token)
          );

          let html = escapeHtml(linha);

          if (somenteAcordes) {
            html = html.replace(/\S+/g, (token) => {
              return acorde.test(token)
                ? `<b class="cifra-acorde">${token}</b>`
                : token;
            });
          }

          return `<div class="cifra-linha">${html}</div>`;
        })
        .join("");
    },

    base() { return (process.env.VUE_APP_API_BASE_URL || "http://localhost:5297").replace(/\/$/, ""); },
    config() { const token = localStorage.getItem("jwt"); return { headers: { Authorization: `Bearer ${String(token || "").replace(/^Bearer\s+/i, "")}`, "Content-Type": "application/json" } }; },
    async carregar() { this.carregando = true; try { this.repertorios = await listarRepertorios(); } catch (e) { this.erro(e); } finally { this.carregando = false; } },
    abrirModalCriar() { this.modalRepertorio = { aberto: true, modo: "criar", nome: "", descricao: "", salvando: false }; this.$nextTick(() => this.$refs.nomeRepertorioInput?.focus()); },
    abrirModalEditar() { this.modalRepertorio = { aberto: true, modo: "editar", nome: this.repertorioAtivo?.nome || "", descricao: this.repertorioAtivo?.descricao || "", salvando: false }; this.$nextTick(() => this.$refs.nomeRepertorioInput?.focus()); },
    fecharModal() { if (this.modalRepertorio.salvando) return; this.modalRepertorio.aberto = false; },
    async salvarModalRepertorio() {
      const nome = this.modalRepertorio.nome.trim();
      if (!nome) return;
      this.modalRepertorio.salvando = true;
      try {
        const payload = { nome, descricao: this.modalRepertorio.descricao.trim() || null };
        if (this.modalRepertorio.modo === "editar") {
          await atualizarRepertorio(this.repertorioAtivo.id, payload);
          await this.abrir(this.repertorioAtivo.id);
          await this.carregar();
        } else {
          const novo = await criarRepertorio(payload);
          await this.carregar();
          await this.abrir(novo.id);
        }
        this.modalRepertorio.aberto = false;
      } catch (e) { this.erro(e); } finally { this.modalRepertorio.salvando = false; }
    },
    async abrir(id) { try { const r = await obterRepertorio(id); this.repertorioAtivo = r; this.musicas = r.musicas || []; this.cifra = null; this.cifraMobileRender = ""; this.cifraMobileOriginal = ""; this.cifraOriginalHtml = ""; } catch (e) { this.erro(e); } },
    async editarDaLista(r) {
      try {
        await this.abrir(r.id);
        this.abrirModalEditar();
      } catch (e) { this.erro(e); }
    },
    async exportarDaLista(r) {
      try {
        await this.abrir(r.id);
        this.exportarRepertorioPdf();
      } catch (e) { this.erro(e); }
    },
    async excluirDaLista(r) {
      if (!confirm(`Excluir o repertório "${r.nome}"?`)) return;
      try {
        await excluirRepertorio(r.id);
        await this.carregar();
      } catch (e) { this.erro(e); }
    },
    fechar() { this.repertorioAtivo = null; this.musicas = []; this.cifra = null; this.carregar(); },
    async removerRepertorio() { if (!confirm(`Excluir o repertório "${this.repertorioAtivo.nome}"?`)) return; try { await excluirRepertorio(this.repertorioAtivo.id); this.fechar(); } catch (e) { this.erro(e); } },
    async buscarCifra() {
      if (!this.busca.nomeMusica.trim()) {
        return alert("Informe o nome da música.");
      }

      this.buscando = true;
      this.cifra = null;
      this.mostrarTonsMobile = false;
      this.cifraMobileRender = "";
      this.cifraMobileOriginal = "";
      this.cifraOriginalHtml = "";

      try {
        const r = await axios.post(
          `${this.base()}/artists/ia/generate-cifra`,
          {
            nomeMusica: this.busca.nomeMusica,
            nomeArtista: this.busca.nomeArtista
          },
          this.config()
        );

        this.cifra = r.data;
        this.tomAtual = r.data.tomOriginal || "";
        this.tomOriginalBusca = r.data.tomOriginal || "";

        // Referência imutável para a formatação/transposição mobile.
        this.cifraOriginalHtml =
          String(r.data.htmlEstruturado || "");

        this.$nextTick(() => {
          this.atualizarLarguraCifraMobile();
        });
      } catch (e) {
        this.erro(e);
      } finally {
        this.buscando = false;
      }
    },

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

    aplicarAcordesTranspostosSemAlterarEstrutura(htmlBase, htmlTransposto) {
      const base = document.createElement("div");
      const transposto = document.createElement("div");
      base.innerHTML = String(htmlBase || "");
      transposto.innerHTML = String(htmlTransposto || "");

      const acordesBase = Array.from(base.querySelectorAll("[data-chord-name]"));
      const acordesTranspostos = Array.from(transposto.querySelectorAll("[data-chord-name]"));

      if (!acordesBase.length || acordesBase.length !== acordesTranspostos.length) {
        console.warn("[SEVENSHOWS] Estrutura da transposição divergente; HTML-base preservado.", {
          base: acordesBase.length,
          transposto: acordesTranspostos.length
        });
        return String(htmlBase || "");
      }

      acordesBase.forEach((acordeBase, indice) => {
        const acordeNovo = acordesTranspostos[indice];
        const valor = acordeNovo.getAttribute("data-chord-name") || acordeNovo.textContent || "";
        acordeBase.setAttribute("data-chord-name", valor);
        acordeBase.textContent = valor;
      });

      return base.innerHTML;
    },

    async transpor(tom) {
      if (!this.cifra || !this.cifraOriginalHtml || tom === this.tomAtual) {
        return;
      }

      this.buscando = true;

      try {
        const acordesOriginais =
          this.extrairAcordesOriginaisParaTransposicao();

        if (!acordesOriginais.length) {
          throw new Error("A lista de acordes da cifra original está vazia.");
        }

        const r = await axios.post(
          `${this.base()}/artists/ia/transpose-cifra`,
          {
            acordes: acordesOriginais,
            tomOriginal:
              this.tomOriginalBusca ||
              this.cifra.tomOriginal ||
              this.tomAtual,
            tomDesejado: tom
          },
          this.config()
        );

        const acordesTranspostos =
          Array.isArray(r.data?.acordes)
            ? r.data.acordes
            : [];

        if (!acordesTranspostos.length) {
          throw new Error(
            "O backend não retornou o array de acordes transpostos."
          );
        }

        this.cifraMobileRender =
          this.substituirAcordesNaCifraMobileOriginal(
            acordesOriginais,
            acordesTranspostos
          );

        const base = document.createElement("div");
        base.innerHTML = String(this.cifraOriginalHtml || "");

        const elementos =
          Array.from(base.querySelectorAll("b[data-chord-name]"));

        if (elementos.length === acordesTranspostos.length) {
          elementos.forEach((el, index) => {
            const novo = String(acordesTranspostos[index] || "").trim();
            el.setAttribute("data-chord-name", novo);
            el.textContent = novo;
          });
          this.cifra.htmlEstruturado = base.innerHTML;
        }

        this.cifra.cifraCompleta = this.cifraMobileRender;
        this.tomAtual = tom;
      } catch (e) {
        this.erro(e);
      } finally {
        this.buscando = false;
      }
    },

    async transporMobile(tom) {
      if (tom === this.tomAtual) {
        this.mostrarTonsMobile = false;
        return;
      }
      await this.transpor(tom);
      this.mostrarTonsMobile = false;
    },
    async salvarNoRepertorio() { if (!this.cifra) return; this.salvando = true; try { await adicionarMusica(this.repertorioAtivo.id, { musica: this.cifra.musica, artista: this.cifra.artista, tomOriginal: this.tomOriginalBusca || this.cifra.tomOriginal || this.tomAtual, tomEscolhido: this.tomAtual, cifraCompleta: this.cifra.cifraCompleta, htmlEstruturado: this.cifra.htmlEstruturado }); await this.abrir(this.repertorioAtivo.id); this.busca = { nomeMusica: "", nomeArtista: "" }; } catch (e) { this.erro(e); } finally { this.salvando = false; } },
    async removerMusica(m) { if (!confirm(`Remover "${m.musica}" deste repertório?`)) return; try { await excluirMusica(this.repertorioAtivo.id, m.id); await this.abrir(this.repertorioAtivo.id); } catch (e) { this.erro(e); } },
    exportarRepertorioPdf() {
      if (!this.repertorioAtivo || !this.musicas.length) return alert("Adicione músicas ao repertório antes de exportar.");

      const esc = v => String(v ?? "").replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#039;");
      const nome = esc(this.repertorioAtivo.nome || "Repertório");
      const descricao = esc(this.repertorioAtivo.descricao || "");

      const indice = this.musicas.map((m,i) => `<div class="indice-item"><span class="indice-num">${String(i+1).padStart(2,"0")}</span><div><strong>${esc(m.musica)}</strong><small>${esc(m.artista)} · Tom ${esc(m.tomEscolhido || m.tomOriginal || "-")}</small></div></div>`).join("");

      // A cifra é enviada integralmente para a página. O ajuste de 1/2 colunas é
      // feito depois que o navegador conhece a altura REAL disponível no A4.
      const paginas = this.musicas.map((m,i) => `<section class="musica"><header><div><div class="numero">${String(i+1).padStart(2,"0")}</div><h1>${esc(m.musica)}</h1><p>Cantor: <strong>${esc(m.artista)}</strong></p></div><div class="tom">TOM: ${esc(m.tomEscolhido || m.tomOriginal || "-")}</div></header><div class="cifra-area"><pre class="cifra-source">${esc(String(m.cifraCompleta ?? "").replace(/\r\n/g,"\n"))}</pre></div></section>`).join("");

      const janela = window.open("","_blank","width=1100,height=850");
      if (!janela) return alert("O navegador bloqueou a pré-visualização. Permita pop-ups para o Seven Shows.");
      janela.document.open();
      janela.document.write(`<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><title>${nome} - Seven Shows</title><style>
@page{size:A4 portrait;margin:0}*{box-sizing:border-box}html,body{margin:0;padding:0;background:#eef1f5;color:#15171a;font-family:Arial,Helvetica,sans-serif}.toolbar{position:sticky;top:0;z-index:10;display:flex;justify-content:center;gap:10px;padding:12px;background:#20242a;box-shadow:0 2px 10px #0003}.toolbar button{border:0;border-radius:7px;padding:10px 18px;font-weight:800;cursor:pointer}.print{background:#198754;color:#fff}.close{background:#fff;color:#333}.sheet,.musica{width:210mm;height:297mm;margin:18px auto;background:#fff;padding:14mm 13mm 12mm;box-shadow:0 4px 22px #0002;overflow:hidden}.capa{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center}.brand{font-size:16px;font-weight:900;letter-spacing:3px;color:#ff6c22}.capa h1{font-size:34px;margin:22px 0 8px;text-transform:uppercase}.capa p{color:#667085}.count{margin-top:28px;border:1px solid #d9dde4;border-radius:20px;padding:8px 16px;font-weight:800}.indice h1{margin:0 0 6px;font-size:25px}.indice>p{margin:0 0 25px;color:#667085}.indice-item{display:flex;gap:14px;padding:11px 0;border-bottom:1px solid #eceff3}.indice-num{font:800 12px "Courier New",monospace;color:#ff6c22;padding-top:2px}.indice-item div{display:flex;flex-direction:column}.indice-item strong{font-size:12px}.indice-item small{font-size:9px;color:#667085;margin-top:3px}.musica{display:flex;flex-direction:column;page-break-before:always;break-before:page}.musica header{flex:0 0 auto;display:flex;justify-content:space-between;gap:18px;align-items:flex-start;padding-bottom:7px;margin-bottom:8px;border-bottom:1px solid #cfd4d8}.musica h1{font-size:16px;margin:2px 0 3px;text-transform:uppercase}.musica p{font-size:9px;margin:0;color:#444}.numero{font:800 9px "Courier New",monospace;color:#ff6c22}.tom{border:1px solid #333;border-radius:4px;padding:5px 9px;font:700 10px "Courier New",monospace;white-space:nowrap}.cifra-area{flex:1 1 auto;min-height:0;overflow:hidden}.musica pre{margin:0;padding:0;white-space:pre;overflow:visible;font-family:"Courier New",Courier,monospace;font-size:8.5pt;font-weight:400;line-height:1.03;tab-size:4;color:#000}.cifra-duas{height:100%;display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:6mm;align-items:start}.cifra-duas pre{min-width:0}.layout-info{position:absolute;left:-99999px}
@media print{html,body{background:#fff}.toolbar{display:none!important}.sheet,.musica{margin:0!important;box-shadow:none!important;width:210mm!important;height:297mm!important;page-break-after:always;break-after:page}.sheet:last-child,.musica:last-child{page-break-after:auto}.musica{page-break-before:auto;break-before:auto}}

/* v159 — exibição da cifra usa a mesma estrutura visual do Gerador v155. */
.cifra-scroll {
  max-height: 650px;
  overflow: auto;
  background: linear-gradient(180deg, #f1f8f9 0%, #edf6f7 100%);
  scrollbar-width: thin;
  scrollbar-color: #8f9fa4 #dfeaec;
}
.cifra-scroll::-webkit-scrollbar { width: 9px; height: 9px; }
.cifra-scroll::-webkit-scrollbar-track { background: #dfeaec; }
.cifra-scroll::-webkit-scrollbar-thumb {
  background: #8f9fa4;
  border-radius: 10px;
  border: 2px solid #dfeaec;
}

.cifra-card .cifra-pre {
  min-width: max-content !important;
  margin: 0 !important;
  padding: 27px 29px 38px !important;
  border: 0 !important;
  background: transparent !important;
  color: #111827 !important;
  font-family: monospace !important;
  font-size: 14px !important;
  font-weight: 500 !important;
  white-space: pre !important;
  line-height: 1.0 !important;
  letter-spacing: 0.5px !important;
  overflow: visible !important;
}
.cifra-pre-mobile { display: none !important; }

@media (max-width: 575.98px) {
  .cifra-scroll { overflow-x: hidden; }
  .cifra-pre-desktop { display: none !important; }

  .cifra-card .cifra-pre-mobile {
    display: block !important;
    min-width: 0 !important;
    width: 100% !important;
    max-width: 100% !important;
    padding: 20px 8px 30px !important;
    font-family: monospace !important;
    font-size: clamp(12px, calc(10vw - 24px), 15px) !important;
    font-weight: 500 !important;
    line-height: 1.12 !important;
    letter-spacing: 0.5px !important;
    white-space: pre !important;
    overflow: visible !important;
    overflow-wrap: normal !important;
    word-break: normal !important;
    background: transparent !important;
    border-radius: 0 !important;
  }

  .cifra-pre-mobile :deep(.cifra-acorde) {
    color: #ff6c22;
    display: inline-block;
    padding-top: 6px;
  }
}

</style></head><body><div class="toolbar"><button class="print" onclick="window.print()">🖨 Imprimir / Salvar PDF</button><button class="close" onclick="window.close()">Fechar</button></div><section class="sheet capa"><div class="brand">SEVEN SHOWS</div><h1>${nome}</h1>${descricao?`<p>${descricao}</p>`:""}<div class="count">${this.musicas.length} música(s)</div></section><section class="sheet indice"><h1>Índice</h1><p>${nome}</p>${indice}</section>${paginas}<script>
(function(){
  function melhorCorte(linhas){
    var meio=Math.ceil(linhas.length/2), corte=meio, dist=999999;
    for(var i=Math.max(1,meio-10);i<=Math.min(linhas.length-1,meio+10);i++){
      if(linhas[i].trim()==="" && Math.abs(i-meio)<dist){corte=i+1;dist=Math.abs(i-meio);}
    }
    return corte;
  }
  function cabe(area, pres){
    return pres.every(function(pre){return pre.scrollHeight<=area.clientHeight+1 && pre.scrollWidth<=pre.clientWidth+1;});
  }
  function ajustar(sec){
    var area=sec.querySelector('.cifra-area');
    var original=sec.querySelector('.cifra-source');
    var texto=original.textContent.replace(/\\r\\n/g,'\\n');
    var linhas=texto.split('\\n');
    var tamanhos=[8.5,8,7.5,7,6.5];

    // 1) tenta uma coluna, medindo a folha A4 real.
    for(var a=0;a<tamanhos.length;a++){
      original.style.fontSize=tamanhos[a]+'pt';
      if(cabe(area,[original])) return;
    }

    // 2) se não couber, divide somente ENTRE linhas completas.
    var corte=melhorCorte(linhas);
    area.innerHTML='<div class="cifra-duas"><pre></pre><pre></pre></div>';
    var pres=area.querySelectorAll('pre');
    pres[0].textContent=linhas.slice(0,corte).join('\\n');
    pres[1].textContent=linhas.slice(corte).join('\\n');
    for(var b=0;b<tamanhos.length;b++){
      pres[0].style.fontSize=tamanhos[b]+'pt';
      pres[1].style.fontSize=tamanhos[b]+'pt';
      if(cabe(area,[pres[0],pres[1]])) return;
    }

    // 3) último ajuste: mantém duas colunas e usa o menor tamanho legível.
    pres[0].style.fontSize='6.5pt'; pres[1].style.fontSize='6.5pt';
  }
  function executar(){document.querySelectorAll('.musica').forEach(ajustar);}
  if(document.fonts && document.fonts.ready){document.fonts.ready.then(executar);}else{setTimeout(executar,50);}
})();
${"<" + "/script>"}</body></html>`);
      janela.document.close();
    },
    async mover(index, delta) { const destino = index + delta; if (destino < 0 || destino >= this.musicas.length) return; const copia = [...this.musicas]; [copia[index], copia[destino]] = [copia[destino], copia[index]]; this.musicas = copia; try { await reordenarMusicas(this.repertorioAtivo.id, copia.map(x => x.id)); } catch (e) { this.erro(e); await this.abrir(this.repertorioAtivo.id); } },
    erro(e) { console.error(e); alert(e.response?.data?.message || e.response?.data?.mensagem || e.message || "Ocorreu um erro."); }
  }
};
</script>

<style scoped>
.sr-wrap{font-family:monospace;color:#263238}.sr-top,.cifra-head,.songs-title{display:flex;align-items:center;justify-content:space-between;gap:16px}.sr-top{background:#fff;border:1px solid #e5e7eb;border-radius:14px;padding:20px;margin-bottom:18px}.sr-top h5,.cifra-head h5{margin:0;font-weight:800}.sr-top p{margin:5px 0 0;color:#7a8290}.btn-primary-action{border:0;border-radius:8px;background:#4f46e5;color:#fff;font-weight:800;padding:11px 18px;transition:.18s}.btn-primary-action:hover:not(:disabled){background:#4338ca;transform:translateY(-1px)}.btn-primary-action:disabled{opacity:.55;cursor:not-allowed}.sr-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:14px}.rep-card{background:#fff;border:1px solid #e3e6ec;border-radius:12px;padding:18px;text-align:left;display:flex;flex-direction:column;gap:7px;transition:.18s}.rep-card:hover{border-color:#6366f1;box-shadow:0 5px 15px rgba(79,70,229,.08);transform:translateY(-1px)}.rep-card strong{font-size:15px}.rep-card span{color:#4f46e5;font-weight:800}.rep-card small{color:#7a8290}.empty{grid-column:1/-1;background:#fff;border:1px dashed #cfd5df;border-radius:12px;padding:35px;text-align:center;color:#7a8290}.editor-head{display:grid;grid-template-columns:minmax(145px,1fr) minmax(260px,2fr) minmax(320px,1fr);align-items:center;gap:18px;background:#fff;border:1px solid #e3e6ec;border-radius:14px;padding:16px 18px;margin-bottom:16px}.editor-context{text-align:center}.editor-context .context-label{font-size:10px;font-weight:900;letter-spacing:1px;color:#6366f1;margin-bottom:4px}.editor-context h4{margin:0;font-size:20px;font-weight:900}.editor-context p{margin:5px 0 2px;color:#667085;font-size:12px}.editor-context span{color:#7a8290;font-size:12px}.editor-actions{display:flex;justify-content:flex-end;gap:8px;align-items:center}.btn-pdf{border:1px solid #198754;background:#198754;color:#fff;border-radius:8px;padding:9px 12px;font-weight:800}.btn-pdf:disabled{opacity:.45;cursor:not-allowed}.btn-light,.btn-danger-soft{border:1px solid #dfe3e8;background:#fff;border-radius:8px;padding:9px 12px;font-weight:700}.btn-light:hover{background:#f8f9fc}.btn-danger-soft{color:#c0392b}.btn-danger-soft:hover{background:#fff5f4;border-color:#f2c6c1}.search-box,.cifra-card,.songs{background:#fff;border:1px solid #e3e6ec;border-radius:12px;padding:18px;margin-bottom:16px}.search-box h6,.songs-title h6{margin:0 0 10px}.search-row{display:grid;grid-template-columns:1fr 1fr auto;gap:10px}.search-row input{border:1px solid #d9dee7;border-radius:8px;padding:10px 12px}.cifra-actions-top{display:flex;align-items:center;gap:10px}.tone,.song-tone{background:#edf8ef;color:#198754;border-radius:7px;padding:7px 10px;font-weight:900}.tons{display:flex;flex-wrap:wrap;gap:6px;margin:14px 0}.tons button{border:1px solid #dfe3e8;background:#fff;border-radius:6px;padding:6px 9px}.tons button.ativo{background:#198754;color:#fff;border-color:#198754}.songs-title{margin-bottom:12px}.songs-title span{font-size:11px;color:#7a8290}.song-row{display:grid;grid-template-columns:44px 1fr 70px auto;align-items:center;gap:10px;border-top:1px solid #eef0f3;padding:11px 4px}.order{font-weight:900;color:#8a919d}.song-info{display:flex;flex-direction:column}.song-info span{font-size:11px;color:#7a8290}.song-actions{display:flex;gap:5px}.song-actions button{border:1px solid #dfe3e8;background:#fff;border-radius:6px;min-width:32px;height:32px}.song-actions button:hover:not(:disabled){background:#f8f9fc}.song-actions .trash{color:#c0392b}.song-actions .trash:hover{background:#fff5f4}.small-empty{padding:22px}.modal-backdrop-custom{position:fixed;inset:0;z-index:10550;background:rgba(15,23,42,.56);display:flex;align-items:center;justify-content:center;padding:20px}.rep-modal{width:min(520px,100%);background:#fff;border-radius:16px;box-shadow:0 24px 70px rgba(15,23,42,.25);padding:22px}.modal-head{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:18px}.modal-head h5{margin:3px 0 0;font-weight:900}.modal-kicker{font-size:10px;color:#6366f1;font-weight:900;letter-spacing:1px}.modal-close{border:0;background:#f3f4f6;border-radius:8px;width:34px;height:34px;font-size:22px;line-height:1}.rep-modal form{display:flex;flex-direction:column;gap:8px}.rep-modal label{font-weight:800;font-size:12px;margin-top:4px}.rep-modal label b{color:#c0392b}.rep-modal label span{font-weight:400;color:#7a8290}.rep-modal input,.rep-modal textarea{width:100%;border:1px solid #d9dee7;border-radius:9px;padding:11px 12px;outline:none}.rep-modal input:focus,.rep-modal textarea:focus{border-color:#6366f1;box-shadow:0 0 0 3px rgba(99,102,241,.12)}.rep-modal textarea{resize:vertical;min-height:84px}.modal-actions{display:flex;justify-content:flex-end;gap:9px;margin-top:12px}
@media(max-width:1000px){.editor-head{grid-template-columns:1fr}.editor-context{text-align:left}.editor-actions{justify-content:flex-start;flex-wrap:wrap}}@media(max-width:768px){.sr-top,.cifra-head{align-items:stretch;flex-direction:column}.search-row{grid-template-columns:1fr}.cifra-actions-top{align-items:stretch;flex-direction:column}.song-row{grid-template-columns:32px 1fr 55px}.song-actions{grid-column:2/4;justify-content:flex-end}.cifra-card pre{font-size:12px}.modal-actions{flex-direction:column-reverse}.modal-actions button{width:100%}}

.cifra-mobile-controls{display:none}

@media(max-width:768px){
  /* v43 — transposição do Seven Repertório padronizada com Gerador de Cifras */
  .cifra-actions-desktop,
  .tons-desktop{
    display:none !important;
  }

  .cifra-mobile-controls{
    display:block;
    margin-top:10px;
  }

  .mobile-tone-row{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:7px;
  }

  .mobile-current-tone,
  .mobile-change-tone{
    min-width:0;
    min-height:36px;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:7px;
    padding:7px 8px;
    font-family:inherit;
    font-size:10px;
    font-weight:900;
    white-space:nowrap;
  }

  .mobile-current-tone{
    margin:0;
    background:#198754;
    color:#fff;
  }

  .mobile-change-tone{
    border:1px solid #00a9b7;
    background:#fff;
    color:#008e9a;
  }

  .mobile-tone-grid{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:6px;
    margin-top:7px;
    padding:8px;
    border:1px solid #dce5e8;
    border-radius:9px;
    background:#fff;
  }

  .mobile-tone-grid button{
    min-height:34px;
    border:1px solid #dfe3e8;
    border-radius:6px;
    background:#fff;
    color:#52606d;
    font-family:inherit;
    font-size:10px;
    font-weight:800;
  }

  .mobile-tone-grid button.ativo{
    background:#00a9b7;
    border-color:#00a9b7;
    color:#fff;
  }

  .mobile-tone-grid button:disabled{
    opacity:.55;
  }

  .mobile-add-repertoire{
    width:100%;
    margin-top:7px;
    min-height:38px;
    padding:8px 12px;
    font-size:11px;
  }
}


/* v44 — ações administrativas diretamente nos cards da listagem */
.rep-card{
  display:flex;
  flex-direction:column;
}
.rep-card-main{
  width:100%;
  border:0;
  background:transparent;
  color:inherit;
  text-align:left;
  font:inherit;
  cursor:pointer;
}
.rep-card-main strong,
.rep-card-main span,
.rep-card-main small{
  display:block;
}
.rep-card-actions{
  display:flex;
  gap:8px;
  margin-top:14px;
}
.rep-card-actions button{
  flex:1 1 0;
  min-width:0;
}

@media(max-width:768px){
  .rep-card{
    padding:14px !important;
  }
  .rep-card-main{
    padding:0 !important;
  }
  .rep-card-actions{
    gap:6px;
    margin-top:12px;
  }
  .rep-card-actions button{
    min-height:36px;
    padding:7px 5px;
    font-size:10px;
    font-weight:800;
    white-space:nowrap;
  }
}


/* v45 — card inicial: nome + ações na primeira linha; quantidade e descrição abaixo */
.rep-card-v45 .rep-card-topline{
  display:flex;
  align-items:center;
  gap:10px;
  width:100%;
}
.rep-card-v45 .rep-card-title,
.rep-card-v45 .rep-card-info{
  border:0;
  background:transparent;
  color:inherit;
  font:inherit;
  text-align:left;
  cursor:pointer;
}
.rep-card-v45 .rep-card-title{
  flex:1 1 auto;
  min-width:0;
  padding:0;
}
.rep-card-v45 .rep-card-title strong{
  display:block;
}
.rep-card-v45 .rep-card-info{
  width:100%;
  padding:8px 0 0;
}
.rep-card-v45 .rep-card-info span,
.rep-card-v45 .rep-card-info small{
  display:block;
}
.rep-card-v45 .rep-card-actions{
  flex:0 0 auto;
  margin-top:0;
}

@media(max-width:768px){
  .rep-card-v45{
    padding:12px !important;
  }

  .rep-card-v45 .rep-card-topline{
    gap:5px;
  }

  .rep-card-v45 .rep-card-title{
    flex:1 1 0;
  }

  .rep-card-v45 .rep-card-title strong{
    font-size:12px;
    line-height:1.2;
  }

  .rep-card-v45 .rep-card-actions{
    display:flex;
    flex:0 0 auto;
    gap:4px;
  }

  .rep-card-v45 .rep-card-actions button{
    flex:0 0 auto;
    min-height:30px;
    padding:5px 7px;
    font-size:8px;
    font-weight:800;
    white-space:nowrap;
  }

  .rep-card-v45 .rep-card-info{
    padding-top:7px;
  }

  .rep-card-v45 .rep-card-info span{
    font-size:10px;
    font-weight:800;
  }

  .rep-card-v45 .rep-card-info small{
    margin-top:5px;
    font-size:9px;
    line-height:1.35;
  }
}


/* v46 — melhor legibilidade das informações abaixo do título no card mobile */
@media(max-width:768px){
  .rep-card-v45 .rep-card-info span{
    font-size:12px !important;
    line-height:1.3 !important;
    font-weight:800 !important;
  }

  .rep-card-v45 .rep-card-info small{
    margin-top:6px !important;
    font-size:11px !important;
    line-height:1.4 !important;
  }
}


/* v47 — excluir como X circular vermelho no canto superior direito */
.rep-card-v45{
  position:relative;
}

.rep-card-v45 .rep-card-delete-x{
  position:absolute;
  top:7px;
  right:7px;
  z-index:2;
  width:24px;
  height:24px;
  min-width:24px;
  padding:0;
  border:0;
  border-radius:50%;
  background:#dc3545;
  color:#fff;
  display:flex;
  align-items:center;
  justify-content:center;
  font-family:Arial,sans-serif;
  font-size:17px;
  font-weight:800;
  line-height:1;
  cursor:pointer;
}

@media(max-width:768px){
  .rep-card-v45 .rep-card-topline{
    padding-right:25px;
  }

  .rep-card-v45 .rep-card-actions .rep-card-delete-x{
    position:absolute;
    top:7px;
    right:7px;
    width:24px;
    height:24px;
    min-height:24px;
    padding:0;
    font-size:17px;
  }
}


/* v48 — nome do repertório em negrito nos cards */
.rep-card-v45 .rep-card-title strong{
  font-weight:800 !important;
}


/* v49 — cifra do Repertório igual ao Gerador de Cifras no mobile:
   mesma fonte, quebra e tratamento de overflow. */








/* v161 — renderer da cifra mobile implantado a partir do Gerador aprovado. */
.cifra-scroll {
  max-height: 650px;
  overflow: auto;
  background: linear-gradient(180deg, #f1f8f9 0%, #edf6f7 100%);
  scrollbar-width: thin;
  scrollbar-color: #8f9fa4 #dfeaec;
}
.cifra-scroll::-webkit-scrollbar { width: 9px; height: 9px; }
.cifra-scroll::-webkit-scrollbar-track { background: #dfeaec; }
.cifra-scroll::-webkit-scrollbar-thumb {
  background: #8f9fa4;
  border-radius: 10px;
  border: 2px solid #dfeaec;
}
.cifra-pre-mobile { display: none !important; }

@media (max-width: 767.98px) {
  .cifra-actions-desktop,
  .tons-desktop { display: none !important; }

  .cifra-mobile-controls {
    display: block;
    margin-top: 10px;
  }

  .cifra-card {
    min-width: 0 !important;
    max-width: 100% !important;
    overflow: hidden !important;
  }
}

@media (max-width: 575.98px) {
  .cifra-card > .cifra-scroll {
    margin-left: -18px;
    margin-right: -18px;
    width: calc(100% + 36px);
    max-width: none;
    overflow-x: hidden;
  }

  .cifra-pre-desktop { display: none !important; }

  .cifra-card .cifra-pre-mobile {
    display: block !important;
    min-width: 0 !important;
    width: 100% !important;
    max-width: 100% !important;
    margin: 0 !important;
    padding: 20px 8px 30px !important;
    border: 0 !important;
    background: transparent !important;
    color: #111827 !important;
    font-family: monospace !important;
    font-size: clamp(12px, calc(10vw - 24px), 15px) !important;
    font-weight: 500 !important;
    line-height: 1.12 !important;
    letter-spacing: 0.5px !important;
    white-space: pre !important;
    overflow: visible !important;
    overflow-wrap: normal !important;
    word-break: normal !important;
  }

  .cifra-pre-mobile :deep(.cifra-acorde) {
    color: #ff6c22;
    display: inline-block;
    padding-top: 6px;
  }
}
</style>
