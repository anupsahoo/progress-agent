import type { Vacation, VacationKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/hr-payroll/vacations`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This vacation was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const vacationService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: Vacation[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: VacationKey) => http<Vacation>(`${URL_}/${encodeURIComponent(String(key.EmpNum))}/${encodeURIComponent(String(key.StartDate))}`),
  create: (row: Vacation) => http<Vacation>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: VacationKey, row: Vacation) => http<Vacation>(`${URL_}/${encodeURIComponent(String(key.EmpNum))}/${encodeURIComponent(String(key.StartDate))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: VacationKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.EmpNum))}/${encodeURIComponent(String(key.StartDate))}`, { method: 'DELETE' }),
};
