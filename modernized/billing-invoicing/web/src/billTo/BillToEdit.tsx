import { useState } from 'react';
import type { BillTo } from './types';
import { billToLabels as L } from './types';
import { validateBillTo } from './validation';
import { billToService } from './service';

// Replaces bill_to_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function BillToEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<BillTo>; isNew: boolean; onSaved: (row: BillTo) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<BillTo>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof BillTo, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateBillTo(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await billToService.create(v as BillTo) : await billToService.update({ CustNum: v.CustNum!, BillToID: v.BillToID! } as any, v as BillTo);
      setBanner('BillTo saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="bill-to-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.CustNum} *</span>
        <input type="number" data-testid="field-CustNum" aria-label={L.CustNum} readOnly={!isNew} min={0} max={99999} step={1} value={v.CustNum ?? ''} onChange={(e) => set('CustNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CustNum && <small role="alert" data-testid="error-CustNum">{errors.CustNum}</small>}
      </label>
      <label>
        <span>{L.BillToID} *</span>
        <input type="number" data-testid="field-BillToID" aria-label={L.BillToID} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.BillToID ?? ''} onChange={(e) => set('BillToID', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.BillToID && <small role="alert" data-testid="error-BillToID">{errors.BillToID}</small>}
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
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
