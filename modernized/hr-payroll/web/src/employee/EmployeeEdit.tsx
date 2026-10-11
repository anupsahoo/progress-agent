import { useState } from 'react';
import type { Employee } from './types';
import { employeeLabels as L } from './types';
import { validateEmployee } from './validation';
import { employeeService } from './service';

// Replaces employee_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function EmployeeEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Employee>; isNew: boolean; onSaved: (row: Employee) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Employee>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Employee, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateEmployee(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await employeeService.create(v as Employee) : await employeeService.update({ EmpNum: v.EmpNum! } as any, v as Employee);
      setBanner('Employee saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="employee-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.EmpNum} *</span>
        <input type="number" data-testid="field-EmpNum" aria-label={L.EmpNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.EmpNum ?? ''} onChange={(e) => set('EmpNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.EmpNum && <small role="alert" data-testid="error-EmpNum">{errors.EmpNum}</small>}
      </label>
      <label>
        <span>{L.LastName}</span>
        <input data-testid="field-LastName" aria-label={L.LastName} maxLength={25} value={v.LastName ?? ''} onChange={(e) => set('LastName', e.target.value)} />
        {errors.LastName && <small role="alert" data-testid="error-LastName">{errors.LastName}</small>}
      </label>
      <label>
        <span>{L.FirstName}</span>
        <input data-testid="field-FirstName" aria-label={L.FirstName} maxLength={15} value={v.FirstName ?? ''} onChange={(e) => set('FirstName', e.target.value)} />
        {errors.FirstName && <small role="alert" data-testid="error-FirstName">{errors.FirstName}</small>}
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
        <span>{L.HomePhone}</span>
        <input data-testid="field-HomePhone" aria-label={L.HomePhone} maxLength={20} value={v.HomePhone ?? ''} onChange={(e) => set('HomePhone', e.target.value)} />
        {errors.HomePhone && <small role="alert" data-testid="error-HomePhone">{errors.HomePhone}</small>}
      </label>
      <label>
        <span>{L.WorkPhone}</span>
        <input data-testid="field-WorkPhone" aria-label={L.WorkPhone} maxLength={20} value={v.WorkPhone ?? ''} onChange={(e) => set('WorkPhone', e.target.value)} />
        {errors.WorkPhone && <small role="alert" data-testid="error-WorkPhone">{errors.WorkPhone}</small>}
      </label>
      <label>
        <span>{L.DeptCode}</span>
        <input data-testid="field-DeptCode" aria-label={L.DeptCode} maxLength={3} value={v.DeptCode ?? ''} onChange={(e) => set('DeptCode', e.target.value)} />
        {errors.DeptCode && <small role="alert" data-testid="error-DeptCode">{errors.DeptCode}</small>}
      </label>
      <label>
        <span>{L.Position}</span>
        <input data-testid="field-Position" aria-label={L.Position} maxLength={20} value={v.Position ?? ''} onChange={(e) => set('Position', e.target.value)} />
        {errors.Position && <small role="alert" data-testid="error-Position">{errors.Position}</small>}
      </label>
      <label>
        <span>{L.Birthdate}</span>
        <input type="date" data-testid="field-Birthdate" aria-label={L.Birthdate} value={v.Birthdate ?? ''} onChange={(e) => set('Birthdate', e.target.value || null)} />
        {errors.Birthdate && <small role="alert" data-testid="error-Birthdate">{errors.Birthdate}</small>}
      </label>
      <label>
        <span>{L.StartDate}</span>
        <input type="date" data-testid="field-StartDate" aria-label={L.StartDate} value={v.StartDate ?? ''} onChange={(e) => set('StartDate', e.target.value || null)} />
        {errors.StartDate && <small role="alert" data-testid="error-StartDate">{errors.StartDate}</small>}
      </label>
      <label>
        <span>{L.VacationDaysLeft}</span>
        <input type="number" data-testid="field-VacationDaysLeft" aria-label={L.VacationDaysLeft} min={0} max={999} step={1} value={v.VacationDaysLeft ?? ''} onChange={(e) => set('VacationDaysLeft', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.VacationDaysLeft && <small role="alert" data-testid="error-VacationDaysLeft">{errors.VacationDaysLeft}</small>}
      </label>
      <label>
        <span>{L.SickDaysLeft}</span>
        <input type="number" data-testid="field-SickDaysLeft" aria-label={L.SickDaysLeft} min={0} max={999} step={1} value={v.SickDaysLeft ?? ''} onChange={(e) => set('SickDaysLeft', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.SickDaysLeft && <small role="alert" data-testid="error-SickDaysLeft">{errors.SickDaysLeft}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
