<template>
  <div class="seven-designer">
    <div class="card border-0 shadow-sm mb-3">
      <div class="card-body px-4 py-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
          <div class="d-flex align-items-center gap-2">
            <span class="fs-4">🎨</span>
            <h5 class="mb-0 fw-bold">Seven Designer</h5>
            <span class="badge bg-warning text-dark">NOVO</span>
          </div>
          <small class="text-muted">Clique diretamente nos elementos do cartaz para editar.</small>
        </div>
        <div class="d-flex align-items-center gap-2 flex-wrap justify-content-end">
          <strong class="small">Story 1080 × 1920</strong>
          <button type="button" class="btn btn-dark btn-sm fw-bold designer-download-btn"
            :disabled="operacaoImagemAtiva" @click="baixarCartaz">
            ⬇ Baixar o Cartaz
          </button>
        </div>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-xl-3 col-lg-4">
        <div class="card border-0 shadow-sm designer-sidebar-sticky">
          <div class="card-body p-3">
            <div class="designer-sidebar-section designer-tools-section">
              <strong class="d-block mb-2">Ferramentas</strong>
              <button class="btn btn-dark w-100 fw-bold mb-2" type="button"
                @click.stop="menuAdicionarTexto = !menuAdicionarTexto">
                T＋ Adicionar texto
              </button>
              <div v-if="menuAdicionarTexto" class="sidebar-text-menu" @click.stop>
                <button @click="adicionarTextoLivre('titulo')"><b>Título</b><small>Destaque principal</small></button>
                <button @click="adicionarTextoLivre('subtitulo')"><b>Subtítulo</b><small>Informação
                    secundária</small></button>
                <button @click="adicionarTextoLivre('texto')"><b>Texto</b><small>Texto livre</small></button>
              </div>
              <button class="btn btn-outline-dark w-100 fw-bold mb-2" type="button"
                @click.stop="menuAdicionarForma = !menuAdicionarForma; menuAdicionarTexto = false">
                ▢ Adicionar forma
              </button>
              <div v-if="menuAdicionarForma" class="sidebar-text-menu" @click.stop>
                <button @click="adicionarForma('quadrado')"><b>■ Quadrado</b><small>Forma proporcional</small></button>
                <button @click="adicionarForma('retangulo')"><b>▬ Retângulo</b><small>Faixa ou caixa</small></button>
                <button @click="adicionarForma('circulo')"><b>● Círculo</b><small>Destaque circular</small></button>
              </div>
            </div>

            <div class="designer-sidebar-section posters-section">
              <button type="button" class="designer-accordion-header"
                @click="painelLateralAberto = painelLateralAberto === 'cartazes' ? null : 'cartazes'">
                <span class="designer-accordion-title"><span class="designer-accordion-icon">🗂️</span> Meus
                  cartazes</span>
                <span class="designer-accordion-right">
                  <span class="designer-chevron" :class="{ aberto: painelLateralAberto === 'cartazes' }"></span>
                </span>
              </button>

              <div v-show="painelLateralAberto === 'cartazes'" class="designer-accordion-body designer-posters-body">
                <div class="poster-quota mb-2">
                  <div class="d-flex justify-content-between align-items-center mb-1">
                    <small class="text-muted">{{ postersUsados }} de {{ postersLimite }} utilizados</small>
                    <small v-if="posterAtivo" class="autosave-status"
                      :class="{ saving: statusAutosave === 'salvando', error: statusAutosave === 'erro' }">
                      {{ textoStatusAutosave }}
                    </small>
                  </div>
                  <div class="progress poster-progress">
                    <div class="progress-bar" :style="{ width: percentualPosters + '%' }"></div>
                  </div>
                </div>

                <button class="btn btn-dark w-100 fw-bold mb-2" type="button"
                  :disabled="carregandoPosters || trocandoPoster" @click="novoCartaz">
                  + Novo cartaz
                </button>

                <div v-if="erroPosters" class="alert alert-danger py-2 small">{{ erroPosters }}</div>
                <div v-if="carregandoPosters" class="text-muted small text-center py-2">Carregando cartazes...</div>

                <div v-else class="posters-list">
                  <div v-for="poster in posters" :key="poster.id" class="poster-list-item"
                    :class="{ active: poster.id === posterAtivo?.id }">
                    <button type="button" class="poster-open" @click="abrirCartazSalvo(poster)">
                      <span class="poster-icon">{{ poster.isDraft ? '✏️' : '🖼️' }}</span>
                      <span class="poster-info">
                        <strong>{{ poster.name }}</strong>
                        <small>
                          {{ poster.isDraft ? 'Em criação' : 'Salvo' }}
                          <span v-if="poster.isActive"> • Em edição</span>
                        </small>
                      </span>
                    </button>

                    <div class="poster-actions">
                      <button v-if="poster.isDraft" type="button" title="Salvar e nomear"
                        @click.stop="salvarNomeCartaz(poster)">✓</button>
                      <button v-else type="button" title="Renomear" @click.stop="salvarNomeCartaz(poster)">✎</button>
                      <button v-if="!poster.isDraft" type="button" title="Duplicar" :disabled="!postersPodeCriar"
                        @click.stop="duplicarCartazSalvo(poster)">⧉</button>
                      <button type="button" class="danger" title="Excluir"
                        @click.stop="excluirCartazSalvo(poster)">×</button>
                    </div>
                  </div>
                </div>

                <div v-if="posters.length === 0 && !carregandoPosters" class="empty-box">
                  Nenhum cartaz encontrado.
                </div>
              </div>
            </div>

            <div class="designer-sidebar-section uploads-section">
              <button type="button" class="designer-accordion-header"
                @click="painelLateralAberto = painelLateralAberto === 'uploads' ? null : 'uploads'">
                <span class="designer-accordion-title"><span class="designer-accordion-icon">🖼️</span> Minhas imagens</span>
                <span class="designer-accordion-right">
                  <span class="designer-chevron" :class="{ aberto: painelLateralAberto === 'uploads' }"></span>
                </span>
              </button>

              <div v-show="painelLateralAberto === 'uploads'" class="designer-accordion-body designer-uploads-body">
                <div class="upload-quota mb-2">
                  <div class="d-flex justify-content-between align-items-center mb-1">
                    <small class="text-muted">Fotos, logos e imagens.</small>
                    <small class="upload-quota-count" :class="{ full: !podeEnviar }">{{ usados }} de {{ limite }}</small>
                  </div>
                  <div class="progress upload-progress">
                    <div class="progress-bar" :style="{ width: percentualUploads + '%' }"></div>
                  </div>
                </div>

                <input ref="inputUpload" type="file" class="d-none" accept="image/png,image/jpeg,image/webp"
                  @change="enviarUpload" />
                <input ref="inputFotoArtista" type="file" class="d-none" accept="image/png,image/jpeg,image/webp"
                  @change="enviarFotoArtista" />

                <button class="btn btn-warning w-100 fw-bold mb-2" :disabled="enviando || !podeEnviar"
                  @click="$refs.inputUpload?.click()">
                  {{ enviando ? "Enviando..." : (!podeEnviar ? "Limite de uploads atingido" : "+ Enviar nova imagem") }}
                </button>

                <div v-if="erroUploads" class="alert alert-danger py-2 small">{{ erroUploads }}</div>
                <div v-if="carregando" class="text-muted small text-center py-2">Carregando...</div>

                <div v-else class="uploads-grid">
                  <div v-for="asset in assets" :key="asset.id" class="upload-item">
                    <button class="upload-thumb" @click="adicionarImagemGaleria(asset)" title="Adicionar ao designer">
                      <img :src="urlAsset(asset.originalUrl)" :alt="asset.originalFileName" />
                    </button>
                    <button class="upload-delete" @click.stop="excluirUpload(asset)" title="Excluir upload">×</button>
                  </div>
                </div>

                <div v-if="assets.length === 0 && !carregando" class="empty-box">
                  Envie a primeira foto ou logo.
                </div>
                <div v-if="!podeEnviar" class="alert alert-warning py-2 small mt-2 mb-0">
                  Limite atingido. Exclua um upload para liberar espaço.
                </div>
              </div>
            </div>

            <div class="designer-sidebar-section designer-background-section"
              :class="{ aberto: painelLateralAberto === 'fundos' }">
              <button type="button" class="designer-accordion-header"
                @click="painelLateralAberto = painelLateralAberto === 'fundos' ? null : 'fundos'">
                <span class="designer-accordion-title"><span class="designer-accordion-icon">🎨</span> Fundos do
                  cartaz</span>
                <span class="designer-chevron" :class="{ aberto: painelLateralAberto === 'fundos' }"></span>
              </button>

              <div v-show="painelLateralAberto === 'fundos'" class="sidebar-backgrounds-scroll">
                <div class="sidebar-backgrounds">
                  <button v-for="bg in backgrounds" :key="bg.id" type="button" class="sidebar-bg-choice"
                    :class="{ active: backgroundId === bg.id }" @click="backgroundId = bg.id">
                    <span v-if="bg.tipo === 'procedural'" class="sidebar-procedural-thumb"></span>
                    <img v-else :src="bg.src" :alt="bg.nome" />
                    <small :title="bg.nome">{{ bg.nome }}</small>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-xl-9 col-lg-8">
        <div class="card border-0 shadow-sm">
          <div class="card-body p-3 p-md-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div>
                <small class="text-muted fw-bold">EDITOR VISUAL</small>
                <h6 class="fw-bold mb-0 mt-1">{{ posterAtivo?.name || "Seu cartaz" }}</h6>
                <small v-if="posterAtivo" class="editor-autosave-status"
                  :class="{ saving: statusAutosave === 'salvando', error: statusAutosave === 'erro' }">
                  {{ textoStatusAutosave }}
                </small>
              </div>
              <span class="badge bg-light text-muted border">Sertanejo Sunset</span>
            </div>

            <div v-if="selecionado" class="designer-floating-toolbar" @click.stop>
              <template v-if="selecionado.tipo === 'texto'">
                <input v-model="selecionado.texto" class="form-control floating-text-input" title="Texto selecionado"
                  @input="sincronizarTexto" />

                <div class="font-picker">
                  <button type="button" class="font-picker-button"
                    :style="{ fontFamily: fonteSelecionada?.family || 'Arial' }"
                    @click.stop="fontMenuAberto = !fontMenuAberto; posicaoMenuAberto = false">
                    <span>{{ fonteSelecionada?.nome || "Fonte" }}</span>
                    <span class="font-picker-arrow">⌄</span>
                  </button>

                  <div v-if="fontMenuAberto" class="font-picker-menu">
                    <button v-for="fonte in fontes" :key="fonte.id" type="button" class="font-option"
                      :class="{ active: selecionado.fontId === fonte.id }" :style="{ fontFamily: fonte.family }"
                      @click.stop="selecionarFonte(fonte)">
                      <span class="font-option-preview">Aa</span>
                      <span>{{ fonte.nome }}</span>
                    </button>
                  </div>
                </div>

                <label class="floating-color" title="Cor do texto">
                  <span class="floating-color-letter">A</span>
                  <input v-model="selecionado.corTexto" type="color" @input="sincronizarTexto" />
                </label>

                <button type="button" class="toolbar-action" :class="{ active: selecionado.temFundo }"
                  title="Ativar ou remover fundo do texto" @click="alternarFundoTexto">▰ Fundo</button>
                <label v-if="selecionado.temFundo" class="floating-color" title="Cor do fundo">
                  <span>▰</span>
                  <input v-model="selecionado.corFundo" type="color" @input="sincronizarTexto" />
                </label>

                <button class="toolbar-action" @click="duplicarTexto">⧉ Duplicar</button>

                <div class="position-picker">
                  <button type="button" class="toolbar-action" @click.stop="alternarMenuPosicao">
                    <span class="toolbar-icon">▱</span>
                    Posição
                  </button>

                  <div v-if="posicaoMenuAberto" class="position-menu">
                    <div class="position-title">Camadas</div>
                    <button @click="executarPosicao('top')"><span>▣</span> Trazer para frente</button>
                    <button @click="executarPosicao('up')"><span>↑</span> Avançar uma camada</button>
                    <button @click="executarPosicao('down')"><span>↓</span> Recuar uma camada</button>
                    <button @click="executarPosicao('bottom')"><span>▤</span> Enviar para trás</button>

                    <div class="position-separator"></div>
                    <div class="position-title">Alinhar no cartaz</div>
                    <div class="align-grid">
                      <button title="Esquerda" @click="alinharSelecionado('left')">⇤</button>
                      <button title="Centro horizontal" @click="alinharSelecionado('center')">↔</button>
                      <button title="Direita" @click="alinharSelecionado('right')">⇥</button>
                      <button title="Topo" @click="alinharSelecionado('top')">⇡</button>
                      <button title="Centro vertical" @click="alinharSelecionado('middle')">↕</button>
                      <button title="Base" @click="alinharSelecionado('bottom')">⇣</button>
                    </div>
                  </div>
                </div>

                <button class="toolbar-action toolbar-danger" @click="excluirSelecionado">
                  🗑 Excluir
                </button>
              </template>

              <template v-else-if="selecionado.tipo === 'forma'">
                <strong class="shape-name">{{ nomeForma(selecionado.forma) }}</strong>
                <label class="floating-color" title="Cor da forma"><span>■</span>
                  <input v-model="selecionado.cor" type="color" @input="sincronizarForma" />
                </label>
                <label class="floating-color" title="Cor da borda"><span>□</span>
                  <input v-model="selecionado.corBorda" type="color" @input="sincronizarForma" />
                </label>
                <label class="shape-number" title="Espessura da borda"><span>Borda</span>
                  <input v-model.number="selecionado.espessuraBorda" type="number" min="0" max="30"
                    @input="sincronizarForma" />
                </label>
                <label class="shape-number" title="Opacidade"><span>Opac.</span>
                  <input v-model.number="selecionado.opacidade" type="number" min="0.05" max="1" step="0.05"
                    @input="sincronizarForma" />
                </label>
                <button type="button" class="toolbar-action" :class="{ active: selecionado.sombra }"
                  @click="selecionado.sombra = !selecionado.sombra; sincronizarForma()">◐ Sombra</button>
                <label v-if="selecionado.sombra" class="floating-color" title="Cor da sombra"><span>◐</span>
                  <input v-model="selecionado.corSombra" type="color" @input="sincronizarForma" />
                </label>
                <label v-if="selecionado.sombra" class="shape-number" title="Desfoque da sombra"><span>Blur</span>
                  <input v-model.number="selecionado.blurSombra" type="number" min="0" max="80"
                    @input="sincronizarForma" />
                </label>
                <button class="toolbar-action" @click="duplicarForma">⧉ Duplicar</button>
                <div class="position-picker">
                  <button type="button" class="toolbar-action" @click.stop="alternarMenuPosicao"><span
                      class="toolbar-icon">▱</span> Posição</button>
                  <div v-if="posicaoMenuAberto" class="position-menu">
                    <div class="position-title">Camadas</div>
                    <button @click="executarPosicao('top')"><span>▣</span> Trazer para frente</button>
                    <button @click="executarPosicao('up')"><span>↑</span> Avançar uma camada</button>
                    <button @click="executarPosicao('down')"><span>↓</span> Recuar uma camada</button>
                    <button @click="executarPosicao('bottom')"><span>▤</span> Enviar para trás</button>
                    <div class="position-separator"></div>
                    <div class="position-title">Alinhar no cartaz</div>
                    <div class="align-grid">
                      <button title="Esquerda" @click="alinharSelecionado('left')">⇤</button>
                      <button title="Centro horizontal" @click="alinharSelecionado('center')">↔</button>
                      <button title="Direita" @click="alinharSelecionado('right')">⇥</button>
                      <button title="Topo" @click="alinharSelecionado('top')">⇡</button>
                      <button title="Centro vertical" @click="alinharSelecionado('middle')">↕</button>
                      <button title="Base" @click="alinharSelecionado('bottom')">⇣</button>
                    </div>
                  </div>
                </div>
                <button class="toolbar-action toolbar-danger" @click="excluirSelecionado">🗑 Excluir</button>
              </template>

              <template v-else-if="selecionado.tipo === 'imagem'">
                <span class="selected-image-name">{{ selecionado.nome }}</span>

                <button v-if="!selecionado.backgroundRemovedSrc" class="toolbar-action toolbar-dark"
                  :disabled="removendoBackground" @click="removerFundoSelecionada">
                  {{ removendoBackground ? "Processando..." : "✨ Remover fundo" }}
                </button>
                <template v-else>
                  <button class="toolbar-action version-action"
                    :class="{ active: !selecionado.usarSemFundo }"
                    :disabled="operacaoImagemAtiva" @click="usarOriginal">
                    <span v-if="!selecionado.usarSemFundo">✓ </span>Original
                  </button>
                  <button class="toolbar-action version-action"
                    :class="{ active: selecionado.usarSemFundo }"
                    :disabled="operacaoImagemAtiva" @click="usarSemFundo">
                    <span v-if="selecionado.usarSemFundo">✓ </span>Sem fundo
                  </button>
                </template>

                <select v-model="intensidadeRecorte" class="form-select recorte-select" title="Preservação do recorte">
                  <option value="objeto">Preservar instrumento</option>
                  <option value="suave">Recorte suave</option>
                  <option value="normal">Recorte normal</option>
                  <option value="forte">Recorte forte</option>
                </select>

                <button class="toolbar-action" @click="duplicarImagem">⧉ Duplicar</button>

                <div class="position-picker">
                  <button type="button" class="toolbar-action" @click.stop="alternarMenuPosicao">
                    <span class="toolbar-icon">▱</span>
                    Posição
                  </button>

                  <div v-if="posicaoMenuAberto" class="position-menu">
                    <div class="position-title">Camadas</div>
                    <button @click="executarPosicao('top')"><span>▣</span> Trazer para frente</button>
                    <button @click="executarPosicao('up')"><span>↑</span> Avançar uma camada</button>
                    <button @click="executarPosicao('down')"><span>↓</span> Recuar uma camada</button>
                    <button @click="executarPosicao('bottom')"><span>▤</span> Enviar para trás</button>

                    <div class="position-separator"></div>
                    <div class="position-title">Alinhar no cartaz</div>
                    <div class="align-grid">
                      <button title="Esquerda" @click="alinharSelecionado('left')">⇤</button>
                      <button title="Centro horizontal" @click="alinharSelecionado('center')">↔</button>
                      <button title="Direita" @click="alinharSelecionado('right')">⇥</button>
                      <button title="Topo" @click="alinharSelecionado('top')">⇡</button>
                      <button title="Centro vertical" @click="alinharSelecionado('middle')">↕</button>
                      <button title="Base" @click="alinharSelecionado('bottom')">⇣</button>
                    </div>
                  </div>
                </div>

                <button class="toolbar-action toolbar-danger" @click="removerImagemCartaz">
                  🗑 Excluir
                </button>

                <div v-if="removendoBackground" class="remove-bg-progress" title="Removendo fundo">
                  <div class="remove-bg-progress-bar" :style="{ width: progressoBackground + '%' }"></div>
                  <small>{{ etapaBackground || "Processando" }} · {{ Math.round(progressoBackground) }}%</small>
                </div>
              </template>
            </div>

            <div v-if="erroBackground" class="alert alert-danger py-2 small">{{ erroBackground }}</div>

            <div :class="{ 'designer-processing': removendoBackground }">
              <DesignerCanvas ref="canvas" :dados="cartaz" :imagens="imagensCartaz" :formas="formasCartaz"
                :estilos="estilosTexto" :textos-livres="textosLivres" :background-id="backgroundId"
                @selecionar="selecionar" @atualizar-imagem="atualizarImagem" @atualizar-forma="atualizarForma"
                @atualizar-texto-layout="atualizarTextoLayout" @editar-texto="editarTextoDireto"
                @remover-imagem="removerImagemPorId" @remover-forma="removerFormaPorId"
                @pedir-upload="pedirUploadFotoArtista" @imagem-carregada="onImagemCarregada" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="operacaoImagemAtiva" class="designer-global-loading" role="status" aria-live="polite">
      <div class="designer-global-loading-card">
        <div class="designer-global-spinner"></div>
        <strong>{{ operacaoImagemTexto }}</strong>
        <small v-if="removendoBackground && progressoBackground > 0">
          {{ etapaBackground || "Processando" }} · {{ Math.round(progressoBackground) }}%
        </small>
      </div>
    </div>

    <div v-if="modalImagemAberto" class="image-picker-backdrop" @click.self="fecharModalImagem">
      <div class="image-picker-modal" role="dialog" aria-modal="true" aria-label="Escolher imagem">
        <div class="image-picker-header">
          <div>
            <h5>Escolher imagem</h5>
            <p>Use uma imagem já enviada ou adicione uma nova.</p>
          </div>
          <button type="button" class="image-picker-close" @click="fecharModalImagem" :disabled="enviando">×</button>
        </div>

        <div class="image-picker-quota">
          <div class="image-picker-quota-row">
            <span>Minhas imagens</span>
            <strong :class="{ full: !podeEnviar }">{{ usados }} de {{ limite }}</strong>
          </div>
          <div class="progress upload-progress">
            <div class="progress-bar" :style="{ width: percentualUploads + '%' }"></div>
          </div>
        </div>

        <div v-if="!podeEnviar" class="image-picker-limit">
          Limite de imagens atingido. Você ainda pode usar ou excluir imagens existentes.
        </div>
        <div v-if="erroModalImagem" class="alert alert-danger py-2 small mb-3">{{ erroModalImagem }}</div>

        <div class="image-picker-toolbar">
          <button type="button" class="btn btn-warning fw-bold" :disabled="enviando || !podeEnviar"
            @click="$refs.inputFotoArtista?.click()">
            {{ enviando ? "Enviando..." : (!podeEnviar ? "Limite de imagens atingido" : "+ Enviar nova imagem") }}
          </button>
        </div>

        <div v-if="carregando" class="image-picker-loading">Carregando imagens...</div>
        <div v-else-if="assets.length === 0" class="image-picker-empty">
          Nenhuma imagem enviada ainda.
        </div>
        <div v-else class="image-picker-grid">
          <div v-for="asset in assets" :key="asset.id" class="image-picker-item">
            <div class="image-picker-thumb">
              <img :src="urlAsset(asset.originalUrl)" :alt="asset.originalFileName" />
            </div>
            <div class="image-picker-name" :title="asset.originalFileName">{{ asset.originalFileName }}</div>
            <div class="image-picker-actions">
              <button type="button" class="image-picker-use" @click="usarImagemDoModal(asset)">Usar no cartaz</button>
              <button type="button" class="image-picker-delete" @click="excluirImagemModal(asset)" title="Excluir imagem">×</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DesignerCanvas from "./DesignerCanvas.vue";
