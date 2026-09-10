<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="seven-portal text-start" style="position: relative; width: 100%; min-height: 100vh; background-color: #08090d !important; padding-bottom: 100px; display: block !important; box-sizing: border-box; font-family: sans-serif; color: #ced4da; overflow-x: hidden;">
    
    <!-- FIXAÇÃO ABSOLUTA DA NAVBAR SUPERIOR -->
    <NavbarPublic />

    <!-- ==================================================================== -->
    <!-- 🌌 SEÇÃO 1: BANNER HERO IMERSIVO DE PONTA A PONTA (ESTILO FESTIVAL)  -->
    <!-- ==================================================================== -->
    <div style="position: relative; width: 100%; height: 560px; overflow: hidden; display: flex; align-items: center; justify-content: center; border-bottom: 1px solid rgba(255,255,255,0.05); box-shadow: 0 10px 40px rgba(0,0,0,0.5);" class="animate__animated animate__fadeIn">
      
      <!-- Imagem de Fundo Bruta do Show Expandida -->
      <img :src="imagemHeroBackground" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1;" alt="Palco principal iluminado ao vivo" />
      
      <!-- Máscara de Contraste Escura e Gradiente Sênior para Leitura Perfeita -->
      <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(135deg, rgba(8,9,13,0.95) 0%, rgba(8,9,13,0.75) 50%, rgba(8,9,13,0.95) 100%); z-index: 2;"></div>

      <!-- Conteúdo Comercial Centralizado e Sobreposto -->
      <div style="position: relative; z-index: 3; max-width: 850px; padding: 0 24px; text-align: center; margin-top: 40px;">
        
        <!-- Badge Flutuante Neon -->
        <div style="display: inline-flex; align-items: center; gap: 8px; background: rgba(19, 21, 37, 0.85); border: 1px solid rgba(255,108,34,0.4); padding: 8px 22px; border-radius: 30px; margin-bottom: 25px; backdrop-filter: blur(10px);">
          <span style="color: #ff6c22; font-weight: 900; font-size: 11px; text-transform: uppercase; letter-spacing: 1.5px; font-family: monospace;">★ SEVENSHOWS FOR ARTISTS</span>
        </div>
        
        <h1 style="color: #ffffff; font-weight: 900; font-size: 42px; line-height: 1.2; margin: 0 0 20px 0; text-transform: uppercase; letter-spacing: -1px; font-family: monospace; text-shadow: 0 4px 15px rgba(0,0,0,0.9);">
          MULTIPLIQUE AS VENDAS DA SUA BANDA <br />
          <span style="background: linear-gradient(135deg, #ff6c22 0%, #ff9e66 50%, #0ab39c 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; filter: drop-shadow(0 2px 10px rgba(255,108,34,0.3));">SEM DEPENDER DE INTERMEDIÁRIOS</span>
        </h1>
        
        <p style="color: #e2e4eb; font-size: 15px; line-height: 1.6; margin: 0 0 35px 0; font-weight: 500; text-shadow: 0 2px 8px rgba(0,0,0,0.9);">
          Gerencie sua agenda digital, emita minutas de contrato com assinatura eletrônica automática e tenha a segurança de receber via PIX ou faturamento integrado antes mesmo de subir ao palco. Sua única preocupação será o show.
        </p>

        <!-- Botão Master de Conversão -->
        <button @click="rolarAteOnboarding" type="button" style="background: linear-gradient(135deg, #ff6c22, #ff8138); border: none; color: #ffffff; padding: 18px 45px; font-size: 11px; font-weight: 900; text-transform: uppercase; border-radius: 50px; box-shadow: 0 8px 25px rgba(255,108,34,0.4); cursor: pointer; transition: 0.2s; letter-spacing: 1px; outline: none;" onmouseover="this.style.transform='scale(1.02)';" onmouseout="this.style.transform='scale(1)';">
          Criar Meu Perfil de Artista Grátis →
        </button>
      </div>

    </div>

    <!-- CONTÊINER PARA OS RECURSOS INFERIORES -->
    <div style="max-width: 1200px; margin: 0 auto; padding: 0 24px; margin-top: 50px;">
