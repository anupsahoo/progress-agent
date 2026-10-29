import { useState } from 'react';
import type { OrderLine } from './types';
import { orderLineLabels as L } from './types';
import { validateOrderLine } from './validation';
import { orderLineService } from './service';

// Replaces order_line_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function OrderLineEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<OrderLine>; isNew: boolean; onSaved: (row: OrderLine) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<OrderLine>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof OrderLine, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateOrderLine(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await orderLineService.create(v as OrderLine) : await orderLineService.update({ Ordernum: v.Ordernum!, Linenum: v.Linenum! } as any, v as OrderLine);
      setBanner('OrderLine saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="order-line-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Ordernum} *</span>
        <input type="number" data-testid="field-Ordernum" aria-label={L.Ordernum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.Ordernum ?? ''} onChange={(e) => set('Ordernum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Ordernum && <small role="alert" data-testid="error-Ordernum">{errors.Ordernum}</small>}
      </label>
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
        <input type="number" data-testid="field-ExtendedPrice" aria-label={L.ExtendedPrice} min={-999999.99} max={999999.99} step={0.01} value={v.ExtendedPrice ?? ''} onChange={(e) => set('ExtendedPrice', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.ExtendedPrice && <small role="alert" data-testid="error-ExtendedPrice">{errors.ExtendedPrice}</small>}
      </label>
      <label>
        <span>{L.OrderLineStatus}</span>
        <input data-testid="field-OrderLineStatus" aria-label={L.OrderLineStatus} maxLength={20} value={v.OrderLineStatus ?? ''} onChange={(e) => set('OrderLineStatus', e.target.value)} />
        {errors.OrderLineStatus && <small role="alert" data-testid="error-OrderLineStatus">{errors.OrderLineStatus}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
