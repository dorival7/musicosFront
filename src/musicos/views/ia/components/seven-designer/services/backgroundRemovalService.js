import {
  AutoModel,
  AutoProcessor,
  RawImage,
  env
} from "@huggingface/transformers";


/*
 * ================================================================
 * SEVEN DESIGNER
 * Background Removal Service
 * ================================================================
 *
 * Motor:
 *   MODNet
 *
 * Modelo:
 *   Xenova/modnet
 *
 * Processamento:
 *   100% no navegador do usuário.
 * ================================================================
 */

const MODEL_ID = "Xenova/modnet";


env.allowRemoteModels = true;


let model = null;

let processor = null;

let carregandoModelo = null;


/*
 * ================================================================
 * CARREGAR MODELO
 * ================================================================
 */
async function carregarModelo(
  onProgress = null
) {

  if (
    model &&
    processor
  ) {

    return {
      model,
      processor
    };

  }


  if (carregandoModelo) {

    return carregandoModelo;

  }


  carregandoModelo =
    (async () => {

      try {

        const progressCallback =
          (evento) => {

            if (
              typeof onProgress ===
              "function"
            ) {

              onProgress(
                evento
              );

            }

          };


        /*
         * Processor
         */
        processor =
          await AutoProcessor.from_pretrained(
            MODEL_ID,
            {
              progress_callback:
                progressCallback
            }
          );


        /*
         * Modelo MODNet
         *
         * fp32 é a configuração indicada
         * pelo próprio modelo.
         */
        model =
          await AutoModel.from_pretrained(
            MODEL_ID,
            {
              dtype: "fp32",

              progress_callback:
                progressCallback
            }
          );


        return {
          model,
          processor
        };

      }
      catch (erro) {

        model = null;

        processor = null;


        console.error(
          "[SEVEN DESIGNER] Erro ao carregar MODNet:",
          erro
        );


        throw erro;

      }
      finally {

        carregandoModelo =
          null;

      }

    })();


  return carregandoModelo;

}


/*
 * ================================================================
 * FILE -> RAW IMAGE
 * ================================================================
 */
async function arquivoParaRawImage(
  arquivo
) {

  const url =
    URL.createObjectURL(
      arquivo
    );


  try {

    const imagem =
      await RawImage.fromURL(
        url
      );


    return imagem;

  }
  finally {

    URL.revokeObjectURL(
      url
    );

  }

}


/*
 * ================================================================
 * CRIAR PNG TRANSPARENTE
 * ================================================================
 */
async function criarImagemTransparente(
  arquivo,
  mask
) {

  /*
   * Carrega a imagem original.
   */
  const bitmap =
    await createImageBitmap(
      arquivo
    );


  /*
   * Canvas final.
   */
  const canvas =
    document.createElement(
      "canvas"
    );


  canvas.width =
    bitmap.width;

  canvas.height =
    bitmap.height;


  const ctx =
    canvas.getContext(
      "2d",
      {
        willReadFrequently: true
      }
    );


  ctx.drawImage(
    bitmap,
    0,
    0
  );


  /*
   * Pixels originais.
   */
  const imagemOriginal =
    ctx.getImageData(
      0,
      0,
      canvas.width,
      canvas.height
    );


  /*
   * ==============================================================
   * MÁSCARA
   * ==============================================================
   *
   * A máscara recebida do MODNet já foi
   * convertida para RawImage e redimensionada
   * para o tamanho da fotografia original.
   */
  const maskCanvas =
    mask.toCanvas();


  /*
   * Garantimos o mesmo tamanho.
   */
  const resizedMaskCanvas =
    document.createElement(
      "canvas"
    );


  resizedMaskCanvas.width =
    canvas.width;

  resizedMaskCanvas.height =
    canvas.height;


  const resizedMaskCtx =
    resizedMaskCanvas.getContext(
      "2d",
      {
        willReadFrequently: true
      }
    );


  resizedMaskCtx.imageSmoothingEnabled =
    true;

  resizedMaskCtx.imageSmoothingQuality =
    "high";


  resizedMaskCtx.drawImage(
    maskCanvas,
    0,
    0,
    canvas.width,
    canvas.height
  );


  const mascara =
    resizedMaskCtx.getImageData(
      0,
      0,
      canvas.width,
      canvas.height
    );


  /*
   * ==============================================================
   * APLICAR ALPHA
   * ==============================================================
   *
   * A máscara é grayscale.
   *
   * Utilizamos o canal vermelho como alpha.
   */
  for (
    let i = 0;
    i < imagemOriginal.data.length;
    i += 4
  ) {

    imagemOriginal.data[
      i + 3
    ] =
      mascara.data[i];

  }


  ctx.putImageData(
    imagemOriginal,
    0,
    0
  );


  /*
   * Libera bitmap.
   */
  if (
    typeof bitmap.close ===
    "function"
  ) {

    bitmap.close();

  }


  /*
   * Canvas -> PNG
   */
  const blob =
    await new Promise(
      (
        resolve,
        reject
      ) => {

        canvas.toBlob(
          (resultado) => {

            if (resultado) {

              resolve(
                resultado
              );

            }
            else {

              reject(
                new Error(
                  "Não foi possível gerar a imagem transparente."
                )
              );

            }

          },

          "image/png"

        );

      }
    );


  return blob;

}


