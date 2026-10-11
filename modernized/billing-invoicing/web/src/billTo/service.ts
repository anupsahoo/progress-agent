import type { BillTo, BillToKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/billing-invoicing/bill-tos`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This billto was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const billToService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: BillTo[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: BillToKey) => http<BillTo>(`${URL_}/${encodeURIComponent(String(key.CustNum))}/${encodeURIComponent(String(key.BillToID))}`),
  create: (row: BillTo) => http<BillTo>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: BillToKey, row: BillTo) => http<BillTo>(`${URL_}/${encodeURIComponent(String(key.CustNum))}/${encodeURIComponent(String(key.BillToID))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: BillToKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.CustNum))}/${encodeURIComponent(String(key.BillToID))}`, { method: 'DELETE' }),
};
