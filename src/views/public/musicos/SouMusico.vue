<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="seven-portal text-start" style="position: relative; width: 100%; min-height: 100vh; background-color: #08090d !important; padding-bottom: 100px; display: block !important; box-sizing: border-box; font-family: sans-serif; color: #ced4da; overflow-x: hidden;">
    
    <!-- FIXAÇÃO ABSOLUTA DA NAVBAR SUPERIOR -->
    <NavbarPublic />

    <!-- ================================================================ -->
    <!-- SEVEN SHOWS PARA ARTISTAS — PÁGINA DE CONVERSÃO                  -->
    <!-- ================================================================ -->
    <main class="artist-sales">

      <section class="sales-hero">
        <img :src="imagemHeroBackground" class="sales-hero-bg" alt="Show ao vivo" />
        <div class="sales-hero-mask"></div>
        <div class="sales-hero-content">
          <div class="sales-badge">♫ SEVEN SHOWS PARA ARTISTAS</div>
          <div class="sales-audience">VOCÊ É CANTOR, MÚSICO OU TEM UMA BANDA?</div>

          <h1>
            MAIS SHOWS. MENOS CORRERIA.
            <span>SUA CARREIRA EM UM SÓ LUGAR.</span>
          </h1>

          <p class="sales-lead">
            Seja encontrado por novos contratantes, receba propostas, organize sua agenda,
            feche contratos e acompanhe seus recebimentos — enquanto você cuida da música.
          </p>

          <div class="trial-pill">
            <strong>30 DIAS GRÁTIS</strong>
            <span>para conhecer a plataforma funcionando na sua rotina</span>
          </div>

          <button @click="rolarAteOnboarding" type="button" class="sales-primary-btn">
            COMEÇAR MEUS 30 DIAS GRÁTIS →
          </button>

          <div class="sales-proof">
            ✓ Acesso imediato ao painel <span>•</span> ✓ Escolha seu plano abaixo <span>•</span> ✓ Primeiro mês por R$ 0
          </div>
        </div>
      </section>

      <section class="sales-section sales-problem">
        <div class="section-kicker">MENOS IMPROVISO. MAIS PROFISSIONALISMO.</div>
        <h2>TUDO O QUE HOJE FICA ESPALHADO.<br><span>AGORA TRABALHA JUNTO.</span></h2>
        <p class="section-intro">
          Chega de controlar a carreira entre WhatsApp, agenda, anotações, arquivos e planilhas.
          A Seven Shows reúne sua operação em um só lugar.
        </p>

        <div class="pain-grid">
          <article><i class="ri-calendar-check-line"></i><b>Agenda organizada</b><span>Datas livres, bloqueios e shows confirmados sem conflito.</span></article>
          <article><i class="ri-file-list-3-line"></i><b>Propostas e contratos</b><span>Acompanhe negociações sem procurar conversas antigas.</span></article>
          <article><i class="ri-shield-check-line"></i><b>Pagamento protegido</b><span>Mais segurança para fechar o show e receber o seu cachê.</span></article>
          <article><i class="ri-map-pin-2-line"></i><b>Deslocamento calculado</b><span>Quilometragem e regras de viagem entram na contratação.</span></article>
          <article><i class="ri-store-2-line"></i><b>Vitrine profissional</b><span>Seu trabalho pronto para ser descoberto por novos contratantes.</span></article>
          <article><i class="ri-line-chart-line"></i><b>Visão da carreira</b><span>Shows, oportunidades e financeiro dentro da mesma rotina.</span></article>
        </div>
      </section>

      <section class="sales-section opportunity-section">
        <div class="opportunity-copy">
          <div class="section-kicker teal">SUA VITRINE PARA NOVOS SHOWS</div>
          <h2>NÃO É SÓ UM PAINEL.<br><span>É ONDE O CONTRATANTE ENCONTRA VOCÊ.</span></h2>
          <p>
            Sua página pública apresenta seu trabalho, fotos, vídeos e formatos de show.
            O contratante consulta sua disponibilidade e pode iniciar a contratação dentro do mesmo ecossistema.
          </p>
          <ul>
            <li>Perfil público profissional</li>
            <li>Galeria de fotos e vídeos conforme o seu plano</li>
            <li>Formatos e pacotes de show organizados</li>
            <li>Agenda conectada ao processo de contratação</li>
          </ul>
        </div>
        <div class="opportunity-card">
          <div class="mini-window-top"><span></span><span></span><span></span><small>seven shows • artista</small></div>
          <div class="mini-profile">
            <div class="mini-avatar">7</div>
            <div><small>SEU PERFIL</small><strong>Seu palco começa aqui.</strong><span>Apresente seu trabalho. Receba oportunidades.</span></div>
          </div>
          <div class="mini-metrics">
            <div><i class="ri-eye-line"></i><b>Visibilidade</b><span>para novos contratantes</span></div>
            <div><i class="ri-calendar-event-line"></i><b>Agenda</b><span>sempre atualizada</span></div>
          </div>
        </div>
      </section>

      <section class="sales-section intelligent-section">
        <div class="section-kicker teal">✦ RECURSOS INTELIGENTES SEVEN</div>
        <h2>MAIS QUE GESTÃO.<br><span>FERRAMENTAS PARA QUEM VIVE DE MÚSICA.</span></h2>
        <p class="section-intro">
          Da preparação do repertório à divulgação do próximo show, recursos criados para tarefas reais do músico.
        </p>

        <div class="smart-grid">
          <article>
            <div class="smart-icon"><i class="ri-music-2-line"></i></div>
            <small>REPERTÓRIO INTELIGENTE</small>
            <h3>Organize melhor o seu show</h3>
            <p>Estruture seu setlist, organize a sequência das músicas e trabalhe a dinâmica da apresentação.</p>
          </article>
          <article>
            <div class="smart-icon"><i class="ri-magic-line"></i></div>
            <small>CIFRAS NO TOM CERTO</small>
            <h3>Prepare o material para tocar</h3>
            <p>Pesquise músicas, trabalhe cifras e faça transposição para a tonalidade que você precisa.</p>
          </article>
          <article>
            <div class="smart-icon"><i class="ri-image-edit-line"></i></div>
            <small>SEVEN DESIGNER</small>
            <h3>Divulgação pronta para as redes</h3>
            <p>Crie artes para Stories e Status dentro da Seven Shows e mantenha sua divulgação sempre ativa.</p>
          </article>
        </div>
      </section>

      <section class="sales-section security-section">
        <div class="section-kicker">DO ACORDO AO PALCO</div>
        <h2>MENOS RISCO PARA VOCÊ.<br><span>MAIS SEGURANÇA PARA FECHAR.</span></h2>

        <div class="benefit-grid">
          <article><small>01. MAIS OPORTUNIDADES</small><h3>Vitrine para novos shows</h3><p>Seu perfil fica disponível para contratantes conhecerem seu trabalho e iniciarem uma contratação.</p></article>
          <article><small>02. RECEBIMENTO</small><h3>Pagamento protegido</h3><p>O fluxo financeiro acompanha a contratação para trazer mais segurança ao seu cachê.</p></article>
          <article><small>03. GESTÃO</small><h3>Painel de controle</h3><p>Propostas, contratos, agenda e financeiro organizados em uma visão central da carreira.</p></article>
          <article><small>04. AGENDA</small><h3>Controle de datas</h3><p>Bloqueie compromissos e mantenha a disponibilidade sincronizada para evitar conflitos.</p></article>
          <article><small>05. LOGÍSTICA</small><h3>KM e deslocamento</h3><p>As regras cadastradas pelo artista ajudam a calcular o deslocamento durante a contratação.</p></article>
          <article><small>06. RESPEITO AO PALCO</small><h3>Hora extra prevista</h3><p>As condições do show ficam organizadas para reduzir improvisos e proteger o combinado.</p></article>
        </div>
      </section>

      <section class="pre-plans">
        <div class="pre-plans-badge">30 DIAS GRÁTIS EM QUALQUER PLANO</div>
        <h2>ESCOLHA COMO QUER COMEÇAR.<br><span>HOJE, SEU PRIMEIRO MÊS É R$ 0.</span></h2>
        <p>Os planos abaixo são carregados diretamente do catálogo da Seven Shows. Escolha o que combina com o momento da sua carreira.</p>
        <div class="arrow-down"><i class="ri-arrow-down-line"></i></div>
      </section>

    </main>

    <!-- 🏁 ETAPA 0: ESTEIRA REATIVA DE SELEÇÃO DE PLANOS SAAS (VELZON DARK)  -->
        <!-- ==================================================================== -->
        <div id="secao-onboarding" style="grid-column: 1 / -1; max-width: 1000px; margin: 40px auto 0 auto; background: linear-gradient(145deg, #161929, #10121d); border: 1px solid rgba(255,255,255,0.06); border-radius: 24px; padding: 45px; box-shadow: 0 25px 60px rgba(0,0,0,0.6); width: 100%; box-sizing: border-box;">
          
          <!-- INDICADOR DINÂMICO DE ETAPA ATIVA -->
          <div style="text-align: center; margin-bottom: 35px;">
            <div style="display: inline-flex; align-items: center; gap: 8px; background-color: rgba(255,108,34,0.05); border: 1px solid rgba(255,108,34,0.2); padding: 5px 15px; border-radius: 6px;">
              <span style="color: #ff6c22; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; font-family: monospace;">
                Passo {{ etapaOnboarding + 1 }} de 3: {{ etapaOnboarding === 0 ? 'Escolha do Plano Comercial' : 'Preenchimento do Perfil' }}
              </span>
            </div>
            <h3 style="color: #ffffff; font-size: 20px; font-weight: 900; text-transform: uppercase; margin: 15px 0 0 0; font-family: monospace; letter-spacing: -0.5px;">
              {{ etapaOnboarding === 0 ? 'Escolha seu plano e comece com 30 dias grátis' : 'Crie suas credenciais de acesso' }}
            </h3>
          </div>

          <!-- ⏳ LOADER DE CONEXÃO COM O MARIADB -->
          <div v-if="loadingPlanos" style="text-align: center; padding: 40px 0;">
            <div class="spinner-border text-primary" role="status" style="color: #ff6c22 !important;"></div>
            <p style="color: #878a99; font-size: 12px; margin-top: 10px; font-family: monospace; text-transform: uppercase;">Buscando planos ativos no servidor...</p>
          </div>

          <!-- 📊 GRID DE CARDS LADO A LADO DINÂMICO (MODELO REPLICADO 1:1) -->
          <div v-else-if="etapaOnboarding === 0" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; width: 100%; box-sizing: border-box; justify-items: center;">
            
            <div 
              v-for="plano in planosSaaS" 
              :key="plano.id"
              :style="{
                borderColor: plano.monthlyFee > 50 ? '#0ab39c' : 'rgba(255,255,255,0.06)',
                background: plano.monthlyFee > 50 ? 'linear-gradient(145deg, #181b2f, #10121f)' : 'linear-gradient(145deg, #131524, #10111a)'
              }"
              style="width: 100%; max-width: 320px; border: 1px solid; border-radius: 20px; padding: 30px 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.4); display: flex; flex-direction: column; justify-content: space-between; position: relative; box-sizing: border-box; transition: transform 0.2s;"
              onmouseover="this.style.transform='scale(1.02)';"
              onmouseout="this.style.transform='scale(1)';"
            >
