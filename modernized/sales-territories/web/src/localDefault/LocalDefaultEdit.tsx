import { useState } from 'react';
import type { LocalDefault } from './types';
import { localDefaultLabels as L } from './types';
import { validateLocalDefault } from './validation';
import { localDefaultService } from './service';

// Replaces local_default_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function LocalDefaultEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<LocalDefault>; isNew: boolean; onSaved: (row: LocalDefault) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<LocalDefault>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof LocalDefault, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateLocalDefault(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await localDefaultService.create(v as LocalDefault) : await localDefaultService.update({ LocalDefNum: v.LocalDefNum! } as any, v as LocalDefault);
      setBanner('LocalDefault saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="local-default-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Country}</span>
        <input data-testid="field-Country" aria-label={L.Country} maxLength={20} value={v.Country ?? ''} onChange={(e) => set('Country', e.target.value)} />
        {errors.Country && <small role="alert" data-testid="error-Country">{errors.Country}</small>}
      </label>
      <label>
        <span>{L.Region1Label}</span>
        <input data-testid="field-Region1Label" aria-label={L.Region1Label} maxLength={15} value={v.Region1Label ?? ''} onChange={(e) => set('Region1Label', e.target.value)} />
        {errors.Region1Label && <small role="alert" data-testid="error-Region1Label">{errors.Region1Label}</small>}
      </label>
      <label>
        <span>{L.Region2Label}</span>
        <input data-testid="field-Region2Label" aria-label={L.Region2Label} maxLength={15} value={v.Region2Label ?? ''} onChange={(e) => set('Region2Label', e.target.value)} />
        {errors.Region2Label && <small role="alert" data-testid="error-Region2Label">{errors.Region2Label}</small>}
      </label>
      <label>
        <span>{L.PostalLabel}</span>
        <input data-testid="field-PostalLabel" aria-label={L.PostalLabel} maxLength={15} value={v.PostalLabel ?? ''} onChange={(e) => set('PostalLabel', e.target.value)} />
        {errors.PostalLabel && <small role="alert" data-testid="error-PostalLabel">{errors.PostalLabel}</small>}
      </label>
      <label>
        <span>{L.PostalFormat}</span>
        <input data-testid="field-PostalFormat" aria-label={L.PostalFormat} maxLength={15} value={v.PostalFormat ?? ''} onChange={(e) => set('PostalFormat', e.target.value)} />
        {errors.PostalFormat && <small role="alert" data-testid="error-PostalFormat">{errors.PostalFormat}</small>}
      </label>
      <label>
        <span>{L.TelFormat}</span>
        <input data-testid="field-TelFormat" aria-label={L.TelFormat} maxLength={15} value={v.TelFormat ?? ''} onChange={(e) => set('TelFormat', e.target.value)} />
        {errors.TelFormat && <small role="alert" data-testid="error-TelFormat">{errors.TelFormat}</small>}
      </label>
      <label>
        <span>{L.CurrencySymbol}</span>
        <input data-testid="field-CurrencySymbol" aria-label={L.CurrencySymbol} maxLength={6} value={v.CurrencySymbol ?? ''} onChange={(e) => set('CurrencySymbol', e.target.value)} />
        {errors.CurrencySymbol && <small role="alert" data-testid="error-CurrencySymbol">{errors.CurrencySymbol}</small>}
      </label>
      <label>
        <span>{L.DateFormat}</span>
        <input data-testid="field-DateFormat" aria-label={L.DateFormat} maxLength={8} value={v.DateFormat ?? ''} onChange={(e) => set('DateFormat', e.target.value)} />
        {errors.DateFormat && <small role="alert" data-testid="error-DateFormat">{errors.DateFormat}</small>}
      </label>
      <label>
        <span>{L.LocalDefNum} *</span>
        <input type="number" data-testid="field-LocalDefNum" aria-label={L.LocalDefNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.LocalDefNum ?? ''} onChange={(e) => set('LocalDefNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.LocalDefNum && <small role="alert" data-testid="error-LocalDefNum">{errors.LocalDefNum}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
