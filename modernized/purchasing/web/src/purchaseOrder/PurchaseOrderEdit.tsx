import { useState } from 'react';
import type { PurchaseOrder } from './types';
import { purchaseOrderLabels as L } from './types';
import { validatePurchaseOrder } from './validation';
import { purchaseOrderService } from './service';

// Replaces purchase_order_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function PurchaseOrderEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<PurchaseOrder>; isNew: boolean; onSaved: (row: PurchaseOrder) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<PurchaseOrder>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof PurchaseOrder, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validatePurchaseOrder(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await purchaseOrderService.create(v as PurchaseOrder) : await purchaseOrderService.update({ PONum: v.PONum! } as any, v as PurchaseOrder);
      setBanner('PurchaseOrder saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="purchase-order-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.PONum} *</span>
        <input type="number" data-testid="field-PONum" aria-label={L.PONum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.PONum ?? ''} onChange={(e) => set('PONum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.PONum && <small role="alert" data-testid="error-PONum">{errors.PONum}</small>}
      </label>
      <label>
        <span>{L.DateEntered}</span>
        <input type="date" data-testid="field-DateEntered" aria-label={L.DateEntered} value={v.DateEntered ?? ''} onChange={(e) => set('DateEntered', e.target.value || null)} />
        {errors.DateEntered && <small role="alert" data-testid="error-DateEntered">{errors.DateEntered}</small>}
      </label>
      <label>
        <span>{L.SupplierIDNum}</span>
        <input type="number" data-testid="field-SupplierIDNum" aria-label={L.SupplierIDNum} min={0} max={9999999999} step={1} value={v.SupplierIDNum ?? ''} onChange={(e) => set('SupplierIDNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.SupplierIDNum && <small role="alert" data-testid="error-SupplierIDNum">{errors.SupplierIDNum}</small>}
      </label>
      <label>
        <span>{L.ReceiveDate}</span>
        <input type="date" data-testid="field-ReceiveDate" aria-label={L.ReceiveDate} value={v.ReceiveDate ?? ''} onChange={(e) => set('ReceiveDate', e.target.value || null)} />
        {errors.ReceiveDate && <small role="alert" data-testid="error-ReceiveDate">{errors.ReceiveDate}</small>}
      </label>
      <label>
        <span>{L.POStatus}</span>
        <input data-testid="field-POStatus" aria-label={L.POStatus} maxLength={20} value={v.POStatus ?? ''} onChange={(e) => set('POStatus', e.target.value)} />
        {errors.POStatus && <small role="alert" data-testid="error-POStatus">{errors.POStatus}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
