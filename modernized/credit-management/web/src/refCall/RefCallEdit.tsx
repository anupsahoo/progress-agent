import { useState } from 'react';
import type { RefCall } from './types';
import { refCallLabels as L } from './types';
import { validateRefCall } from './validation';
import { refCallService } from './service';

// Replaces ref_call_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function RefCallEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<RefCall>; isNew: boolean; onSaved: (row: RefCall) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<RefCall>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof RefCall, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateRefCall(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await refCallService.create(v as RefCall) : await refCallService.update({ CallNum: v.CallNum! } as any, v as RefCall);
      setBanner('RefCall saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="ref-call-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.CallNum} *</span>
        <input data-testid="field-CallNum" aria-label={L.CallNum} readOnly={!isNew} maxLength={6} value={v.CallNum ?? ''} onChange={(e) => set('CallNum', e.target.value)} />
        {errors.CallNum && <small role="alert" data-testid="error-CallNum">{errors.CallNum}</small>}
      </label>
      <label>
        <span>{L.CustNum}</span>
        <input type="number" data-testid="field-CustNum" aria-label={L.CustNum} min={0} max={99999} step={1} value={v.CustNum ?? ''} onChange={(e) => set('CustNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CustNum && <small role="alert" data-testid="error-CustNum">{errors.CustNum}</small>}
      </label>
      <label>
        <span>{L.CallDate}</span>
        <input type="date" data-testid="field-CallDate" aria-label={L.CallDate} value={v.CallDate ?? ''} onChange={(e) => set('CallDate', e.target.value || null)} />
        {errors.CallDate && <small role="alert" data-testid="error-CallDate">{errors.CallDate}</small>}
      </label>
      <label>
        <span>{L.SalesRep}</span>
        <input data-testid="field-SalesRep" aria-label={L.SalesRep} maxLength={4} value={v.SalesRep ?? ''} onChange={(e) => set('SalesRep', e.target.value)} />
        {errors.SalesRep && <small role="alert" data-testid="error-SalesRep">{errors.SalesRep}</small>}
      </label>
      <label>
        <span>{L.Parent}</span>
        <input data-testid="field-Parent" aria-label={L.Parent} maxLength={6} value={v.Parent ?? ''} onChange={(e) => set('Parent', e.target.value)} />
        {errors.Parent && <small role="alert" data-testid="error-Parent">{errors.Parent}</small>}
      </label>
      <label>
        <span>{L.Txt}</span>
        <input data-testid="field-Txt" aria-label={L.Txt} maxLength={300} value={v.Txt ?? ''} onChange={(e) => set('Txt', e.target.value)} />
        {errors.Txt && <small role="alert" data-testid="error-Txt">{errors.Txt}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
