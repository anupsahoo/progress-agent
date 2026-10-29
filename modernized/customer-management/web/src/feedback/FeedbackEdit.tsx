import { useState } from 'react';
import type { Feedback } from './types';
import { feedbackLabels as L } from './types';
import { validateFeedback } from './validation';
import { feedbackService } from './service';

// Replaces feedback_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function FeedbackEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<Feedback>; isNew: boolean; onSaved: (row: Feedback) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<Feedback>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof Feedback, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateFeedback(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await feedbackService.create(v as Feedback) : await feedbackService.update({ Department: v.Department! } as any, v as Feedback);
      setBanner('Feedback saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="feedback-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.Contact}</span>
        <input data-testid="field-Contact" aria-label={L.Contact} maxLength={30} value={v.Contact ?? ''} onChange={(e) => set('Contact', e.target.value)} />
        {errors.Contact && <small role="alert" data-testid="error-Contact">{errors.Contact}</small>}
      </label>
      <label>
        <span>{L.Company}</span>
        <input data-testid="field-Company" aria-label={L.Company} maxLength={20} value={v.Company ?? ''} onChange={(e) => set('Company', e.target.value)} />
        {errors.Company && <small role="alert" data-testid="error-Company">{errors.Company}</small>}
      </label>
      <label>
        <span>{L.EmailAddress}</span>
        <input data-testid="field-EmailAddress" aria-label={L.EmailAddress} maxLength={50} value={v.EmailAddress ?? ''} onChange={(e) => set('EmailAddress', e.target.value)} />
        {errors.EmailAddress && <small role="alert" data-testid="error-EmailAddress">{errors.EmailAddress}</small>}
      </label>
      <label>
        <span>{L.Phone}</span>
        <input data-testid="field-Phone" aria-label={L.Phone} maxLength={20} value={v.Phone ?? ''} onChange={(e) => set('Phone', e.target.value)} />
        {errors.Phone && <small role="alert" data-testid="error-Phone">{errors.Phone}</small>}
      </label>
      <label>
        <span>{L.Fax}</span>
        <input data-testid="field-Fax" aria-label={L.Fax} maxLength={20} value={v.Fax ?? ''} onChange={(e) => set('Fax', e.target.value)} />
        {errors.Fax && <small role="alert" data-testid="error-Fax">{errors.Fax}</small>}
      </label>
      <label>
        <span>{L.Comments}</span>
        <input data-testid="field-Comments" aria-label={L.Comments} maxLength={80} value={v.Comments ?? ''} onChange={(e) => set('Comments', e.target.value)} />
        {errors.Comments && <small role="alert" data-testid="error-Comments">{errors.Comments}</small>}
      </label>
      <label>
        <span>{L.Department} *</span>
        <input data-testid="field-Department" aria-label={L.Department} readOnly={!isNew} maxLength={15} value={v.Department ?? ''} onChange={(e) => set('Department', e.target.value)} />
        {errors.Department && <small role="alert" data-testid="error-Department">{errors.Department}</small>}
      </label>
      <label>
        <span>{L.Rating}</span>
        <input type="number" data-testid="field-Rating" aria-label={L.Rating} min={0} max={9} step={1} value={v.Rating ?? ''} onChange={(e) => set('Rating', e.target.value === '' ? null : Number(e.target.value))} />
        {errors.Rating && <small role="alert" data-testid="error-Rating">{errors.Rating}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