import backgrounds from "./backgrounds/backgrounds";
import fonts from "./fonts/fonts";
import { removerBackground, liberarBackgroundUrl } from "./services/backgroundRemovalService";
import {
  listarDesignerAssets,
  enviarDesignerAsset,
  enviarBackgroundRemovidoDesignerAsset,
  excluirDesignerAsset,
  urlDesignerAsset
} from "./services/designerAssetsService";
import {
  listarDesignerPosters,
  garantirDesignerPosterAtivo,
  autosalvarDesignerPoster,
  salvarDesignerPoster,
  criarNovoDesignerPoster,
  criarDesignerPosterDaAgenda,
  abrirDesignerPoster,
  duplicarDesignerPoster,
  excluirDesignerPoster
} from "./services/designerPostersService";

const DEFAULTS = {
  data: { fontId: "bebas-neue", corTexto: "#FFE000", corFundo: "#000000", temFundo: false },
  weekday: { fontId: "oswald", corTexto: "#111111", corFundo: "#FFE000", temFundo: true },
  chamada: { fontId: "pacifico", corTexto: "#FFFFFF", corFundo: "#000000", temFundo: false },
  showLabel: { fontId: "permanent-marker", corTexto: "#FFFFFF", corFundo: "#000000", temFundo: true },
  artista: { fontId: "permanent-marker", corTexto: "#FFFFFF", corFundo: "#000000", temFundo: true },
  estabelecimento: { fontId: "oswald", corTexto: "#FFFFFF", corFundo: "#4A2818", temFundo: true },
  cidadeHorario: { fontId: "oswald", corTexto: "#FFFFFF", corFundo: "#000000", temFundo: false },
  extra: { fontId: "bangers", corTexto: "#FFFFFF", corFundo: "#ED1C24", temFundo: true }
};

