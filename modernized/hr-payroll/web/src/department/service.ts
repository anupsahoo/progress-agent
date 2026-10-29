import type { Department, DepartmentKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/hr-payroll/departments`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This department was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const departmentService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: Department[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: DepartmentKey) => http<Department>(`${URL_}/${encodeURIComponent(String(key.DeptCode))}`),
  create: (row: Department) => http<Department>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: DepartmentKey, row: Department) => http<Department>(`${URL_}/${encodeURIComponent(String(key.DeptCode))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: DepartmentKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.DeptCode))}`, { method: 'DELETE' }),
};
