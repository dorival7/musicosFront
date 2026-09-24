<template>
  <!-- 🛠️ RESOLUÇÃO COMPLETA: Remove as amarras do Velzon e força a visibilidade contínua do topo -->
  <div class="seven-portal"
    style="display: block !important; position: relative; width: 100%; min-height: 100vh; background-color: #0a0b10 !important;">

    <!-- COMPONENTE 1: MENU SUPERIOR NACIONALIZADO -->
    <NavbarPublic />

    <div class="vertical-overlay" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent.show"></div>

    <!-- COMPONENTE 2: ABERTURA HERO COM BARRA DE BUSCA EM LINHA -->
    <section class="home-session hero-session">
      <BContainer fluid class="p-0">
        <HeroPublic />
      </BContainer>
    </section>

    <!-- JORNADA RÁPIDA DO CONTRATANTE -->
    <section class="home-session contractor-journey">
      <BContainer>
        <div class="journey-shell">
          <div class="journey-intro"><small>DO PRIMEIRO CLIQUE AO SHOW</small><b>Contrate sem complicação</b></div>
          <div class="journey-step"><i class="ri-search-eye-line"></i><span><b>Encontre</b><small>o artista ideal</small></span></div>
          <i class="ri-arrow-right-s-line journey-arrow"></i>
          <div class="journey-step"><i class="ri-calendar-check-line"></i><span><b>Escolha</b><small>uma data livre</small></span></div>
          <i class="ri-arrow-right-s-line journey-arrow"></i>
          <div class="journey-step"><i class="ri-route-line"></i><span><b>Calcule</b><small>a logística</small></span></div>
          <i class="ri-arrow-right-s-line journey-arrow"></i>
          <div class="journey-step"><i class="ri-shield-check-line"></i><span><b>Contrate</b><small>e pague seguro</small></span></div>
        </div>
      </BContainer>
    </section>

    <!-- CARROSSEL DE ARTISTAS EM DESTAQUE (MANTIDO DO DESIGN BASE) -->
    <section class="home-session featured-artists-session">
      <BContainer>
        <BRow>
          <BCol lg="12">
            <div class="home-session-header text-center">
              <h5 class="fs-20 text-white font-monospace text-uppercase mb-1" style="letter-spacing: 0.5px;">
                Artistas em <span class="text-primary text-decoration-underline">Destaque</span> na Plataforma
              </h5>
              <p class="text-muted small mb-0">Conheça algumas das grandes atrações disponíveis para o seu espetáculo
              </p>
            </div>

            <div class="home-session-body trusted-client-slider">

                <!-- SWIPER REATIVO INTEGRADO AO ECOSSISTEMA SEVENSHOWS -->
                <swiper class="swiper responsive-swiper rounded gallery-light pb-4" :loop="artistasLista.length > 4"
                  :autoplay="{ delay: 3000, disableOnInteraction: false }" :modules="[Autoplay]" :slidesPerView="1"
                  :spaceBetween="20" :breakpoints="{
                    640: { slidesPerView: 2, spaceBetween: 20 },
                    768: { slidesPerView: 3, spaceBetween: 30 },
                    1200: { slidesPerView: 4, spaceBetween: 30 }
                  }">
                  <!-- LAÇO REATIVO: Renderiza um slide para cada músico do MariaDB -->
                  <swiper-slide v-for="artista in artistasLista" :key="artista.Id || artista.id">
                    <div class="modern-card overflow-hidden d-flex flex-column w-100 test-start"
                      @click="handleNavigateToArtist(artista.slug || artista.Slug)"
                      style="cursor: pointer; border-radius: 16px !important; text-align: left; background-color: #131520; min-height: 380px;">
                      <!-- CONTAINER FOTO DE CAPA COM DIMENSÕES MISTAS -->
                      <div class="position-relative overflow-hidden border-bottom border-light border-opacity-5"
                        style="height: 180px; min-height: 180px; background-color: #141622;">
                        <img
                          :src="(artista.fotoCapaUrl || artista.FotoCapaUrl) ? obterUrlImagem(artista.fotoCapaUrl || artista.FotoCapaUrl) : require('@/assets/images/banner-artist-default.jpg')"
                          alt="Foto de Capa" class="w-100 h-100 object-fit-cover artist-card-img" />

                        <!-- BADGES DE IDENTIFICAÇÃO SOBRE A IMAGEM -->
                        <div class="position-absolute top-0 end-0 m-2 d-flex flex-row gap-1 align-items-start"
                          style="z-index: 3;">
                          <span
                            class="badge bg-primary fw-bold font-monospace text-uppercase fs-10 rounded-pill shadow-sm py-1 px-2"
                            style="background-color: #ff6c22 !important; letter-spacing: 0.5px;">
                            {{ artista.estiloMusical || artista.EstiloMusical || 'Geral' }}
                          </span>
                          <span
                            class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-20 fw-bold font-monospace text-uppercase fs-10 rounded-pill shadow-sm py-1 px-2"
                            style="background-color: rgba(41,156,219,0.1) !important; color: #299cdb !important; border-color: rgba(41,156,219,0.2) !important;">
                            {{ artista.formatoArtístico || artista.FormatoArtístico || 'Banda' }}
                          </span>
                        </div>
                      </div>

                      <!-- CONTEÚDO CORRIGIDO COM ESTRUTURA SEM PREÇOS -->
                      <div class="p-3 d-flex flex-column flex-grow-1">
                        <h5 class="text-white fw-bold font-monospace text-uppercase fs-15 text-truncate mb-1"
                          style="letter-spacing: -0.5px; margin-top: 0;">
                          {{ artista.nomeBanda || artista.NomeBanda || 'Atração Sem Nome' }}
                        </h5>

                        <!-- SLOGAN LIMITADO A DUAS LINHAS -->
                        <p class="text-muted small mb-3 text-truncate-2 font-monospace fs-12 lh-base"
                          style="color: #9ca3af !important; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 36px; margin-bottom: 15px;">
                          {{ artista.slogan || artista.Slogan || 'Nenhum slogan comercial cadastrado.' }}
                        </p>

                        <!-- LOCALIZAÇÃO PURA ANCORANDO O RODAPÉ DO CARD -->
                        <p class="text-muted small mb-0 d-flex align-items-center gap-1 fs-13 mt-auto"
                          style="color: #ced4da !important; margin-bottom: 0;">
                          <i class="ri-map-pin-line fs-15" style="color: #ff6c22;"></i> Atende:
                          <!-- 🛠️ CORREÇÃO CIRÚRGICA: Consome a abrangência de mercado real enviada pelo .NET -->
                          {{ artista.regiaoAtendida || artista.RegiaoAtendida || artista.cidadeAtendida ||
                            artista.CidadeAtendida || 'Não informada' }}
                          <span v-if="artista.state || artista.State"> - {{ artista.state || artista.State }}</span>
                        </p>
                      </div>
                    </div>
                  </swiper-slide>
                </swiper>

                <!-- BOTÃO INSTITUCIONAL DE NAVEGAÇÃO -->
                <div class="text-center mt-4 animate__animated animate__fadeInUp">
                  <router-link to="/artistas"
                    class="btn btn-outline-primary btn-lg fw-bold px-5 text-uppercase font-monospace fs-14"
                    style="height: 50px; border-radius: 25px !important; display: inline-flex; align-items: center; justify-content: center; letter-spacing: 0.5px;">
                    <i class="ri-user-search-line me-2 fs-18"></i> Ver Todos os Artistas Cadastrados
                  </router-link>
                </div>

              </div>
          </BCol>
        </BRow>
      </BContainer>
    </section>

    <!-- SEÇÃO DA TRÍADE DE SEGURANÇA SEVENSHOWS -->
    <section class="home-session security-session" id="seguranca">
      <BContainer>
        <BRow class="justify-content-center">
          <BCol lg="8">
            <div class="home-session-header text-center">
              <h1 class="mb-3 ff-secondary fw-semibold lh-base text-white">Contratação Segura com
                Tecnologia de Ponta</h1>
              <p class="text-muted fs-15">Garantimos transparência absoluta e proteção jurídica para
                contratantes e músicos em cada evento realizado no país.</p>
            </div>
          </BCol>
        </BRow>

        <BRow class="home-session-body gx-3 gy-0">
          <BCol lg="4">
            <div class="d-flex card-h border-0 rounded-3" style="background-color: #131520;">
              <div class="flex-shrink-0 me-3">
                <div class="avatar-sm icon-effect">
                  <div class="avatar-title bg-transparent text-primary rounded-circle">
                    <i class="ri-lock-password-line fs-36"></i>
                  </div>
                </div>
              </div>
              <div class="flex-grow-1">
                <h5 class="fs-18 fw-bold text-white">Custódia do Cachê</h5>
                <p class="text-muted my-3 ff-secondary small">O pagamento fica guardado de forma
                  protegida e só é liberado para a conta do músico após a realização física do show.
                </p>
              </div>
            </div>
          </BCol>
          <BCol lg="4">
            <div class="d-flex card-h border-0 rounded-3" style="background-color: #131520;">
              <div class="flex-shrink-0 me-3">
                <div class="avatar-sm icon-effect">
                  <div class="avatar-title bg-transparent text-primary rounded-circle">
                    <i class="ri-file-shield-2-line fs-36"></i>
                  </div>
                </div>
              </div>
              <div class="flex-grow-1">
                <h5 class="fs-18 fw-bold text-white">Contrato Automatizado</h5>
                <p class="text-muted my-3 ff-secondary small">Geração digital e instantânea de termos de
                  prestação de serviços com validade jurídica assegurada para ambas as partes.</p>
              </div>
            </div>
          </BCol>
          <BCol lg="4">
            <div class="d-flex card-h border-0 rounded-3" style="background-color: #131520;">
              <div class="flex-shrink-0 me-3">
                <div class="avatar-sm icon-effect">
                  <div class="avatar-title bg-transparent text-primary rounded-circle">
                    <i class="ri-calendar-check-line fs-36"></i>
                  </div>
                </div>
              </div>
              <div class="flex-grow-1">
                <h5 class="fs-18 fw-bold text-white">Agenda Blindada</h5>
                <p class="text-muted my-3 ff-secondary small">Sincronização reativa em tempo real
                  diretamente com o banco de dados do artista, eliminando riscos de choque de
                  horários.</p>
              </div>
            </div>
          </BCol>
        </BRow>
      </BContainer>
    </section>
    <!-- ==================================================================== -->
    <!-- SEÇÃO 1: COMO FUNCIONA PARA CONTRATANTES (LINHA DO TEMPO VISUAL)     -->
    <!-- ==================================================================== -->
    <section class="home-session how-it-works-session" id="como-funciona">
      <BContainer>
        <BRow class="justify-content-center">
          <BCol lg="8">
            <div class="home-session-header text-center animate__animated animate__fadeIn">
              <span
                class="badge bg-primary-subtle text-primary fw-bold text-uppercase px-3 py-2 rounded-pill fs-11 mb-2">
                🛡️ O MELHOR PARA O SEU EVENTO!!!
              </span>
              <h2 class="mb-3 fw-bold text-white display-6">Contratar uma Banda nunca foi tão Simples</h2>
              <p class="text-muted fs-15">Esqueça ligações cansativas e burocracia. Na Seven Shows você
                resolve tudo em poucos minutos com total transparência.</p>
            </div>
          </BCol>
        </BRow>

        <BRow class="home-session-body gx-4 home-session-grid">
          <!-- PASSO 01 -->
          <BCol lg="4" md="6">
            <div class="p-4 rounded-3 h-100 position-relative border border-light border-opacity-5 modern-card"
              style="background-color: #131520; cursor: pointer;" @click="$router.push('/artistas')">
              <div
                class="display-4 text-primary font-monospace fw-bold position-absolute opacity-10 end-0 top-0 me-3 mt-2"
                style="font-size: 64px;">01</div>
              <div
                class="avatar-sm bg-soft-primary text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center"
                style="width: 45px; height: 45px; background-color: rgba(255, 108, 34, 0.1) !important;">
                <i class="ri-search-eye-line fs-20"></i>
              </div>
              <h5 class="text-white fw-bold fs-16 mb-2">Explore & Escolha</h5>
              <p class="text-muted mb-0 small" style="color: #9ca3af !important;">Clique aqui para acessar
                o nosso catálogo completo. Filtre nosso casting por gênero musical, faixa de preço e
                região antes de mandar a proposta.</p>
            </div>
          </BCol>

          <!-- PASSO 02 -->
          <BCol lg="4" md="6">
            <div class="p-4 rounded-3 h-100 position-relative border border-light border-opacity-5 modern-card"
              style="background-color: #131520;">
              <div
                class="display-4 text-primary font-monospace fw-bold position-absolute opacity-10 end-0 top-0 me-3 mt-2"
                style="font-size: 64px;">02</div>
              <div
                class="avatar-sm bg-soft-primary text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center"
                style="width: 45px; height: 45px;">
                <i class="ri-map-pin-time-line fs-20"></i>
              </div>
              <h5 class="text-white fw-bold fs-16 mb-2">Calcule a Logística</h5>
              <p class="text-muted mb-0 small">Selecione o pacote desejado e informe o CEP do evento. O
                sistema consulta as tabelas do músico e calcula o frete por KM reativamente.</p>
            </div>
          </BCol>

          <!-- PASSO 03 -->
          <BCol lg="4" md="6">
            <div class="p-4 rounded-3 h-100 position-relative border border-light border-opacity-5 modern-card"
              style="background-color: #131520;">
              <div
                class="display-4 text-primary font-monospace fw-bold position-absolute opacity-10 end-0 top-0 me-3 mt-2"
                style="font-size: 64px;">03</div>
              <div
                class="avatar-sm bg-soft-primary text-primary rounded-circle mb-3 d-flex align-items-center justify-content-center"
                style="width: 45px; height: 45px;">
                <i class="ri-bank-card-line fs-20"></i>
              </div>
              <h5 class="text-white fw-bold fs-16 mb-2">Pagamento Seguro</h5>
              <p class="text-muted mb-0 small">Efetue o pagamento via PIX ou cartão. O cachê fica retido
                em custódia bancária segura e só é liberado para o músico após o show.</p>
            </div>
          </BCol>
        </BRow>
      </BContainer>
    </section>

    <!-- MOMENTO VISUAL — mantém a narrativa e acrescenta emoção de palco -->
    <section class="home-session seven-stage-break" aria-label="A experiência do palco começa na Seven Shows">
      <BContainer class="position-relative" style="z-index:2;">
        <div class="seven-stage-break-copy">
          <span>DO PRIMEIRO CLIQUE AO PALCO</span>
          <h2>TECNOLOGIA PARA CONTRATAR.<br><b>EMOÇÃO PARA VIVER.</b></h2>
          <p>Encontre o artista certo, organize cada etapa da contratação e deixe o espetáculo acontecer.</p>
        </div>
      </BContainer>
    </section>

    <!-- ==================================================================== -->
    <!-- ÁREA DO MÚSICO — cada bloco principal é uma home-session independente -->
    <!-- ==================================================================== -->
    <section class="home-session artist-intro-session artist-growth-surface" id="vantagens-musico">
      <BContainer class="position-relative" style="z-index: 2;">
        <BRow class="justify-content-center">
          <BCol lg="10" class="text-center">
            <div class="artist-entry-label">
              <span class="artist-eyebrow"><i class="ri-rocket-2-line"></i> SEVEN SHOWS PARA ARTISTAS</span>
              <div class="artist-audience-callout">VOCÊ É CANTOR, MÚSICO OU TEM UMA BANDA?</div>
            </div>
            <h2 class="artist-main-title">VOCÊ CUIDA DA MÚSICA.<br><span>A SEVEN SHOWS CUIDA DE TODO O RESTO.</span></h2>
            <p class="artist-lead">Da divulgação à contratação, da agenda ao financeiro, a Seven Shows reúne as ferramentas para você organizar sua carreira, conquistar novas oportunidades e ter mais tempo para fazer o que realmente importa: música.</p>
            <div class="d-flex flex-wrap justify-content-center gap-3 mt-4">
              <router-link to="/quero-vender" class="artist-cta artist-cta-primary"><i class="ri-flashlight-fill"></i> CRIAR MINHA PÁGINA</router-link>
              <a href="#recursos-ia" class="artist-cta artist-cta-ghost"><i class="ri-sparkling-2-line"></i> CONHECER OS RECURSOS</a>
            </div>
            <div class="artist-mini-proof mt-3"><i class="ri-check-line"></i> Cadastre-se e acesse seu painel para começar a configurar sua presença na Seven Shows.</div>
          </BCol>
        </BRow>
        </BContainer>
      </section>

    <section class="home-session artist-benefits-session artist-growth-surface">
        <BContainer>
      <div class="artist-pain-block">
          <div class="home-session-header text-center">
            <span class="section-kicker">MENOS IMPROVISO. MAIS PROFISSIONALISMO.</span>
            <h3 class="section-title">MENOS TEMPO ORGANIZANDO.<br><span>MAIS TEMPO TOCANDO.</span></h3>
            <p class="section-copy">A Seven Shows centraliza tarefas que hoje ficam espalhadas entre WhatsApp, agenda, anotações, arquivos e planilhas.</p>
          </div>
          <BRow class="home-session-body gx-4 home-session-grid">
            <BCol md="6" lg="4" v-for="beneficio in beneficiosMusico" :key="beneficio.titulo">
              <div class="benefit-card h-100">
                <div class="benefit-icon"><i :class="beneficio.icone"></i></div>
                <div>
                  <small>{{ beneficio.sobre }}</small>
                  <h4>{{ beneficio.titulo }}</h4>
                  <p>{{ beneficio.texto }}</p>
                </div>
              </div>
            </BCol>
          </BRow>
      </div>
        </BContainer>
      </section>

    <section class="home-session artist-dashboard-session artist-growth-surface">
        <BContainer>
      <div class="dashboard-showcase">
          <BRow class="align-items-center g-5">
            <BCol lg="5">
              <span class="section-kicker">SEU NEGÓCIO NA PALMA DA MÃO</span>
              <h3 class="section-title text-start">SEU ESCRITÓRIO DE SHOWS.<br><span>DENTRO DO SEU CELULAR.</span></h3>
              <p class="section-copy text-start mx-0">Acompanhe sua carreira em um painel feito para quem vive de música. Veja oportunidades, organize datas, acompanhe contratos e tenha uma visão clara dos seus shows e recebimentos.</p>
              <div class="showcase-list">
                <div><i class="ri-check-double-line"></i><span><b>Agenda inteligente</b><small>Datas livres, bloqueios e shows em um só calendário.</small></span></div>
                <div><i class="ri-check-double-line"></i><span><b>Propostas e contratos</b><small>Acompanhe cada oportunidade sem procurar conversas antigas.</small></span></div>
                <div><i class="ri-check-double-line"></i><span><b>Financeiro organizado</b><small>Visualize cachês, pagamentos e histórico da sua operação.</small></span></div>
                <div><i class="ri-check-double-line"></i><span><b>Vitrine profissional</b><small>Seu perfil público trabalha por você enquanto você está no palco.</small></span></div>
              </div>
            </BCol>
            <BCol lg="7">
              <div class="dashboard-mockup">
                <div class="mockup-top"><span></span><span></span><span></span><div>painel.sevenshows</div></div>
                <div class="mockup-body">
                  <aside><div class="mock-logo">7</div><i class="ri-home-5-line active"></i><i class="ri-calendar-event-line"></i><i class="ri-file-list-3-line"></i><i class="ri-wallet-3-line"></i><i class="ri-magic-line"></i></aside>
                  <main>
                    <div class="mock-welcome"><small>PAINEL DO ARTISTA</small><b>Olá, músico 👋</b><span>Veja como está sua agenda e suas oportunidades.</span></div>
                    <div class="mock-stats"><div><i class="ri-calendar-check-line"></i><b>Agenda</b><span>Próximos shows</span></div><div><i class="ri-hand-coin-line"></i><b>Propostas</b><span>Em negociação</span></div><div><i class="ri-wallet-line"></i><b>Financeiro</b><span>Recebimentos</span></div></div>
                    <div class="mock-chart"><div class="mock-chart-title"><b>Visão da carreira</b><span>Últimos meses</span></div><div class="bars"><i style="height:34%"></i><i style="height:52%"></i><i style="height:43%"></i><i style="height:70%"></i><i style="height:61%"></i><i style="height:88%"></i><i style="height:78%"></i></div></div>
                  </main>
                </div>
              </div>
            </BCol>
          </BRow>
      </div>
        </BContainer>
      </section>

    <section class="home-session artist-ai-session artist-growth-surface" id="recursos-ia">
        <BContainer>
      <div class="ai-showcase">
          <div class="home-session-header text-center">
            <span class="ai-badge"><i class="ri-sparkling-fill"></i> RECURSOS INTELIGENTES SEVEN</span>
            <h3 class="section-title">MAIS QUE UM PAINEL.<br><span>FERRAMENTAS INTELIGENTES PARA O SEU SHOW.</span></h3>
            <p class="section-copy">Tecnologia aplicada a tarefas reais do músico: preparar repertório, trabalhar cifras e criar divulgação sem sair da plataforma.</p>
          </div>
          <BRow class="home-session-body gx-4 home-session-grid">
            <BCol lg="4">
              <div class="ai-card h-100"><div class="ai-number">01</div><div class="ai-icon"><i class="ri-music-2-line"></i></div><span>REPERTÓRIO INTELIGENTE</span><h4>Organize melhor o seu show</h4><p>Use recursos inteligentes para estruturar e otimizar seu setlist, organizar a sequência das músicas e trabalhar a dinâmica do espetáculo.</p><div class="ai-tag">SETLIST • ORGANIZAÇÃO • ENERGIA</div></div>
            </BCol>
            <BCol lg="4">
              <div class="ai-card h-100"><div class="ai-number">02</div><div class="ai-icon"><i class="ri-guitar-line"></i></div><span>CIFRAS NO TOM CERTO</span><h4>Menos tempo refazendo acordes</h4><p>Pesquise a música, trabalhe a cifra e faça a transposição para a tonalidade que você precisa, deixando o material pronto para tocar.</p><div class="ai-tag">CIFRAS • TOM • TRANSPOSIÇÃO</div></div>
            </BCol>
            <BCol lg="4">
              <div class="ai-card h-100"><div class="ai-number">03</div><div class="ai-icon"><i class="ri-brush-3-line"></i></div><span>SEVEN DESIGNER</span><h4>Divulgação pronta para as redes</h4><p>Crie artes dos seus shows dentro da Seven Shows e exporte materiais no formato ideal para Stories e Status, mantendo sua divulgação sempre ativa.</p><div class="ai-tag">DESIGN • STORIES • WHATSAPP</div></div>
            </BCol>
          </BRow>
          <div class="ai-closing">DA PREPARAÇÃO AO PALCO. DA DIVULGAÇÃO AO PAGAMENTO. <b>TUDO NA SEVEN SHOWS.</b></div>
      </div>
        </BContainer>
      </section>

    <section class="home-session artist-marketplace-session artist-growth-surface">
        <BContainer>
      <div class="marketplace-section">
        <div class="home-session-header marketplace-message">
          <div class="marketplace-icon"><i class="ri-store-3-line"></i></div>
          <div class="flex-grow-1"><span class="section-kicker">UM DIFERENCIAL QUE VAI ALÉM DA GESTÃO</span><h3>NÃO É APENAS UM PAINEL. <em>É SUA VITRINE PARA NOVOS SHOWS.</em></h3><p>Você administra sua carreira no mesmo ecossistema em que contratantes podem descobrir seu trabalho, conhecer seu perfil e iniciar uma contratação.</p></div>
        </div>

        <div class="home-session-body marketplace-body">
          <div class="marketplace-body-item">
            <div class="marketplace-body-icon"><i class="ri-profile-line"></i></div>
            <div><span>SEU PERFIL É SUA VITRINE</span><p>Apresente seu repertório, estilos, fotos, vídeos e as informações que ajudam o contratante a conhecer o seu trabalho.</p></div>
          </div>
          <div class="marketplace-body-flow"><i class="ri-arrow-right-line"></i></div>
          <div class="marketplace-body-item">
            <div class="marketplace-body-icon"><i class="ri-search-eye-line"></i></div>
            <div><span>SEJA ENCONTRADO</span><p>Contratantes podem encontrar artistas por cidade, estilo e disponibilidade e chegar diretamente ao seu perfil.</p></div>
          </div>
          <div class="marketplace-body-flow"><i class="ri-arrow-right-line"></i></div>
          <div class="marketplace-body-item">
            <div class="marketplace-body-icon"><i class="ri-hand-coin-line"></i></div>
            <div><span>RECEBA OPORTUNIDADES</span><p>Do perfil à proposta e à contratação, a oportunidade continua dentro do mesmo ecossistema Seven Shows.</p></div>
          </div>
        </div>
      </div>
        </BContainer>
      </section>

    <section class="home-session artist-final-cta-session artist-growth-surface">
        <BContainer>
      <div class="final-artist-cta final-artist-cta-visual text-center">
          <span class="section-kicker">PRONTO PARA PROFISSIONALIZAR SEUS SHOWS?</span>
          <h3>COLOQUE SUA CARREIRA NO <span>PRÓXIMO PALCO.</span></h3>
          <p>Crie sua presença na Seven Shows, entre no painel e conheça os recursos disponíveis para organizar e vender melhor o seu trabalho.</p>
          <router-link to="/quero-vender" class="artist-cta artist-cta-primary artist-cta-large"><i class="ri-rocket-fill"></i> QUERO FAZER PARTE DA SEVEN SHOWS</router-link>
      </div>
        </BContainer>
    </section>

    <!-- PUBLICIDADE / PARCEIROS SEVEN SHOWS
         Mantida após toda a narrativa institucional para não interromper
         a jornada de contratantes e artistas na landing page. -->
    <section class="home-session advertising-session">
      <BContainer fluid class="p-0">
        <PaidAdvertising />
      </BContainer>
    </section>

  </div>
