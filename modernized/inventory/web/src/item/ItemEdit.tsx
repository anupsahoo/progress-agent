import { useState } from 'react';
import type { Item } from './types';
import { itemLabels as L } from './types';
import { validateItem } from './validation';
import { itemService } from './service';

// Replaces item_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function ItemEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Item>; isNew: boolean; onSaved: (row: Item) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Item>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Item, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateItem(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await itemService.create(v as Item) : await itemService.update({ Itemnum: v.Itemnum! } as any, v as Item);
      setBanner('Item saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="item-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Itemnum} *</span>
        <input type="number" data-testid="field-Itemnum" aria-label={L.Itemnum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.Itemnum ?? ''} onChange={(e) => set('Itemnum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Itemnum && <small role="alert" data-testid="error-Itemnum">{errors.Itemnum}</small>}
      </label>
      <label>
        <span>{L.ItemName}</span>
        <input data-testid="field-ItemName" aria-label={L.ItemName} maxLength={25} value={v.ItemName ?? ''} onChange={(e) => set('ItemName', e.target.value)} />
        {errors.ItemName && <small role="alert" data-testid="error-ItemName">{errors.ItemName}</small>}
      </label>
      <label>
        <span>{L.Price}</span>
        <input type="number" data-testid="field-Price" aria-label={L.Price} min={-9999999.99} max={9999999.99} step={0.01} value={v.Price ?? ''} onChange={(e) => set('Price', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Price && <small role="alert" data-testid="error-Price">{errors.Price}</small>}
      </label>
      <label>
        <span>{L.Onhand}</span>
        <input type="number" data-testid="field-Onhand" aria-label={L.Onhand} min={-99999} max={99999} step={1} value={v.Onhand ?? ''} onChange={(e) => set('Onhand', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Onhand && <small role="alert" data-testid="error-Onhand">{errors.Onhand}</small>}
      </label>
      <label>
        <span>{L.Allocated}</span>
        <input type="number" data-testid="field-Allocated" aria-label={L.Allocated} min={-99999} max={99999} step={1} value={v.Allocated ?? ''} onChange={(e) => set('Allocated', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Allocated && <small role="alert" data-testid="error-Allocated">{errors.Allocated}</small>}
      </label>
      <label>
        <span>{L.ReOrder}</span>
        <input type="number" data-testid="field-ReOrder" aria-label={L.ReOrder} min={-99999} max={99999} step={1} value={v.ReOrder ?? ''} onChange={(e) => set('ReOrder', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.ReOrder && <small role="alert" data-testid="error-ReOrder">{errors.ReOrder}</small>}
      </label>
      <label>
        <span>{L.OnOrder}</span>
        <input type="number" data-testid="field-OnOrder" aria-label={L.OnOrder} min={-99999} max={99999} step={1} value={v.OnOrder ?? ''} onChange={(e) => set('OnOrder', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.OnOrder && <small role="alert" data-testid="error-OnOrder">{errors.OnOrder}</small>}
      </label>
      <label>
        <span>{L.CatPage}</span>
        <input type="number" data-testid="field-CatPage" aria-label={L.CatPage} min={0} max={999} step={1} value={v.CatPage ?? ''} onChange={(e) => set('CatPage', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.CatPage && <small role="alert" data-testid="error-CatPage">{errors.CatPage}</small>}
      </label>
      <label>
        <span>{L.CatDescription}</span>
        <input data-testid="field-CatDescription" aria-label={L.CatDescription} maxLength={200} value={v.CatDescription ?? ''} onChange={(e) => set('CatDescription', e.target.value)} />
        {errors.CatDescription && <small role="alert" data-testid="error-CatDescription">{errors.CatDescription}</small>}
      </label>
      <label>
        <span>{L.Category1}</span>
        <input data-testid="field-Category1" aria-label={L.Category1} maxLength={30} value={v.Category1 ?? ''} onChange={(e) => set('Category1', e.target.value)} />
        {errors.Category1 && <small role="alert" data-testid="error-Category1">{errors.Category1}</small>}
      </label>
      <label>
        <span>{L.Category2}</span>
        <input data-testid="field-Category2" aria-label={L.Category2} maxLength={30} value={v.Category2 ?? ''} onChange={(e) => set('Category2', e.target.value)} />
        {errors.Category2 && <small role="alert" data-testid="error-Category2">{errors.Category2}</small>}
      </label>
      <label>
        <span>{L.Special}</span>
        <input data-testid="field-Special" aria-label={L.Special} maxLength={8} value={v.Special ?? ''} onChange={(e) => set('Special', e.target.value)} />
        {errors.Special && <small role="alert" data-testid="error-Special">{errors.Special}</small>}
      </label>
      <label>
        <span>{L.Weight}</span>
        <input type="number" data-testid="field-Weight" aria-label={L.Weight} min={-99999.99} max={99999.99} step={0.01} value={v.Weight ?? ''} onChange={(e) => set('Weight', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Weight && <small role="alert" data-testid="error-Weight">{errors.Weight}</small>}
      </label>
      <label>
        <span>{L.Minqty}</span>
        <input type="number" data-testid="field-Minqty" aria-label={L.Minqty} min={-99999} max={99999} step={1} value={v.Minqty ?? ''} onChange={(e) => set('Minqty', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Minqty && <small role="alert" data-testid="error-Minqty">{errors.Minqty}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
