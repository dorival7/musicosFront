import axios from "axios";
const base = process.env.VUE_APP_API_BASE_URL;
const config = () => ({ headers: { Authorization: `Bearer ${localStorage.getItem("jwt")}` } });
export const adminApi = {
  get: (path) => axios.get(`${base}/admin/${path}`, config()).then(r => r.data),
  plans: () => axios.get(`${base}/saas-products`, config()).then(r => r.data),
  createPlan: (data) => axios.post(`${base}/saas-products`, data, config()).then(r => r.data),
  updatePlan: (id, data) => axios.put(`${base}/saas-products/${id}`, data, config()).then(r => r.data)
};
