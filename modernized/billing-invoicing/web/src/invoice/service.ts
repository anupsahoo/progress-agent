import type { Invoice, InvoiceKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/billing-invoicing/invoices`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This invoice was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const invoiceService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: Invoice[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: InvoiceKey) => http<Invoice>(`${URL_}/${encodeURIComponent(String(key.Invoicenum))}`),
  create: (row: Invoice) => http<Invoice>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: InvoiceKey, row: Invoice) => http<Invoice>(`${URL_}/${encodeURIComponent(String(key.Invoicenum))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: InvoiceKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.Invoicenum))}`, { method: 'DELETE' }),
};
