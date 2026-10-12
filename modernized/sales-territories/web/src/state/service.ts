import type { State, StateKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/sales-territories/states`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This state was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const stateService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: State[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: StateKey) => http<State>(`${URL_}/${encodeURIComponent(String(key.State))}`),
  create: (row: State) => http<State>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: StateKey, row: State) => http<State>(`${URL_}/${encodeURIComponent(String(key.State))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: StateKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.State))}`, { method: 'DELETE' }),
};
