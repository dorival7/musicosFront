<!-- eslint-disable vue/no-parsing-error -->
<template>
  <div class="seven-portal text-start" style="position: relative; width: 100%; min-height: 100vh; background-color: #0a0b10 !important; padding-top: 120px; display: block !important; box-sizing: border-box;">
    
    <!-- NAVBAR PÚBLICA FIXA NO TOPO -->
    <NavbarPublic />

    <div style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
      
      <!-- FEEDBACK DE CARREGAMENTO INICIAL EM TEMPO DE REDE -->
      <div v-if="loading" style="text-align: center; padding: 50px 0; font-family: monospace; color: #878a99;">
        <div class="spinner-border text-primary" role="status" style="color: #ff6c22 !important;"></div>
        <p style="margin-top: 15px; font-size: 13px; letter-spacing: 0.5px;">Carregando esteira de contratação comercial...</p>
      </div>

      <!-- CHASSI PRINCIPAL MONTADO APÓS RETORNO DA API -->
      <div v-else-if="pacoteInfo" class="animate__animated animate__fadeIn">
        <div style="display: flex; flex-wrap: wrap; gap: 30px;">
          
          <!-- ==================================================================== -->
          <!-- 📋 COLUNA DA ESQUERDA: HUB REATIVO DE ETAPAS (70%)                   -->
          <!-- ==================================================================== -->
          <div style="flex: 1; min-width: 300px;">
            
            <!-- STEP 0: MANIFESTO DE GARANTIAS -->
            <Step0Garantias 
              v-if="passoAtivo === 0" 
              :nomeAtracao="pacoteInfo?.nomeBanda || pacoteInfo?.NomeBanda"
              @prosseguir="passoAtivo = 1" 
            />

            <!-- STEP 1: AGENDA, HORÁRIO & HORAS EXTRAS -->
            <Step1AgendaExtras
              v-else-if="passoAtivo === 1"
              :artistId="pacoteInfo?.userId || pacoteInfo?.UserId"
              :apiBaseUrl="apiBaseUrlGlobal"
              :aceitaHorasExtras="aceitaHorasExtras"
              :valorHoraExtra="valorHoraExtraMúsico"
              :duracaoMinutos="Number(pacoteInfo?.duracaoMinutos || pacoteInfo?.DuracaoMinutos || 0)"
              @atualizar-agenda="receberAtualizacaoAgenda"
              @avancar-etapa="passoAtivo = 2"
            />

            <!-- STEP 2: LOGÍSTICA E FRETE -->
            <Step2Logistica
              v-else-if="passoAtivo === 2"
              @atualizar-frete="calcularFreteDeslocamento"
              @avancar-etapa="passoAtivo = 3"
            />

            <!-- STEP 3: CENTRAL DE FECHAMENTO (SUMÁRIO, MODAL CONTRATO E CHECKBOX) -->
            <Step3Contrato
              v-else-if="passoAtivo === 3"
              :pacoteInfo="pacoteInfo"
              :dataFormatada="dataSelecionadaFormatada"
              :horarioShow="horarioSelecionado"
              :horasExtras="horasExtrasContratadas"
              :taxaFrete="taxaDeslocamentoFrete"
              :totalGeral="calcularPrecoTotal"
              @avancar-etapa="avancarPassoMestre"
            />

            <!-- STEP 4: GATEWAY DE PAGAMENTO (PIX INSTANTÂNEO & CARTÃO) -->
            <Step4Pagamento
              v-else-if="passoAtivo === 4"
              :key="metodoSelecionado"
              :totalGeral="calcularPrecoTotal"
              :metodoPreSelecionado="metodoSelecionado"
            />

          </div>

                    <!-- ==================================================================== -->
          <!-- 💎 COLUNA DA DIREITA: DETALHAMENTO TRANSPARENTE DE FATURAMENTO (30%)   -->
          <!-- ==================================================================== -->
          <div class="checkout-summary-column" :class="{ 'checkout-summary-mobile-hidden': passoAtivo < 4, 'checkout-summary-mobile-payment': passoAtivo === 4 }" style="width: 340px;">
            <div style="background-color: #131520; border: 1px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); position: sticky; top: 120px; font-family: monospace;">
              
              <h4 style="color: #ffffff; font-weight: bold; text-transform: uppercase; font-size: 14px; margin: 0 0 20px 0; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.05); letter-spacing: 0.5px;">
                🛒 Resumo da contratação
              </h4>

              <!-- ITEM 1: CACHÊ CONTRATUAL BASE COM DURAÇÃO EM DESTAQUE -->
              <div style="margin-bottom: 16px; display: flex; justify-content: space-between; align-items: start;">
                <div style="flex: 1; text-align: left;">
                  <span style="color: rgba(255,255,255,0.5); font-size: 12px; text-transform: uppercase; display: block; font-weight: bold;">Artista escolhido</span>
                  <strong style="color: #ffffff; font-size: 14px; text-transform: uppercase; display: block; margin-top: 2px;">{{ pacoteInfo?.nomeBanda || pacoteInfo?.NomeBanda }}</strong>
                  <span style="color: #ced4da; display: block; font-size: 12px; margin-top: 4px; font-weight: bold;">
                    🎬 {{ pacoteInfo?.tituloPacote || pacoteInfo?.TituloPacote }}
                  </span>
                  
                  <!-- TAG DE ALTO DESTAQUE: Duração do show em Amarelo Ouro -->
                  <div style="display: inline-block; margin-top: 8px; padding: 4px 10px; background-color: rgba(255, 193, 7, 0.05); border: 1px solid rgba(255, 193, 7, 0.15); border-radius: 4px;">
                    <span style="color: #ffc107; font-size: 13px; font-weight: bold; display: flex; align-items: center; gap: 4px;">
                      ⏱️ {{ pacoteInfo?.duracaoMinutos || pacoteInfo?.DuracaoMinutos }} minutos de show
                    </span>
                  </div>
                </div>
                <span style="color: #ffffff; font-weight: bold; font-size: 14px;">{{ formatCurrency(pacoteInfo?.precoBase || pacoteInfo?.PrecoBase) }}</span>
              </div>

              <!-- 📋 INFRAESTRUTURA INCLUSA E DESCRIÇÃO DO PACOTE -->
              <div v-if="pacoteInfo?.descricaoPacote || pacoteInfo?.DescricaoPacote" class="checkout-package-description" style="background-color: rgba(255,255,255,0.02); border: 1px dashed rgba(255,255,255,0.05); border-radius: 8px; padding: 14px; margin-bottom: 18px; text-align: left;">
                <span style="color: rgba(255,255,255,0.4); font-size: 11px; text-transform: uppercase; display: block; margin-bottom: 4px; font-weight: bold;">📋 O que está incluído neste formato:</span>
                <p style="color: #a3a3a3; font-size: 12px; line-height: 1.65; margin: 0; white-space: pre-line; word-break: break-word;">
                  {{ pacoteInfo?.descricaoPacote || pacoteInfo?.DescricaoPacote }}
                </p>
              </div>

              <!-- ITEM 2: HORAS EXTRAS DISCRIMINADAS -->
              <div v-if="horasExtrasContratadas > 0" style="margin-bottom: 16px; display: flex; justify-content: space-between; align-items: start; background-color: rgba(255,108,34,0.02); padding: 8px; border-radius: 6px; border: 1px dashed rgba(255,108,34,0.15);">
                <div>
                  <span style="color: #ff6c22; font-size: 12px; text-transform: uppercase; display: block; font-weight: bold;">Adicional de Tempo</span>
                  <span style="color: #ced4da; font-size: 12px; display: block; margin-top: 2px;">+{{ horasExtrasContratadas }}h Horas Extras</span>
                  <span style="color: #878a99; font-size: 11px; display: block;">({{ formatCurrency(valorHoraExtraMúsico) }} / hora)</span>
                </div>
                <span style="color: #ff6c22; font-weight: bold; font-size: 14px; margin-top: 14px;">+{{ formatCurrency(horasExtrasContratadas * valorHoraExtraMúsico) }}</span>
              </div>

              <!-- ITEM 3: FRETE LOGÍSTICO POR KM -->
              <div v-if="quilometrosCalculados > 0" style="margin-bottom: 16px; display: flex; justify-content: space-between; align-items: start; background-color: rgba(10,179,156,0.02); padding: 8px; border-radius: 6px; border: 1px dashed rgba(10,179,156,0.15);">
                <div>
                  <span style="color: #0ab39c; font-size: 12px; text-transform: uppercase; display: block; font-weight: bold;">Logística de Viagem</span>
                  <span style="color: #ced4da; font-size: 12px; display: block; margin-top: 2px;">Deslocamento: {{ quilometrosCalculados }} KM</span>
                  
                  <!-- 🔗 CORREÇÃO VISUAL: Exibe dinamicamente o valor real usando o método formatCurrency -->
                  <span style="color: #878a99; font-size: 11px; display: block;">(Taxa por KM: {{ formatCurrency(pacoteInfo?.extraKmValue) }})</span>
                </div>
                <span style="color: #0ab39c; font-weight: bold; font-size: 14px; margin-top: 14px;">+{{ formatCurrency(taxaDeslocamentoFrete) }}</span>
              </div>

              <div style="border-top: 1px solid rgba(255,255,255,0.05); margin: 15px 0;"></div>

              <!-- TOTALIZADOR REATIVO CONSOLIDADO (BASE + EXTRAS + FRETE) -->
              <div style="background-color: rgba(0,0,0,0.25); padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.02); display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                <div>
                  <span style="color: rgba(255,255,255,0.5); font-size: 12px; text-transform: uppercase; display: block; font-weight: bold;">Total até aqui</span>
                  <strong style="color: #ff6c22; font-size: 20px; display: block; margin-top: 2px;">{{ formatCurrency(calcularPrecoTotal) }}</strong>
                </div>
                <span style="font-size: 24px; opacity: 0.4;">💵</span>
              </div>

              <!-- 🛡️ EMBLEMA DE ALTA CONFIANÇA: Custódia de Pagamento Garantida Segura SevenShows -->
              <div style="background-color: rgba(10, 179, 156, 0.06); border: 1px solid rgba(10, 179, 156, 0.25); border-radius: 8px; padding: 12px; text-align: center; box-shadow: inset 0 0 10px rgba(10,179,156,0.02);">
                <p style="color: #0ab39c; font-size: 11px; line-height: 1.5; margin: 0; font-weight: bold; text-transform: uppercase; letter-spacing: 0.3px;">
                  🔒 PAGAMENTO PROTEGIDO PELA SEVEN SHOWS<br/>
                  <span style="color: #c0c3cb; font-size: 11px; font-weight: normal; text-transform: none; display: block; margin-top: 4px; line-height: 1.4;">
                    O valor permanece protegido na plataforma e o artista só recebe após a realização do show e sua liberação.
                  </span>
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
/* eslint-disable */
import NavbarPublic from "@/components/public/NavbarPublic.vue";
import Step0Garantias from "./components/Step0Garantias.vue";
import Step1AgendaExtras from "./components/Step1AgendaExtras.vue";
import Step2Logistica from "./components/Step2Logistica.vue";
import Step3Contrato from "./components/Step3Contrato.vue";
import Step4Pagamento from "./components/Step4Pagamento.vue";
import axios from "axios";

