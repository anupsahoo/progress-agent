import { useState } from 'react';
import type { Salesrep } from './types';
import { salesrepLabels as L } from './types';
import { validateSalesrep } from './validation';
import { salesrepService } from './service';

// Replaces salesrep_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function SalesrepEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Salesrep>; isNew: boolean; onSaved: (row: Salesrep) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Salesrep>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Salesrep, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateSalesrep(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await salesrepService.create(v as Salesrep) : await salesrepService.update({ SalesRep: v.SalesRep! } as any, v as Salesrep);
      setBanner('Salesrep saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="salesrep-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.SalesRep} *</span>
        <input data-testid="field-SalesRep" aria-label={L.SalesRep} readOnly={!isNew} maxLength={4} value={v.SalesRep ?? ''} onChange={(e) => set('SalesRep', e.target.value)} />
        {errors.SalesRep && <small role="alert" data-testid="error-SalesRep">{errors.SalesRep}</small>}
      </label>
      <label>
        <span>{L.RepName}</span>
        <input data-testid="field-RepName" aria-label={L.RepName} maxLength={30} value={v.RepName ?? ''} onChange={(e) => set('RepName', e.target.value)} />
        {errors.RepName && <small role="alert" data-testid="error-RepName">{errors.RepName}</small>}
      </label>
      <label>
        <span>{L.Region}</span>
        <input data-testid="field-Region" aria-label={L.Region} maxLength={8} value={v.Region ?? ''} onChange={(e) => set('Region', e.target.value)} />
        {errors.Region && <small role="alert" data-testid="error-Region">{errors.Region}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