<!-- Topo do Card -->
              <div style="text-align: center; margin-bottom: 20px;">
                <h4 style="color: #ffffff; font-size: 15px; font-weight: 900; margin: 0 0 6px 0; text-transform: uppercase; font-family: monospace; letter-spacing: 0.5px;">{{ plano.name }}</h4>
                <p style="color: #878a99; font-size: 11px; margin: 0; line-height: 1.4; font-family: sans-serif; min-height: 32px;">{{ plano.description || 'Ideal para gerenciar seus shows regionais.' }}</p>
              </div>

              <!-- Centro do Card: Bloco de Faturamento com Cifrão -->
              <div style="background-color: rgba(255,255,255,0.02); border-radius: 12px; padding: 15px; text-align: center; margin-bottom: 20px; border: 1px solid rgba(255,255,255,0.03);">
                <div style="display:inline-block;background:rgba(10,179,156,.12);border:1px solid rgba(10,179,156,.28);color:#35d7c0;font:800 10px monospace;padding:5px 9px;border-radius:20px;margin-bottom:8px;text-transform:uppercase;">1º mês grátis</div>
                <span style="display:block;color:#a8b3c6;font-size:10px;font-weight:bold;text-transform:uppercase;font-family:monospace;">Depois</span>
                <div style="color: #0ab39c; font-size: 22px; font-weight: 900; font-family: monospace; margin-top: 2px;">
                  R$ {{ plano.monthlyFee.toFixed(2).replace('.', ',') }}<span style="color: #878a99; font-size: 11px; font-weight: normal; font-family: sans-serif;">/mês</span>
                </div>
              </div>

              <!-- Lista de Vantagens e Limites do Banco MariaDB -->
              <div style="display: flex; flex-direction: column; gap: 12px; text-align: left; margin-bottom: 25px; flex: 1;">
                <div style="display: flex; align-items: start; gap: 8px; font-size: 11px; color: #ced4da;">
                  <span style="color: #0ab39c; font-weight: bold;">✓</span>
                  <span>Até <strong>{{ plano.maxPhotosCount }} fotos</strong> na galeria</span>
                </div>
                <div style="display: flex; align-items: start; gap: 8px; font-size: 11px; color: #ced4da;">
                  <span style="color: #0ab39c; font-weight: bold;">✓</span>
                  <span>Até <strong>{{ plano.maxVideosCount }} vídeos</strong> no YouTube</span>
                </div>
                <div style="display: flex; align-items: start; gap: 8px; font-size: 11px; color: #ced4da;">
                  <span style="color: #0ab39c; font-weight: bold;">✓</span>
                  <span>Até <strong>{{ plano.maxShowsPerMonth }} formatos</strong> de shows</span>
                </div>
                <div style="display: flex; align-items: start; gap: 8px; font-size: 11px; color: #ced4da; border-top: 1px dashed rgba(255,255,255,0.05); padding-top: 10px; margin-top: 2px;">
                  <span style="color: #ff6c22; font-weight: bold;">★</span>
                  <span>Taxa de comissão: <strong>{{ plano.defaultTakeRatePercent }}%</strong></span>
                </div>
              </div>

              <!-- Botão de Ação -->
              <button 
                @click="selecionarPlanoEAvancar(plano.id)"
                type="button" 
                :style="{ backgroundColor: plano.monthlyFee > 50 ? '#0ab39c' : 'transparent', borderColor: plano.monthlyFee > 50 ? '#0ab39c' : '#3a3f50', color: '#ffffff' }"
                style="width: 100%; padding: 12px; border: 1px solid; border-radius: 8px; font-size: 10px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; cursor: pointer; transition: 0.2s;"
                onmouseover="this.style.borderColor='#ff6c22'; this.style.color='#ff6c22';"
                onmouseout="this.style.borderColor=this.style.backgroundColor==='transparent'?'#3a3f50':'#0ab39c'; this.style.color='#ffffff';"
              >
                COMEÇAR 30 DIAS GRÁTIS →
              </button>
            </div>

          </div>

          <!-- ==================================================================== -->
          <!-- 📝 ETAPA 1: FORMULÁRIO DE IDENTIFICAÇÃO CADASTRAL (UMA COLUNA CLEAN)  -->
          <!-- ==================================================================== -->
          <div v-else-if="etapaOnboarding === 1" class="animate__animated animate__fadeIn" style="max-width: 500px; margin: 0 auto; text-align: left; box-sizing: border-box;">
            
            <!-- CONTROLES DE TOPO -->
            <div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 25px;">
              <button 
                @click="etapaOnboarding = 0" 
                type="button" 
                style="background: transparent; border: none; color: #878a99; font-size: 11px; font-weight: bold; text-transform: uppercase; cursor: pointer; padding: 0; text-align: left; width: max-content; outline: none; font-family: monospace; transition: 0.2s;"
                onmouseover="this.style.color='#ff6c22';"
                onmouseout="this.style.color='#878a99';"
              >
                ← Voltar e Mudar de Plano
              </button>

              <!-- BARRA VANTAGEM DO PLANO SELECIONADO -->
              <div v-if="planosSaaS.find(p => p.id === formCadastro.saaSPlanId)" style="background-color: rgba(10,179,156,0.05); border: 1px solid rgba(10,179,156,0.2); border-radius: 8px; padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; box-sizing: border-box;">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <span style="font-size: 15px;">💎</span>
                  <div>
                    <span style="color: #ffffff; font-size: 11px; font-weight: bold; text-transform: uppercase; font-family: monospace; display: block;">{{ planosSaaS.find(p => p.id === formCadastro.saaSPlanId).name }}</span>
                    <span style="color: #878a99; font-size: 10px; font-family: sans-serif;">Comissão de apenas {{ planosSaaS.find(p => p.id === formCadastro.saaSPlanId).defaultTakeRatePercent }}% por apresentação</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 📋 FORMULÁRIO DE ENTRADA (SEPARAÇÃO DE VITRINE E IDENTIDADE FISCAL) -->
            <form @submit.prevent="validarEtapaAcessoEAvancar" style="display: flex; flex-direction: column; gap: 18px; font-family: monospace;">
              
              <!-- Campo A: Nome da Banda (Exibido no Perfil Público) -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Nome Artístico / Banda * <span style="color: #ff6c22;">(Vitrine Pública)</span></label>
                <input 
                  type="text" 
                  v-model="formCadastro.name" 
                  placeholder="Ex: Banda Quatro, DJ Marcos, Trio Acústico" 
                  required
                  style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;"
                />
              </div>

              <!-- Campo B: Nome Completo do Responsável (Ajuste Solicitado) -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;">Nome Completo do Responsável *</label>
                <input 
                  type="text" 
                  v-model="formCadastro.responsibleName" 
                  placeholder="Nome completo do titular do CPF" 
                  required
                  style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;"
                />
              </div>

              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">E-mail de Acesso *</label>
                <input 
                  type="email" 
                  v-model="formCadastro.email" 
                  placeholder="exemplo@banda.com" 
                  required
                  style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;"
                />
              </div>

              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Criar Senha de Acesso *</label>
                <input 
                  type="password" 
                  v-model="formCadastro.password" 
                  placeholder="Mínimo 6 caracteres" 
                  required
                  style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;"
                />
              </div>

              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Confirme a Senha Criada *</label>
                <input 
                  type="password" 
                  v-model="confirmarPasswordLocal" 
                  placeholder="Repita a senha para validação" 
                  required
                  style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;"
                />
              </div>

              <!-- Botão Avançar para Localidade -->
              <div style="margin-top: 5px; text-align: right;">
                <button 
                  type="submit" 
                  style="padding: 12px 30px; background-color: #ff6c22; border: 1px solid #ff6c22; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 11px; border-radius: 6px; box-shadow: 0 4px 15px rgba(255,108,34,0.15); transition: 0.2s; cursor: pointer; letter-spacing: 0.5px;"
                  onmouseover="this.style.backgroundColor='#ff8138'; this.style.borderColor='#ff8138';"
                  onmouseout="this.style.backgroundColor='#ff6c22'; this.style.borderColor='#ff6c22';"
                >
                  Continuar para Localidade (Passo 2) →
                </button>
              </div>

            </form>
          </div>

          <!-- ==================================================================== -->
          <!-- 🏡 ETAPA 2: FORMULÁRIO DE LOCALIDADE & ENDEREÇO (VIA CEP ASSÍNCRONO) -->
          <!-- ==================================================================== -->
          <div v-else-if="etapaOnboarding === 2" class="animate__animated animate__fadeIn" style="max-width: 500px; margin: 0 auto; text-align: left; box-sizing: border-box;">
            
            <div style="margin-bottom: 20px;">
              <button @click="etapaOnboarding = 1" type="button" style="background: transparent; border: none; color: #878a99; font-size: 11px; font-weight: bold; text-transform: uppercase; cursor: pointer; padding: 0; font-family: monospace; outline: none; transition: 0.2s;" onmouseover="this.style.color='#ff6c22';" onmouseout="this.style.color='#878a99';">← Voltar para Passo 1</button>
            </div>

            <form @submit.prevent="etapaOnboarding = 3" style="display: flex; flex-direction: column; gap: 16px; font-family: monospace;">
              
              <!-- Digitação do CEP Postal -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Digite o CEP Residencial / Base *</label>
                <div style="position: relative; display: flex; align-items: center;">
                  <input type="text" v-model="formCadastro.zipCode" @input="processarMascaraECep" placeholder="00000-000" maxlength="9" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
                  <div v-if="loadingCep" style="position: absolute; right: 15px;" class="spinner-border spinner-border-sm text-primary" role="status"></div>
                </div>
                <span v-if="erroCep" style="color: #f06548; font-size: 11px; font-weight: bold;">❌ CEP postal não localizado na malha urbana.</span>
              </div>

              <!-- Logradouro / Rua -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Rua / Logradouro *</label>
                <input type="text" v-model="formCadastro.street" placeholder="Nome da rua ou avenida" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
              </div>

              <!-- Grid Número e Complemento -->
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; width: 100%; box-sizing: border-box;">
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Número *</label>
                  <input type="text" v-model="formCadastro.number" placeholder="Ex: 123" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
                </div>
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Complemento</label>
                  <input type="text" v-model="formCadastro.complement" placeholder="Apto, Bloco" style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
                </div>
              </div>

              <!-- Bairro -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Bairro *</label>
                <input type="text" v-model="formCadastro.neighborhood" placeholder="Nome do bairro" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
              </div>

              <!-- Grid Cidade e Estado -->
              <div style="display: grid; grid-template-columns: 3fr 1fr; gap: 15px; width: 100%; box-sizing: border-box;">
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="color: rgba(255,255,255,0.4); font-weight: bold; font-size: 11px; text-transform: uppercase;">Cidade</label>
                  <input type="text" v-model="formCadastro.city" readonly style="width: 100%; padding: 12px 16px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #0ab39c; font-size: 13px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
                </div>
                <div style="display: flex; flex-direction: column; gap: 6px;">
                  <label style="color: rgba(255,255,255,0.4); font-weight: bold; font-size: 11px; text-transform: uppercase;">UF</label>
                  <input type="text" v-model="formCadastro.state" readonly style="width: 100%; padding: 12px 16px; background-color: rgba(42, 45, 61, 0.3); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #0ab39c; font-size: 13px; font-weight: bold; outline: none; cursor: not-allowed; box-sizing: border-box;" />
                </div>
              </div>

              <div style="margin-top: 10px; text-align: right;">
                <button type="submit" style="padding: 12px 30px; background-color: #ff6c22; border: 1px solid #ff6c22; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 11px; border-radius: 6px; box-shadow: 0 4px 15px rgba(255,108,34,0.15); cursor: pointer; letter-spacing: 0.5px;">Continuar para Faturamento (Passo 3) →</button>
              </div>
            </form>
          </div>

          <!-- ==================================================================== -->
          <!-- 📊 ETAPA 3: COMPLIANCE, CPF & DISPARO COMPLETO DO COMPONENTE FILHO  -->
          <!-- ==================================================================== -->
          <div v-else-if="etapaOnboarding === 3" class="animate__animated animate__fadeIn" style="max-width: 500px; margin: 0 auto; text-align: left; box-sizing: border-box;">
            
            <div style="margin-bottom: 20px;">
              <button @click="etapaOnboarding = 2" type="button" style="background: transparent; border: none; color: #878a99; font-size: 11px; font-weight: bold; text-transform: uppercase; cursor: pointer; padding: 0; font-family: monospace; outline: none; transition: 0.2s;" onmouseover="this.style.color='#ff6c22';" onmouseout="this.style.color='#878a99';">← Voltar para Passo 2</button>
            </div>

            <form @submit.prevent="despacharCadastroAoServidor" style="display: flex; flex-direction: column; gap: 16px; font-family: monospace;">
              
              <!-- Entrada do CPF do Responsável -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Número de CPF do Responsável *</label>
                <input type="text" v-model="formCadastro.cpf" @input="aplicarMascaraCpf" placeholder="000.000.000-00" maxlength="14" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
              </div>

              <!-- Entrada do Celular/WhatsApp -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Celular / WhatsApp do Músico *</label>
                <input type="text" v-model="formCadastro.mobilePhone" @input="aplicarMascaraWhatsApp" placeholder="(00) 00000-0000" maxlength="15" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
              </div>

              <!-- Entrada da Data de Nascimento -->
              <div style="display: flex; flex-direction: column; gap: 6px;">
                <label style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase;">Data de Nascimento do Titular *</label>
                <input type="date" v-model="formCadastro.birthDate" required style="width: 100%; padding: 12px 16px; background-color: #1a1d29; border: 1px solid #3a3f50; border-radius: 8px; color: #ffffff; font-size: 13px; font-weight: bold; outline: none; box-sizing: border-box;" />
              </div>

              <!-- 🚀 DISPARO FINAL MASTER CONTRA O .NET 10 -->
              <div style="margin-top: 15px; text-align: right;">
                <button type="submit" :disabled="loadingEnvio" :style="{ backgroundColor: loadingEnvio ? '#2a2d3d' : '#0ab39c', borderColor: loadingEnvio ? '#2a2d3d' : '#0ab39c', cursor: loadingEnvio ? 'not-allowed' : 'pointer' }" style="width: 100%; padding: 15px; border: 1px solid; color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 12px; border-radius: 8px; box-shadow: 0 4px 15px rgba(10,179,156,0.15); transition: 0.2s; letter-spacing: 0.5px;">
                  {{ loadingEnvio ? 'Processando Registro no MariaDB...' : 'Finalizar Inscrição e Abrir Conta de Músico →' }}
                </button>
              </div>

            </form>
          </div>

        </div>

  </div>
