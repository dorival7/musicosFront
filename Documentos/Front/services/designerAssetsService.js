import axios from "axios";

const API_BASE_URL = process.env.VUE_APP_API_BASE_URL;

function obterToken() {
  const token = localStorage.getItem("jwt");

  if (!token) {
    throw new Error("Token de autenticação do músico não encontrado.");
  }

  return token.replace(/^Bearer\s+/i, "");
}

function obterConfig() {
  return {
    headers: {
      Authorization: `Bearer ${obterToken()}`
    }
  };
}

export async function listarDesignerAssets() {
  const response = await axios.get(
    `${API_BASE_URL}/tenants/designer-assets`,
    obterConfig()
  );
  return response.data;
}

export async function enviarDesignerAsset(file) {
  const formData = new FormData();
  formData.append("file", file);

  const response = await axios.post(
    `${API_BASE_URL}/tenants/designer-assets`,
    formData,
    {
      headers: {
        Authorization: `Bearer ${obterToken()}`
      }
    }
  );
  return response.data;
}

export async function excluirDesignerAsset(id) {
  const response = await axios.delete(
    `${API_BASE_URL}/tenants/designer-assets/${id}`,
    obterConfig()
  );
  return response.data;
}

export function urlDesignerAsset(relativeUrl) {
  if (!relativeUrl) return null;

  if (
    relativeUrl.startsWith("http://") ||
    relativeUrl.startsWith("https://") ||
    relativeUrl.startsWith("blob:")
  ) {
    return relativeUrl;
  }

  // Os endpoints usam VUE_APP_API_BASE_URL (normalmente terminando em /api),
  // mas os arquivos do wwwroot são servidos pela raiz do host.
  const baseSemApi = String(API_BASE_URL || "")
    .replace(/\/+$/, "")
    .replace(/\/api$/i, "");

  const caminho = relativeUrl.startsWith("/")
    ? relativeUrl
    : `/${relativeUrl}`;

  return `${baseSemApi}${caminho}`;
}