export default {
  name: "SevenDesigner",
  components: { DesignerCanvas },

  data() {
    return {
      fontes: fonts,
      backgrounds,
      backgroundId: "show-luzes-01",
      cartaz: {
        artista: "Banda Quatro", data: "2026-09-18", horario: "20:30",
        local: "Fazenda Monte Belo", cidade: "Maringá - PR",
        chamada: "Música boa é aqui!", extra: "Show ao vivo"
      },
      estilosTexto: JSON.parse(JSON.stringify(DEFAULTS)),
      assets: [], usados: 0, limite: 10, podeEnviar: true,
      carregando: false, enviando: false, erroUploads: null,
      imagensCartaz: [],
      formasCartaz: [],
      selecionado: null,
      fontMenuAberto: false,
      posicaoMenuAberto: false,
      removendoBackground: false,
      progressoBackground: 0,
      erroBackground: null,
      textosLivres: [],
      menuAdicionarTexto: false,
      menuAdicionarForma: false,
      painelLateralAberto: null,
      intensidadeRecorte: "objeto",
      etapaBackground: "",
      posters: [],
      posterAtivo: null,
      postersUsados: 0,
      postersLimite: 0,
      postersPodeCriar: false,
      carregandoPosters: false,
      trocandoPoster: false,
      erroPosters: null,
      statusAutosave: "pronto",
      autosaveTimer: null,
      autosaveSuspenso: true,
      ultimoStateSalvo: null,
      modalImagemAberto: false,
      erroModalImagem: null,
      operacaoImagemAtiva: false,
      operacaoImagemTexto: "",
      aguardandoImagemSrc: null
    };
  },

  computed: {
    fonteSelecionada() {
      if (!this.selecionado || this.selecionado.tipo !== "texto") return null;
      return this.fontes.find(f => f.id === this.selecionado.fontId) || null;
    },
    backgroundAtualNome() {
      return this.backgrounds.find(b => b.id === this.backgroundId)?.nome || "";
    },
    percentualPosters() {
      if (this.postersLimite <= 0) return 0;
      return Math.min(100, Math.round((this.postersUsados / this.postersLimite) * 100));
    },
    percentualUploads() {
      if (this.limite <= 0) return 0;
      return Math.min(100, Math.round((this.usados / this.limite) * 100));
    },
    textoStatusAutosave() {
      if (this.statusAutosave === "salvando") return "Salvando...";
      if (this.statusAutosave === "erro") return "Erro ao salvar";
      if (this.statusAutosave === "alterado") return "Alterações pendentes";
      return "✓ Salvo automaticamente";
    }
  },

  watch: {
    cartaz: { deep: true, handler() { this.agendarAutosave(); } },
    estilosTexto: { deep: true, handler() { this.agendarAutosave(); } },
    imagensCartaz: { deep: true, handler() { this.agendarAutosave(); } },
    formasCartaz: { deep: true, handler() { this.agendarAutosave(); } },
    textosLivres: { deep: true, handler() { this.agendarAutosave(); } },
    backgroundId() { this.agendarAutosave(); }
  },

  async mounted() {
    document.addEventListener("click", this.fecharMenusContextuais);
    await Promise.all([
      this.carregarUploads(),
      this.inicializarCartazes()
    ]);
    await this.aplicarContextoAgendaSeExistir();
  },

  beforeUnmount() {
    document.removeEventListener("click", this.fecharMenusContextuais);
    if (this.autosaveTimer) clearTimeout(this.autosaveTimer);
    // Faz uma última tentativa de persistência sem bloquear a saída da tela.
    this.autosalvarAgora().catch(() => { });
    this.imagensCartaz.forEach(i => {
      if (i.backgroundRemovedSrc?.startsWith("blob:")) liberarBackgroundUrl(i.backgroundRemovedSrc);
    });
  },

  methods: {
    urlAsset(url) { return urlDesignerAsset(url); },

    async aplicarContextoAgendaSeExistir() {
      const raw = sessionStorage.getItem("sevenDesignerEventContext");
      if (!raw) return;

      let contexto;
      try { contexto = JSON.parse(raw); } catch {
        sessionStorage.removeItem("sevenDesignerEventContext");
        return;
      }
      if (!contexto || contexto.origem !== "agenda") return;
      sessionStorage.removeItem("sevenDesignerEventContext");

      const dataHora = contexto.eventDate ? new Date(contexto.eventDate) : null;
      const dataValida = dataHora && !Number.isNaN(dataHora.getTime());
      const data = dataValida ? `${dataHora.getFullYear()}-${String(dataHora.getMonth() + 1).padStart(2, "0")}-${String(dataHora.getDate()).padStart(2, "0")}` : "";
      const horario = dataValida ? `${String(dataHora.getHours()).padStart(2, "0")}:${String(dataHora.getMinutes()).padStart(2, "0")}` : "";
      const dataNome = dataValida ? `${String(dataHora.getDate()).padStart(2, "0")}-${String(dataHora.getMonth() + 1).padStart(2, "0")}` : "Show";
      const localNome = contexto.venueName || contexto.city || "Evento";
      const nomeDraft = `Show ${dataNome} - ${localNome}`.slice(0, 120);

      this.trocandoPoster = true;
      this.autosaveSuspenso = true;
      try {
        const resultado = await criarDesignerPosterDaAgenda(contexto.eventId, nomeDraft);
        const poster = resultado?.poster || resultado;
        this.aplicarEstadoPoster(poster);
        // Mantém um índice local do vínculo evento -> cartaz. O backend continua
        // sendo a fonte principal; isto garante o rótulo correto ao voltar à Agenda.
        if (contexto.eventId) {
          const posterId = poster?.id || poster?.Id || "linked";
          localStorage.setItem(`sevenDesignerPosterEvent:${String(contexto.eventId).toLowerCase()}`, String(posterId));
        }
        await this.carregarCartazes();

        // Cartaz já vinculado ao evento: preserva as edições do músico.
        // Apenas corrige os rótulos legados do layout da Agenda, sem reinjetar
        // data, local, artista, imagens ou qualquer outro conteúdo.
        if (resultado?.created === false) {
          const chamadaAtual = String(this.cartaz?.chamada || this.estilosTexto?.chamada?.textoOverride || "").trim().toLowerCase();
          const showAtual = String(this.estilosTexto?.showLabel?.textoOverride || "").trim().toLowerCase();

          if (["", "show", "show ao vivo", "noite de música"].includes(chamadaAtual)) {
            this.cartaz.chamada = "IMPERDÍVEL!!!";
            this.estilosTexto.chamada.oculto = false;
            this.estilosTexto.chamada.textoOverride = "IMPERDÍVEL!!!";
            this.estilosTexto.chamada.layout = { x: 300, y: 205, w: 460, h: 82, size: 42, align: "center", zIndex: 209 };
          }

          if (["", "show ao", "show ao vivo"].includes(showAtual)) {
            this.estilosTexto.showLabel.textoOverride = "SHOW AO VIVO";
            this.estilosTexto.showLabel.layout = { x: 115, y: 1040, w: 520, h: 90, size: 46, align: "center", zIndex: 210 };
          }

          this.autosaveSuspenso = false;
          this.agendarAutosave();
          return;
        }
      } catch (e) {
        this.erroPosters = this.mensagemErroApi(e, "Erro ao criar um novo cartaz para este show.");
        this.autosaveSuspenso = false;
        return;
      } finally {
        this.trocandoPoster = false;
      }

      // Sem fallback para dados do cartaz anterior.
      this.cartaz = {
        ...this.cartaz,
        data,
        horario,
        local: contexto.venueName || "",
        cidade: [contexto.city, contexto.state].filter(Boolean).join(" - "),
        chamada: contexto.eventType || "Show ao vivo",
        extra: "NOME DO EVENTO"
      };
      this.imagensCartaz = [];
      this.formasCartaz = [];
      this.textosLivres = [];

      // Layout exclusivo do cartaz criado pela Agenda: preserva a área central
      // para a foto do artista e mantém todo o rodapé dentro da safe area.
      this.estilosTexto = JSON.parse(JSON.stringify(DEFAULTS));
      this.cartaz.chamada = "IMPERDÍVEL!!!";
      this.estilosTexto.chamada.oculto = false;
      this.estilosTexto.chamada.textoOverride = "IMPERDÍVEL!!!";
      this.estilosTexto.chamada.layout = { x: 300, y: 205, w: 460, h: 82, size: 42, align: "center", zIndex: 209 };
      this.estilosTexto.showLabel.textoOverride = "SHOW AO VIVO";
      this.estilosTexto.showLabel.layout = { x: 115, y: 1040, w: 520, h: 90, size: 46, align: "center", zIndex: 210 };
      this.estilosTexto.artista.layout = { x: 95, y: 1145, w: 890, h: 180, size: 118, align: "center", zIndex: 211 };
      this.estilosTexto.estabelecimento.layout = { x: 135, y: 1365, w: 810, h: 140, size: 66, align: "center", zIndex: 212 };
      this.estilosTexto.cidadeHorario.layout = { x: 140, y: 1530, w: 800, h: 85, size: 43, align: "center", zIndex: 213 };
      this.estilosTexto.extra.layout = { x: 170, y: 1650, w: 740, h: 105, size: 48, align: "center", zIndex: 214 };

      if (contexto.contractorLogoUrl) {
        const id = `logo-agenda-${Date.now()}`;
        this.imagensCartaz.push({
          elementId: id, tipo: "imagem", assetId: null, nome: "Logo do contratante",
          originalSrc: contexto.contractorLogoUrl, backgroundRemovedSrc: null,
          src: contexto.contractorLogoUrl, usarSemFundo: false, origemAgendaLogo: true,
          x: 820, y: 55, width: 190, height: 135, rotation: 0, zIndex: 120
        });
      }

      this.autosaveSuspenso = false;
      this.statusAutosave = "alterado";
      this.$nextTick(() => this.agendarAutosave());
    },

    async baixarCartaz() {
      if (this.operacaoImagemAtiva) return;

      this.iniciarLoadingImagem("Gerando cartaz em 1080 × 1920...");
      try {
        // Fecha menus/seleção visual antes da exportação. O Transformer também
        // é ocultado pelo próprio DesignerCanvas durante a geração do PNG.
        this.fontMenuAberto = false;
        this.posicaoMenuAberto = false;

        const dataUrl = await this.$refs.canvas?.exportarPng?.();
        if (!dataUrl) throw new Error("Não foi possível gerar a imagem do cartaz.");

        const nomeBase = (this.posterAtivo?.name || this.cartaz?.artista || "cartaz-seven-shows")
          .normalize("NFD")
          .replace(/[\u0300-\u036f]/g, "")
          .replace(/[^a-zA-Z0-9-_]+/g, "-")
          .replace(/^-+|-+$/g, "")
          .toLowerCase() || "cartaz-seven-shows";

        const link = document.createElement("a");
        link.href = dataUrl;
        link.download = `${nomeBase}.png`;
        document.body.appendChild(link);
        link.click();
        link.remove();
      } catch (e) {
        console.error("[SEVEN DESIGNER] Erro ao baixar cartaz:", e);
        alert(e?.message || "Não foi possível baixar o cartaz.");
      } finally {
        this.finalizarLoadingImagem();
      }
    },

    estadoInicialDesigner() {
      return {
        cartaz: {
          artista: "Banda Quatro", data: "2026-09-18", horario: "20:30",
          local: "Fazenda Monte Belo", cidade: "Maringá - PR",
          chamada: "Música boa é aqui!", extra: "Show ao vivo"
        },
        estilosTexto: JSON.parse(JSON.stringify(DEFAULTS)),
        imagensCartaz: [],
        formasCartaz: [],
        textosLivres: [],
        backgroundId: "show-luzes-01",
        templateId: "sertanejo-sunset"
      };
    },

    serializarEstado() {
      // blob: é temporário e não sobrevive a um reload do navegador.
      // Até a próxima etapa (persistir o PNG recortado no backend),
      // o autosave guarda a imagem original como fallback durável.
      const imagens = this.imagensCartaz.map(img => {
        const copia = { ...img };
        if (copia.backgroundRemovedSrc?.startsWith("blob:")) {
          copia.backgroundRemovedSrc = null;
          copia.src = copia.originalSrc;
          copia.usarSemFundo = false;
        }
        return copia;
      });

      return {
        version: 1,
        cartaz: JSON.parse(JSON.stringify(this.cartaz)),
        estilosTexto: JSON.parse(JSON.stringify(this.estilosTexto)),
        imagensCartaz: JSON.parse(JSON.stringify(imagens)),
        formasCartaz: JSON.parse(JSON.stringify(this.formasCartaz)),
        textosLivres: JSON.parse(JSON.stringify(this.textosLivres)),
        backgroundId: this.backgroundId,
        templateId: "sertanejo-sunset"
      };
    },

    aplicarEstadoPoster(poster) {
      this.autosaveSuspenso = true;
      this.selecionado = null;
      this.fontMenuAberto = false;
      this.posicaoMenuAberto = false;

      let state = null;
      try {
        state = poster?.stateJson ? JSON.parse(poster.stateJson) : null;
      } catch {
        state = null;
      }

      const base = this.estadoInicialDesigner();
      const temEstado = state && typeof state === "object" && Object.keys(state).length > 0;

      this.cartaz = temEstado && state.cartaz
        ? { ...base.cartaz, ...state.cartaz }
        : { ...base.cartaz };

      this.estilosTexto = temEstado && state.estilosTexto
        ? { ...JSON.parse(JSON.stringify(DEFAULTS)), ...state.estilosTexto }
        : JSON.parse(JSON.stringify(DEFAULTS));

      this.imagensCartaz = Array.isArray(state?.imagensCartaz) ? state.imagensCartaz : [];
      this.formasCartaz = Array.isArray(state?.formasCartaz) ? state.formasCartaz : [];
      this.textosLivres = Array.isArray(state?.textosLivres) ? state.textosLivres : [];
      this.backgroundId = state?.backgroundId || poster?.backgroundId || base.backgroundId;

      this.posterAtivo = poster;
      this.statusAutosave = "pronto";
      this.ultimoStateSalvo = JSON.stringify(this.serializarEstado());

      this.$nextTick(() => {
        this.autosaveSuspenso = false;
        this.$refs.canvas?.limparSelecao?.();
      });
    },

    async inicializarCartazes() {
      this.carregandoPosters = true;
      this.erroPosters = null;
      this.autosaveSuspenso = true;

      try {
        const ativo = await garantirDesignerPosterAtivo();
        this.aplicarEstadoPoster(ativo);
        await this.carregarCartazes();
      } catch (e) {
        this.erroPosters = e?.response?.data?.message || e?.message || "Erro ao carregar o cartaz em edição.";
        this.autosaveSuspenso = false;
      } finally {
        this.carregandoPosters = false;
      }
    },

    async carregarCartazes() {
      try {
        const r = await listarDesignerPosters();
        this.posters = r?.items || [];
        this.postersUsados = Number(r?.used || 0);
        this.postersLimite = Number(r?.limit || 0);
        this.postersPodeCriar = Boolean(r?.canCreate);

        if (this.posterAtivo?.id) {
          const atualizado = this.posters.find(p => p.id === this.posterAtivo.id);
          if (atualizado) this.posterAtivo = { ...this.posterAtivo, ...atualizado };
        }
      } catch (e) {
        this.erroPosters = e?.response?.data?.message || e?.message || "Erro ao listar cartazes.";
      }
    },

    agendarAutosave() {
      if (this.autosaveSuspenso || !this.posterAtivo?.id || this.trocandoPoster) return;

      const atual = JSON.stringify(this.serializarEstado());
      if (atual === this.ultimoStateSalvo) return;

      this.statusAutosave = "alterado";
      if (this.autosaveTimer) clearTimeout(this.autosaveTimer);

      this.autosaveTimer = setTimeout(() => {
        this.autosalvarAgora();
      }, 2500);
    },

    async autosalvarAgora() {
      if (this.autosaveSuspenso || !this.posterAtivo?.id || this.trocandoPoster) return;
      if (this.autosaveTimer) {
        clearTimeout(this.autosaveTimer);
        this.autosaveTimer = null;
      }

      const state = this.serializarEstado();
      const stateJson = JSON.stringify(state);
      if (stateJson === this.ultimoStateSalvo) {
        this.statusAutosave = "pronto";
        return;
      }

      this.statusAutosave = "salvando";
      try {
        const r = await autosalvarDesignerPoster(this.posterAtivo.id, {
          templateId: state.templateId,
          backgroundId: state.backgroundId,
          stateJson,
          previewUrl: this.posterAtivo.previewUrl || null
        });

        this.ultimoStateSalvo = stateJson;
        this.statusAutosave = "pronto";
        this.posterAtivo = {
          ...this.posterAtivo,
          updatedAt: r?.updatedAt || this.posterAtivo.updatedAt
        };
      } catch (e) {
        this.statusAutosave = "erro";
        this.erroPosters = e?.response?.data?.message || e?.message || "Erro no salvamento automático.";
        throw e;
      }
    },

    async abrirCartazSalvo(poster) {
      if (!poster?.id || poster.id === this.posterAtivo?.id || this.trocandoPoster) return;

      this.erroPosters = null;

      try {
        await this.autosalvarAgora();
      } catch {
        return;
      }

      this.trocandoPoster = true;

      try {
        const aberto = await abrirDesignerPoster(poster.id);
        this.aplicarEstadoPoster(aberto);
        await this.carregarCartazes();
      } catch (e) {
        this.erroPosters = e?.response?.data?.message || e?.message || "Erro ao abrir cartaz.";
      } finally {
        this.trocandoPoster = false;
      }
    },

    async novoCartaz() {
      if (this.trocandoPoster) return;
      this.erroPosters = null;

      // Nunca abandona um rascunho em edição. Antes de criar outro cartaz,
      // o atual precisa ser salvo/nomeado. Se o músico cancelar, nada muda.
      if (this.posterAtivo?.isDraft) {
        if (!this.postersPodeCriar) {
          this.erroPosters = `Limite de cartazes atingido (${this.postersUsados}/${this.postersLimite}). Salve espaço excluindo um cartaz antes de criar outro.`;
          return;
        }

        const salvo = await this.salvarNomeCartaz(this.posterAtivo, { paraCriarNovo: true });
        if (!salvo) return;
      }

      // Faz o flush ANTES de bloquear a troca.
      try {
        await this.autosalvarAgora();
      } catch {
        return;
      }

      this.trocandoPoster = true;

      try {
        const novo = await criarNovoDesignerPoster();
        this.aplicarEstadoPoster(novo);
        await this.carregarCartazes();
      } catch (e) {
        this.erroPosters = this.mensagemErroApi(e, "Erro ao criar novo cartaz.");
      } finally {
        this.trocandoPoster = false;
      }
    },

    async salvarNomeCartaz(poster = this.posterAtivo, options = {}) {
      if (!poster?.id) return false;

      if (poster.id === this.posterAtivo?.id) {
        try { await this.autosalvarAgora(); } catch { return false; }
      }

      const nomeAtual = poster.isDraft ? "" : (poster.name || "");
      const mensagem = options.paraCriarNovo
        ? "Salve o cartaz atual antes de criar outro. Informe um nome:"
        : (poster.isDraft ? "Nome para salvar este cartaz:" : "Novo nome do cartaz:");

      const nome = window.prompt(mensagem, nomeAtual);
      if (nome === null) return false;

      const nomeLimpo = nome.trim();
      if (!nomeLimpo) {
        this.erroPosters = "Informe um nome para salvar o cartaz atual.";
        return false;
      }

      try {
        const salvo = await salvarDesignerPoster(poster.id, nomeLimpo);
        if (poster.id === this.posterAtivo?.id) {
          this.posterAtivo = { ...this.posterAtivo, ...salvo, name: nomeLimpo, isDraft: false };
        }
        await this.carregarCartazes();
        return true;
      } catch (e) {
        this.erroPosters = this.mensagemErroApi(e, "Erro ao salvar cartaz.");
        return false;
      }
    },

    async duplicarCartazSalvo(poster) {
      if (!poster?.id || poster.isDraft || !this.postersPodeCriar) return;
      try {
        if (poster.id === this.posterAtivo?.id) await this.autosalvarAgora();
        await duplicarDesignerPoster(poster.id);
        await this.carregarCartazes();
      } catch (e) {
        this.erroPosters = e?.response?.data?.message || e?.message || "Erro ao duplicar cartaz.";
      }
    },

    async excluirCartazSalvo(poster) {
      if (!poster?.id) return;
      if (!confirm(`Excluir "${poster.name}"?`)) return;

      try {
        const eraAtivo = poster.id === this.posterAtivo?.id;
        await excluirDesignerPoster(poster.id);

        if (eraAtivo) {
          const ativo = await garantirDesignerPosterAtivo();
          this.aplicarEstadoPoster(ativo);
        }

        await this.carregarCartazes();
      } catch (e) {
        this.erroPosters = e?.response?.data?.message || e?.message || "Erro ao excluir cartaz.";
      }
    },

    fecharMenusContextuais() {
      this.fontMenuAberto = false;
      this.posicaoMenuAberto = false;
      this.menuAdicionarTexto = false;
      this.menuAdicionarForma = false;
    },

    selecionarFonte(fonte) {
      if (!this.selecionado || this.selecionado.tipo !== "texto") return;
      this.selecionado.fontId = fonte.id;
      this.fontMenuAberto = false;
      this.sincronizarTexto();
    },

    alternarMenuPosicao() {
      this.posicaoMenuAberto = !this.posicaoMenuAberto;
      this.fontMenuAberto = false;
    },

    executarPosicao(direcao) {
      this.moverSelecionado(direcao);
      this.posicaoMenuAberto = false;
    },

    alinharSelecionado(alinhamento) {
      this.$refs.canvas?.alinharSelecionado?.(alinhamento);
      this.posicaoMenuAberto = false;
    },

    mensagemErroApi(erro, fallback = "Ocorreu um erro.") {
      return erro?.response?.data?.message ||
        erro?.response?.data?.title ||
        erro?.message ||
        fallback;
    },

    avisarLimiteUploads() {
      const usados = Number(this.usados || 0);
      const limite = Number(this.limite || 0);
      this.erroUploads = limite > 0
        ? `Limite de uploads atingido (${usados}/${limite}). Exclua uma imagem para liberar espaço.`
        : "Seu plano não permite novos uploads.";
    },

    pedirUploadFotoArtista() {
      this.erroModalImagem = null;
      this.modalImagemAberto = true;
    },

    fecharModalImagem() {
      if (this.enviando) return;
      this.modalImagemAberto = false;
      this.erroModalImagem = null;
    },

    async usarImagemDoModal(asset) {
      if (!asset?.id) return;
      this.modalImagemAberto = false;
      this.erroModalImagem = null;
      await this.adicionarImagemComLoading(asset, { fotoPrincipal: true });
    },

    async adicionarImagemGaleria(asset) {
      await this.adicionarImagemComLoading(asset);
    },

    async adicionarImagemComLoading(asset, options = {}) {
      if (!asset?.id) return;
      this.iniciarLoadingImagem("Adicionando imagem ao designer...");
      try {
        const item = this.adicionarAoCartaz(asset, options);
        if (item?.src) await this.aguardarImagemCanvas(item.src);
      } finally {
        this.finalizarLoadingImagem();
      }
    },

    async excluirImagemModal(asset) {
      if (!asset?.id) return;
      if (!confirm(`Excluir "${asset.originalFileName}" das suas imagens?`)) return;

      try {
        await excluirDesignerAsset(asset.id);
        await this.carregarUploads();
        this.erroModalImagem = null;
      } catch (e) {
        this.erroModalImagem = this.mensagemErroApi(e, "Erro ao excluir a imagem.");
      }
    },

    async carregarUploads() {
      this.carregando = true;
      this.erroUploads = null;
      try {
        const r = await listarDesignerAssets();
        this.assets = r?.items || [];
        this.usados = Number(r?.used || 0);
        this.limite = Number(r?.limit || 0);
        this.podeEnviar = Boolean(r?.canUpload);
      } catch (e) {
        this.erroUploads = this.mensagemErroApi(e, "Erro ao carregar uploads.");
      } finally {
        this.carregando = false;
      }
    },

    async enviarUpload(e) {
      const file = e.target.files?.[0];
      e.target.value = "";
      if (!file) return;

      if (!this.podeEnviar) {
        this.avisarLimiteUploads();
        return;
      }

      this.enviando = true;
      this.erroUploads = null;
      try {
        await enviarDesignerAsset(file);
        await this.carregarUploads();
      } catch (err) {
        this.erroUploads = this.mensagemErroApi(err, "Erro no upload.");
        if (err?.response?.status === 400) await this.carregarUploads().catch(() => {});
      } finally {
        this.enviando = false;
      }
    },

    async enviarFotoArtista(e) {
      const file = e.target.files?.[0];
      e.target.value = "";
      if (!file) return;

      if (!this.podeEnviar) {
        const usados = Number(this.usados || 0);
        const limite = Number(this.limite || 0);
        this.erroModalImagem = limite > 0
          ? `Limite de imagens atingido (${usados}/${limite}). Exclua uma imagem para liberar espaço.`
          : "Seu plano não permite novas imagens.";
        return;
      }

      this.enviando = true;
      this.erroModalImagem = null;

      try {
        const enviado = await enviarDesignerAsset(file);
        await this.carregarUploads();

        const asset =
          enviado?.item ||
          enviado?.asset ||
          enviado ||
          this.assets.find(a => a.originalFileName === file.name) ||
          this.assets[0];

        if (asset?.id) {
          this.adicionarAoCartaz(asset, { fotoPrincipal: true });
          this.modalImagemAberto = false;
          this.erroModalImagem = null;
        }
      } catch (err) {
        this.erroModalImagem = this.mensagemErroApi(err, "Erro ao enviar a foto do artista.");
        if (err?.response?.status === 400) await this.carregarUploads().catch(() => {});
      } finally {
        this.enviando = false;
      }
    },

    async excluirUpload(asset) {
      if (!confirm(`Remover "${asset.originalFileName}" de Minhas imagens?\n\nSe ela estiver sendo usada em algum cartaz, continuará preservada nesse cartaz.`)) return;

      this.erroUploads = null;

      try {
        const resposta = await excluirDesignerAsset(asset.id);
        await this.carregarUploads();

        const mensagem = resposta?.message;
        if (mensagem) alert(mensagem);
      } catch (e) {
        this.erroUploads = e?.response?.data?.message || e?.message || "Erro ao excluir a imagem.";
      }
    },

    adicionarAoCartaz(asset, options = {}) {
      if (this.imagensCartaz.length >= 5) { alert("Máximo de 5 imagens no cartaz nesta versão."); return; }
      const n = this.imagensCartaz.length;
      const fotoPrincipal = Boolean(options.fotoPrincipal);
      const id = `img-${Date.now()}-${Math.random().toString(16).slice(2)}`;
      const item = {
        elementId: id, tipo: "imagem", assetId: asset.id, nome: asset.originalFileName,
        originalSrc: this.urlAsset(asset.originalUrl),
        backgroundRemovedSrc: asset.backgroundRemovedUrl ? this.urlAsset(asset.backgroundRemovedUrl) : null,
        src: this.urlAsset(asset.backgroundRemovedUrl || asset.originalUrl),
        usarSemFundo: Boolean(asset.backgroundRemovedUrl),
        x: fotoPrincipal ? 110 : 110 + n * 35,
        y: fotoPrincipal ? 300 : 300 + n * 35,
        width: fotoPrincipal ? 860 : (n === 0 ? 860 : 520),
        height: fotoPrincipal ? 920 : (n === 0 ? 920 : 620),
        rotation: 0
      };
      this.imagensCartaz.push(item);
      this.selecionado = item;
      this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(id, "imagem"));
      return item;
    },

    selecionar(payload) {
      this.fontMenuAberto = false;
      this.posicaoMenuAberto = false;

      if (!payload?.id || !payload?.tipo) {
        this.selecionado = null;
        return;
      }

      if (payload.tipo === "imagem") {
        this.selecionado =
          this.imagensCartaz.find(i => i.elementId === payload.id) || null;
        return;
      }

      if (payload.tipo === "forma") {
        this.selecionado = this.formasCartaz.find(f => f.elementId === payload.id) || null;
        return;
      }

      const estilo = this.estilosTexto[payload.id];
      if (!estilo) {
        this.selecionado = null;
        return;
      }

      this.selecionado = {
        tipo: "texto",
        id: payload.id,
        texto: payload.texto,
        fontId: estilo.fontId,
        corTexto: estilo.corTexto,
        corFundo: estilo.corFundo,
        temFundo: estilo.temFundo
      };
    },

    editarTextoDireto(payload) {
      if (!payload?.id || payload.cancelado) return;

      this.selecionar({
        id: payload.id,
        tipo: "texto",
        texto: payload.texto
      });

      if (this.selecionado?.tipo === "texto") {
        this.selecionado.texto = payload.texto;
        this.sincronizarTexto();
      }
    },

    removerImagemPorId(elementId) {
      this.imagensCartaz =
        this.imagensCartaz.filter(i => i.elementId !== elementId);

      if (this.selecionado?.elementId === elementId) {
        this.selecionado = null;
      }
    },

    sincronizarTexto() {
      const s = this.selecionado;
      if (!s || s.tipo !== "texto") return;

      const estilo = this.estilosTexto[s.id];
      if (!estilo) return;

      estilo.fontId = s.fontId;
      estilo.corTexto = s.corTexto;
      estilo.corFundo = s.corFundo;
      estilo.temFundo = Boolean(s.temFundo);

      // Data é estrutural: nunca gravar "18/09" sobre YYYY-MM-DD.
      if (s.id === "data") {
        // Apenas estilo/layout da data é editável aqui.
      } else if (s.id === "weekday") {
        // O dia continua derivado da data. Só cria override se o usuário
        // realmente alterar o texto mostrado.
        const derivado = this.$refs.canvas?.weekday;
        if (s.texto && s.texto !== derivado) estilo.textoOverride = s.texto;
      } else if (s.id === "chamada") this.cartaz.chamada = s.texto;
      else if (s.id === "showLabel") estilo.textoOverride = s.texto;
      else if (s.id === "artista") this.cartaz.artista = s.texto;
      else if (s.id === "estabelecimento") this.cartaz.local = s.texto;
      else if (s.id === "cidadeHorario") estilo.textoOverride = s.texto;
      else if (s.id === "extra") this.cartaz.extra = s.texto;
      else if (s.id.startsWith("livre-")) {
        const livre = this.textosLivres.find(t => t.id === s.id);
        if (livre) livre.texto = s.texto;
        estilo.textoOverride = s.texto;
      }

      this.$forceUpdate();
    },

    alternarFundoTexto() {
      if (!this.selecionado || this.selecionado.tipo !== "texto") return;
      this.selecionado.temFundo = !this.selecionado.temFundo;
      this.sincronizarTexto();
    },

    duplicarTexto() {
      const s = this.selecionado;
      if (!s || s.tipo !== "texto") return;

      const origem = this.estilosTexto[s.id] || {};
      const layoutOrigem = origem.layout || {};
      const id = `livre-${Date.now()}-${Math.random().toString(16).slice(2)}`;
      const texto = s.texto || origem.textoOverride || "Texto";

      this.estilosTexto[id] = {
        ...JSON.parse(JSON.stringify(origem)),
        textoOverride: texto,
        layout: {
          ...JSON.parse(JSON.stringify(layoutOrigem)),
          x: Number(layoutOrigem.x || 0) + 35,
          y: Number(layoutOrigem.y || 0) + 35
        }
      };

      this.textosLivres.push({ id, texto });
      this.$forceUpdate();

      this.$nextTick(() => {
        this.$refs.canvas?.selecionarExterno?.(id, "texto");
        this.selecionar({ id, tipo: "texto", texto });
      });
    },

    nomeForma(tipo) {
      return ({ quadrado: "Quadrado", retangulo: "Retângulo", circulo: "Círculo" })[tipo] || "Forma";
    },

    adicionarForma(tipo = "retangulo") {
      this.menuAdicionarForma = false;
      const id = `forma-${Date.now()}-${Math.random().toString(16).slice(2)}`;
      const proporcional = tipo === "quadrado" || tipo === "circulo";
      const forma = {
        elementId: id, tipo: "forma", forma: tipo,
        x: proporcional ? 390 : 240, y: 760,
        width: proporcional ? 300 : 600, height: proporcional ? 300 : 220,
        rotation: 0, cor: "#ffffff", corBorda: "#111111", espessuraBorda: 0,
        opacidade: .85, sombra: false, corSombra: "#000000", blurSombra: 20,
        offsetSombraX: 10, offsetSombraY: 10
      };
      this.formasCartaz.push(forma);
      this.selecionado = forma;
      this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(id, "forma"));
    },

    atualizarForma(p) {
      const i = this.formasCartaz.findIndex(f => f.elementId === p.elementId);
      if (i < 0) return;
      this.formasCartaz[i] = { ...this.formasCartaz[i], ...p };
      if (this.selecionado?.elementId === p.elementId) this.selecionado = this.formasCartaz[i];
    },

    sincronizarForma() {
      const s = this.selecionado;
      if (!s || s.tipo !== "forma") return;
      this.atualizarForma({
        elementId: s.elementId, cor: s.cor, corBorda: s.corBorda,
        espessuraBorda: Math.max(0, Number(s.espessuraBorda || 0)),
        opacidade: Math.max(.05, Math.min(1, Number(s.opacidade || 1))),
        sombra: Boolean(s.sombra), corSombra: s.corSombra,
        blurSombra: Math.max(0, Number(s.blurSombra || 0))
      });
    },

    duplicarForma() {
      const f = this.selecionado;
      if (!f || f.tipo !== "forma") return;
      const copia = { ...f, elementId: `forma-${Date.now()}-${Math.random().toString(16).slice(2)}`, x: f.x + 35, y: f.y + 35 };
      this.formasCartaz.push(copia);
      this.selecionado = copia;
      this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(copia.elementId, "forma"));
    },

    removerFormaPorId(elementId) {
      this.formasCartaz = this.formasCartaz.filter(f => f.elementId !== elementId);
      if (this.selecionado?.elementId === elementId) this.selecionado = null;
    },

    atualizarTextoLayout(p) {
      if (!p?.id || !p?.layout) return;

      const estiloAtual = this.estilosTexto[p.id] || {};

      this.estilosTexto[p.id] = {
        ...estiloAtual,
        layout: {
          ...(estiloAtual.layout || {}),
          ...p.layout
        }
      };
    },

    atualizarImagem(p) {
      const i = this.imagensCartaz.findIndex(x => x.elementId === p.elementId);
      if (i < 0) return;
      this.imagensCartaz[i] = { ...this.imagensCartaz[i], ...p };
      if (this.selecionado?.elementId === p.elementId) this.selecionado = this.imagensCartaz[i];
    },

    async obterArquivo(imagem) {
      const r = await fetch(imagem.originalSrc);
      if (!r.ok) throw new Error("Não foi possível carregar a imagem original.");
      const blob = await r.blob();
      return new File([blob], imagem.nome || "imagem.jpg", { type: blob.type || "image/jpeg" });
    },

    iniciarLoadingImagem(texto) {
      this.operacaoImagemAtiva = true;
      this.operacaoImagemTexto = texto || "Processando imagem...";
    },

    finalizarLoadingImagem() {
      this.operacaoImagemAtiva = false;
      this.operacaoImagemTexto = "";
      this.aguardandoImagemSrc = null;
      if (this._resolverImagemCanvas) {
        clearTimeout(this._timeoutImagemCanvas);
        this._resolverImagemCanvas();
        this._resolverImagemCanvas = null;
      }
    },

    aguardarImagemCanvas(src) {
      if (!src) return Promise.resolve();
      this.aguardandoImagemSrc = src;
      return new Promise(resolve => {
        this._resolverImagemCanvas = resolve;
        clearTimeout(this._timeoutImagemCanvas);
        this._timeoutImagemCanvas = setTimeout(() => {
          this._resolverImagemCanvas = null;
          this.aguardandoImagemSrc = null;
          resolve();
        }, 12000);
      });
    },

    onImagemCarregada(payload) {
      if (!this._resolverImagemCanvas || !this.aguardandoImagemSrc) return;
      if (payload?.src !== this.aguardandoImagemSrc) return;
      clearTimeout(this._timeoutImagemCanvas);
      const resolver = this._resolverImagemCanvas;
      this._resolverImagemCanvas = null;
      this.aguardandoImagemSrc = null;
      resolver();
    },

    async removerFundoSelecionada() {
      const imagem = this.selecionado;
      if (!imagem || imagem.tipo !== "imagem" || this.removendoBackground) return;

      if (!imagem.assetId) {
        this.erroBackground = "Esta imagem não possui um asset persistido.";
        return;
      }

      this.removendoBackground = true;
      this.iniciarLoadingImagem("Removendo fundo da imagem...");
      this.progressoBackground = 0;
      this.etapaBackground = "Preparando";
      this.erroBackground = null;
      let urlTemporaria = null;

      try {
        const file = await this.obterArquivo(imagem);
        const resultado = await removerBackground(file, {
          intensidade: this.intensidadeRecorte,
          onProgress: (p) => {
            const valor = Number(p?.progress ?? 0);
            this.progressoBackground = Math.max(0, Math.min(100, valor <= 1 ? valor * 100 : valor));
            this.etapaBackground = p?.etapa || this.etapaBackground;
          }
        });

        urlTemporaria = resultado.url;
        this.etapaBackground = "Salvando imagem sem fundo";

        const assetAtualizado = await enviarBackgroundRemovidoDesignerAsset(
          imagem.assetId,
          resultado.blob
        );

        if (!assetAtualizado?.backgroundRemovedUrl) {
          throw new Error("O servidor não retornou a URL da imagem sem fundo.");
        }

        const urlPermanente = this.urlAsset(assetAtualizado.backgroundRemovedUrl);

        this.atualizarImagem({
          elementId: imagem.elementId,
          backgroundRemovedSrc: urlPermanente,
          src: urlPermanente,
          usarSemFundo: true
        });

        const assetIndex = this.assets.findIndex(a => a.id === imagem.assetId);
        if (assetIndex >= 0) {
          this.assets[assetIndex] = {
            ...this.assets[assetIndex],
            backgroundRemovedUrl: assetAtualizado.backgroundRemovedUrl
          };
        }

        if (urlTemporaria) {
          liberarBackgroundUrl(urlTemporaria);
          urlTemporaria = null;
        }

        this.progressoBackground = 100;
        this.etapaBackground = "Aplicando imagem sem fundo";
        this.operacaoImagemTexto = "Aplicando imagem sem fundo...";
        await this.$nextTick();
        await this.aguardarImagemCanvas(urlPermanente);
        this.etapaBackground = "Concluído";
        await this.autosalvarAgora();
      } catch (e) {
        if (urlTemporaria) liberarBackgroundUrl(urlTemporaria);
        this.erroBackground = e?.response?.data?.message || e?.message || "Erro ao remover e salvar o fundo.";
      } finally {
        this.removendoBackground = false;
        this.etapaBackground = "";
        this.finalizarLoadingImagem();
      }
    },

    async usarOriginal() {
      const i = this.selecionado;
      if (i?.tipo !== "imagem" || !i.originalSrc || !i.usarSemFundo) return;
      this.iniciarLoadingImagem("Carregando imagem original...");
      try {
        this.atualizarImagem({ elementId: i.elementId, src: i.originalSrc, usarSemFundo: false });
        await this.aguardarImagemCanvas(i.originalSrc);
      } finally {
        this.finalizarLoadingImagem();
      }
    },

    async usarSemFundo() {
      const i = this.selecionado;
      if (i?.tipo !== "imagem" || !i.backgroundRemovedSrc || i.usarSemFundo) return;
      this.iniciarLoadingImagem("Carregando imagem sem fundo...");
      try {
        this.atualizarImagem({ elementId: i.elementId, src: i.backgroundRemovedSrc, usarSemFundo: true });
        await this.aguardarImagemCanvas(i.backgroundRemovedSrc);
      } finally {
        this.finalizarLoadingImagem();
      }
    },

    duplicarImagem() {
      const i = this.selecionado; if (!i || i.tipo !== "imagem") return;
      const c = { ...i, elementId: `img-${Date.now()}`, x: i.x + 45, y: i.y + 45 };
      this.imagensCartaz.push(c); this.selecionado = c;
      this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(c.elementId, "imagem"));
    },

    moverSelecionado(direcao) {
      if (!this.selecionado) return;

      const fixos = ["data", "weekday", "chamada", "showLabel", "artista", "estabelecimento", "cidadeHorario", "extra"];
      const elementos = [];

      this.formasCartaz.forEach((ref, index) => {
        const z = Number(ref.zIndex);
        elementos.push({ id: ref.elementId, tipo: "forma", ref, ordem: Number.isFinite(z) ? z : 10 + index });
      });
      this.imagensCartaz.forEach((ref, index) => {
        const z = Number(ref.zIndex);
        elementos.push({ id: ref.elementId, tipo: "imagem", ref, ordem: Number.isFinite(z) ? z : 100 + index });
      });
      fixos.forEach((id, index) => {
        const z = Number(this.estilosTexto[id]?.layout?.zIndex);
        elementos.push({ id, tipo: "texto", ordem: Number.isFinite(z) ? z : 200 + index });
      });
      this.textosLivres.forEach((t, index) => {
        const z = Number(this.estilosTexto[t.id]?.layout?.zIndex);
        elementos.push({ id: t.id, tipo: "texto", ordem: Number.isFinite(z) ? z : 300 + index });
      });

      elementos.sort((a, b) => a.ordem - b.ordem);

      const idSelecionado = this.selecionado.tipo === "texto"
        ? this.selecionado.id
        : this.selecionado.elementId;
      const indiceAtual = elementos.findIndex(e => e.id === idSelecionado);
      if (indiceAtual < 0) return;

      const [movido] = elementos.splice(indiceAtual, 1);
      let destino = indiceAtual;

      if (direcao === "top") destino = elementos.length;
      else if (direcao === "bottom") destino = 0;
      else if (direcao === "up") destino = Math.min(indiceAtual + 1, elementos.length);
      else if (direcao === "down") destino = Math.max(indiceAtual - 1, 0);

      elementos.splice(destino, 0, movido);

      // A ordem 0..N-1 passa a ser o estado oficial do cartaz.
      elementos.forEach((e, ordem) => {
        if (e.tipo === "texto") {
          const estilo = this.estilosTexto[e.id] || {};
          this.estilosTexto[e.id] = {
            ...estilo,
            layout: { ...(estilo.layout || {}), zIndex: ordem }
          };
        } else if (e.tipo === "imagem") {
          const idx = this.imagensCartaz.findIndex(x => x.elementId === e.id);
          if (idx >= 0) this.imagensCartaz[idx] = { ...this.imagensCartaz[idx], zIndex: ordem };
        } else if (e.tipo === "forma") {
          const idx = this.formasCartaz.findIndex(x => x.elementId === e.id);
          if (idx >= 0) this.formasCartaz[idx] = { ...this.formasCartaz[idx], zIndex: ordem };
        }
      });

      this.posicaoMenuAberto = false;
      this.$forceUpdate();

      this.$nextTick(() => {
        this.$refs.canvas?.selecionarExterno?.(idSelecionado, this.selecionado.tipo);
        this.agendarAutosave();
      });
    },

    adicionarTextoLivre(tipo = "texto") {
      this.menuAdicionarTexto = false;
      const id = `livre-${Date.now()}`;
      const fonte = this.fontes[0]?.id || null;
      const presets = {
        titulo: { texto: "Novo título", size: 84, w: 620, h: 120 },
        subtitulo: { texto: "Novo subtítulo", size: 58, w: 560, h: 100 },
        texto: { texto: "Novo texto", size: 42, w: 500, h: 90 }
      };
      const preset = presets[tipo] || presets.texto;

      this.estilosTexto[id] = {
        fontId: fonte,
        corTexto: "#ffffff",
        corFundo: "#000000",
        temFundo: false,
        textoOverride: preset.texto,
        layout: { x: 270, y: 900, w: preset.w, h: preset.h, size: preset.size, align: "center", rotation: 0 }
      };

      this.textosLivres.push({ id, texto: preset.texto });
      this.$forceUpdate();

      this.$nextTick(() => {
        this.$refs.canvas?.selecionarExterno?.(id, "texto");
        this.selecionar({ id, tipo: "texto", texto: preset.texto });
        this.$nextTick(() => this.$refs.canvas?.iniciarEdicaoInline?.(id));
      });
    },

    excluirSelecionado() {
      const s = this.selecionado;
      if (!s) return;

      if (s.tipo === "imagem") {
        this.removerImagemCartaz();
        return;
      }

      if (s.tipo === "forma") {
        this.removerFormaPorId(s.elementId);
        this.selecionado = null;
        this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(null, null));
        return;
      }

      if (s.tipo === "texto") {
        // Elementos do template são ocultados; textos livres são removidos.
        if (s.id.startsWith("livre-")) {
          this.textosLivres = this.textosLivres.filter(t => t.id !== s.id);
          delete this.estilosTexto[s.id];
        } else {
          this.estilosTexto[s.id].oculto = true;
        }

        this.selecionado = null;
        this.$forceUpdate();
        this.$nextTick(() => this.$refs.canvas?.selecionarExterno?.(null, null));
      }
    },

    removerImagemCartaz() {
      const i = this.selecionado; if (!i || i.tipo !== "imagem") return;
      this.imagensCartaz = this.imagensCartaz.filter(x => x.elementId !== i.elementId);
      this.selecionado = null;
      this.$nextTick(() => this.$refs.canvas?.limparSelecao?.());
    }
  }
};
</script>