</template>

<style scoped>
.artist-sales{--orange:#ff6c22;--teal:#10cdb4;--panel:#121521;--line:rgba(255,255,255,.09);color:#d8deea;background:#08090d}
.sales-hero{position:relative;min-height:650px;display:flex;align-items:center;justify-content:center;overflow:hidden;border-bottom:1px solid var(--line)}
.sales-hero-bg{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
.sales-hero-mask{position:absolute;inset:0;background:radial-gradient(circle at 50% 40%,rgba(8,9,13,.56),rgba(8,9,13,.94) 72%),linear-gradient(180deg,rgba(8,9,13,.25),#08090d)}
.sales-hero-content{position:relative;z-index:2;width:min(980px,92%);text-align:center;padding:70px 20px 55px}
.sales-badge,.section-kicker{display:inline-flex;border:1px solid rgba(255,108,34,.45);background:rgba(255,108,34,.07);color:var(--orange);border-radius:30px;padding:9px 17px;font:900 12px monospace;letter-spacing:1.2px}
.sales-audience{margin:18px 0 14px;color:#fff;font:900 16px monospace;letter-spacing:.5px}
.sales-hero h1,.sales-section h2,.pre-plans h2{margin:0;color:#fff;font:900 clamp(34px,4.4vw,58px)/1.08 monospace;letter-spacing:-1.5px}
.sales-hero h1 span,.sales-section h2 span,.pre-plans h2 span{display:block;color:var(--orange);margin-top:8px}
.sales-lead{max-width:800px;margin:24px auto;color:#c2cbda;font-size:18px;line-height:1.65}
.trial-pill{width:max-content;max-width:100%;margin:24px auto 20px;padding:10px 18px;border:1px solid rgba(16,205,180,.35);border-radius:12px;background:rgba(16,205,180,.08);display:flex;gap:10px;align-items:center;color:#cbd5e1;font-size:13px}
.trial-pill strong{color:#43dec8;font:900 14px monospace}
.sales-primary-btn{border:0;border-radius:50px;padding:18px 34px;background:linear-gradient(135deg,#ff6c22,#ff8138);color:#fff;font:900 12px monospace;letter-spacing:.7px;box-shadow:0 12px 30px rgba(255,108,34,.25);cursor:pointer}
.sales-primary-btn:hover{transform:translateY(-2px);box-shadow:0 16px 34px rgba(255,108,34,.35)}
.sales-proof{margin-top:18px;color:#aab6c8;font-size:13px}.sales-proof span{margin:0 7px;color:#465064}
.sales-section{max-width:1160px;margin:0 auto;padding:90px 28px}
.sales-section .section-kicker{margin-bottom:20px}.section-kicker.teal{border-color:rgba(16,205,180,.35);background:rgba(16,205,180,.07);color:#55ded0}
.sales-section h2{font-size:clamp(30px,3.2vw,44px);text-align:center}.section-intro{max-width:780px;margin:20px auto 42px;text-align:center;color:#aeb9cb;font-size:17px;line-height:1.7}
.sales-problem{text-align:center}.pain-grid,.smart-grid,.benefit-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:22px}
.pain-grid article,.smart-grid article,.benefit-grid article{background:linear-gradient(145deg,#141724,#0f111a);border:1px solid var(--line);border-radius:18px;padding:26px;text-align:left;transition:.2s}
.pain-grid article:hover,.smart-grid article:hover,.benefit-grid article:hover{transform:translateY(-3px);border-color:rgba(255,108,34,.42)}
.pain-grid i{font-size:25px;color:var(--orange);display:block;margin-bottom:16px}.pain-grid b{display:block;color:#fff;font-size:17px;margin-bottom:8px}.pain-grid span{color:#9fabc0;font-size:14px;line-height:1.6}
.opportunity-section{display:grid;grid-template-columns:1.05fr .95fr;gap:55px;align-items:center;border-top:1px solid rgba(255,255,255,.05);border-bottom:1px solid rgba(255,255,255,.05)}
.opportunity-section h2{text-align:left}.opportunity-copy p{color:#aeb9cb;font-size:16px;line-height:1.7}.opportunity-copy ul{list-style:none;padding:0;margin:24px 0 0}.opportunity-copy li{margin:12px 0;color:#d7deea}.opportunity-copy li:before{content:"✓";color:var(--teal);font-weight:900;margin-right:10px}
.opportunity-card{background:#11141f;border:1px solid var(--line);border-radius:20px;overflow:hidden;box-shadow:0 25px 60px rgba(0,0,0,.35)}.mini-window-top{height:44px;padding:0 15px;display:flex;align-items:center;gap:7px;border-bottom:1px solid var(--line)}.mini-window-top span{width:8px;height:8px;border-radius:50%;background:#4a5265}.mini-window-top small{margin-left:8px;color:#79849a;font:700 10px monospace}.mini-profile{display:flex;gap:16px;padding:28px}.mini-avatar{width:48px;height:48px;border-radius:13px;background:var(--orange);display:grid;place-items:center;color:#fff;font-weight:900}.mini-profile div:last-child{display:flex;flex-direction:column;gap:4px}.mini-profile small{color:var(--orange);font:800 10px monospace}.mini-profile strong{color:#fff;font-size:21px}.mini-profile span{color:#929fb4;font-size:13px}.mini-metrics{display:grid;grid-template-columns:1fr 1fr;gap:12px;padding:0 28px 28px}.mini-metrics div{padding:18px;border:1px solid var(--line);border-radius:13px;background:#171a26}.mini-metrics i{color:var(--teal);font-size:21px}.mini-metrics b,.mini-metrics span{display:block}.mini-metrics b{color:#fff;margin:8px 0 3px}.mini-metrics span{color:#8f9bb0;font-size:12px}
.intelligent-section{text-align:center}.smart-grid{margin-top:42px}.smart-icon{width:54px;height:54px;border-radius:14px;background:linear-gradient(135deg,rgba(255,108,34,.15),rgba(16,205,180,.1));display:grid;place-items:center;margin-bottom:24px}.smart-icon i{font-size:24px;color:var(--orange)}.smart-grid small,.benefit-grid small{color:#58d8ca;font:900 11px monospace;letter-spacing:.7px}.smart-grid h3,.benefit-grid h3{color:#fff;font-size:19px;margin:10px 0}.smart-grid p,.benefit-grid p{color:#a3aec0;font-size:14px;line-height:1.65;margin:0}
.security-section{text-align:center;border-top:1px solid rgba(255,255,255,.05)}.benefit-grid{margin-top:42px}.benefit-grid small{color:var(--orange)}
.pre-plans{max-width:1000px;margin:15px auto 10px;text-align:center;padding:65px 28px 25px;border-top:1px solid rgba(255,255,255,.07)}.pre-plans-badge{display:inline-block;color:#55decf;border:1px solid rgba(16,205,180,.4);background:rgba(16,205,180,.08);padding:9px 16px;border-radius:30px;font:900 12px monospace;letter-spacing:1px;margin-bottom:20px}.pre-plans h2{font-size:clamp(29px,3.2vw,42px)}.pre-plans p{max-width:720px;margin:20px auto;color:#aab6c8;font-size:15px;line-height:1.65}.arrow-down{color:var(--orange);font-size:28px;margin-top:18px;animation:bounceDown 1.6s infinite}@keyframes bounceDown{50%{transform:translateY(7px)}}
#secao-onboarding{scroll-margin-top:105px}
@media(max-width:900px){.pain-grid,.smart-grid,.benefit-grid{grid-template-columns:1fr 1fr}.opportunity-section{grid-template-columns:1fr}.opportunity-section h2{text-align:center}.opportunity-copy{text-align:center}.opportunity-copy ul{display:inline-block;text-align:left}}
@media(max-width:640px){.sales-hero{min-height:690px}.sales-hero-content{padding-top:55px}.sales-lead{font-size:16px}.trial-pill{flex-direction:column;gap:3px}.sales-proof{line-height:1.8}.pain-grid,.smart-grid,.benefit-grid{grid-template-columns:1fr}.sales-section{padding:65px 20px}.sales-section h2{font-size:29px}.mini-metrics{grid-template-columns:1fr}}
</style>

<script>
/* eslint-disable */
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import axios from "axios";

// 🌐 INFRAESTRUTURA DE MÍDIA FRAGMENTADA: Evita cortes no buffer do editor de texto
const PROTOCOLO = "https://";
const PROVEDOR = "picsum.photos";
const BARRA = "/";
const ROTA_ID = "id";

function fabricarLinkImagem(codigoFoto, largura, altura) {
  return PROTOCOLO + PROVEDOR + BARRA + ROTA_ID + BARRA + codigoFoto + BARRA + largura + BARRA + altura;
}

export default {
  name: "SouMusico",
  components: {
    NavbarPublic
  },
  data() {
    return {
      // 🛠️ CONFIGURAÇÕES DE CONTROLE DE ESTEIRA COMERCIAL
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL,
      loadingPlanos: false,
      loadingCep: false,
      loadingEnvio: false,
      erroCep: false,
      etapaOnboarding: 0, // 0 = Planos, 1 = Acesso, 2 = Localidade, 3 = Compliance
      planosSaaS: [],
      
      // Validador local volátil para checagem de igualdade de credenciais
      confirmarPasswordLocal: "",

      // 📋 Objeto Único de Onboarding síncrono casado com o DTO do C#
      formCadastro: {
        saaSPlanId: "",
        name: "",
        responsibleName: "",
        email: "",
        password: "",
        
        // Dados de Endereço (Etapa 2)
        zipCode: "",
        street: "",
        number: "",
        complement: "",
        neighborhood: "",
        city: "",
        state: "",
        
        // Dados de Compliance e Faturamento Limpo (Etapa 3)
        cpf: "",
        cnpj: null, // Enviado como nulo conforme governança (coleta interna posterior)
        mobilePhone: "",
        birthDate: "",
        incomeValue: 0.00, // Fallback zerado padrão (coleta interna posterior)
        companyType: null // Enviado como nulo conforme governança (coleta interna posterior)
      },

      // Imagens Estáticas da Vitrine
      imagemHeroBackground: fabricarLinkImagem(452, 1200, 800),
      imagemBannerAudiência: fabricarLinkImagem(984, 1200, 400)
    };
  },
  methods: {
    // 🧠 CARGA DINÂMICA: Consome o endpoint público do C# para listar os planos ativos
    async carregarPlanosDisponiveis() {
      this.loadingPlanos = true;
      try {
        const urlPlanos = `${this.apiBaseUrlGlobal}/saas-products`;
        const response = await axios.get(urlPlanos);
        if (response.data) {
          this.planosSaaS = response.data.filter(p => p.isActive !== false) || [];
        }
      } catch (error) {
        console.error("Falha ao recuperar catálogo de planos SaaS no backend:", error);
      } finally {
        this.loadingPlanos = false;
      }
    },

    // 🎯 SELEÇÃO DE PLANO: Captura o GUID do plano escolhido e avança
    selecionarPlanoEAvancar(planId) {
      if (!planId) return;
      this.formCadastro.saaSPlanId = planId;
      this.etapaOnboarding = 1; 
      this.rolarAteOnboarding();
    },

    // 🔒 VALIDADOR PASSO 1: Trava o avanço se as credenciais do artista divergirem
    validarEtapaAcessoEAvancar() {
      if (this.formCadastro.password.length < 6) {
        return alert("⚠️ Restrição de tamanho:\nA sua senha de acesso precisa conter no mínimo 6 caracteres.");
      }
      if (this.formCadastro.password !== this.confirmarPasswordLocal) {
        return alert("❌ Inconsistência de Credenciais:\nA confirmação de senha não confere com a senha digitada.");
      }
      this.etapaOnboarding = 2;
      this.rolarAteOnboarding();
    },

    // 🔍 MÁSCARA & VIACEP: Formata o CEP e bate na API pública de endereços em 8 dígitos
    async processarMascaraECep(event) {
      // 1. Sanitização inicial: isola apenas os caracteres numéricos
      let apenasNumeros = event.target.value.replace(/\D/g, "");
      
      if (apenasNumeros.length > 8) {
        apenasNumeros = apenasNumeros.substring(0, 8);
      }

      // 2. Aplica a máscara visual para a experiência do usuário (00000-000)
      let valorMascarado = apenasNumeros;
      if (apenasNumeros.length > 5) {
        valorMascarado = apenasNumeros.substring(0, 5) + "-" + apenasNumeros.substring(5, 8);
      }
      this.formCadastro.zipCode = valorMascarado;
      this.erroCep = false;

      // 3. LIMPEZA ADICIONAL: Garante que o CEP esteja limpo e sem traço para o construtor
      const cepFormatado = valorMascarado.replace("-", "");

      // 4. TRAVA DE SEGURANÇA: Só dispara a chamada ao atingir exatamente os 8 dígitos numéricos puros
      if (cepFormatado.length === 8) {
        this.loadingCep = true;
        try {
          // 🚀 EXATAMENTE IGUAL AO SEU PADRÃO: Montagem atômica usando o construtor de URL nativo
          const construtorUrl = new URL("https://viacep.com.br");
          construtorUrl.pathname = "/ws/" + cepFormatado + "/json/";
          const urlFinal = construtorUrl.toString();

          // Execução via Fetch para isolar a requisição e blindar contra falhas de CORS do Axios
          const response = await fetch(urlFinal);
          const dados = await response.json();
          
          if (dados && !dados.erro) {
            this.formCadastro.street = dados.logradouro || "";
            this.formCadastro.neighborhood = dados.bairro || "";
            this.formCadastro.city = dados.localidade || "";
            this.formCadastro.state = dados.uf || "";
            this.erroCep = false;
            console.log("🎯 [VIACEP] Endereço populado com sucesso absoluto via URL nativa:", urlFinal);
          } else {
            this.erroCep = true;
            this.limparCamposEndereco();
          }
        } catch (err) {
          console.error("Falha de rede ou timeout ao processar construtorUrl:", err);
          this.erroCep = true;
        } finally {
          this.loadingCep = false;
        }
      }
    },

    limparCamposEndereco() {
      this.formCadastro.street = "";
      this.formCadastro.neighborhood = "";
      this.formCadastro.city = "";
      this.formCadastro.state = "";
    },

    // 🖨️ FORMATADOR REATIVO: Injeta os pontos e o traço do CPF na digitação
    aplicarMascaraCpf(event) {
      let v = event.target.value.replace(/\D/g, "");
      if (v.length > 11) v = v.substring(0, 11);
      if (v.length > 9) {
        v = v.substring(0, 3) + "." + v.substring(3, 6) + "." + v.substring(6, 9) + "-" + v.substring(9, 11);
      } else if (v.length > 6) {
        v = v.substring(0, 3) + "." + v.substring(3, 6) + "." + v.substring(6, 9);
      } else if (v.length > 3) {
        v = v.substring(0, 3) + "." + v.substring(3, 6);
      }
      this.formCadastro.cpf = v;
    },

    // 🖨️ FORMATADOR REATIVO: Injeta os parênteses e o traço elástico do celular
    aplicarMascaraWhatsApp(event) {
      let v = event.target.value.replace(/\D/g, "");
      if (v.length > 11) v = v.substring(0, 11);
      if (v.length > 10) {
        v = "(" + v.substring(0, 2) + ") " + v.substring(2, 7) + "-" + v.substring(7, 11);
      } else if (v.length > 6) {
        v = "(" + v.substring(0, 2) + ") " + v.substring(2, 6) + "-" + v.substring(6, 10);
      } else if (v.length > 2) {
        v = "(" + v.substring(0, 2) + ") " + v.substring(2, v.length);
      }
      this.formCadastro.mobilePhone = v;
    },
    // 🚀 ENVIO MASTER: Dispara o payload consolidado contra o endpoint do .NET 10
    async despacharCadastroAoServidor() {
      this.loadingEnvio = true;
      try {
        const urlRegistro = `${this.apiBaseUrlGlobal}/tenants/register`;
        
        // Dispara a carga atômica contendo a cópia do objeto limpo da model
        const response = await axios.post(urlRegistro, this.formCadastro);
        
        if (response.data) {
          // Chuta reativamente o usuário de volta para a raiz ou tela de login
          this.$router.push("/");
        }
      } catch (error) {
        console.error("Falha ao registrar músico na API C#:", error);
        
        // Captura e exibe mensagens de validação vindas da controller (ex: e-mail já cadastrado)
        if (error.response && error.response.data) {
          alert(`❌ Erro no Cadastro: ${error.response.data}`);
        } else {
          alert("❌ Falha de Conexão: Não foi possível contatar o servidor de faturamento.");
        }
      } finally {
        this.loadingEnvio = false;
      }
    },

    // 🛠️ ACIONADOR COMPORTAMENTAL: Rola a tela até o formulário de forma macia
    rolarAteOnboarding() {
      const secao = document.getElementById("secao-onboarding");
      if (secao) {
        secao.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    }
  },
  mounted() {
    // Inicializa a esteira buscando os planos cadastrados de forma assíncrona
    this.carregarPlanosDisponiveis();
  }
};
</script>