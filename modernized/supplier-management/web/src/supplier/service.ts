import type { Supplier, SupplierKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/supplier-management/suppliers`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This supplier was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const supplierService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: Supplier[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: SupplierKey) => http<Supplier>(`${URL_}/${encodeURIComponent(String(key.SupplierIDNum))}`),
  create: (row: Supplier) => http<Supplier>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: SupplierKey, row: Supplier) => http<Supplier>(`${URL_}/${encodeURIComponent(String(key.SupplierIDNum))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: SupplierKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.SupplierIDNum))}`, { method: 'DELETE' }),
};
