/* ==========================================
   js/api.js — API Service untuk MBG System
   Semua komunikasi dengan backend FastAPI
   ========================================== */

const API_BASE = 'http://localhost:8000';

/* ─── Auth helper ─── */
function getAuthHeader() {
  const user = JSON.parse(sessionStorage.getItem('mbg_user') || '{}');
  if (user.username && user.password) {
    return 'Basic ' + btoa(`${user.username}:${user.password}`);
  }
  return null;
}

function isLoggedIn() {
  return !!sessionStorage.getItem('mbg_user');
}

function logout() {
  sessionStorage.removeItem('mbg_user');
  window.location.href = 'index.html';
}

/* ─── Generic fetch wrapper ─── */
async function apiFetch(path, options = {}) {
  const url = `${API_BASE}${path}`;
  const auth = getAuthHeader();
  const headers = { 'Content-Type': 'application/json', ...options.headers };
  if (auth) headers['Authorization'] = auth;

  const response = await fetch(url, { ...options, headers });
  if (!response.ok) {
    const err = await response.json().catch(() => ({ detail: 'Error tidak diketahui' }));
    throw new Error(err.detail || `HTTP ${response.status}`);
  }
  return response.json();
}

/* ─── Auth ─── */
async function login(username, password) {
  const response = await fetch(`${API_BASE}/api/auth/login`, {
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa(`${username}:${password}`),
      'Content-Type': 'application/json',
    },
  });
  if (!response.ok) throw new Error('Username atau password salah');
  const data = await response.json();
  sessionStorage.setItem('mbg_user', JSON.stringify({ username, password, ...data }));
  return data;
}

/* ─── Dashboard ─── */
async function getDashboard() {
  return apiFetch('/api/dashboard');
}

/* ─── Dapur ─── */
async function getDapur() {
  return apiFetch('/api/dapur');
}

async function addDapur(payload) {
  return apiFetch('/api/dapur', { method: 'POST', body: JSON.stringify(payload) });
}

async function deleteDapur(id) {
  return apiFetch(`/api/dapur/${id}`, { method: 'DELETE' });
}

/* ─── Sekolah ─── */
async function getSekolah(idDapur = null) {
  const qs = idDapur ? `?id_dapur=${idDapur}` : '';
  return apiFetch(`/api/sekolah${qs}`);
}

async function addSekolah(payload) {
  return apiFetch('/api/sekolah', { method: 'POST', body: JSON.stringify(payload) });
}

async function deleteSekolah(id) {
  return apiFetch(`/api/sekolah/${id}`, { method: 'DELETE' });
}

/* ─── Optimasi ─── */
async function postOptimasi(payload) {
  return apiFetch('/api/optimasi', { method: 'POST', body: JSON.stringify(payload) });
}

/* ─── Riwayat ─── */
async function getRiwayat() {
  return apiFetch('/api/rute');
}

async function deleteRiwayat(id) {
  return apiFetch(`/api/rute/${id}`, { method: 'DELETE' });
}

/* ─── Health Check ─── */
async function checkHealth() {
  return apiFetch('/api/health');
}