/*
 * ================================================================
 * REMOVER BACKGROUND
 * ================================================================
 */
export async function removerBackground(
  arquivo,
  options = {}
) {

  if (
    !(arquivo instanceof File)
  ) {

    throw new Error(
      "Arquivo de imagem inválido."
    );

  }


  const {
    onProgress = null
  } = options;


  /*
   * ==============================================================
   * 1. CARREGA MODELO
   * ==============================================================
   */
  const {
    model: modelo,
    processor: processador
  } =
    await carregarModelo(
      onProgress
    );


  /*
   * ==============================================================
   * 2. CARREGA IMAGEM
   * ==============================================================
   */
  const imagem =
    await arquivoParaRawImage(
      arquivo
    );


  /*
   * ==============================================================
   * 3. PREPROCESSAMENTO
   * ==============================================================
   *
   * IMPORTANTE:
   *
   * MODNet não recebe diretamente o objeto
   * retornado pelo processor.
   *
   * Precisamos extrair pixel_values.
   */
  const {
    pixel_values
  } =
    await processador(
      imagem
    );


  if (!pixel_values) {

    throw new Error(
      "O processador MODNet não retornou pixel_values."
    );

  }


  /*
   * ==============================================================
   * 4. INFERÊNCIA
   * ==============================================================
   *
   * Esta é a assinatura esperada pelo
   * Xenova/modnet:
   *
   * model({
   *     input: pixel_values
   * })
   */
  const {
    output
  } =
    await modelo({
      input:
        pixel_values
    });


  if (!output) {

    throw new Error(
      "O MODNet não retornou a máscara da imagem."
    );

  }


  /*
   * ==============================================================
   * 5. TENSOR -> RAW IMAGE
   * ==============================================================
   *
   * output[0]
   *
   * Valores MODNet:
   *     0..1
   *
   * RawImage:
   *     0..255
   */
  const mask =
    await RawImage
      .fromTensor(
        output[0]
          .mul(255)
          .to("uint8")
      )
      .resize(
        imagem.width,
        imagem.height
      );


  /*
   * ==============================================================
   * 6. APLICA MÁSCARA NA FOTO ORIGINAL
   * ==============================================================
   */
  const blob =
    await criarImagemTransparente(
      arquivo,
      mask
    );


  /*
   * ==============================================================
   * 7. URL TEMPORÁRIA
   * ==============================================================
   */
  const url =
    URL.createObjectURL(
      blob
    );


  return {

    blob,

    url

  };

}


/*
 * ================================================================
 * LIBERAR URL
 * ================================================================
 */
export function liberarBackgroundUrl(
  url
) {

  if (
    url &&
    url.startsWith("blob:")
  ) {

    URL.revokeObjectURL(
      url
    );

  }

}