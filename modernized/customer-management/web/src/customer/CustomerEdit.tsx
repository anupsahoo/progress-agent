import { useState } from 'react';
import type { Customer } from './types';
import { customerLabels as L } from './types';
import { validateCustomer } from './validation';
import { customerService } from './service';

// Replaces customer_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function CustomerEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Customer>; isNew: boolean; onSaved: (row: Customer) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Customer>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Customer, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateCustomer(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await customerService.create(v as Customer) : await customerService.update({ CustNum: v.CustNum! } as any, v as Customer);
      setBanner('Customer saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="customer-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.CustNum} *</span>
        <input type="number" data-testid="field-CustNum" aria-label={L.CustNum} readOnly={!isNew} min={0} max={99999} step={1} value={v.CustNum ?? ''} onChange={(e) => set('CustNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CustNum && <small role="alert" data-testid="error-CustNum">{errors.CustNum}</small>}
      </label>
      <label>
        <span>{L.Country}</span>
        <input data-testid="field-Country" aria-label={L.Country} maxLength={20} value={v.Country ?? ''} onChange={(e) => set('Country', e.target.value)} />
        {errors.Country && <small role="alert" data-testid="error-Country">{errors.Country}</small>}
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
        <span>{L.Contact}</span>
        <input data-testid="field-Contact" aria-label={L.Contact} maxLength={30} value={v.Contact ?? ''} onChange={(e) => set('Contact', e.target.value)} />
        {errors.Contact && <small role="alert" data-testid="error-Contact">{errors.Contact}</small>}
      </label>
      <label>
        <span>{L.Phone}</span>
        <input data-testid="field-Phone" aria-label={L.Phone} maxLength={20} value={v.Phone ?? ''} onChange={(e) => set('Phone', e.target.value)} />
        {errors.Phone && <small role="alert" data-testid="error-Phone">{errors.Phone}</small>}
      </label>
      <label>
        <span>{L.SalesRep}</span>
        <input data-testid="field-SalesRep" aria-label={L.SalesRep} maxLength={4} value={v.SalesRep ?? ''} onChange={(e) => set('SalesRep', e.target.value)} />
        {errors.SalesRep && <small role="alert" data-testid="error-SalesRep">{errors.SalesRep}</small>}
      </label>
      <label>
        <span>{L.CreditLimit}</span>
        <input type="number" data-testid="field-CreditLimit" aria-label={L.CreditLimit} min={0} max={9999999} step={0.01} value={v.CreditLimit ?? ''} onChange={(e) => set('CreditLimit', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CreditLimit && <small role="alert" data-testid="error-CreditLimit">{errors.CreditLimit}</small>}
      </label>
      <label>
        <span>{L.Balance}</span>
        <input type="number" data-testid="field-Balance" aria-label={L.Balance} min={-9999999.99} max={9999999.99} step={0.01} value={v.Balance ?? ''} onChange={(e) => set('Balance', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Balance && <small role="alert" data-testid="error-Balance">{errors.Balance}</small>}
      </label>
      <label>
        <span>{L.Terms}</span>
        <input data-testid="field-Terms" aria-label={L.Terms} maxLength={20} value={v.Terms ?? ''} onChange={(e) => set('Terms', e.target.value)} />
        {errors.Terms && <small role="alert" data-testid="error-Terms">{errors.Terms}</small>}
      </label>
      <label>
        <span>{L.Discount}</span>
        <input type="number" data-testid="field-Discount" aria-label={L.Discount} min={0} max={999} step={1} value={v.Discount ?? ''} onChange={(e) => set('Discount', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Discount && <small role="alert" data-testid="error-Discount">{errors.Discount}</small>}
      </label>
      <label>
        <span>{L.Comments}</span>
        <input data-testid="field-Comments" aria-label={L.Comments} maxLength={80} value={v.Comments ?? ''} onChange={(e) => set('Comments', e.target.value)} />
        {errors.Comments && <small role="alert" data-testid="error-Comments">{errors.Comments}</small>}
      </label>
      <label>
        <span>{L.Fax}</span>
        <input data-testid="field-Fax" aria-label={L.Fax} maxLength={20} value={v.Fax ?? ''} onChange={(e) => set('Fax', e.target.value)} />
        {errors.Fax && <small role="alert" data-testid="error-Fax">{errors.Fax}</small>}
      </label>
      <label>
        <span>{L.EmailAddress}</span>
        <input data-testid="field-EmailAddress" aria-label={L.EmailAddress} maxLength={50} value={v.EmailAddress ?? ''} onChange={(e) => set('EmailAddress', e.target.value)} />
        {errors.EmailAddress && <small role="alert" data-testid="error-EmailAddress">{errors.EmailAddress}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
