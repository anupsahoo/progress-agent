import { useState } from 'react';
import type { SupplierItemXref } from './types';
import { supplierItemXrefLabels as L } from './types';
import { validateSupplierItemXref } from './validation';
import { supplierItemXrefService } from './service';

// Replaces supplier_item_xref_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function SupplierItemXrefEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<SupplierItemXref>; isNew: boolean; onSaved: (row: SupplierItemXref) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<SupplierItemXref>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof SupplierItemXref, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateSupplierItemXref(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await supplierItemXrefService.create(v as SupplierItemXref) : await supplierItemXrefService.update({ SupplierIDNum: v.SupplierIDNum!, Itemnum: v.Itemnum! } as any, v as SupplierItemXref);
      setBanner('SupplierItemXref saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="supplier-item-xref-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.SupplierIDNum} *</span>
        <input type="number" data-testid="field-SupplierIDNum" aria-label={L.SupplierIDNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.SupplierIDNum ?? ''} onChange={(e) => set('SupplierIDNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.SupplierIDNum && <small role="alert" data-testid="error-SupplierIDNum">{errors.SupplierIDNum}</small>}
      </label>
      <label>
        <span>{L.Itemnum} *</span>
        <input type="number" data-testid="field-Itemnum" aria-label={L.Itemnum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.Itemnum ?? ''} onChange={(e) => set('Itemnum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Itemnum && <small role="alert" data-testid="error-Itemnum">{errors.Itemnum}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
