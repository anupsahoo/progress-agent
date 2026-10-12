import { useState } from 'react';
import type { Order } from './types';
import { orderLabels as L } from './types';
import { validateOrder } from './validation';
import { orderService } from './service';

// Replaces order_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function OrderEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Order>; isNew: boolean; onSaved: (row: Order) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Order>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Order, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateOrder(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await orderService.create(v as Order) : await orderService.update({ Ordernum: v.Ordernum! } as any, v as Order);
      setBanner('Order saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="order-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Ordernum} *</span>
        <input type="number" data-testid="field-Ordernum" aria-label={L.Ordernum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.Ordernum ?? ''} onChange={(e) => set('Ordernum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Ordernum && <small role="alert" data-testid="error-Ordernum">{errors.Ordernum}</small>}
      </label>
      <label>
        <span>{L.CustNum}</span>
        <input type="number" data-testid="field-CustNum" aria-label={L.CustNum} min={0} max={99999} step={1} value={v.CustNum ?? ''} onChange={(e) => set('CustNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CustNum && <small role="alert" data-testid="error-CustNum">{errors.CustNum}</small>}
      </label>
      <label>
        <span>{L.OrderDate}</span>
        <input type="date" data-testid="field-OrderDate" aria-label={L.OrderDate} value={v.OrderDate ?? ''} onChange={(e) => set('OrderDate', e.target.value || null)} />
        {errors.OrderDate && <small role="alert" data-testid="error-OrderDate">{errors.OrderDate}</small>}
      </label>
      <label>
        <span>{L.ShipDate}</span>
        <input type="date" data-testid="field-ShipDate" aria-label={L.ShipDate} value={v.ShipDate ?? ''} onChange={(e) => set('ShipDate', e.target.value || null)} />
        {errors.ShipDate && <small role="alert" data-testid="error-ShipDate">{errors.ShipDate}</small>}
      </label>
      <label>
        <span>{L.PromiseDate}</span>
        <input type="date" data-testid="field-PromiseDate" aria-label={L.PromiseDate} value={v.PromiseDate ?? ''} onChange={(e) => set('PromiseDate', e.target.value || null)} />
        {errors.PromiseDate && <small role="alert" data-testid="error-PromiseDate">{errors.PromiseDate}</small>}
      </label>
      <label>
        <span>{L.Carrier}</span>
        <input data-testid="field-Carrier" aria-label={L.Carrier} maxLength={25} value={v.Carrier ?? ''} onChange={(e) => set('Carrier', e.target.value)} />
        {errors.Carrier && <small role="alert" data-testid="error-Carrier">{errors.Carrier}</small>}
      </label>
      <label>
        <span>{L.Instructions}</span>
        <input data-testid="field-Instructions" aria-label={L.Instructions} maxLength={50} value={v.Instructions ?? ''} onChange={(e) => set('Instructions', e.target.value)} />
        {errors.Instructions && <small role="alert" data-testid="error-Instructions">{errors.Instructions}</small>}
      </label>
      <label>
        <span>{L.PO}</span>
        <input data-testid="field-PO" aria-label={L.PO} maxLength={20} value={v.PO ?? ''} onChange={(e) => set('PO', e.target.value)} />
        {errors.PO && <small role="alert" data-testid="error-PO">{errors.PO}</small>}
      </label>
      <label>
        <span>{L.Terms}</span>
        <input data-testid="field-Terms" aria-label={L.Terms} maxLength={20} value={v.Terms ?? ''} onChange={(e) => set('Terms', e.target.value)} />
        {errors.Terms && <small role="alert" data-testid="error-Terms">{errors.Terms}</small>}
      </label>
      <label>
        <span>{L.SalesRep}</span>
        <input data-testid="field-SalesRep" aria-label={L.SalesRep} maxLength={4} value={v.SalesRep ?? ''} onChange={(e) => set('SalesRep', e.target.value)} />
        {errors.SalesRep && <small role="alert" data-testid="error-SalesRep">{errors.SalesRep}</small>}
      </label>
      <label>
        <span>{L.BillToID}</span>
        <input type="number" data-testid="field-BillToID" aria-label={L.BillToID} min={0} max={9999999999} step={1} value={v.BillToID ?? ''} onChange={(e) => set('BillToID', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.BillToID && <small role="alert" data-testid="error-BillToID">{errors.BillToID}</small>}
      </label>
      <label>
        <span>{L.ShipToID}</span>
        <input type="number" data-testid="field-ShipToID" aria-label={L.ShipToID} min={0} max={9999999999} step={1} value={v.ShipToID ?? ''} onChange={(e) => set('ShipToID', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.ShipToID && <small role="alert" data-testid="error-ShipToID">{errors.ShipToID}</small>}
      </label>
      <label>
        <span>{L.OrderStatus}</span>
        <input data-testid="field-OrderStatus" aria-label={L.OrderStatus} maxLength={20} value={v.OrderStatus ?? ''} onChange={(e) => set('OrderStatus', e.target.value)} />
        {errors.OrderStatus && <small role="alert" data-testid="error-OrderStatus">{errors.OrderStatus}</small>}
      </label>
      <label>
        <span>{L.WarehouseNum}</span>
        <input type="number" data-testid="field-WarehouseNum" aria-label={L.WarehouseNum} min={0} max={9999999999} step={1} value={v.WarehouseNum ?? ''} onChange={(e) => set('WarehouseNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.WarehouseNum && <small role="alert" data-testid="error-WarehouseNum">{errors.WarehouseNum}</small>}
      </label>
      <label>
        <span>{L.Creditcard}</span>
        <input data-testid="field-Creditcard" aria-label={L.Creditcard} maxLength={20} value={v.Creditcard ?? ''} onChange={(e) => set('Creditcard', e.target.value)} />
        {errors.Creditcard && <small role="alert" data-testid="error-Creditcard">{errors.Creditcard}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
