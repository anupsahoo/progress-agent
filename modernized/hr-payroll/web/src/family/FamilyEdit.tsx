import { useState } from 'react';
import type { Family } from './types';
import { familyLabels as L } from './types';
import { validateFamily } from './validation';
import { familyService } from './service';

// Replaces family_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function FamilyEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Family>; isNew: boolean; onSaved: (row: Family) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Family>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Family, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateFamily(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await familyService.create(v as Family) : await familyService.update({ EmpNum: v.EmpNum!, RelativeName: v.RelativeName! } as any, v as Family);
      setBanner('Family saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="family-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.EmpNum} *</span>
        <input type="number" data-testid="field-EmpNum" aria-label={L.EmpNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.EmpNum ?? ''} onChange={(e) => set('EmpNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.EmpNum && <small role="alert" data-testid="error-EmpNum">{errors.EmpNum}</small>}
      </label>
      <label>
        <span>{L.RelativeName} *</span>
        <input data-testid="field-RelativeName" aria-label={L.RelativeName} readOnly={!isNew} maxLength={15} value={v.RelativeName ?? ''} onChange={(e) => set('RelativeName', e.target.value)} />
        {errors.RelativeName && <small role="alert" data-testid="error-RelativeName">{errors.RelativeName}</small>}
      </label>
      <label>
        <span>{L.Relation}</span>
        <input data-testid="field-Relation" aria-label={L.Relation} maxLength={15} value={v.Relation ?? ''} onChange={(e) => set('Relation', e.target.value)} />
        {errors.Relation && <small role="alert" data-testid="error-Relation">{errors.Relation}</small>}
      </label>
      <label>
        <span>{L.Birthdate}</span>
        <input type="date" data-testid="field-Birthdate" aria-label={L.Birthdate} value={v.Birthdate ?? ''} onChange={(e) => set('Birthdate', e.target.value || null)} />
        {errors.Birthdate && <small role="alert" data-testid="error-Birthdate">{errors.Birthdate}</small>}
      </label>
      <label>
        <span>{L.CoveredOnBenefits}</span>
        <input type="checkbox" data-testid="field-CoveredOnBenefits" aria-label={L.CoveredOnBenefits} checked={!!v.CoveredOnBenefits} onChange={(e) => set('CoveredOnBenefits', e.target.checked)} />
        {errors.CoveredOnBenefits && <small role="alert" data-testid="error-CoveredOnBenefits">{errors.CoveredOnBenefits}</small>}
      </label>
      <label>
        <span>{L.BenefitDate}</span>
        <input type="date" data-testid="field-BenefitDate" aria-label={L.BenefitDate} value={v.BenefitDate ?? ''} onChange={(e) => set('BenefitDate', e.target.value || null)} />
        {errors.BenefitDate && <small role="alert" data-testid="error-BenefitDate">{errors.BenefitDate}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
