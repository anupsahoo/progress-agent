import { useState } from 'react';
import type { TimeSheet } from './types';
import { timeSheetLabels as L } from './types';
import { validateTimeSheet } from './validation';
import { timeSheetService } from './service';

// Replaces time_sheet_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function TimeSheetEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<TimeSheet>; isNew: boolean; onSaved: (row: TimeSheet) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<TimeSheet>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof TimeSheet, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateTimeSheet(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await timeSheetService.create(v as TimeSheet) : await timeSheetService.update({ EmpNum: v.EmpNum!, DayRecorded: v.DayRecorded! } as any, v as TimeSheet);
      setBanner('TimeSheet saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="time-sheet-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.EmpNum} *</span>
        <input type="number" data-testid="field-EmpNum" aria-label={L.EmpNum} readOnly={!isNew} min={0} max={9999999999} step={1} value={v.EmpNum ?? ''} onChange={(e) => set('EmpNum', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.EmpNum && <small role="alert" data-testid="error-EmpNum">{errors.EmpNum}</small>}
      </label>
      <label>
        <span>{L.DayRecorded} *</span>
        <input type="date" data-testid="field-DayRecorded" aria-label={L.DayRecorded} readOnly={!isNew} value={v.DayRecorded ?? ''} onChange={(e) => set('DayRecorded', e.target.value || null)} />
        {errors.DayRecorded && <small role="alert" data-testid="error-DayRecorded">{errors.DayRecorded}</small>}
      </label>
      <label>
        <span>{L.TypeRecorded}</span>
        <input data-testid="field-TypeRecorded" aria-label={L.TypeRecorded} maxLength={8} value={v.TypeRecorded ?? ''} onChange={(e) => set('TypeRecorded', e.target.value)} />
        {errors.TypeRecorded && <small role="alert" data-testid="error-TypeRecorded">{errors.TypeRecorded}</small>}
      </label>
      <label>
        <span>{L.AMTimeIn}</span>
        <input data-testid="field-AMTimeIn" aria-label={L.AMTimeIn} maxLength={5} value={v.AMTimeIn ?? ''} onChange={(e) => set('AMTimeIn', e.target.value)} />
        {errors.AMTimeIn && <small role="alert" data-testid="error-AMTimeIn">{errors.AMTimeIn}</small>}
      </label>
      <label>
        <span>{L.AMTimeOut}</span>
        <input data-testid="field-AMTimeOut" aria-label={L.AMTimeOut} maxLength={5} value={v.AMTimeOut ?? ''} onChange={(e) => set('AMTimeOut', e.target.value)} />
        {errors.AMTimeOut && <small role="alert" data-testid="error-AMTimeOut">{errors.AMTimeOut}</small>}
      </label>
      <label>
        <span>{L.PMTimeIn}</span>
        <input data-testid="field-PMTimeIn" aria-label={L.PMTimeIn} maxLength={5} value={v.PMTimeIn ?? ''} onChange={(e) => set('PMTimeIn', e.target.value)} />
        {errors.PMTimeIn && <small role="alert" data-testid="error-PMTimeIn">{errors.PMTimeIn}</small>}
      </label>
      <label>
        <span>{L.PMTimeOut}</span>
        <input data-testid="field-PMTimeOut" aria-label={L.PMTimeOut} maxLength={5} value={v.PMTimeOut ?? ''} onChange={(e) => set('PMTimeOut', e.target.value)} />
        {errors.PMTimeOut && <small role="alert" data-testid="error-PMTimeOut">{errors.PMTimeOut}</small>}
      </label>
      <label>
        <span>{L.RegularHours}</span>
        <input type="number" data-testid="field-RegularHours" aria-label={L.RegularHours} min={0} max={999.99} step={0.01} value={v.RegularHours ?? ''} onChange={(e) => set('RegularHours', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.RegularHours && <small role="alert" data-testid="error-RegularHours">{errors.RegularHours}</small>}
      </label>
      <label>
        <span>{L.OvertimeHours}</span>
        <input type="number" data-testid="field-OvertimeHours" aria-label={L.OvertimeHours} min={0} max={999.99} step={0.01} value={v.OvertimeHours ?? ''} onChange={(e) => set('OvertimeHours', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.OvertimeHours && <small role="alert" data-testid="error-OvertimeHours">{errors.OvertimeHours}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