<!-- ==================================================================== -->
      <!-- 💎 SEÇÃO 2: GRID COMPACTO E MINIMALISTA (FOCO TEXTUAL PREMIUM)      -->
      <!-- ==================================================================== -->
      <div style="margin-bottom: 35px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.05);">
        <h3 style="color: #ffffff; font-size: 14px; font-weight: 900; text-transform: uppercase; letter-spacing: 1px; margin: 0; font-family: monospace;">
          汇 RECURSOS DESENVOLVIDOS PARA BLINDAR SUA CARREIRA
        </h3>
      </div>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 25px;">
        
        <!-- Benefício 1 -->
        <div style="background-color: #131524; border: 1px solid rgba(255,255,255,0.04); border-radius: 16px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); transition: 0.2s;" onmouseover="this.style.borderColor='#ff6c22';" onmouseout="this.style.borderColor='rgba(255,255,255,0.04)';">
          <div style="color: #ff6c22; font-size: 11px; font-weight: 900; text-transform: uppercase; font-family: monospace; margin-bottom: 8px; letter-spacing: 0.5px;">01. Aceleração de Mercado</div>
          <h4 style="color: #ffffff; font-size: 14px; font-weight: bold; margin: 0 0 10px 0;">Aumento Real de Vendas</h4>
          <p style="color: #878a99; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif;">Fique visível na nossa vitrine pública regional. Contratantes encontram seus pacotes comerciais, escolhem as suas datas livres e fecham a contratação direto pelo checkout.</p>
        </div>

        <!-- Benefício 2 -->
        <div style="background-color: #131524; border: 1px solid rgba(255,255,255,0.04); border-radius: 16px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); transition: 0.2s;" onmouseover="this.style.borderColor='#0ab39c';" onmouseout="this.style.borderColor='rgba(255,255,255,0.04)';">
          <div style="color: #0ab39c; font-size: 11px; font-weight: 900; text-transform: uppercase; font-family: monospace; margin-bottom: 8px; letter-spacing: 0.5px;">02. Blindagem Financeira</div>
          <h4 style="color: #ffffff; font-size: 14px; font-weight: bold; margin: 0 0 10px 0;">Garantia de Recebimento</h4>
          <p style="color: #878a99; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif;">Sem espaço para calotes. A data só fica bloqueada na agenda quando o Pix ou Cartão é liquidado pelo gateway Asaas, mantendo o cachê guardado em custódia segura.</p>
        </div>

        <!-- Benefício 3 -->
        <div style="background-color: #131524; border: 1px solid rgba(255,255,255,0.04); border-radius: 16px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); transition: 0.2s;" onmouseover="this.style.borderColor='#299cdb';" onmouseout="this.style.borderColor='rgba(255,255,255,0.04)';">
          <div style="color: #299cdb; font-size: 11px; font-weight: 900; text-transform: uppercase; font-family: monospace; margin-bottom: 8px; letter-spacing: 0.5px;">03. Gestão Centralizada</div>
          <h4 style="color: #ffffff; font-size: 14px; font-weight: bold; margin: 0 0 10px 0;">Painel de Controle (Dashboard)</h4>
          <p style="color: #878a99; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif;">Acompanhe o faturamento da sua carreira, gerencie propostas em análise, verifique contratos assinados e acompanhe relatórios financeiros completos de forma centralizada.</p>
        </div>

        <!-- Benefício 4 -->
        <div style="background-color: #131524; border: 1px solid rgba(255,255,255,0.04); border-radius: 16px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); transition: 0.2s;" onmouseover="this.style.borderColor='#ff6c22';" onmouseout="this.style.borderColor='rgba(255,255,255,0.04)';">
          <div style="color: #ff6c22; font-size: 11px; font-weight: 900; text-transform: uppercase; font-family: monospace; margin-bottom: 8px; letter-spacing: 0.5px;">04. Sincronia de Datas</div>
          <h4 style="color: #ffffff; font-size: 14px; font-weight: bold; margin: 0 0 10px 0;">Controle de Agenda Digital</h4>
          <p style="color: #878a99; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif;">Sincronia automática total. Um painel interativo para você bloquear folgas ou indisponibilidades com facilidade, organizando suas apresentações sem riscos de reservas duplas.</p>
        </div>

        <!-- Benefício 5 -->
        <div style="background-color: #131524; border: 1px solid rgba(255,255,255,0.04); border-radius: 16px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); transition: 0.2s;" onmouseover="this.style.borderColor='#ff6c22';" onmouseout="this.style.borderColor='rgba(255,255,255,0.04)';">
          <div style="color: #ff6c22; font-size: 11px; font-weight: 900; text-transform: uppercase; font-family: monospace; margin-bottom: 8px; letter-spacing: 0.5px;">05. Motor Tecnológico</div>
          <h4 style="color: #ffffff; font-size: 14px; font-weight: bold; margin: 0 0 10px 0;">Cálculo de KM e Deslocamento</h4>
          <p style="color: #878a99; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif;">Nosso motor de mapas calcula as rotas rodoviárias reais de estrada. O sistema deduz a sua franquia de raio gratuito e cobra taxas extras automáticas por cada quilômetro excedente.</p>
        </div>

        <!-- Benefício 6 -->
        <div style="background-color: #131524; border: 1px solid rgba(255,255,255,0.04); border-radius: 16px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); transition: 0.2s;" onmouseover="this.style.borderColor='#ff6c22';" onmouseout="this.style.borderColor='rgba(255,255,255,0.04)';">
          <div style="color: #ff6c22; font-size: 11px; font-weight: 900; text-transform: uppercase; font-family: monospace; margin-bottom: 8px; letter-spacing: 0.5px;">06. Respeito ao Músico</div>
          <h4 style="color: #ffffff; font-size: 14px; font-weight: bold; margin: 0 0 10px 0;">Taxação por Hora Extra</h4>
          <p style="color: #878a99; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif;">Se o evento atrasar ou a comemoração pedir bis, seu tempo extra de palco está protegido. O contratante realiza o pagamento adicional de hora extra diretamente pela esteira.</p>
        </div>

                <!-- ==================================================================== -->
        <!-- 🌌 NOVO BANNER HERO 2: VISIBILIDADE REGIONAL E VITRINE DE MÍDIA       -->
        <!-- ==================================================================== -->
        <div style="grid-column: 1 / -1; margin: 50px 0 20px 0; position: relative; width: 100%; min-height: 280px; border-radius: 24px; overflow: hidden; display: flex; align-items: center; box-shadow: 0 20px 50px rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.06);">
          
          <!-- Imagem de Fundo do Banner 2 (Multidão/Audiência em Alta Resolução) -->
          <img :src="imagemBannerAudiência" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: 1; opacity: 0.15;" alt="Multidão assistindo show" />
          <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(135deg, #111322 30%, rgba(17,19,34,0.85) 100%); z-index: 2;"></div>

          <!-- Conteúdo Interno do Banner Dividido em Duas Colunas -->
          <div style="position: relative; z-index: 3; width: 100%; padding: 45px; display: flex; flex-wrap: wrap; gap: 40px; align-items: center; justify-content: space-between;">
            
            <!-- Lado Esquerdo: A Carga da Promessa de Audiência (60%) -->
            <div style="flex: 1; min-width: 300px; text-align: left;">
              <div style="display: inline-block; background-color: rgba(10,179,156,0.1); border: 1px solid rgba(10,179,156,0.3); padding: 4px 14px; border-radius: 50px; margin-bottom: 15px;">
                <span style="color: #0ab39c; font-weight: bold; font-size: 10px; text-transform: uppercase; letter-spacing: 1px; font-family: monospace;">🚀 Visibilidade Máxima Regional</span>
              </div>
              <h2 style="color: #ffffff; font-weight: 900; font-size: 26px; line-height: 1.2; margin: 0 0 12px 0; text-transform: uppercase; font-family: monospace; letter-spacing: -0.5px;">
                SEU PERFIL VISTO POR <span style="color: #ff6c22;">MILHARES DE CONTRATANTES</span> DIRETO NA SUA REGIÃO
              </h2>
              <p style="color: #949aaf; font-size: 12px; line-height: 1.6; margin: 0; font-family: sans-serif; max-width: 620px;">
                Conectamos sua carreira direto com promotores de eventos, prefeituras, casamentos e donos de bares locais. Ao se cadastrar, seu portfólio entra em nosso motor reativo e passa a ser ofertado ativamente para quem tem orçamento pronto para fechar shows na sua praça de deslocamento.
              </p>
            </div>

            <!-- Lado Direito: A Vitrine de Recursos de Mídia (40%) -->
            <div style="width: 340px; background: rgba(8,9,13,0.6); border: 1px solid rgba(255,255,255,0.05); padding: 25px; border-radius: 16px; backdrop-filter: blur(10px); text-align: left;">
              <span style="color: #ffffff; font-weight: bold; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; font-family: monospace; display: block; margin-bottom: 15px;">📸 Portfólio de Alta Conversão:</span>
              
              <div style="display: flex; flex-direction: column; gap: 12px;">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <div style="color: #ff6c22; font-size: 14px;">🖼️</div>
                  <span style="color: #ced4da; font-size: 11px; font-weight: bold; text-transform: uppercase; font-family: monospace;">Galeria de Fotos Premium</span>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                  <div style="color: #ff6c22; font-size: 14px;">🎬</div>
                  <span style="color: #ced4da; font-size: 11px; font-weight: bold; text-transform: uppercase; font-family: monospace;">Vídeos Integrados (YouTube/Vimeo)</span>
                </div>
                <div style="display: flex; align-items: center; gap: 10px;">
                  <div style="color: #ff6c22; font-size: 14px;">🎵</div>
                  <span style="color: #ced4da; font-size: 11px; font-weight: bold; text-transform: uppercase; font-family: monospace;">Streaming e Links de Redes Sociais</span>
                </div>
              </div>
            </div>

          </div>
        </div>

        <!-- ==================================================================== -->
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
              {{ etapaOnboarding === 0 ? 'Selecione o plano ideal para a sua carreira' : 'Crie suas credenciais de acesso' }}
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
              <!-- Tag de Destaque Recomendado (Alinhada ao preço mais alto do Ouro) -->
              <div v-if="plano.monthlyFee > 50" style="position: absolute; top: -12px; left: 50%; transform: translateX(-50%); background-color: #0ab39c; color: #ffffff; font-size: 9px; font-weight: bold; padding: 4px 12px; border-radius: 4px; text-transform: uppercase; letter-spacing: 0.5px; font-family: monospace; white-space: nowrap; z-index: 5;">
                🚀 RECOMENDADO
              </div>

              <!-- Topo do Card -->
              <div style="text-align: center; margin-bottom: 20px;">
                <h4 style="color: #ffffff; font-size: 15px; font-weight: 900; margin: 0 0 6px 0; text-transform: uppercase; font-family: monospace; letter-spacing: 0.5px;">{{ plano.name }}</h4>
                <p style="color: #878a99; font-size: 11px; margin: 0; line-height: 1.4; font-family: sans-serif; min-height: 32px;">{{ plano.description || 'Ideal para gerenciar seus shows regionais.' }}</p>
              </div>

              <!-- Centro do Card: Bloco de Faturamento com Cifrão -->
              <div style="background-color: rgba(255,255,255,0.02); border-radius: 12px; padding: 15px; text-align: center; margin-bottom: 20px; border: 1px solid rgba(255,255,255,0.03);">
                <span style="color: #878a99; font-size: 10px; font-weight: bold; text-transform: uppercase; font-family: monospace;">Mensalidade</span>
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
                Selecionar Plano →
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
    </div>
  </div>
</template>
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