import { useState } from 'react';
import type { Warehouse } from './types';
import { warehouseLabels as L } from './types';
import { validateWarehouse } from './validation';
import { warehouseService } from './service';

// Replaces warehouse_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function WarehouseEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Warehouse>; isNew: boolean; onSaved: (row: Warehouse) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Warehouse>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Warehouse, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateWarehouse(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await warehouseService.create(v as Warehouse) : await warehouseService.update({ WarehouseNum: v.WarehouseNum! } as any, v as Warehouse);
      setBanner('Warehouse saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="warehouse-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.WarehouseNum} *</span>
        <input type="number" data-testid="field-WarehouseNum" aria-label={L.WarehouseNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.WarehouseNum ?? ''} onChange={(e) => set('WarehouseNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.WarehouseNum && <small role="alert" data-testid="error-WarehouseNum">{errors.WarehouseNum}</small>}
      </label>
      <label>
        <span>{L.WarehouseName}</span>
        <input data-testid="field-WarehouseName" aria-label={L.WarehouseName} maxLength={30} value={v.WarehouseName ?? ''} onChange={(e) => set('WarehouseName', e.target.value)} />
        {errors.WarehouseName && <small role="alert" data-testid="error-WarehouseName">{errors.WarehouseName}</small>}
      </label>
      <label>
        <span>{L.Country}</span>
        <input data-testid="field-Country" aria-label={L.Country} maxLength={20} value={v.Country ?? ''} onChange={(e) => set('Country', e.target.value)} />
        {errors.Country && <small role="alert" data-testid="error-Country">{errors.Country}</small>}
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
