import type { Customer } from './types';

const BASE = import.meta.env.VITE_API_URL ?? '';

export class NotFoundError extends Error {}
export class ConflictError extends Error {}

// R1 / R2 — lookup by CustNum. The ETag replaces the legacy EXCLUSIVE-LOCK (R5).
export async function getCustomer(custNum: number): Promise<{ customer: Customer; etag: string }> {
  const res = await fetch(`${BASE}/customers/${custNum}`);
  if (res.status === 404) throw new NotFoundError('Customer not found.');
  if (!res.ok) throw new Error(`Lookup failed (${res.status})`);
  return { customer: await res.json(), etag: res.headers.get('ETag') ?? '' };
}

// R4 / R5 — save with optimistic concurrency.
export async function updateCustomer(c: Customer, etag: string): Promise<string> {
  const res = await fetch(`${BASE}/customers/${c.custNum}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json', 'If-Match': etag },
    body: JSON.stringify(c),
  });
  if (res.status === 404) throw new NotFoundError('Customer not found.');
  if (res.status === 409) throw new ConflictError('This customer was changed by someone else. Reload and try again.');
  if (!res.ok) throw new Error(`Save failed (${res.status})`);
  return (await res.json()).message as string;
}