<style scoped>
.designer-download-btn {
  white-space: nowrap;
  min-width: 126px;
}

@import url('https://fonts.googleapis.com/css2?family=Bangers&family=Bebas+Neue&family=Black+Ops+One&family=Oswald:wght@400;700&family=Pacifico&family=Permanent+Marker&family=Righteous&family=Rock+Salt&display=swap');

.uploads-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 9px;
  max-height: 330px;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 3px 5px 6px 2px;
  scrollbar-width: thin;
}

.upload-item {
  position: relative;
  min-width: 0
}

.upload-thumb {
  width: 100%;
  aspect-ratio: 1;
  border: 1px solid #dee2e6;
  border-radius: 10px;
  padding: 0;
  overflow: hidden;
  position: relative;
  background: #f8f9fa
}

.upload-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover
}

.upload-delete {
  position: absolute;
  right: -5px;
  top: -5px;
  width: 24px;
  height: 24px;
  border: 2px solid #fff;
  border-radius: 50%;
  background: #dc3545;
  color: #fff;
  font-weight: bold
}

.empty-box {
  padding: 25px 8px;
  text-align: center;
  border: 1px dashed #ced4da;
  border-radius: 8px;
  color: #6c757d;
  font-size: 12px
}

.context-toolbar {
  display: flex;
  gap: 8px;
  align-items: center;
  flex-wrap: wrap;
  padding: 10px;
  border: 1px solid #dee2e6;
  border-radius: 10px;
  background: #f8f9fa
}

