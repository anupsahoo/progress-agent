import { useState } from 'react';
import type { Bin } from './types';
import { binLabels as L } from './types';
import { validateBin } from './validation';
import { binService } from './service';

// Replaces bin_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function BinEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Bin>; isNew: boolean; onSaved: (row: Bin) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Bin>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Bin, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateBin(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await binService.create(v as Bin) : await binService.update({ BinNum: v.BinNum! } as any, v as Bin);
      setBanner('Bin saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="bin-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.WarehouseNum}</span>
        <input type="number" data-testid="field-WarehouseNum" aria-label={L.WarehouseNum} min={0} max={9999999999} step={1} value={v.WarehouseNum ?? ''} onChange={(e) => set('WarehouseNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.WarehouseNum && <small role="alert" data-testid="error-WarehouseNum">{errors.WarehouseNum}</small>}
      </label>
      <label>
        <span>{L.Itemnum}</span>
        <input type="number" data-testid="field-Itemnum" aria-label={L.Itemnum} min={0} max={9999999999} step={1} value={v.Itemnum ?? ''} onChange={(e) => set('Itemnum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Itemnum && <small role="alert" data-testid="error-Itemnum">{errors.Itemnum}</small>}
      </label>
      <label>
        <span>{L.Qty}</span>
        <input type="number" data-testid="field-Qty" aria-label={L.Qty} min={-99999} max={99999} step={1} value={v.Qty ?? ''} onChange={(e) => set('Qty', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Qty && <small role="alert" data-testid="error-Qty">{errors.Qty}</small>}
      </label>
      <label>
        <span>{L.BinNum} *</span>
        <input type="number" data-testid="field-BinNum" aria-label={L.BinNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.BinNum ?? ''} onChange={(e) => set('BinNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.BinNum && <small role="alert" data-testid="error-BinNum">{errors.BinNum}</small>}
      </label>
      <label>
        <span>{L.BinName}</span>
        <input data-testid="field-BinName" aria-label={L.BinName} maxLength={30} value={v.BinName ?? ''} onChange={(e) => set('BinName', e.target.value)} />
        {errors.BinName && <small role="alert" data-testid="error-BinName">{errors.BinName}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