export default {
  name: "CheckoutContratacao",
  components: { 
    NavbarPublic, 
    Step0Garantias, 
    Step1AgendaExtras, 
    Step2Logistica, 
    Step3Contrato,
    Step4Pagamento
  },
  data() {
    return {
      loading: false,
      passoAtivo: 0,
      pacoteInfo: null,
      apiBaseUrlGlobal: process.env.VUE_APP_API_BASE_URL,
      
      // 🚀 INJETADO: Armazena estritamente a escolha de faturamento vinda do Step 3
      metodoSelecionado: "pix",
      
      // ESTADOS GLOBAIS COMPARTILHADOS ENTRE OS FILHOS
      dataSelecionadaFormatada: null,
      horarioSelecionado: "",
      horasExtrasContratadas: 0,
      valorHoraExtraMúsico: 0,
      aceitaHorasExtras: false,
      startTimeLimiteArtista: null,
      taxaDeslocamentoFrete: 0,
      quilometrosCalculados: 0 
    };
  },
  computed: {
    // 📊 ALGORITMO SÊNIOR: Calcula o cachê base + o tempo elástico de horas extras
    calcularPrecoTotal() {
      const precoBase = this.pacoteInfo?.precoBase || this.pacoteInfo?.PrecoBase || 0;
      const custoExtras = this.horasExtrasContratadas * this.valorHoraExtraMúsico;
      return precoBase + custoExtras + this.taxaDeslocamentoFrete;
    }
  },
  methods: {
    // 🔀 ORQUESTRADOR MESTRE: Intercepta a string de faturamento e avança com segurança
    avancarPassoMestre(metodoPagamento = null) {
      if (metodoPagamento === "pix" || metodoPagamento === "cartao") {
        this.metodoSelecionado = metodoPagamento;
      }
      if (this.passoAtivo < 4) {
        this.passoAtivo++;
      }
    },
    async calcularFreteDeslocamento(dados) {
      // 1. LEITURA DIRETA E CRUA DA FONTE ÚNICA DA VERDADE (Sem Concorrência de Fallbacks)
      const cepOrigemArtista = this.pacoteInfo?.zipCodeOrigem;
      const valorKmConfigurado = Number(this.pacoteInfo?.extraKmValue);
      const franquiaIsentaKm = Number(this.pacoteInfo?.freeRadiusKm);
      
      const cidadeOrigemArtista = this.pacoteInfo?.cidadeOrigem;
      const ufOrigemArtista = this.pacoteInfo?.estadoOrigem;

      // 2. HIGIENIZAÇÃO DE ENTRADAS (Garante Strings limpas com fallback apenas na string vazia)
      const cepOrigemLimpo = String(cepOrigemArtista || "86490000").replace(/\D/g, "");
      const cepDestinoLimpo = String(dados?.cep || "").replace(/\D/g, "");
      
      const cidadeDestinoShow = dados?.cidade || "";
      const ufDestinoShow = dados?.uf || "";

      // 🧠 REGRA DE ISENÇÃO INDISCUTÍVEL: Se for a mesma cidade do artista, o frete é ZERO!
      if (cepDestinoLimpo && cepOrigemLimpo && cepDestinoLimpo.slice(0, 5) === cepOrigemLimpo.slice(0, 5)) {
        this.quilometrosCalculados = 0;
        this.taxaDeslocamentoFrete = 0;
        console.log("🛡️ [MOTOR LOGÍSTICA] Show na mesma cidade de " + cidadeOrigemArtista + ". Frete ISENTO.");
        return;
      }

      // 🚀 DISPARO DA ROTA: Aciona o motor utilitário gratuito OpenStreetMap (OSRM)
      if (cidadeDestinoShow && ufDestinoShow && cidadeOrigemArtista && ufOrigemArtista) {
        console.log("🛣️ [MOTOR LOGÍSTICA] Calculando rota real: " + cidadeOrigemArtista + "/" + ufOrigemArtista + " ➔ " + cidadeDestinoShow + "/" + ufDestinoShow);
        
        // Invoca o motor encapsulado passando as propriedades extraídas do pacoteInfo
        const resultadoRota = await this.obterDistanciaRodoviaria(
          cidadeOrigemArtista, 
          ufOrigemArtista, 
          cidadeDestinoShow, 
          ufDestinoShow
        );

        // 🟢 CÁLCULO FINANCEIRO REAL E ARREDONDADO
        if (resultadoRota && resultadoRota.quilometros !== null) {
          const distanciaTotalEstrada = resultadoRota.quilometros; 
          
          // Aplica o abatimento da franquia isenta recuperada do banco (Estrada - FreeRadiusKm)
          const kmDiferenca = Math.max(0, distanciaTotalEstrada - franquiaIsentaKm);
          
          // Trunca o KM final e a taxa estritamente em duas casas decimais de centavos monetários
          this.quilometrosCalculados = parseFloat(kmDiferenca.toFixed(2));
          this.taxaDeslocamentoFrete = parseFloat((this.quilometrosCalculados * valorKmConfigurado).toFixed(2));
          
          console.log("🏆 [MOTOR LOGÍSTICA] Sucesso: " + distanciaTotalEstrada + " KM Totais | " + this.quilometrosCalculados + " KM Cobrados | Taxa: R$ " + this.taxaDeslocamentoFrete);
          return;
        }
      }

      // 🛡️ PLANO B (FALLBACK DE SEGURANÇA): Ativado apenas em caso de queda extrema do OpenStreetMap
      console.warn("⚠️ [MOTOR LOGÍSTICA] Ativando contingência regional devido a oscilações externas.");
      if (cepDestinoLimpo && cepOrigemLimpo && cepDestinoLimpo.slice(0, 5) !== cepOrigemLimpo.slice(0, 5)) {
        const kmContingencia = Math.max(0, 120 - franquiaIsentaKm);
        this.quilometrosCalculados = kmContingencia; 
        this.taxaDeslocamentoFrete = parseFloat((kmContingencia * valorKmConfigurado).toFixed(2));
      } else {
        this.quilometrosCalculados = 0;
        this.taxaDeslocamentoFrete = 0;
      }
    },
    receberAtualizacaoAgenda(dados) {
      if (dados.data) {
        const [ano, mes, dia] = dados.data.split("-");
        this.dataSelecionadaFormatada = `${dia}/${mes}/${ano}`;
      } else {
        this.dataSelecionadaFormatada = null;
      }
      this.horarioSelecionado = dados.horario;
      this.horasExtrasContratadas = dados.horasExtras;
      
      // Nova variável global que receberá o limite "21:00" enviado pelo filho
      this.startTimeLimiteArtista = dados.startTimeLimite; 
    },
    async carregarDadosPacote() {
      this.loading = true;
      try {
        const pacoteId = this.$route.params.pacoteId;
        const response = await axios.get(this.apiBaseUrlGlobal + "/public/packages/" + pacoteId);
        
        if (response.data) {
          // 🚀 FONTE ÚNICA DA VERDADE: Popula o objeto com dados do pacote + Join da banda (MariaDB)
          this.pacoteInfo = response.data;

          console.log("this.pacoteInfo", JSON.stringify(this.pacoteInfo))
          
          // Hora extra: respeita estritamente a configuração comercial retornada pelo backend.
          // MariaDB/API pode retornar AcceptExtraHours como 1/0 (número ou string).
          // Normaliza aqui para booleano antes de enviar ao Step1.
          const acceptExtraHoursRaw = response.data.acceptExtraHours ?? response.data.AcceptExtraHours ?? false;
          this.aceitaHorasExtras =
            acceptExtraHoursRaw === true ||
            acceptExtraHoursRaw === 1 ||
            acceptExtraHoursRaw === "1";

          this.valorHoraExtraMúsico = Number(
            response.data.extraHourValue ??
            response.data.ExtraHourValue ??
            response.data.extraHoursValueCharged ??
            response.data.ExtraHoursValueCharged ??
            0
          );
          
          console.log("🎯 [CARGA INICIAL] Dados do Pacote e Banda carregados com sucesso.");

          // 🏛️ PROPORÇÃO DE FRETE GLOBAL: Se o cliente já está logado, calcula o OSRM direto da sessão estável
          const dadosUsuarioStr = localStorage.getItem("user");
          const tokenAtivo = localStorage.getItem("jwt");
          
          if (dadosUsuarioStr && tokenAtivo) {
            const user = JSON.parse(dadosUsuarioStr);
            
            // Força a leitura direta e síncrona a partir do rastro global unificado do localStorage
            if (user && user.cidade && user.estado) {
              console.log("👤 [CARGA INICIAL] Executando frete para usuário logado a partir do endereço global: " + user.cidade);
              
              // Invoca o motor de rotas de forma segura passando os parâmetros corretos
              this.calcularFreteDeslocamento({
                cidade: user.cidade,
                uf: user.estado,
                cep: user.cep ? String(user.cep).replace(/\D/g, "") : ""
              });
            }
          }
        }
      } catch (error) {
        console.error("Falha ao carregar pacote no orquestrador pai:", error);
      } finally {
        this.loading = false;
      }
    },
    formatCurrency(value) {
      if (!value) return "R$ 0,00";
      return new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value);
    },
    async obterDistanciaRodoviaria(cidadeOrigem, ufOrigem, cidadeDestino, ufDestino) {
      // Validação rápida de integridade das strings de entrada
      if (!cidadeOrigem || !ufOrigem || !cidadeDestino || !ufDestino) {
        console.warn("⚠️ [MOTOR ROTAS] Parâmetros de localização incompletos para o cálculo.");
        return null;
      }

      // 🌍 QUEBRA DA INFRAESTRUTURA DO NOMINATIM EM VARIÁVEIS CURTAS
      const dnsNominatim = "https://nominatim.";
      const domNominatim = "openstreetmap.org";
      const rotaNominatim = "/search?city=";

      // 🌍 QUEBRA DA INFRAESTRUTURA DO OSRM EM VARIÁVEIS CURTAS
      const esquemaWeb = "https://";
      const prefixoRouter = "router.";
      const nomeServidor = "project-osrm";
      const sufixoOrg = ".org";
      const dnsOSRM = esquemaWeb + prefixoRouter + nomeServidor + sufixoOrg;
      const rotaOSRM = "/route/v1/driving/";

      try {
        // 🚀 PASSO 1: Busca coordenadas geográficas da cidade de Origem (Músico)
        const urlOrigem = dnsNominatim + domNominatim + rotaNominatim + encodeURIComponent(cidadeOrigem) + "&state=" + encodeURIComponent(ufOrigem) + "&format=json&limit=1";
        const resOrigem = await axios.get(urlOrigem);

        // 🚀 PASSO 2: Busca coordenadas geográficas da cidade de Destino (Show)
        const urlDestino = dnsNominatim + domNominatim + rotaNominatim + encodeURIComponent(cidadeDestino) + "&state=" + encodeURIComponent(ufDestino) + "&format=json&limit=1";
        const resDestino = await axios.get(urlDestino);

        // Se o Nominatim localizou os dois pontos geográficos com sucesso
        if (resOrigem.data && resOrigem.data.length > 0 && resDestino.data && resDestino.data.length > 0) {
          const latOrigem = resOrigem.data[0].lat;
          const lonOrigem = resOrigem.data[0].lon;
          const latDestino = resDestino.data[0].lat;
          const lonDestino = resDestino.data[0].lon;

          // 🚀 PASSO 3: Consulta o trajeto rodoviário real no servidor do OSRM
          const urlOSRM = dnsOSRM + rotaOSRM + lonOrigem + "," + latOrigem + ";" + lonDestino + "," + latDestino + "?overview=false";
          const resOSRM = await axios.get(urlOSRM);

          if (resOSRM.data && resOSRM.data.routes && resOSRM.data.routes.length > 0) {
            const distanciaEmMetros = resOSRM.data.routes[0].distance;
            const tempoEmSegundos = resOSRM.data.routes[0].duration;

            // Transforma metros em KM flutuante real (Mantendo as casas decimais de precisão)
            const kmCalculadoFloat = parseFloat((distanciaEmMetros / 1000).toFixed(2));
            const minutosCalculadosInt = parseInt((tempoEmSegundos / 60).toFixed(0));

            // Retorna o payload estruturado contendo a quilometragem e o tempo real de estrada
            return {
              quilometros: kmCalculadoFloat,
              tempoMinutos: minutosCalculadosInt
            };
          }
        }
        
        // Retorno de contingência caso os arrays venham vazios do OpenStreetMap
        return null;
      } catch (error) {
        console.error("🚨 [MOTOR ROTAS] Queda ou instabilidade detectada nas APIs públicas:", error.message);
        // Intercepta a falha de rede silenciosamente retornando null para ativar o Plano B externo
        return null;
      }
    },
  },
    async mounted() {
    // Mantém a sua chamada original intocada e funcionando perfeitamente
    this.carregarDadosPacote();
    
  }

};

</script>


<style scoped>
/* Mobile: o resumo fica oculto durante agenda e logística e aparece
   somente a partir da etapa de revisão/fechamento. Desktop permanece igual. */
@media (max-width: 767.98px) {
  .checkout-summary-column.checkout-summary-mobile-hidden {
    display: none !important;
  }

  .checkout-summary-column {
    width: 100% !important;
  }

  /* Etapa final no mobile: a conferência completa já ocorreu no passo 3. */
  .checkout-summary-column.checkout-summary-mobile-payment {
    display: none !important;
  }

  /* No mobile, o resumo fica objetivo: detalhes extensos do formato
     continuam disponíveis na vitrine e permanecem visíveis no desktop. */
  .checkout-package-description {
    display: none !important;
  }
}
</style>
