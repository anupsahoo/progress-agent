import { useState } from 'react';
import type { Benefits } from './types';
import { benefitsLabels as L } from './types';
import { validateBenefits } from './validation';
import { benefitsService } from './service';

// Replaces benefits_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function BenefitsEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Benefits>; isNew: boolean; onSaved: (row: Benefits) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Benefits>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Benefits, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateBenefits(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await benefitsService.create(v as Benefits) : await benefitsService.update({ EmpNum: v.EmpNum! } as any, v as Benefits);
      setBanner('Benefits saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="benefits-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.EmpNum} *</span>
        <input type="number" data-testid="field-EmpNum" aria-label={L.EmpNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.EmpNum ?? ''} onChange={(e) => set('EmpNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.EmpNum && <small role="alert" data-testid="error-EmpNum">{errors.EmpNum}</small>}
      </label>
      <label>
        <span>{L.HealthCare}</span>
        <input data-testid="field-HealthCare" aria-label={L.HealthCare} maxLength={8} value={v.HealthCare ?? ''} onChange={(e) => set('HealthCare', e.target.value)} />
        {errors.HealthCare && <small role="alert" data-testid="error-HealthCare">{errors.HealthCare}</small>}
      </label>
      <label>
        <span>{L.LifeInsurance}</span>
        <input type="number" data-testid="field-LifeInsurance" aria-label={L.LifeInsurance} min={0} max={99999999} step={1} value={v.LifeInsurance ?? ''} onChange={(e) => set('LifeInsurance', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.LifeInsurance && <small role="alert" data-testid="error-LifeInsurance">{errors.LifeInsurance}</small>}
      </label>
      <label>
        <span>{L.Pension401K}</span>
        <input type="number" data-testid="field-Pension401K" aria-label={L.Pension401K} min={0} max={99999} step={1} value={v.Pension401K ?? ''} onChange={(e) => set('Pension401K', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Pension401K && <small role="alert" data-testid="error-Pension401K">{errors.Pension401K}</small>}
      </label>
      <label>
        <span>{L.StockPurchase}</span>
        <input type="number" data-testid="field-StockPurchase" aria-label={L.StockPurchase} min={0} max={99999} step={1} value={v.StockPurchase ?? ''} onChange={(e) => set('StockPurchase', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.StockPurchase && <small role="alert" data-testid="error-StockPurchase">{errors.StockPurchase}</small>}
      </label>
      <label>
        <span>{L.MedicalSpending}</span>
        <input type="number" data-testid="field-MedicalSpending" aria-label={L.MedicalSpending} min={0} max={99999} step={1} value={v.MedicalSpending ?? ''} onChange={(e) => set('MedicalSpending', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.MedicalSpending && <small role="alert" data-testid="error-MedicalSpending">{errors.MedicalSpending}</small>}
      </label>
      <label>
        <span>{L.DependentCare}</span>
        <input type="number" data-testid="field-DependentCare" aria-label={L.DependentCare} min={0} max={99999} step={1} value={v.DependentCare ?? ''} onChange={(e) => set('DependentCare', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.DependentCare && <small role="alert" data-testid="error-DependentCare">{errors.DependentCare}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
