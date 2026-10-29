import { useState } from 'react';
import type { State } from './types';
import { stateLabels as L } from './types';
import { validateState } from './validation';
import { stateService } from './service';

// Replaces state_maint.p: UPDATE ... WITH FRAME, ON LEAVE validation, EXCLUSIVE-LOCK.
// The record lock becomes an optimistic version check (HTTP 409 on conflict).
export function StateEdit({ initial, isNew, onSaved, onCancel }: { initial: Partial<State>; isNew: boolean; onSaved: (row: State) => void; onCancel: () => void }) {
  const [v, setV] = useState<Partial<State>>(initial);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);
  const [banner, setBanner] = useState('');
  const set = (k: keyof State, val: unknown) => setV((s) => ({ ...s, [k]: val }));

  const save = async () => {
    const e = validateState(v);
    setErrors(e);
    if (Object.keys(e).length) return;
    setBusy(true);
    try {
      const row = isNew ? await stateService.create(v as State) : await stateService.update({ State: v.State! } as any, v as State);
      setBanner('State saved.');
      onSaved(row);
    } catch (err: any) {
      setBanner(String(err.message || err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form data-testid="state-edit" onSubmit={(e) => { e.preventDefault(); save(); }}>
      {banner && <div role="status" data-testid="banner">{banner}</div>}
      <label>
        <span>{L.State} *</span>
        <input data-testid="field-State" aria-label={L.State} readOnly={!isNew} maxLength={20} value={v.State ?? ''} onChange={(e) => set('State', e.target.value)} />
        {errors.State && <small role="alert" data-testid="error-State">{errors.State}</small>}
      </label>
      <label>
        <span>{L.StateName}</span>
        <input data-testid="field-StateName" aria-label={L.StateName} maxLength={20} value={v.StateName ?? ''} onChange={(e) => set('StateName', e.target.value)} />
        {errors.StateName && <small role="alert" data-testid="error-StateName">{errors.StateName}</small>}
      </label>
      <label>
        <span>{L.Region}</span>
        <input data-testid="field-Region" aria-label={L.Region} maxLength={8} value={v.Region ?? ''} onChange={(e) => set('Region', e.target.value)} />
        {errors.Region && <small role="alert" data-testid="error-Region">{errors.Region}</small>}
      </label>
      <footer>
        <button type="submit" data-testid="save" disabled={busy}>Save</button>
        <button type="button" onClick={onCancel}>Cancel</button>
      </footer>
    </form>
  );
}
