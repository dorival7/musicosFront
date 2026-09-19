import axios from "axios";

const API_BASE_URL = process.env.VUE_APP_API_BASE_URL;

function obterToken() {
  const token = localStorage.getItem("jwt");

  if (!token) {
    throw new Error("Token de autenticação do músico não encontrado.");
  }

  return token.replace(/^Bearer\\s+/i, "");
}

function authHeaders() {
  return {
    Authorization: `Bearer ${obterToken()}`
  };
}

export async function listarDesignerAssets() {
  const response = await axios.get(
    `${API_BASE_URL}/tenants/designer-assets`,
    { headers: authHeaders() }
  );
  return response.data;
}

export async function enviarDesignerAsset(file) {
  const formData = new FormData();
  formData.append("file", file);

  const response = await axios.post(
    `${API_BASE_URL}/tenants/designer-assets`,
    formData,
    { headers: authHeaders() }
  );
  return response.data;
}

export async function excluirDesignerAsset(id) {
  const response = await axios.delete(
    `${API_BASE_URL}/tenants/designer-assets/${id}`,
    { headers: authHeaders() }
  );
  return response.data;
}

export function urlDesignerAsset(relativeUrl) {
  if (!relativeUrl) return null;

  if (/^(https?:|blob:|data:)/i.test(relativeUrl)) {
    return relativeUrl;
  }

  const baseSemApi = String(API_BASE_URL || "")
    .replace(/\/+$/, "")
    .replace(/\/api$/i, "");

  return `${baseSemApi}${relativeUrl.startsWith("/") ? "" : "/"}${relativeUrl}`;
}

export async function enviarBackgroundRemovidoDesignerAsset(assetId, blob) {
  if (!assetId) {
    throw new Error("Asset da imagem não informado.");
  }

  if (!blob) {
    throw new Error("PNG sem fundo não informado.");
  }

  const arquivo = new File(
    [blob],
    `${assetId}-sem-fundo.png`,
    { type: "image/png" }
  );

  const formData = new FormData();
  formData.append("file", arquivo);

  const token = localStorage.getItem("jwt");

  if (!token) {
    throw new Error("Token de autenticação do músico não encontrado.");
  }

  const response = await axios.post(
    `${process.env.VUE_APP_API_BASE_URL}/tenants/designer-assets/${assetId}/background-removed`,
    formData,
    {
      headers: {
        Authorization: `Bearer ${token.replace(/^Bearer\s+/i, "")}`
      }
    }
  );

  return response.data;
}
