import { useState, type FormEvent } from 'react';
import type { Customer, EditableField } from './types';
import { EDITABLE } from './types';
import { getCustomer, updateCustomer, NotFoundError } from './customerService';

const LABELS: Record<EditableField, string> = {
  name: 'Name', address: 'Address', city: 'City', state: 'State', postalCode: 'Postal code', phone: 'Phone',
};

// Modernized from sports/customer_maint.p — see specs/requirements.md (R1–R7).
export function CustomerMaint() {
  const [custNum, setCustNum] = useState('');
  const [draft, setDraft] = useState<Customer | null>(null);
  const [etag, setEtag] = useState('');
  const [status, setStatus] = useState<{ kind: 'ok' | 'error'; text: string } | null>(null);

  async function load(e: FormEvent) {
    e.preventDefault();
    setStatus(null);
    try {
      const { customer, etag } = await getCustomer(Number(custNum));
      setDraft(customer);
      setEtag(etag);
    } catch (err) {
      setDraft(null);
      setStatus({ kind: 'error', text: err instanceof NotFoundError ? 'Customer not found.' : String(err) });
    }
  }

  async function save(e: FormEvent) {
    e.preventDefault();
    if (!draft) return;
    try {
      const message = await updateCustomer(draft, etag);
      setStatus({ kind: 'ok', text: message }); // "Record updated successfully." (R4)
      setDraft(null);                          // R6 — release, ready for next lookup (R7)
      setCustNum('');
    } catch (err) {
      setStatus({ kind: 'error', text: err instanceof Error ? err.message : String(err) });
    }
  }

  return (
    <main aria-labelledby="title">
      <h1 id="title">Customer Maintenance</h1>

      <form onSubmit={load} role="search">
        <label htmlFor="custNum">Customer number</label>
        <input id="custNum" name="custNum" type="number" required value={custNum}
          onChange={(e) => setCustNum(e.target.value)} />
        <button type="submit">Search</button>
      </form>

      {status && (
        <p role={status.kind === 'error' ? 'alert' : 'status'} data-status={status.kind}>{status.text}</p>
      )}

      {draft && (
        <form onSubmit={save} aria-label="Edit customer">
          <label htmlFor="custNumRO">Cust Num</label>
          <input id="custNumRO" value={draft.custNum} readOnly />
          {EDITABLE.map((f) => (
            <div key={f}>
              <label htmlFor={f}>{LABELS[f]}</label>
              <input id={f} name={f} value={draft[f]}
                onChange={(e) => setDraft({ ...draft, [f]: e.target.value })} />
            </div>
          ))}
          <button type="submit">Save</button>
        </form>
      )}
    </main>
  );
}
