import { useState } from 'react';
import type { Department } from './types';
import { departmentLabels as L } from './types';
import { validateDepartment } from './validation';
import { departmentService } from './service';

// Replaces department_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function DepartmentEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Department>; isNew: boolean; onSaved: (row: Department) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Department>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Department, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateDepartment(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await departmentService.create(v as Department) : await departmentService.update({ DeptCode: v.DeptCode! } as any, v as Department);
      setBanner('Department saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="department-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.DeptCode} *</span>
        <input data-testid="field-DeptCode" aria-label={L.DeptCode} readOnly={!isNew} maxLength={3} value={v.DeptCode ?? ''} onChange={(e) => set('DeptCode', e.target.value)} />
        {errors.DeptCode && <small role="alert" data-testid="error-DeptCode">{errors.DeptCode}</small>}
      </label>
      <label>
        <span>{L.DeptName}</span>
        <input data-testid="field-DeptName" aria-label={L.DeptName} maxLength={15} value={v.DeptName ?? ''} onChange={(e) => set('DeptName', e.target.value)} />
        {errors.DeptName && <small role="alert" data-testid="error-DeptName">{errors.DeptName}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
