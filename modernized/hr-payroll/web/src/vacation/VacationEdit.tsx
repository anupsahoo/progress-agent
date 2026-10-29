import { useState } from 'react';
import type { Vacation } from './types';
import { vacationLabels as L } from './types';
import { validateVacation } from './validation';
import { vacationService } from './service';

// Replaces vacation_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function VacationEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Vacation>; isNew: boolean; onSaved: (row: Vacation) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Vacation>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Vacation, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateVacation(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await vacationService.create(v as Vacation) : await vacationService.update({ EmpNum: v.EmpNum!, StartDate: v.StartDate! } as any, v as Vacation);
      setBanner('Vacation saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="vacation-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.EmpNum} *</span>
        <input type="number" data-testid="field-EmpNum" aria-label={L.EmpNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.EmpNum ?? ''} onChange={(e) => set('EmpNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.EmpNum && <small role="alert" data-testid="error-EmpNum">{errors.EmpNum}</small>}
      </label>
      <label>
        <span>{L.StartDate} *</span>
        <input type="date" data-testid="field-StartDate" aria-label={L.StartDate} readOnly={!isNew} value={v.StartDate ?? ''} onChange={(e) => set('StartDate', e.target.value || null)} />
        {errors.StartDate && <small role="alert" data-testid="error-StartDate">{errors.StartDate}</small>}
      </label>
      <label>
        <span>{L.EndDate}</span>
        <input type="date" data-testid="field-EndDate" aria-label={L.EndDate} value={v.EndDate ?? ''} onChange={(e) => set('EndDate', e.target.value || null)} />
        {errors.EndDate && <small role="alert" data-testid="error-EndDate">{errors.EndDate}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
