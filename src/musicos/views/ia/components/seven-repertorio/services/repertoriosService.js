import axios from "axios";

const API_BASE_URL = (process.env.VUE_APP_API_BASE_URL || "http://localhost:5297").replace(/\/$/, "");
const ENDPOINT = `${API_BASE_URL}/tenants/repertorios`;

function config() {
  const token = localStorage.getItem("jwt");
  if (!token) throw new Error("Token de autenticação do músico não encontrado.");
  return { headers: { Authorization: `Bearer ${token.replace(/^Bearer\s+/i, "")}` } };
}

export async function listarRepertorios() { return (await axios.get(ENDPOINT, config())).data; }
export async function obterRepertorio(id) { return (await axios.get(`${ENDPOINT}/${id}`, config())).data; }
export async function criarRepertorio(payload) { return (await axios.post(ENDPOINT, payload, config())).data; }
export async function atualizarRepertorio(id, payload) { return (await axios.put(`${ENDPOINT}/${id}`, payload, config())).data; }
export async function excluirRepertorio(id) { return (await axios.delete(`${ENDPOINT}/${id}`, config())).data; }
export async function adicionarMusica(id, payload) { return (await axios.post(`${ENDPOINT}/${id}/musicas`, payload, config())).data; }
export async function atualizarMusica(id, musicaId, payload) { return (await axios.put(`${ENDPOINT}/${id}/musicas/${musicaId}`, payload, config())).data; }
export async function excluirMusica(id, musicaId) { return (await axios.delete(`${ENDPOINT}/${id}/musicas/${musicaId}`, config())).data; }
export async function reordenarMusicas(id, musicaIds) { return (await axios.put(`${ENDPOINT}/${id}/musicas/reordenar`, { musicaIds }, config())).data; }