.context-text {
  flex: 1 1 240px
}

.context-font {
  width: auto;
  min-width: 190px
}

.color-control {
  display: flex;
  align-items: center;
  gap: 4px;
  border: 1px solid #ced4da;
  background: #fff;
  border-radius: 6px;
  padding: 4px 7px;
  font-weight: bold
}

.layer-controls {
  display: flex;
  gap: 4px;
  align-items: center
}

.color-control input {
  width: 28px;
  height: 28px;
  border: 0;
  padding: 0;
  background: transparent
}

.designer-preview-column {
  position: relative;
}

.designer-floating-toolbar {
  position: sticky;
  top: 12px;
  z-index: 1050;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  flex-wrap: wrap;
  width: max-content;
  max-width: calc(100% - 24px);
  min-height: 48px;
  margin: 0 auto 12px auto;
  transform: none;
  padding: 6px 8px;
  border: 1px solid rgba(208, 213, 221, .95);
  border-radius: 13px;
  background: rgba(255, 255, 255, .98);
  box-shadow: 0 8px 24px rgba(16, 24, 40, .18);
  backdrop-filter: blur(12px);
}

.floating-text-input {
  width: 165px;
  min-width: 125px;
  height: 36px;
  border-radius: 8px;
  font-size: 13px;
}