</template>
<script>
/* eslint-disable no-unused-vars */
/* eslint-disable vue/no-unused-components */
import { Autoplay, Navigation, Pagination } from "swiper/modules";
import { Swiper, SwiperSlide } from "swiper/vue";
import axios from "axios"; // 🆕 IMPORTADO: Ativa o barramento HTTP público anônimo
import "swiper/css";
import "swiper/css/autoplay";
import 'swiper/css/navigation';
import 'swiper/css/pagination';

import "@/assets/scss/public-theme.css";
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import HeroPublic from "@/components/public/HeroPublic.vue";
import PaidAdvertising from "@/components/public/PaidAdvertising.vue";

export default {
  data() {
    return {
      Autoplay, Navigation, Pagination,
      artistasLista: [], // 🆕 DINÂMICO: Recebe a lista viva de bandas do MariaDB
      loading: false,
      beneficiosMusico: [
        { sobre: "MAIS VISIBILIDADE", titulo: "Pare de depender só de indicação", texto: "Tenha uma vitrine profissional e seja encontrado por contratantes que estão procurando artistas para seus eventos.", icone: "ri-user-search-line" },
        { sobre: "VITRINE PROFISSIONAL", titulo: "Seu material sempre pronto", texto: "Centralize sua apresentação e informações comerciais em um perfil preparado para transformar visitas em oportunidades.", icone: "ri-window-line" },
        { sobre: "AGENDA INTELIGENTE", titulo: "Chega de conflito de datas", texto: "Controle disponibilidade, bloqueios e compromissos para manter sua agenda organizada e atualizada.", icone: "ri-calendar-check-line" },
        { sobre: "NEGOCIAÇÃO ORGANIZADA", titulo: "Propostas em um só lugar", texto: "Acompanhe oportunidades e contratações pelo painel sem depender de conversas espalhadas no WhatsApp.", icone: "ri-file-list-3-line" },
        { sobre: "PAGAMENTO PROTEGIDO", titulo: "Mais segurança para receber", texto: "Tenha o fluxo de contratação e pagamento integrado para subir ao palco com muito mais tranquilidade.", icone: "ri-shield-check-line" },
        { sobre: "GESTÃO DA CARREIRA", titulo: "Enxergue o seu negócio", texto: "Shows, agenda, contratos e financeiro passam a fazer parte da mesma rotina digital.", icone: "ri-line-chart-line" }
      ]
    };
  },
  components: {
    Swiper,
    SwiperSlide,
    NavbarPublic,
    HeroPublic,
    PaidAdvertising
  },
  methods: {
    // 🆕 INTEGRADO: Varre a API pública e popula o carrossel reativamente
    async carregarArtistasDestaque() {
      this.loading = true;
      try {
        const response = await axios.get(`${process.env.VUE_APP_API_BASE_URL}/public/artists`);
        if (response.data) {
          // Filtra o administrador direto na recepção da carga para blindagem dupla
          this.artistasLista = response.data.filter(art => {
            const nomeReal = art.nomeBanda || art.NomeBanda || "";
            return !nomeReal.toUpperCase().includes("ADMINISTRADOR");
          });
        }
      } catch (error) {
        console.error("Falha técnica ao tentar consumir a esteira de destaques na Home:", error);
      } finally {
        this.loading = false;
      }
    },

    // 🆕 INTEGRADO: Formata o caminho físico de mídias de forma idêntica ao catálogo
    obterUrlImagem(urlRelativa) {
      if (!urlRelativa) return "";
      if (urlRelativa.startsWith("http://") || urlRelativa.startsWith("https://")) {
        return urlRelativa;
      }
      let base = process.env.VUE_APP_API_BASE_URL || "";
      if (base.endsWith("/api")) {
        base = base.substring(0, base.length - 4);
      } else if (base.endsWith("/api/")) {
        base = base.substring(0, base.length - 5);
      }
      const urlLimpa = urlRelativa.startsWith("/") ? urlRelativa : "/" + urlRelativa;
      return `${base}${urlLimpa}`;
    },

    // 🆕 INTEGRADO: Redireciona o contratante para a tela interna do músico selecionado
    handleNavigateToArtist(slug) {
      if (!slug) return;
      this.$router.push(`/artista/${slug}`);
    },

    topFunction() {
      document.body.scrollTop = 0;
      document.documentElement.scrollTop = 0;
    },
    monthly() {
      const highlightedItems = document.querySelectorAll(".month");
      highlightedItems.forEach(function (userItem) {
        userItem.style.display = "block";
      });
      const highlightedItems2 = document.querySelectorAll(".annual");
      highlightedItems2.forEach(function (userItem) {
        userItem.style.display = "none";
      });
    },
    anually() {
      const highlightedItems = document.querySelectorAll(".month");
      highlightedItems.forEach(function (userItem) {
        userItem.style.display = "none";
      });
      const highlightedItems2 = document.querySelectorAll(".annual");
      highlightedItems2.forEach(function (userItem) {
        userItem.style.display = "block";
      });
    },
    scrollToSection(sectionId) {
      const element = document.getElementById(sectionId);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth' });
      }
    }
  },
  unmounted() {
    window.removeEventListener('scroll', this.setActiveSection);
  },
  mounted() {
    // 🚀 DISPARO AUTOMÁTICO: Consome a esteira do banco de dados na inicialização
    this.carregarArtistasDestaque();

    window.addEventListener('scroll', this.setActiveSection);
    let backtoTop = document.getElementById("back-to-top");

    if (backtoTop) {
      backtoTop = document.getElementById("back-to-top");
      window.onscroll = function () {
        if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
          backtoTop.style.display = "block";
        } else {
          backtoTop.style.display = "none";
        }
      };
    }

    this.monthly();

    window.addEventListener('scroll', function (ev) {
      ev.preventDefault();
      var navbar = document.getElementById("navbar");
      if (navbar) {
        if (document.body.scrollTop >= 50 || document.documentElement.scrollTop >= 50) {
          navbar.classList.add("is-sticky");
        } else {
          navbar.classList.remove("is-sticky");
        }
      }
    });

    const currentYearEl = document.querySelector('.currentyear');
    if (currentYearEl) {
      currentYearEl.innerHTML = new Date().getFullYear() + " © Seven Shows";
    }
  },
};
</script>

