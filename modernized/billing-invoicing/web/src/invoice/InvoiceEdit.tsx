import { useState } from 'react';
import type { Invoice } from './types';
import { invoiceLabels as L } from './types';
import { validateInvoice } from './validation';
import { invoiceService } from './service';

// Replaces invoice_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function InvoiceEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Invoice>; isNew: boolean; onSaved: (row: Invoice) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Invoice>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Invoice, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateInvoice(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await invoiceService.create(v as Invoice) : await invoiceService.update({ Invoicenum: v.Invoicenum! } as any, v as Invoice);
      setBanner('Invoice saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="invoice-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Invoicenum} *</span>
        <input type="number" data-testid="field-Invoicenum" aria-label={L.Invoicenum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.Invoicenum ?? ''} onChange={(e) => set('Invoicenum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Invoicenum && <small role="alert" data-testid="error-Invoicenum">{errors.Invoicenum}</small>}
      </label>
      <label>
        <span>{L.CustNum}</span>
        <input type="number" data-testid="field-CustNum" aria-label={L.CustNum} min={0} max={99999} step={1} value={v.CustNum ?? ''} onChange={(e) => set('CustNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CustNum && <small role="alert" data-testid="error-CustNum">{errors.CustNum}</small>}
      </label>
      <label>
        <span>{L.InvoiceDate}</span>
        <input type="date" data-testid="field-InvoiceDate" aria-label={L.InvoiceDate} value={v.InvoiceDate ?? ''} onChange={(e) => set('InvoiceDate', e.target.value || null)} />
        {errors.InvoiceDate && <small role="alert" data-testid="error-InvoiceDate">{errors.InvoiceDate}</small>}
      </label>
      <label>
        <span>{L.Amount}</span>
        <input type="number" data-testid="field-Amount" aria-label={L.Amount} min={-99999.99} max={99999.99} step={0.01} value={v.Amount ?? ''} onChange={(e) => set('Amount', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Amount && <small role="alert" data-testid="error-Amount">{errors.Amount}</small>}
      </label>
      <label>
        <span>{L.TotalPaid}</span>
        <input type="number" data-testid="field-TotalPaid" aria-label={L.TotalPaid} min={-99999.99} max={99999.99} step={0.01} value={v.TotalPaid ?? ''} onChange={(e) => set('TotalPaid', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.TotalPaid && <small role="alert" data-testid="error-TotalPaid">{errors.TotalPaid}</small>}
      </label>
      <label>
        <span>{L.Adjustment}</span>
        <input type="number" data-testid="field-Adjustment" aria-label={L.Adjustment} min={-99999.99} max={99999.99} step={0.01} value={v.Adjustment ?? ''} onChange={(e) => set('Adjustment', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Adjustment && <small role="alert" data-testid="error-Adjustment">{errors.Adjustment}</small>}
      </label>
      <label>
        <span>{L.OrderNum}</span>
        <input type="number" data-testid="field-OrderNum" aria-label={L.OrderNum} min={0} max={9999999999} step={1} value={v.OrderNum ?? ''} onChange={(e) => set('OrderNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.OrderNum && <small role="alert" data-testid="error-OrderNum">{errors.OrderNum}</small>}
      </label>
      <label>
        <span>{L.ShipCharge}</span>
        <input type="number" data-testid="field-ShipCharge" aria-label={L.ShipCharge} min={-99999.99} max={99999.99} step={0.01} value={v.ShipCharge ?? ''} onChange={(e) => set('ShipCharge', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.ShipCharge && <small role="alert" data-testid="error-ShipCharge">{errors.ShipCharge}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