.font-picker,
.position-picker {
  position: relative
}

.font-picker-button,
.toolbar-action {
  height: 36px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  border: 1px solid #d0d5dd;
  border-radius: 9px;
  padding: 0 11px;
  background: #fff;
  color: #20242b;
  font-weight: 700;
  white-space: nowrap;
}

.font-picker-button {
  min-width: 170px;
  justify-content: space-between;
  font-size: 17px
}

.font-picker-arrow {
  font-family: Arial, sans-serif;
  color: #667085
}

.font-picker-menu {
  position: absolute;
  top: 44px;
  left: 0;
  z-index: 250;
  width: 250px;
  max-height: 360px;
  overflow: auto;
  padding: 7px;
  border: 1px solid #e4e7ec;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 16px 38px rgba(16, 24, 40, .20);
}

.font-option {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 9px 10px;
  border: 0;
  border-radius: 8px;
  background: transparent;
  text-align: left;
  font-size: 18px;
}

.font-option:hover,
.font-option.active {
  background: #f2efff
}

.font-option.active {
  outline: 1px solid #8b5cf6
}

.font-option-preview {
  width: 44px;
  flex: 0 0 44px;
  text-align: center;
  font-size: 24px;
}

.floating-color {
  height: 36px;
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 0 8px;
  border: 1px solid #d0d5dd;
  border-radius: 9px;
  background: #fff;
  font-weight: 800;
}