<style scoped>
.contractor-journey{padding:38px 0 0;background:#0a0b10}.journey-shell{display:flex;align-items:center;justify-content:center;gap:18px;padding:20px 24px;border:1px solid rgba(255,255,255,.07);border-radius:18px;background:linear-gradient(90deg,rgba(255,108,34,.055),rgba(255,255,255,.018),rgba(10,179,156,.04))}.journey-intro{display:flex;flex-direction:column;padding-right:22px;border-right:1px solid rgba(255,255,255,.08)}.journey-intro small{color:#ff6c22;font:800 9px monospace;letter-spacing:1px}.journey-intro b{color:#fff;font-size:14px;margin-top:3px}.journey-step{display:flex;align-items:center;gap:9px}.journey-step>i{color:#ff6c22;font-size:20px}.journey-step span{display:flex;flex-direction:column}.journey-step b{color:#fff;font-size:12px}.journey-step small{color:#737b8c;font-size:10px}.journey-arrow{color:#343a48}.artist-growth-section{position:relative;overflow:hidden;padding:110px 0 90px;background:linear-gradient(180deg,#090a0f 0%,#0d0f17 48%,#08090d 100%);border-top:1px solid rgba(255,255,255,.06)}
.artist-glow{position:absolute;border-radius:50%;filter:blur(100px);pointer-events:none;opacity:.13}.artist-glow-orange{width:500px;height:500px;background:#ff6c22;top:80px;left:-250px}.artist-glow-cyan{width:500px;height:500px;background:#00c8c8;top:420px;right:-300px}.artist-eyebrow,.section-kicker,.ai-badge{display:inline-flex;align-items:center;gap:8px;color:#ff7a35;font:800 12px/1 monospace;letter-spacing:1.4px;text-transform:uppercase}.artist-eyebrow{padding:10px 16px;border:1px solid rgba(255,108,34,.35);border-radius:30px;background:rgba(255,108,34,.07)}.artist-entry-label{display:flex;flex-direction:column;align-items:center;gap:14px;margin-bottom:10px}.artist-eyebrow{font-size:13px;padding:12px 22px;border-color:rgba(255,108,34,.58);background:linear-gradient(90deg,rgba(255,108,34,.14),rgba(255,108,34,.05));box-shadow:0 0 28px rgba(255,108,34,.10)}.artist-audience-callout{color:#fff;font:900 clamp(18px,2vw,25px)/1.25 monospace;letter-spacing:.4px;text-transform:uppercase}.artist-main-title{margin:24px auto 18px;color:#fff;font:900 clamp(34px,4.2vw,58px)/1.08 monospace;letter-spacing:-2px;max-width:1000px}.artist-main-title span,.section-title span,.final-artist-cta h3 span{background:linear-gradient(90deg,#ff6c22,#ff9d66);-webkit-background-clip:text;-webkit-text-fill-color:transparent}.artist-lead,.section-copy{max-width:820px;margin:0 auto;color:#aeb4c2;font-size:17px;line-height:1.75}.artist-cta{min-height:52px;padding:0 28px;border-radius:28px;display:inline-flex;align-items:center;justify-content:center;gap:9px;text-decoration:none!important;font:900 12px/1 monospace;letter-spacing:.6px;transition:.25s}.artist-cta-primary{color:#fff!important;background:linear-gradient(135deg,#ff5d16,#ff7b32);box-shadow:0 12px 30px rgba(255,108,34,.24)}.artist-cta-primary:hover{transform:translateY(-2px);box-shadow:0 16px 38px rgba(255,108,34,.35)}.artist-cta-ghost{color:#e9edf5!important;border:1px solid rgba(255,255,255,.15);background:rgba(255,255,255,.035)}.artist-mini-proof{color:#b7c2d3;font-size:14px;font-weight:500;line-height:1.55;margin-top:18px!important}.artist-mini-proof i{color:#18d5bd;font-size:16px;margin-right:4px}.artist-mini-proof i{color:#0ab39c}.artist-pain-block,.dashboard-showcase,.ai-showcase{margin-top:0}.section-title{color:#fff;font:900 clamp(28px,3.1vw,42px)/1.15 monospace;letter-spacing:-1.2px;margin:14px 0 16px}.benefit-card{display:flex;gap:17px;padding:25px;border:1px solid rgba(255,108,34,.28);border-radius:18px;background:linear-gradient(145deg,rgba(22,24,35,.95),rgba(13,15,23,.95));transition:.25s}.benefit-card:hover{transform:translateY(-4px);border-color:rgba(255,108,34,.75);box-shadow:0 16px 35px rgba(0,0,0,.25)}.benefit-icon{width:46px;height:46px;flex:0 0 46px;border-radius:13px;display:flex;align-items:center;justify-content:center;color:#ff6c22;font-size:21px;background:rgba(255,108,34,.09);border:1px solid rgba(255,108,34,.2)}.benefit-card small{color:#ff7a35;font:800 10px monospace;letter-spacing:.8px}.benefit-card h4{color:#fff;font-size:16px;margin:6px 0 8px}.benefit-card p{color:#8f96a5;font-size:13px;line-height:1.6;margin:0}.dashboard-showcase{position:relative;isolation:isolate;overflow:hidden;padding:60px;border-radius:28px;border:1px solid rgba(255,255,255,.09);background:
radial-gradient(circle at 78% 34%,rgba(0,200,200,.14),transparent 31%),
radial-gradient(circle at 10% 18%,rgba(255,108,34,.11),transparent 30%),
linear-gradient(125deg,#0d0f17 0%,#0a1118 52%,#071318 100%);box-shadow:inset 0 1px 0 rgba(255,255,255,.025),0 28px 80px rgba(0,0,0,.18)}
.dashboard-showcase::before{content:"";position:absolute;z-index:-2;inset:-25%;pointer-events:none;background:repeating-radial-gradient(ellipse at 78% 50%,transparent 0 44px,rgba(0,200,200,.045) 45px 46px,transparent 47px 72px);transform:rotate(-8deg);opacity:.8}
.dashboard-showcase::after{content:"";position:absolute;z-index:-1;pointer-events:none;width:520px;height:520px;right:-145px;top:-170px;border-radius:50%;background:radial-gradient(circle,rgba(0,200,200,.13) 0%,rgba(0,200,200,.045) 35%,transparent 70%);filter:blur(10px)}
.dashboard-showcase>.row{position:relative;z-index:1}.showcase-list{margin-top:28px;display:grid;gap:16px}.showcase-list>div{display:flex;gap:12px}.showcase-list i{color:#0ab39c;font-size:21px}.showcase-list span{display:flex;flex-direction:column}.showcase-list b{color:#fff;font-size:14px}.showcase-list small{color:#7f8796;font-size:12px;margin-top:3px}.dashboard-mockup{border:1px solid rgba(255,255,255,.13);border-radius:18px;background:#10131d;box-shadow:0 30px 70px rgba(0,0,0,.45);overflow:hidden;transform:perspective(1200px) rotateY(-2deg)}.mockup-top{height:38px;display:flex;align-items:center;gap:6px;padding:0 13px;background:#171a25;border-bottom:1px solid rgba(255,255,255,.06)}.mockup-top>span{width:8px;height:8px;border-radius:50%;background:#3d4251}.mockup-top div{margin-left:12px;color:#555e70;font:10px monospace}.mockup-body{display:flex;min-height:360px}.mockup-body aside{width:58px;padding:18px 0;display:flex;flex-direction:column;align-items:center;gap:20px;background:#0b0d13;border-right:1px solid rgba(255,255,255,.05);color:#4f586b}.mock-logo{width:29px;height:29px;border-radius:9px;display:grid;place-items:center;background:#ff6c22;color:#fff;font-weight:900}.mockup-body aside i{font-size:17px}.mockup-body aside i.active{color:#ff6c22}.mockup-body main{padding:24px;flex:1}.mock-welcome{display:flex;flex-direction:column}.mock-welcome small{color:#ff6c22;font:9px monospace}.mock-welcome b{color:#fff;font-size:20px;margin:4px 0}.mock-welcome span{color:#687184;font-size:10px}.mock-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin:22px 0}.mock-stats>div{padding:14px;border-radius:10px;background:#171a25;border:1px solid rgba(255,255,255,.05);display:flex;flex-direction:column}.mock-stats i{color:#0ab39c;font-size:17px}.mock-stats b{color:#fff;font-size:11px;margin:8px 0 2px}.mock-stats span{color:#626b7d;font-size:8px}.mock-chart{height:145px;padding:15px;border-radius:11px;background:#171a25}.mock-chart-title{display:flex;justify-content:space-between;color:#fff;font-size:10px}.mock-chart-title span{color:#60697a;font-size:8px}.bars{height:90px;display:flex;align-items:end;gap:9px;padding-top:12px}.bars i{flex:1;min-height:18%;border-radius:4px 4px 0 0;background:linear-gradient(#ff7a35,#71351c)}.ai-showcase{position:relative;overflow:hidden;padding:72px 28px 60px;border:1px solid rgba(255,255,255,.09);border-radius:28px;background:linear-gradient(90deg,rgba(5,7,12,.94),rgba(5,7,12,.76)),url('~@/assets/images/banner-artist-default.jpg') 46% -190px/auto 118% no-repeat;box-shadow:0 28px 70px rgba(0,0,0,.22)}
.ai-showcase::before{content:"";position:absolute;inset:0;background:radial-gradient(circle at 80% 40%,rgba(0,200,200,.16),transparent 34%),radial-gradient(circle at 15% 80%,rgba(255,108,34,.12),transparent 28%);pointer-events:none}
.ai-showcase>*{position:relative;z-index:2}.ai-badge{padding:10px 16px;border-radius:25px;color:#75e7db;background:rgba(10,179,156,.08);border:1px solid rgba(10,179,156,.2)}.ai-card{position:relative;overflow:hidden;padding:30px;border-radius:20px;background:linear-gradient(145deg,#141722,#0d0f17);border:1px solid rgba(255,255,255,.08);transition:.25s}.ai-card:hover{transform:translateY(-5px);border-color:rgba(10,179,156,.3)}.ai-number{position:absolute;right:20px;top:10px;color:rgba(255,255,255,.035);font:900 70px monospace}.ai-icon{width:52px;height:52px;border-radius:15px;display:grid;place-items:center;background:linear-gradient(135deg,rgba(255,108,34,.14),rgba(10,179,156,.12));color:#ff7a35;font-size:23px;margin-bottom:22px}.ai-card>span{color:#62d8cc;font:800 10px monospace;letter-spacing:1px}.ai-card h4{color:#fff;font-size:19px;margin:8px 0 10px}.ai-card p{color:#8e96a6;font-size:13px;line-height:1.7}.ai-tag{display:inline-block;margin-top:10px;color:#697386;font:9px monospace;letter-spacing:.7px}.ai-closing{text-align:center;margin-top:35px;color:#8e96a6;font:800 12px monospace;letter-spacing:.7px}.ai-closing b{color:#ff7a35}.marketplace-message{margin-top:0;padding:38px 42px;border-radius:22px;display:flex;gap:25px;align-items:center;background:linear-gradient(110deg,rgba(255,108,34,.09),rgba(10,179,156,.06));border:1px solid rgba(255,108,34,.2)}.marketplace-icon{width:68px;height:68px;flex:0 0 68px;border-radius:18px;display:grid;place-items:center;color:#ff6c22;font-size:30px;background:rgba(255,108,34,.1)}.marketplace-message h3{color:#fff;font:900 26px monospace;margin:9px 0}.marketplace-message h3 em{font-style:normal;color:#ff7a35}.marketplace-message p{color:#929aaa;margin:0;line-height:1.7}.final-artist-cta{margin-top:0;padding:65px 25px;border-top:1px solid rgba(255,255,255,.07)}.final-artist-cta h3{color:#fff;font:900 clamp(30px,4vw,48px) monospace;margin:16px 0}.final-artist-cta p{color:#929aaa;max-width:700px;margin:0 auto 28px;line-height:1.7}.artist-cta-large{min-height:58px;padding:0 34px}

/* v1.3.0 — camada visual cinematográfica sem remover conteúdo existente */
.seven-stage-break{position:relative;min-height:430px;display:flex;align-items:center;overflow:hidden;background:url('~@/assets/images/banner-artist-default.jpg') center 72%/cover no-repeat;border-top:1px solid rgba(255,255,255,.06);border-bottom:1px solid rgba(255,255,255,.06)}
.seven-stage-break::after{content:"";position:absolute;inset:0;background:linear-gradient(90deg,rgba(5,7,12,.96) 0%,rgba(5,7,12,.72) 45%,rgba(5,7,12,.20) 78%,rgba(5,7,12,.42) 100%)}
.seven-stage-break::before{content:"";position:absolute;inset:0;background:linear-gradient(180deg,#0a0b10 0%,transparent 22%,transparent 78%,#090a0f 100%);z-index:1;pointer-events:none}
.seven-stage-break-copy{position:relative;z-index:3;max-width:680px;padding:86px 0}
.seven-stage-break-copy>span{color:#63ded2;font:900 12px monospace;letter-spacing:1.6px}
.seven-stage-break-copy h2{color:#fff;font:900 clamp(34px,4.2vw,58px)/1.08 monospace;letter-spacing:-1.6px;margin:14px 0 18px;text-shadow:0 4px 24px rgba(0,0,0,.55)}
.seven-stage-break-copy h2 b{color:#ff7a35;font-weight:900}
.seven-stage-break-copy p{max-width:610px;color:#d2d8e3;font-size:17px;line-height:1.7;margin:0}
.final-artist-cta-visual{position:relative;overflow:hidden;border:1px solid rgba(255,255,255,.09)!important;border-radius:28px;padding:78px 28px!important;background:linear-gradient(110deg,rgba(255,108,34,.055),rgba(255,255,255,.018),rgba(10,179,156,.04))!important;box-shadow:0 28px 70px rgba(0,0,0,.20)}
.final-artist-cta-visual::before{content:"";position:absolute;inset:0;background:radial-gradient(circle at 80% 40%,rgba(0,200,200,.08),transparent 34%),radial-gradient(circle at 15% 80%,rgba(255,108,34,.07),transparent 28%);pointer-events:none}
.final-artist-cta-visual>*{position:relative;z-index:2}
@media(max-width:991px){.journey-shell{flex-wrap:wrap;justify-content:flex-start}.journey-intro{width:100%;border-right:0;border-bottom:1px solid rgba(255,255,255,.08);padding:0 0 14px}.journey-arrow{display:none}.dashboard-showcase{padding:35px 22px}.dashboard-mockup{transform:none}.contractor-journey{padding:38px 0 0;background:#0a0b10}.journey-shell{display:flex;align-items:center;justify-content:center;gap:18px;padding:20px 24px;border:1px solid rgba(255,255,255,.07);border-radius:18px;background:linear-gradient(90deg,rgba(255,108,34,.055),rgba(255,255,255,.018),rgba(10,179,156,.04))}.journey-intro{display:flex;flex-direction:column;padding-right:22px;border-right:1px solid rgba(255,255,255,.08)}.journey-intro small{color:#ff6c22;font:800 9px monospace;letter-spacing:1px}.journey-intro b{color:#fff;font-size:14px;margin-top:3px}.journey-step{display:flex;align-items:center;gap:9px}.journey-step>i{color:#ff6c22;font-size:20px}.journey-step span{display:flex;flex-direction:column}.journey-step b{color:#fff;font-size:12px}.journey-step small{color:#737b8c;font-size:10px}.journey-arrow{color:#343a48}.artist-growth-section{padding-top:80px}.marketplace-message{align-items:flex-start}.artist-main-title{letter-spacing:-1px}.artist-pain-block,.dashboard-showcase,.ai-showcase{margin-top:0}}
@media(max-width:575px){.artist-main-title{font-size:32px}.artist-lead,.section-copy{font-size:15px}.dashboard-showcase{padding:28px 16px}.mockup-body main{padding:14px}.mock-stats{grid-template-columns:1fr}.mock-chart{display:none}.marketplace-message{padding:28px 20px;flex-direction:column}.marketplace-message h3{font-size:21px}.artist-cta{width:100%}.ai-closing{line-height:1.7}}

/* v06 — legibilidade da vitrine do painel do artista */
.dashboard-showcase .section-kicker{font-size:13px;letter-spacing:1.2px}
.dashboard-showcase .section-copy{font-size:17px;line-height:1.75;color:#b9c5d8;max-width:520px}
.dashboard-showcase .showcase-list{margin-top:28px}
.dashboard-showcase .showcase-list>div{margin-bottom:18px;align-items:flex-start}
.dashboard-showcase .showcase-list i{font-size:21px;margin-top:1px}
.dashboard-showcase .showcase-list b{font-size:15px;line-height:1.35}
.dashboard-showcase .showcase-list small{font-size:13px;line-height:1.5;color:#91a4bf;margin-top:4px}
@media(max-width:767.98px){
  .dashboard-showcase .section-copy{font-size:16px}
  .dashboard-showcase .showcase-list b{font-size:15px}
  .dashboard-showcase .showcase-list small{font-size:13px}
}


/* v07 — legibilidade dos textos DENTRO do mockup do painel */
.dashboard-mockup .mockup-top{font-size:11px;color:#8792a8}
.dashboard-mockup .mock-welcome small{font-size:11px!important;line-height:1.35;color:#ff7a32!important;font-weight:800}
.dashboard-mockup .mock-welcome b{font-size:21px!important;line-height:1.3;color:#fff!important}
.dashboard-mockup .mock-welcome span{font-size:12px!important;line-height:1.45;color:#9aa8bd!important}
.dashboard-mockup .mock-stats b{font-size:13px!important;line-height:1.35;color:#fff!important}
.dashboard-mockup .mock-stats span{font-size:10px!important;line-height:1.4;color:#9aa8bd!important}
.dashboard-mockup .mock-chart-title b{font-size:12px!important;color:#fff!important}
.dashboard-mockup .mock-chart-title span{font-size:10px!important;color:#9aa8bd!important}
.dashboard-mockup .mock-stats i{font-size:19px!important}


/* v08 — legibilidade do topo do mockup e dos cards de recursos inteligentes */
.dashboard-mockup .mockup-top div{
  font-size:12px!important;
  font-weight:600!important;
  color:#aab6c9!important;
  letter-spacing:.15px;
}

/* Cards IA */
.ai-card>span{
  font-size:12px!important;
  font-weight:800!important;
  line-height:1.4;
  letter-spacing:1px;
  color:#63ded2!important;
}
.ai-card h4{
  font-size:20px!important;
  line-height:1.3!important;
}
.ai-card p{
  font-size:15px!important;
  line-height:1.65!important;
  color:#aeb8c9!important;
}
.ai-card .ai-tag{
  font-size:10px!important;
  line-height:1.4!important;
  color:#91a0b7!important;
  letter-spacing:.7px;
}
.ai-card .ai-number{
  opacity:.42!important;
  color:#9aa8bd!important;
  font-size:58px!important;
  text-shadow:0 0 18px rgba(117,231,219,.10);
}
.ai-card .ai-icon{
  width:54px!important;
  height:54px!important;
}
.ai-card .ai-icon i{
  font-size:24px!important;
}
@media(max-width:767.98px){
  .ai-card p{font-size:14px!important}
  .ai-card h4{font-size:19px!important}
}

/* v1.4.1 — corpo explicativo da vitrine entre a chamada e o CTA final */
.marketplace-body{margin:26px 18px 0;padding:26px 28px;display:grid;grid-template-columns:1fr auto 1fr auto 1fr;align-items:stretch;gap:18px;border:1px solid rgba(255,255,255,.07);border-radius:20px;background:rgba(10,12,18,.54)}
.marketplace-body-item{display:flex;gap:14px;align-items:flex-start;padding:6px 4px}.marketplace-body-icon{width:42px;height:42px;flex:0 0 42px;display:grid;place-items:center;border-radius:12px;color:#63ded2;font-size:20px;background:rgba(10,179,156,.08);border:1px solid rgba(10,179,156,.17)}
.marketplace-body-item span{display:block;color:#fff;font:900 12px/1.35 monospace;letter-spacing:.7px;margin:2px 0 7px}.marketplace-body-item p{margin:0;color:#909aac;font-size:13px;line-height:1.6}.marketplace-body-flow{display:flex;align-items:center;color:rgba(255,108,34,.55);font-size:20px}
@media(max-width:991px){.marketplace-body{grid-template-columns:1fr;gap:8px;margin-left:0;margin-right:0}.marketplace-body-flow{display:none}.marketplace-body-item{padding:10px 4px}}

/* v1.4.12 — estrutura vertical definitiva da Home.
   Todas as áreas principais são sections irmãs diretas de .seven-portal.
   A section não cria espaço interno vertical; o único gutter entre sections é 70px. */
.seven-portal > .home-session{
  margin:0!important;
  padding-top:0!important;
  padding-bottom:0!important;
}
.seven-portal > .home-session + .home-session{
  margin-top:70px!important;
}

/* O antigo wrapper artist-growth-area foi removido para não quebrar o fluxo das sections. */
.artist-growth-surface{
  position:relative;
  background:linear-gradient(180deg,#090a0f 0%,#0d0f17 48%,#08090d 100%);
}
.artist-intro-session{overflow:hidden;border-top:1px solid rgba(255,255,255,.06)}
.artist-final-cta-session{border-bottom:1px solid rgba(255,255,255,.06)}

/* Remove somente espaçamentos externos legados. O padding interno dos cards/blocos visuais é preservado. */
.contractor-journey{padding-top:0!important;padding-bottom:0!important}
.featured-artists-session > .container{padding-top:0!important;padding-bottom:0!important}
.featured-artists-session .text-center.mt-5{margin-top:0!important}
.featured-artists-session .trusted-client-slider{margin-top:32px!important;margin-bottom:0!important}
.artist-pain-block,.dashboard-showcase,.ai-showcase,.marketplace-section,.final-artist-cta{margin-top:0!important}
.artist-marketplace-session .marketplace-body{margin-top:28px!important}
.advertising-session :deep(.seven-ads){padding-top:0!important;padding-bottom:0!important;margin-top:0!important}




/* v1.4.26 — Vitrine: cada etapa passa a ser um card visual independente. */
.seven-portal .artist-marketplace-session .marketplace-body {
  border: 0 !important;
  background: transparent !important;
  padding: 0 !important;
  border-radius: 0 !important;
}
.seven-portal .artist-marketplace-session .marketplace-body-item {
  padding: 22px !important;
  border: 1px solid rgba(255, 108, 34, .34) !important;
  border-radius: 18px;
  background: rgba(10, 12, 18, .72);
  transition: border-color .22s ease, box-shadow .22s ease, transform .22s ease;
}
.seven-portal .artist-marketplace-session .marketplace-body-item:hover {
  border-color: rgba(255, 108, 34, .92) !important;
  box-shadow: 0 12px 30px rgba(255, 108, 34, .12);
  transform: translateY(-2px);
}
@media (max-width: 991px) {
  .seven-portal .artist-marketplace-session .marketplace-body-item { padding: 20px !important; }
}

</style>

<style scoped>
/* v1.4.13 — contrato estrutural: toda home-session tem BContainer como filho direto. */
.artist-intro-session::before,
.artist-intro-session::after{
  content:"";
  position:absolute;
  border-radius:50%;
  filter:blur(100px);
  pointer-events:none;
  opacity:.13;
  z-index:0;
}
.artist-intro-session::before{width:500px;height:500px;background:#ff6c22;top:80px;left:-250px}
.artist-intro-session::after{width:500px;height:500px;background:#00c8c8;top:420px;right:-300px}

/* v1.4.26 — Vitrine: cada etapa passa a ser um card visual independente. */
.seven-portal .artist-marketplace-session .marketplace-body {
  border: 0 !important;
  background: transparent !important;
  padding: 0 !important;
  border-radius: 0 !important;
}
.seven-portal .artist-marketplace-session .marketplace-body-item {
  padding: 22px !important;
  border: 1px solid rgba(255, 108, 34, .34) !important;
  border-radius: 18px;
  background: rgba(10, 12, 18, .72);
  transition: border-color .22s ease, box-shadow .22s ease, transform .22s ease;
}
.seven-portal .artist-marketplace-session .marketplace-body-item:hover {
  border-color: rgba(255, 108, 34, .92) !important;
  box-shadow: 0 12px 30px rgba(255, 108, 34, .12);
  transform: translateY(-2px);
}
@media (max-width: 991px) {
  .seven-portal .artist-marketplace-session .marketplace-body-item { padding: 20px !important; }
}

</style>

<style scoped>
/* v1.4.14 — ritmo vertical único da Home.
   70px existem SOMENTE entre home-session irmãs.
   16px é o ritmo header -> conteúdo dentro de uma seção. */
.seven-portal > .home-session {
  margin-block: 0 !important;
  padding-block: 0 !important;
  min-height: 0 !important;
}

.seven-portal > .home-session + .home-session {
  margin-top: 70px !important;
}

/* O BContainer não participa do ritmo vertical. */
.seven-portal > .home-session > :deep(.container),
.seven-portal > .home-session > :deep(.container-fluid) {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  margin-top: 0 !important;
  margin-bottom: 0 !important;
}

/* Headers das seções: mesma distância até o conteúdo. */
.security-session .text-center.mb-5,
.how-it-works-session .text-center.mb-5,
.artist-benefits-session .text-center.mb-5,
.artist-ai-session .text-center.mb-5 {
  margin-bottom: 16px !important;
}

/* Artistas em destaque: remove margens Bootstrap concorrentes. */
.featured-artists-session .text-center.mt-5 {
  margin-top: 0 !important;
}
.featured-artists-session .trusted-client-slider {
  margin-top: 16px !important;
  margin-bottom: 0 !important;
}
.featured-artists-session .trusted-client-slider > .text-center.mt-4 {
  margin-top: 32px !important;
}

/* Classes específicas não podem criar um segundo espaçamento estrutural. */
.contractor-journey,
.seven-stage-break,
.artist-intro-session,
.artist-benefits-session,
.artist-dashboard-session,
.artist-ai-session,
.artist-marketplace-session,
.artist-final-cta-session,
.advertising-session {
  margin-block: 0 !important;
  padding-block: 0 !important;
  min-height: 0 !important;
}

/* Momento visual: mantém imagem/overlay, mas sem 86px escondidos em cima/baixo. */
.seven-stage-break {
  display: block !important;
}
.seven-stage-break-copy {
  padding-block: 32px !important;
}

/* Blocos visuais internos: respiro consistente, sem corredores verticais. */
.dashboard-showcase {
  padding-top: 32px !important;
  padding-bottom: 32px !important;
}
.ai-showcase {
  padding-top: 32px !important;
  padding-bottom: 32px !important;
}
.marketplace-message {
  margin-top: 0 !important;
}
.artist-marketplace-session .marketplace-body {
  margin-top: 16px !important;
}
.final-artist-cta,
.final-artist-cta-visual {
  margin-top: 0 !important;
  padding-top: 32px !important;
  padding-bottom: 32px !important;
}

/* Evita que o componente de publicidade acrescente outro gutter externo. */
.advertising-session :deep(.seven-ads) {
  margin-block: 0 !important;
  padding-block: 0 !important;
}

/* v1.4.15 — contrato único header -> body.
   Classes visuais não controlam mais a distância entre cabeçalho e conteúdo. */
.home-session-header {
  margin: 0 !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
}
.home-session-body {
  margin-top: 16px !important;
  margin-bottom: 0 !important;
}

/* v1.4.24 — o gutter vertical do Bootstrap (g-4) criava espaço antes da primeira linha.
   O espaçamento header -> body fica exclusivamente em 16px; row-gap atua só ENTRE linhas de cards. */
.home-session-grid {
  --bs-gutter-y: 0 !important;
  row-gap: 24px;
}

/* v1.4.19 — piloto Segurança: padding interno único dos cards.
   O grid cuida apenas do layout; o card cuida do próprio respiro. */
.security-session .card-h {
  padding: 24px !important;
  height: 100%;
}

/* v1.4.20 — 16px VISUAIS entre o último texto do header e o body.
   Remove margens tipográficas e gutter vertical que antes se somavam aos 32px estruturais. */
.home-session-header > :last-child {
  margin-bottom: 0 !important;
}
.security-session .home-session-body > :deep(*) {
  margin-top: 0 !important;
}

/* Neutraliza espaçamentos legados somente nos pares padronizados. */
.featured-artists-session .home-session-header,
.security-session .home-session-header,
.how-it-works-session .home-session-header,
.artist-benefits-session .home-session-header,
.artist-ai-session .home-session-header,
.artist-marketplace-session .home-session-header {
  margin-bottom: 0 !important;
}
.artist-marketplace-session .marketplace-body.home-session-body {
  margin-top: 16px !important;
}


/* v1.4.23 — padrão único de borda para os cards da Home.
   Estado normal já delimita o card; hover apenas reforça a mesma linguagem visual. */
.seven-portal .modern-card,
.seven-portal .security-session .card-h,
.seven-portal .benefit-card,
.seven-portal .ai-card {
  border: 1px solid rgba(255, 108, 34, .34) !important;
  transition: border-color .22s ease, box-shadow .22s ease, transform .22s ease !important;
}

.seven-portal .modern-card:hover,
.seven-portal .security-session .card-h:hover,
.seven-portal .benefit-card:hover,
.seven-portal .ai-card:hover {
  border-color: rgba(255, 108, 34, .92) !important;
  box-shadow: 0 12px 30px rgba(255, 108, 34, .12) !important;
}

@media (max-width: 991px) {
  .seven-portal > .home-session + .home-session {
    margin-top: 70px !important;
  }
  .seven-stage-break-copy,
  .dashboard-showcase,
  .ai-showcase,
  .final-artist-cta,
  .final-artist-cta-visual {
    padding-top: 32px !important;
    padding-bottom: 32px !important;
  }
}

/* v1.4.25 — Vitrine: mesmo contrato visual das demais sections.
   Header -> body = 16px; sem margens laterais/verticais legadas no body. */
.artist-marketplace-session .marketplace-message.home-session-header {
  margin: 0 !important;
}
.artist-marketplace-session .marketplace-body.home-session-body {
  margin: 16px 0 0 !important;
}

/* v1.4.26 — Vitrine: cada etapa passa a ser um card visual independente. */
.seven-portal .artist-marketplace-session .marketplace-body {
  border: 0 !important;
  background: transparent !important;
  padding: 0 !important;
  border-radius: 0 !important;
}
.seven-portal .artist-marketplace-session .marketplace-body-item {
  padding: 22px !important;
  border: 1px solid rgba(255, 108, 34, .34) !important;
  border-radius: 18px;
  background: rgba(10, 12, 18, .72);
  transition: border-color .22s ease, box-shadow .22s ease, transform .22s ease;
}
.seven-portal .artist-marketplace-session .marketplace-body-item:hover {
  border-color: rgba(255, 108, 34, .92) !important;
  box-shadow: 0 12px 30px rgba(255, 108, 34, .12);
  transform: translateY(-2px);
}
@media (max-width: 991px) {
  .seven-portal .artist-marketplace-session .marketplace-body-item { padding: 20px !important; }
}

</style>
