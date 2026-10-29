import { useState } from 'react';
import type { POLine } from './types';
import { pOLineLabels as L } from './types';
import { validatePOLine } from './validation';
import { pOLineService } from './service';

// Replaces po_line_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function POLineEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<POLine>; isNew: boolean; onSaved: (row: POLine) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<POLine>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof POLine, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validatePOLine(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await pOLineService.create(v as POLine) : await pOLineService.update({ PONum: v.PONum!, Linenum: v.Linenum! } as any, v as POLine);
      setBanner('POLine saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="po-line-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Linenum} *</span>
        <input type="number" data-testid="field-Linenum" aria-label={L.Linenum} readOnly={!isNew} min={0} max={999} step={1} value={v.Linenum ?? ''} onChange={(e) => set('Linenum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Linenum && <small role="alert" data-testid="error-Linenum">{errors.Linenum}</small>}
      </label>
      <label>
        <span>{L.Itemnum}</span>
        <input type="number" data-testid="field-Itemnum" aria-label={L.Itemnum} min={0} max={9999999999} step={1} value={v.Itemnum ?? ''} onChange={(e) => set('Itemnum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Itemnum && <small role="alert" data-testid="error-Itemnum">{errors.Itemnum}</small>}
      </label>
      <label>
        <span>{L.Price}</span>
        <input type="number" data-testid="field-Price" aria-label={L.Price} min={-9999999.99} max={9999999.99} step={0.01} value={v.Price ?? ''} onChange={(e) => set('Price', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Price && <small role="alert" data-testid="error-Price">{errors.Price}</small>}
      </label>
      <label>
        <span>{L.Qty}</span>
        <input type="number" data-testid="field-Qty" aria-label={L.Qty} min={-99999} max={99999} step={1} value={v.Qty ?? ''} onChange={(e) => set('Qty', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Qty && <small role="alert" data-testid="error-Qty">{errors.Qty}</small>}
      </label>
      <label>
        <span>{L.Discount}</span>
        <input type="number" data-testid="field-Discount" aria-label={L.Discount} min={0} max={999} step={1} value={v.Discount ?? ''} onChange={(e) => set('Discount', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Discount && <small role="alert" data-testid="error-Discount">{errors.Discount}</small>}
      </label>
      <label>
        <span>{L.ExtendedPrice}</span>
        <input type="number" data-testid="field-ExtendedPrice" aria-label={L.ExtendedPrice} min={-99999.99} max={99999.99} step={0.01} value={v.ExtendedPrice ?? ''} onChange={(e) => set('ExtendedPrice', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.ExtendedPrice && <small role="alert" data-testid="error-ExtendedPrice">{errors.ExtendedPrice}</small>}
      </label>
      <label>
        <span>{L.PONum} *</span>
        <input type="number" data-testid="field-PONum" aria-label={L.PONum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.PONum ?? ''} onChange={(e) => set('PONum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.PONum && <small role="alert" data-testid="error-PONum">{errors.PONum}</small>}
      </label>
      <label>
        <span>{L.POLineStatus}</span>
        <input data-testid="field-POLineStatus" aria-label={L.POLineStatus} maxLength={20} value={v.POLineStatus ?? ''} onChange={(e) => set('POLineStatus', e.target.value)} />
        {errors.POLineStatus && <small role="alert" data-testid="error-POLineStatus">{errors.POLineStatus}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