.floating-color input {
  width: 25px;
  height: 25px;
  padding: 0;
  border: 0;
  background: transparent;
}

.floating-color-letter {
  text-decoration: underline;
  text-decoration-thickness: 3px
}

.toolbar-dark {
  background: #25272b;
  color: #fff;
  border-color: #25272b
}

.toolbar-danger {
  color: #b42318;
  border-color: #f3b7b2
}

.toolbar-danger:hover {
  background: #fff1f0
}

.toolbar-action:hover,
.font-picker-button:hover {
  background: #f7f7f9
}

.selected-image-name {
  max-width: 170px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: 700;
  color: #475467;
}

.position-menu {
  position: absolute;
  top: 44px;
  right: 0;
  z-index: 250;
  width: 245px;
  padding: 8px;
  border: 1px solid #e4e7ec;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 16px 38px rgba(16, 24, 40, .20);
}

.position-title {
  padding: 5px 8px;
  color: #667085;
  font-size: 11px;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: .05em;
}

.position-menu>button {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 9px;
  border: 0;
  border-radius: 8px;
  background: transparent;
  text-align: left;
  font-weight: 600;
}

.position-menu>button:hover,
.align-grid button:hover {
  background: #f2efff
}

.position-separator {
  height: 1px;
  background: #eaecf0;
  margin: 7px 2px
}

.align-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 5px;
  padding: 4px;
}

.align-grid button {
  height: 36px;
  border: 1px solid #eaecf0;
  border-radius: 8px;
  background: #fff;
  font-size: 18px;
}

@media(max-width:768px) {
  .designer-floating-toolbar {
    top: 62px;
    width: calc(100% - 12px);
    max-width: calc(100% - 12px);
    justify-content: flex-start;
    flex-wrap: nowrap;
    overflow-x: auto;
    overflow-y: visible;
    margin-bottom: -54px;
  }

  .floating-text-input {
    width: 145px;
    min-width: 145px
  }

  .font-picker-button {
    min-width: 145px
  }
}


.designer-add-text-btn {
  position: sticky;
  top: 68px;
  z-index: 119;
  float: right;
  margin: 10px 12px -48px 0;
  height: 36px;
  padding: 0 12px;
  border: 1px solid #d0d5dd;
  border-radius: 9px;
  background: #fff;
  font-weight: 800;
  box-shadow: 0 5px 16px rgba(16, 24, 40, .12);
}

.remove-bg-progress {
  position: absolute;
  left: 12px;
  right: 12px;
  bottom: -28px;
  height: 20px;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 3px 7px;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 4px 12px rgba(16, 24, 40, .14);
}

.remove-bg-progress::before {
  content: "";
  position: absolute;
  left: 7px;
  right: 42px;
  top: 8px;
  height: 5px;
  border-radius: 99px;
  background: #eaecf0;
}

.remove-bg-progress-bar {
  position: relative;
  z-index: 1;
  max-width: calc(100% - 42px);
  height: 5px;
  border-radius: 99px;
  background: #7c3aed;
}

.remove-bg-progress small {
  margin-left: auto;
  position: relative;
  z-index: 1;
  font-weight: 800
}


.designer-add-menu {
  position: relative;
  z-index: 118
}

.designer-add-text-popup {
  position: sticky;
  top: 110px;
  z-index: 220;
  float: right;
  clear: right;
  width: 245px;
  margin: 4px 12px -170px 0;
  padding: 7px;
  border: 1px solid #e4e7ec;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 14px 34px rgba(16, 24, 40, .20);
}

.designer-add-text-popup button {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  border: 0;
  background: transparent;
  border-radius: 8px;
  padding: 9px;
  text-align: left;
}

.designer-add-text-popup button:hover {
  background: #f2efff
}

.designer-add-text-popup strong {
  font-size: 24px;
  width: 32px;
  text-align: center
}

.designer-add-text-popup span {
  display: flex;
  flex-direction: column
}

.designer-add-text-popup small {
  color: #667085
}

.recorte-select {
  width: auto;
  min-width: 140px;
  height: 36px;
  font-size: 12px;
  font-weight: 700
}

.designer-processing,
.designer-processing * {
  cursor: progress !important
}

.remove-bg-progress small {
  white-space: nowrap
}


.designer-sidebar-sticky {
  position: sticky;
  top: 72px;
  height: calc(100vh - 88px);
  max-height: calc(100vh - 88px);
  overflow: hidden;
}

