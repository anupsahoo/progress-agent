import { useState } from 'react';
import type { Supplier } from './types';
import { supplierLabels as L } from './types';
import { validateSupplier } from './validation';
import { supplierService } from './service';

// Replaces supplier_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function SupplierEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Supplier>; isNew: boolean; onSaved: (row: Supplier) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Supplier>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Supplier, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateSupplier(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await supplierService.create(v as Supplier) : await supplierService.update({ SupplierIDNum: v.SupplierIDNum! } as any, v as Supplier);
      setBanner('Supplier saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="supplier-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.SupplierIDNum} *</span>
        <input type="number" data-testid="field-SupplierIDNum" aria-label={L.SupplierIDNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.SupplierIDNum ?? ''} onChange={(e) => set('SupplierIDNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.SupplierIDNum && <small role="alert" data-testid="error-SupplierIDNum">{errors.SupplierIDNum}</small>}
      </label>
      <label>
        <span>{L.Name}</span>
        <input data-testid="field-Name" aria-label={L.Name} maxLength={30} value={v.Name ?? ''} onChange={(e) => set('Name', e.target.value)} />
        {errors.Name && <small role="alert" data-testid="error-Name">{errors.Name}</small>}
      </label>
      <label>
        <span>{L.Address}</span>
        <input data-testid="field-Address" aria-label={L.Address} maxLength={35} value={v.Address ?? ''} onChange={(e) => set('Address', e.target.value)} />
        {errors.Address && <small role="alert" data-testid="error-Address">{errors.Address}</small>}
      </label>
      <label>
        <span>{L.Address2}</span>
        <input data-testid="field-Address2" aria-label={L.Address2} maxLength={35} value={v.Address2 ?? ''} onChange={(e) => set('Address2', e.target.value)} />
        {errors.Address2 && <small role="alert" data-testid="error-Address2">{errors.Address2}</small>}
      </label>
      <label>
        <span>{L.City}</span>
        <input data-testid="field-City" aria-label={L.City} maxLength={25} value={v.City ?? ''} onChange={(e) => set('City', e.target.value)} />
        {errors.City && <small role="alert" data-testid="error-City">{errors.City}</small>}
      </label>
      <label>
        <span>{L.State}</span>
        <input data-testid="field-State" aria-label={L.State} maxLength={20} value={v.State ?? ''} onChange={(e) => set('State', e.target.value)} />
        {errors.State && <small role="alert" data-testid="error-State">{errors.State}</small>}
      </label>
      <label>
        <span>{L.PostalCode}</span>
        <input data-testid="field-PostalCode" aria-label={L.PostalCode} maxLength={10} value={v.PostalCode ?? ''} onChange={(e) => set('PostalCode', e.target.value)} />
        {errors.PostalCode && <small role="alert" data-testid="error-PostalCode">{errors.PostalCode}</small>}
      </label>
      <label>
        <span>{L.Country}</span>
        <input data-testid="field-Country" aria-label={L.Country} maxLength={20} value={v.Country ?? ''} onChange={(e) => set('Country', e.target.value)} />
        {errors.Country && <small role="alert" data-testid="error-Country">{errors.Country}</small>}
      </label>
      <label>
        <span>{L.Phone}</span>
        <input data-testid="field-Phone" aria-label={L.Phone} maxLength={20} value={v.Phone ?? ''} onChange={(e) => set('Phone', e.target.value)} />
        {errors.Phone && <small role="alert" data-testid="error-Phone">{errors.Phone}</small>}
      </label>
      <label>
        <span>{L.Comments}</span>
        <input data-testid="field-Comments" aria-label={L.Comments} maxLength={80} value={v.Comments ?? ''} onChange={(e) => set('Comments', e.target.value)} />
        {errors.Comments && <small role="alert" data-testid="error-Comments">{errors.Comments}</small>}
      </label>
      <label>
        <span>{L.Password} *</span>
        <input data-testid="field-Password" aria-label={L.Password} maxLength={8} value={v.Password ?? ''} onChange={(e) => set('Password', e.target.value)} />
        {errors.Password && <small role="alert" data-testid="error-Password">{errors.Password}</small>}
      </label>
      <label>
        <span>{L.LoginDate}</span>
        <input type="date" data-testid="field-LoginDate" aria-label={L.LoginDate} value={v.LoginDate ?? ''} onChange={(e) => set('LoginDate', e.target.value || null)} />
        {errors.LoginDate && <small role="alert" data-testid="error-LoginDate">{errors.LoginDate}</small>}
      </label>
      <label>
        <span>{L.ShipAmount}</span>
        <input type="number" data-testid="field-ShipAmount" aria-label={L.ShipAmount} min={0} max={99999} step={1} value={v.ShipAmount ?? ''} onChange={(e) => set('ShipAmount', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.ShipAmount && <small role="alert" data-testid="error-ShipAmount">{errors.ShipAmount}</small>}
      </label>
      <label>
        <span>{L.Discount}</span>
        <input type="number" data-testid="field-Discount" aria-label={L.Discount} min={0} max={999} step={1} value={v.Discount ?? ''} onChange={(e) => set('Discount', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Discount && <small role="alert" data-testid="error-Discount">{errors.Discount}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
