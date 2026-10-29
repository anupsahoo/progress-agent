import { useState } from 'react';
import type { InventoryTrans } from './types';
import { inventoryTransLabels as L } from './types';
import { validateInventoryTrans } from './validation';
import { inventoryTransService } from './service';

// Replaces inventory_trans_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function InventoryTransEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<InventoryTrans>; isNew: boolean; onSaved: (row: InventoryTrans) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<InventoryTrans>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof InventoryTrans, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateInventoryTrans(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await inventoryTransService.create(v as InventoryTrans) : await inventoryTransService.update({ InvTransNum: v.InvTransNum! } as any, v as InventoryTrans);
      setBanner('InventoryTrans saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="inventory-trans-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.InvTransNum} *</span>
        <input type="number" data-testid="field-InvTransNum" aria-label={L.InvTransNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.InvTransNum ?? ''} onChange={(e) => set('InvTransNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.InvTransNum && <small role="alert" data-testid="error-InvTransNum">{errors.InvTransNum}</small>}
      </label>
      <label>
        <span>{L.WarehouseNum}</span>
        <input type="number" data-testid="field-WarehouseNum" aria-label={L.WarehouseNum} min={0} max={9999999999} step={1} value={v.WarehouseNum ?? ''} onChange={(e) => set('WarehouseNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.WarehouseNum && <small role="alert" data-testid="error-WarehouseNum">{errors.WarehouseNum}</small>}
      </label>
      <label>
        <span>{L.BinNum}</span>
        <input type="number" data-testid="field-BinNum" aria-label={L.BinNum} min={0} max={9999999999} step={1} value={v.BinNum ?? ''} onChange={(e) => set('BinNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.BinNum && <small role="alert" data-testid="error-BinNum">{errors.BinNum}</small>}
      </label>
      <label>
        <span>{L.Qty}</span>
        <input type="number" data-testid="field-Qty" aria-label={L.Qty} min={-99999} max={99999} step={1} value={v.Qty ?? ''} onChange={(e) => set('Qty', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Qty && <small role="alert" data-testid="error-Qty">{errors.Qty}</small>}
      </label>
      <label>
        <span>{L.Itemnum}</span>
        <input type="number" data-testid="field-Itemnum" aria-label={L.Itemnum} min={0} max={9999999999} step={1} value={v.Itemnum ?? ''} onChange={(e) => set('Itemnum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Itemnum && <small role="alert" data-testid="error-Itemnum">{errors.Itemnum}</small>}
      </label>
      <label>
        <span>{L.TransDate}</span>
        <input type="date" data-testid="field-TransDate" aria-label={L.TransDate} value={v.TransDate ?? ''} onChange={(e) => set('TransDate', e.target.value || null)} />
        {errors.TransDate && <small role="alert" data-testid="error-TransDate">{errors.TransDate}</small>}
      </label>
      <label>
        <span>{L.InvType}</span>
        <input data-testid="field-InvType" aria-label={L.InvType} maxLength={12} value={v.InvType ?? ''} onChange={(e) => set('InvType', e.target.value)} />
        {errors.InvType && <small role="alert" data-testid="error-InvType">{errors.InvType}</small>}
      </label>
      <label>
        <span>{L.PONum}</span>
        <input type="number" data-testid="field-PONum" aria-label={L.PONum} min={0} max={9999999999} step={1} value={v.PONum ?? ''} onChange={(e) => set('PONum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.PONum && <small role="alert" data-testid="error-PONum">{errors.PONum}</small>}
      </label>
      <label>
        <span>{L.Ordernum}</span>
        <input type="number" data-testid="field-Ordernum" aria-label={L.Ordernum} min={0} max={9999999999} step={1} value={v.Ordernum ?? ''} onChange={(e) => set('Ordernum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Ordernum && <small role="alert" data-testid="error-Ordernum">{errors.Ordernum}</small>}
      </label>
      <label>
        <span>{L.Transtime}</span>
        <input data-testid="field-Transtime" aria-label={L.Transtime} maxLength={5} value={v.Transtime ?? ''} onChange={(e) => set('Transtime', e.target.value)} />
        {errors.Transtime && <small role="alert" data-testid="error-Transtime">{errors.Transtime}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