.designer-sidebar-sticky>.card-body {
  height: 100%;
  min-height: 0;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.designer-sidebar-section {
  position: relative;
  flex: 0 0 auto;
  padding-bottom: 12px;
  margin-bottom: 12px;
  border-bottom: 1px solid #eaecf0;
}

.designer-tools-section {
  position: relative;
  z-index: 50;
  overflow: visible;
}

.uploads-section {
  z-index: 10;
  background: #fff;
}

.designer-background-section {
  flex: 1 1 auto;
  min-height: 0;
  display: flex;
  flex-direction: column;
  padding-bottom: 0;
  margin-bottom: 0;
  border-bottom: 0;
  z-index: 1;
}

.sidebar-backgrounds-scroll {
  flex: 1 1 auto;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
  padding-right: 4px;
  scrollbar-width: thin;
}

.designer-sidebar-section:last-child {
  border-bottom: 0;
  margin-bottom: 0
}

.sidebar-text-menu {
  position: absolute;
  left: 0;
  right: 0;
  top: 43px;
  z-index: 230;
  padding: 6px;
  border: 1px solid #e4e7ec;
  border-radius: 10px;
  background: #fff;
  box-shadow: 0 12px 30px rgba(16, 24, 40, .18);
}

.sidebar-text-menu button {
  width: 100%;
  display: flex;
  flex-direction: column;
  border: 0;
  border-radius: 8px;
  padding: 8px 10px;
  background: transparent;
  text-align: left;
  z-index: 1000;
}

.sidebar-text-menu button:hover {
  background: #f2efff
}

.sidebar-text-menu small {
  color: #667085
}

.sidebar-backgrounds {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 8px;
}

.sidebar-bg-choice {
  display: flex;
  flex-direction: column;
  gap: 5px;
  align-items: center;
  border: 2px solid transparent;
  border-radius: 10px;
  padding: 5px;
  background: #fff;
  font-weight: 700;
}

.sidebar-bg-choice.active {
  border-color: #f5b400;
  background: #fffaf0
}

.sidebar-bg-choice small {
  display: block;
  width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  text-align: center;
  line-height: 1.2;
}

.sidebar-bg-choice img,
.sidebar-procedural-thumb {
  display: block;
  width: 100%;
  height: 82px;
  object-fit: cover;
  border-radius: 7px;
}

.sidebar-procedural-thumb {
  background: linear-gradient(#2b160f, #8a4322, #120b09);
}

@media(max-width:991px) {
  .designer-sidebar-sticky {
    position: relative;
    top: auto;
    height: auto;
    max-height: none;
    overflow: visible;
  }

  .designer-sidebar-sticky>.card-body {
    height: auto;
    overflow: visible;
  }

  .designer-background-section {
    display: block;
  }

  .sidebar-backgrounds-scroll {
    max-height: 520px;
    overflow-y: auto;
  }
}

.shape-name {
  white-space: nowrap
}

.shape-number {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 5px 8px;
  border: 1px solid #d0d5dd;
  border-radius: 8px;
  background: #fff;
  font-size: 12px
}

.shape-number input {
  width: 58px;
  border: 0;
  outline: 0;
  background: transparent
}

.toolbar-action.active {
  background: #fff4cc;
  border-color: #f5b400
}

.designer-accordion-header {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  border: 0;
  background: transparent;
  padding: 8px 2px 10px;
  color: #20242a;
  text-align: left;
  font-weight: 700;
  cursor: pointer;
}

.designer-accordion-title {
  display: flex;
  align-items: center;
  gap: 7px;
  min-width: 0
}

.designer-accordion-icon {
  font-size: 17px;
  line-height: 1
}

.designer-accordion-right {
  display: flex;
  align-items: center;
  gap: 7px
}

.designer-chevron {
  width: 9px;
  height: 9px;
  display: inline-block;
  border-right: 2px solid #667085;
  border-bottom: 2px solid #667085;
  transform: rotate(45deg);
  transition: transform .18s ease, border-color .18s ease;
  margin-right: 3px;
  margin-bottom: 4px;
}

.designer-accordion-header:hover .designer-chevron {
  border-color: #111827;
}

.designer-chevron.aberto {
  transform: rotate(225deg);
  margin-bottom: -2px;
}

.designer-accordion-body {
  min-height: 0
}

.designer-uploads-body {
  max-height: 430px;
  overflow-y: auto;
  overflow-x: hidden;
  padding-right: 3px;
  scrollbar-width: thin
}

.designer-background-section:not(.aberto) {
  flex: 0 0 auto;
  min-height: auto
}

.designer-background-section.aberto {
  flex: 1 1 auto;
  min-height: 0
}


.posters-section {
  position: relative;
  z-index: 20
}

.designer-posters-body {
  max-height: 430px;
  overflow-y: auto;
  overflow-x: hidden;
  padding-right: 3px;
  scrollbar-width: thin
}

.poster-quota {
  padding: 2px 1px
}

.poster-progress {
  height: 5px;
  background: #eceff3
}

.poster-progress .progress-bar {
  background: #ff6c22
}

.autosave-status,
.editor-autosave-status {
  font-size: 10px;
  color: #198754;
  font-weight: 700
}

.autosave-status.saving,
.editor-autosave-status.saving {
  color: #b76e00
}

.autosave-status.error,
.editor-autosave-status.error {
  color: #dc3545
}

.editor-autosave-status {
  display: block;
  margin-top: 2px
}

.posters-list {
  display: flex;
  flex-direction: column;
  gap: 9px;
}

.poster-list-item {
  position: relative;
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: 7px;
  border: 1px solid #e4e7ec;
  border-radius: 12px;
  background: #fff;
  padding: 9px;
  transition: border-color .15s ease, box-shadow .15s ease, background .15s ease;
}

.poster-list-item:hover {
  border-color: #cbd2dc;
  box-shadow: 0 3px 10px rgba(16, 24, 40, .06);
}

.poster-list-item.active {
  border-color: #ffb38d;
  background: #fffaf7;
  box-shadow: inset 3px 0 0 #ff6c22, 0 3px 10px rgba(16, 24, 40, .05);
}

.poster-open {
  min-width: 0;
  width: 100%;
  display: grid;
  grid-template-columns: 34px minmax(0, 1fr);
  align-items: center;
  gap: 9px;
  border: 0;
  background: transparent;
  text-align: left;
  padding: 0;
}

.poster-icon {
  width: 34px;
  height: 34px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 9px;
  background: #f2f4f7;
  font-size: 16px;
}

.poster-list-item.active .poster-icon {
  background: #fff0e8;
}

.poster-info {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.poster-info strong {
  display: block;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 12px;
  line-height: 1.25;
  color: #20242a;
}

.poster-info small {
  display: block;
  font-size: 10px;
  line-height: 1.3;
  color: #667085;
}

.poster-list-item.active .poster-info small {
  color: #c45116;
  font-weight: 700;
}

.poster-actions {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 5px;
  padding-top: 7px;
  border-top: 1px solid #f0f2f5;
}

.poster-actions button {
  min-width: 30px;
  height: 28px;
  padding: 0 8px;
  border: 1px solid #d0d5dd;
  border-radius: 7px;
  background: #fff;
  color: #344054;
  font-weight: 800;
  line-height: 1;
  transition: .15s ease;
}

.poster-actions button:hover {
  background: #f2f4f7;
  border-color: #b9c0cb;
}

.poster-actions button:disabled {
  opacity: .4;
  cursor: not-allowed;
}

.poster-actions button.danger {
  color: #b42318;
  border-color: #f1c0bc;
}

.poster-actions button.danger:hover {
  background: #fff1f0;
}

.upload-quota-count {
  font-size: 10px;
  font-weight: 800;
  color: #667085;
}

.upload-quota-count.full {
  color: #b42318;
}

.upload-progress {
  height: 4px;
  border-radius: 999px;
  overflow: hidden;
}


/* Seletor de imagens do quadro + FOTO DO ARTISTA */
.upload-quota-count {
  white-space: nowrap;
  flex: 0 0 auto;
  margin-left: 8px;
}

.image-picker-backdrop {
  position: fixed;
  inset: 0;
  z-index: 5000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgba(15, 23, 42, .62);
}

.image-picker-modal {
  width: min(860px, 96vw);
  max-height: 88vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 24px 70px rgba(15, 23, 42, .28);
}

.image-picker-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  padding: 20px 22px 14px;
  border-bottom: 1px solid #eaecf0;
}

.image-picker-header h5 { margin: 0 0 4px; font-weight: 800; color: #1d2939; }
.image-picker-header p { margin: 0; font-size: 13px; color: #667085; }
.image-picker-close {
  width: 34px; height: 34px; border: 0; border-radius: 9px; background: #f2f4f7;
  color: #475467; font-size: 23px; line-height: 1; cursor: pointer;
}
.image-picker-close:hover { background: #eaecf0; }

.image-picker-quota { padding: 14px 22px 8px; }
.image-picker-quota-row { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 7px; font-size: 13px; }
.image-picker-quota-row span { font-weight: 700; color: #344054; }
.image-picker-quota-row strong { white-space: nowrap; color: #667085; }
.image-picker-quota-row strong.full { color: #b42318; }
.image-picker-limit { margin: 4px 22px 10px; padding: 10px 12px; border: 1px solid #fedf89; border-radius: 9px; background: #fffaeb; color: #93370d; font-size: 12px; }
.image-picker-modal .alert { margin-left: 22px; margin-right: 22px; }
.image-picker-toolbar { padding: 6px 22px 14px; display: flex; justify-content: flex-end; }
.image-picker-toolbar .btn { min-width: 190px; }
.image-picker-loading, .image-picker-empty { padding: 42px 22px; text-align: center; color: #667085; }
.image-picker-grid {
  overflow-y: auto;
  padding: 4px 22px 22px;
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}
.image-picker-item { border: 1px solid #eaecf0; border-radius: 12px; padding: 8px; background: #fff; }
.image-picker-thumb { width: 100%; aspect-ratio: 1 / 1; overflow: hidden; border-radius: 9px; background: #f2f4f7; }
.image-picker-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
.image-picker-name { margin: 7px 2px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; font-size: 11px; color: #667085; }
.image-picker-actions { display: flex; gap: 6px; }
.image-picker-use { flex: 1; border: 0; border-radius: 8px; padding: 7px 8px; background: #182230; color: #fff; font-size: 11px; font-weight: 800; cursor: pointer; }
.image-picker-use:hover { background: #101828; }
.image-picker-delete { width: 32px; border: 1px solid #f1c0bc; border-radius: 8px; background: #fff; color: #b42318; font-size: 18px; cursor: pointer; }
.image-picker-delete:hover { background: #fff1f0; }

@media (max-width: 768px) {
  .image-picker-backdrop { padding: 10px; }
  .image-picker-modal { max-height: 94vh; }
  .image-picker-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); padding-left: 14px; padding-right: 14px; }
  .image-picker-header, .image-picker-quota { padding-left: 14px; padding-right: 14px; }
  .image-picker-toolbar { padding-left: 14px; padding-right: 14px; }
  .image-picker-toolbar .btn { width: 100%; }
}

.version-action.active {
  background: #182230 !important;
  border-color: #182230 !important;
  color: #fff !important;
  box-shadow: 0 0 0 2px rgba(24, 34, 48, .12);
}

.version-action:disabled { cursor: wait; opacity: .72; }

.designer-global-loading {
  position: fixed;
  inset: 0;
  z-index: 9000;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(15, 23, 42, .28);
  backdrop-filter: blur(1px);
}

.designer-global-loading-card {
  min-width: 230px;
  max-width: 340px;
  padding: 22px 26px;
  border-radius: 14px;
  background: #fff;
  box-shadow: 0 18px 55px rgba(15, 23, 42, .28);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 9px;
  text-align: center;
  color: #182230;
}

.designer-global-loading-card small { color: #667085; }

.designer-global-spinner {
  width: 38px;
  height: 38px;
  border: 4px solid #e4e7ec;
  border-top-color: #f5a800;
  border-radius: 50%;
  animation: sevenDesignerSpin .75s linear infinite;
}

@keyframes sevenDesignerSpin { to { transform: rotate(360deg); } }

</style>
