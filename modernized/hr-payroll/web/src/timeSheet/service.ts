import type { TimeSheet, TimeSheetKey } from './types';

const BASE = (import.meta as any).env?.VITE_API_URL ?? '';
const URL_ = `${BASE}/api/hr-payroll/time-sheets`;

async function http<T>(input: string, init?: RequestInit): Promise<T> {
  const r = await fetch(input, { headers: { 'Content-Type': 'application/json' }, ...init });
  if (r.status === 409) throw new Error('This timesheet was changed by someone else. Reload and try again.');
  if (!r.ok) {
    const body = await r.json().catch(() => ({}));
    throw new Error(body?.detail?.[0]?.msg || body?.detail || `Request failed (${r.status})`);
  }
  return r.status === 204 ? (undefined as T) : r.json();
}

export const timeSheetService = {
  list: (q = '', limit = 50, offset = 0) => http<{ items: TimeSheet[]; total: number }>(`${URL_}?q=${encodeURIComponent(q)}&limit=${limit}&offset=${offset}`),
  get: (key: TimeSheetKey) => http<TimeSheet>(`${URL_}/${encodeURIComponent(String(key.EmpNum))}/${encodeURIComponent(String(key.DayRecorded))}`),
  create: (row: TimeSheet) => http<TimeSheet>(URL_, { method: 'POST', body: JSON.stringify(row) }),
  update: (key: TimeSheetKey, row: TimeSheet) => http<TimeSheet>(`${URL_}/${encodeURIComponent(String(key.EmpNum))}/${encodeURIComponent(String(key.DayRecorded))}`, { method: 'PUT', headers: { 'Content-Type': 'application/json', 'If-Match': String(row.version ?? 0) }, body: JSON.stringify(row) }),
  remove: (key: TimeSheetKey) => http<void>(`${URL_}/${encodeURIComponent(String(key.EmpNum))}/${encodeURIComponent(String(key.DayRecorded))}`, { method: 'DELETE' }),
};
