import axios from "axios";

const API_BASE_URL = process.env.VUE_APP_API_BASE_URL;
const ENDPOINT = `${API_BASE_URL}/tenants/designer-posters`;

function obterToken() {
  const token = localStorage.getItem("jwt");
  if (!token) {
    throw new Error("Token de autenticação do músico não encontrado.");
  }
  return token.replace(/^Bearer\s+/i, "");
}

function config() {
  return {
    headers: {
      Authorization: `Bearer ${obterToken()}`
    }
  };
}

export async function listarDesignerPosters() {
  const response = await axios.get(ENDPOINT, config());
  return response.data;
}

export async function garantirDesignerPosterAtivo() {
  const response = await axios.post(
    `${ENDPOINT}/active/ensure`,
    null,
    config()
  );
  return response.data;
}

export async function obterDesignerPoster(id) {
  const response = await axios.get(
    `${ENDPOINT}/${id}`,
    config()
  );
  return response.data;
}

export async function autosalvarDesignerPoster(id, payload) {
  const response = await axios.put(
    `${ENDPOINT}/${id}/autosave`,
    payload,
    config()
  );
  return response.data;
}

export async function salvarDesignerPoster(id, name) {
  const response = await axios.post(
    `${ENDPOINT}/${id}/save`,
    { name },
    config()
  );
  return response.data;
}

export async function criarNovoDesignerPoster() {
  const response = await axios.post(
    `${ENDPOINT}/new`,
    null,
    config()
  );
  return response.data;
}

export async function abrirDesignerPoster(id) {
  const response = await axios.post(
    `${ENDPOINT}/${id}/open`,
    null,
    config()
  );
  return response.data;
}

export async function duplicarDesignerPoster(id) {
  const response = await axios.post(
    `${ENDPOINT}/${id}/duplicate`,
    null,
    config()
  );
  return response.data;
}

export async function excluirDesignerPoster(id) {
  const response = await axios.delete(
    `${ENDPOINT}/${id}`,
    config()
  );
  return response.data;
}
