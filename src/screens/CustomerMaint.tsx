import React, { useEffect, useMemo, useRef, useState } from 'react';
import { CheckCircle2, CircleAlert, History, Lock, LockOpen, RotateCcw, Save, Search } from 'lucide-react';
import { customers as initial, type Customer } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, Field, Pill, UtilMeter, initials } from '../components/ui';
import { T } from '../theme';

const PROGRESS_SCREEN = `┌──────────────────────────────────────────────────────────────────┐
│                 Customer Maintenance - Sports2000                │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Enter Cust Num  : 3                                             │
│                                                                  │
│  Customer        : Hoops                                         │
│  Address         : Suite 415                                     │
│                    40 Grove St.                                  │
│  City            : Atlanta                                       │
│  State           : GA                                            │
│  Postal Code     : 02112                                         │
│  Phone           : (617) 355-1557                                │
│                                                                  │
│  F1=Help   F4=Clear   F10=Save   ESC=Exit                        │
└──────────────────────────────────────────────────────────────────┘`;

/** Legacy messages, verbatim from customer_maint.p (R2, R4). */
const MSG_NOT_FOUND = 'Customer not found.';
const MSG_UPDATED = 'Record updated successfully.';

type Editable = 'name' | 'address' | 'city' | 'state' | 'postalCode' | 'phone';

/** Editable fields from the UPDATE statement, with widths from sports2000.df FORMAT x(n). */
const FIELDS: { key: Editable; label: string; max: number; span: string; required?: boolean }[] = [
  { key: 'name', label: 'Name', max: 30, span: 'span-4', required: true },
  { key: 'address', label: 'Address', max: 35, span: 'span-6' },
  { key: 'city', label: 'City', max: 25, span: 'span-2' },
  { key: 'state', label: 'State', max: 20, span: 'span-2' },
  { key: 'postalCode', label: 'Postal code', max: 10, span: 'span-2' },
  { key: 'phone', label: 'Phone', max: 20, span: 'span-3' },
];

type Rec = Customer & { version: number };

function validate(d: Rec): Partial<Record<Editable, string>> {
  const e: Partial<Record<Editable, string>> = {};
  FIELDS.forEach((f) => {
    const v = d[f.key];
    if (f.required && !v.trim()) e[f.key] = `${f.label} is required.`;
    else if (v.length > f.max) e[f.key] = `${f.label} can be at most ${f.max} characters (x(${f.max})).`;
  });
  return e;
}

export function CustomerMaint({ param }: { param?: string }) {
  const [db, setDb] = useState<Rec[]>(() => initial.map((c) => ({ ...c, version: 1 })));
  const [custNumInput, setCustNumInput] = useState(param || '3');
  const [original, setOriginal] = useState<Rec | null>(null);
  const [draft, setDraft] = useState<Rec | null>(null);
  const [locked, setLocked] = useState(false);
  const [message, setMessage] = useState<{ kind: 'error' | 'success'; text: string } | null>(null);
  const [touched, setTouched] = useState(false);
  const [recent, setRecent] = useState<number[]>([]);
  const firstField = useRef<HTMLInputElement>(null);

  // R1 + R2: look up by CustNum.
  const lookup = (raw: string, focus = true) => {
    const n = parseInt(raw, 10);
    const found = db.find((c) => c.custNum === n);
    setTouched(false);
    if (!found) {
      setMessage({ kind: 'error', text: MSG_NOT_FOUND });
      setDraft(null); setOriginal(null); setLocked(false);
      return;
    }
    setMessage(null);
    setOriginal(found);
    setDraft({ ...found });
    setLocked(true); // R5: hold the record while editing
    setRecent((r) => [found.custNum, ...r.filter((x) => x !== found.custNum)].slice(0, 5));
    if (focus) setTimeout(() => firstField.current?.focus(), 0);
  };

  useEffect(() => { lookup(param || '3', false); /* initial load */ }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const errors = useMemo(() => (draft ? validate(draft) : {}), [draft]);
  const hasErrors = Object.keys(errors).length > 0;
  const dirtyKeys = draft && original ? FIELDS.filter((f) => draft[f.key] !== original[f.key]).map((f) => f.key) : [];

  // R4 + R5 + R6: save with version check, then release.
  const save = (e: React.FormEvent) => {
    e.preventDefault();
    if (!draft || !original) return;
    setTouched(true);
    if (hasErrors) return;
    const current = db.find((c) => c.custNum === draft.custNum);
    if (!current || current.version !== original.version) {
      setMessage({ kind: 'error', text: 'This record was changed by someone else. Reload it and try again.' });
      return;
    }
    const saved = { ...draft, version: original.version + 1 };
    setDb(db.map((c) => (c.custNum === saved.custNum ? saved : c)));
    setOriginal(saved);
    setDraft(saved);
    setLocked(false);
    setMessage({ kind: 'success', text: MSG_UPDATED });
  };

  const cancel = () => {
    setDraft(null); setOriginal(null); setLocked(false); setMessage(null);
  };

  const util = draft && draft.creditLimit > 0 ? draft.balance / draft.creditLimit : 0;

  return (
    <ModernizedLayout
      program="customer_maint"
      title="Customer maintenance"
      subtitle="Find a customer by number and update their name, address and phone details."
      crumbs={['Customers', 'Maintenance']}
      legacyScreen={PROGRESS_SCREEN}
    >
      <Card pad>
        <form onSubmit={(e) => { e.preventDefault(); lookup(custNumInput); }} className="row" style={{ alignItems: 'flex-end', flexWrap: 'wrap', gap: 14 }}>
          <Field label="Customer number" htmlFor="custnum" className="" hint="Enter a CustNum, for example 3 or 53.">
            <div className="input-icon" style={{ width: 240 }}>
              <Search size={16} />
              <input id="custnum" className="input mono" inputMode="numeric" value={custNumInput}
                onChange={(e) => setCustNumInput(e.target.value.replace(/[^0-9]/g, ''))} autoComplete="off" />
            </div>
          </Field>
          <button type="submit" className="btn primary" style={{ marginBottom: 26 }}>Look up</button>
          {recent.length > 0 && (
            <div className="row" style={{ gap: 8, marginBottom: 26, flexWrap: 'wrap', marginLeft: 'auto' }}>
              <span className="muted row" style={{ gap: 6, fontSize: 14 }}><History size={15} /> Recent</span>
              {recent.map((n) => (
                <button key={n} type="button" className="btn sm" onClick={() => { setCustNumInput(String(n)); lookup(String(n)); }}>#{n}</button>
              ))}
            </div>
          )}
        </form>

        {message && (
          <div className={`alert ${message.kind}`} role={message.kind === 'error' ? 'alert' : 'status'}>
            {message.kind === 'error' ? <CircleAlert size={18} /> : <CheckCircle2 size={18} />}
            <span>{message.text}</span>
          </div>
        )}
      </Card>

      {draft && (
        <form onSubmit={save} noValidate>
          <Card
            title={
              <span className="row" style={{ gap: 12 }}>
                <span className="avatar-sm" style={{ background: T.color.brandSoft, color: T.color.brand, borderColor: T.color.brandSoftBorder }}>{initials(draft.name || '?')}</span>
                <span>
                  <span style={{ display: 'block' }}>{original?.name}</span>
                  <span className="cell-sub" style={{ fontWeight: 400 }}>{draft.contact} · {draft.country} · Sales rep {draft.salesRep}</span>
                </span>
              </span>
            }
            actions={locked
              ? <Pill tone="brand"><Lock size={13} /> Editing · record held</Pill>
              : <Pill tone="neutral"><LockOpen size={13} /> Lock released</Pill>}
          >
            <div className="form-grid">
              <Field label="Customer number" htmlFor="f-custnum" className="span-2" extra={<Lock size={13} color={T.color.textFaint} aria-label="Read only" />}>
                <input id="f-custnum" className="input mono" value={draft.custNum} readOnly aria-readonly />
              </Field>
              {FIELDS.map((f, i) => {
                const err = touched || dirtyKeys.includes(f.key) ? errors[f.key] : undefined;
                const dirty = dirtyKeys.includes(f.key);
                return (
                  <Field key={f.key} label={f.label} htmlFor={`f-${f.key}`} className={f.span} error={err}
                    hint={dirty ? `${draft[f.key].length} of ${f.max} characters` : undefined}
                    extra={dirty ? <span className="pill brand" style={{ height: 20, fontSize: 11.5, padding: '0 7px' }}>Edited</span> : undefined}>
                    <input
                      id={`f-${f.key}`}
                      ref={i === 0 ? firstField : undefined}
                      className={`input ${err ? 'invalid' : dirty ? 'dirty' : ''}`}
                      value={draft[f.key]}
                      readOnly={!locked}
                      aria-invalid={!!err}
                      onChange={(e) => { setDraft({ ...draft, [f.key]: e.target.value }); if (message?.kind === 'success') setMessage(null); }}
                    />
                  </Field>
                );
              })}
              <div className="span-3 field">
                <label>Credit utilisation</label>
                <div style={{ height: 42, display: 'flex', alignItems: 'center' }}><UtilMeter ratio={util} width={140} /></div>
                <div className="hint">Read only, managed in Credit management</div>
              </div>
            </div>

            {draft.comments && (
              <div className="alert warn" style={{ marginTop: 20 }}>
                <CircleAlert size={18} /><span><b>Account note:</b> {draft.comments}</span>
              </div>
            )}

            <div className="row" style={{ marginTop: 22, paddingTop: 18, borderTop: `1px solid ${T.color.border}`, flexWrap: 'wrap' }}>
              <span className="muted" style={{ fontSize: 14 }}>
                {locked
                  ? dirtyKeys.length ? `${dirtyKeys.length} unsaved change${dirtyKeys.length > 1 ? 's' : ''}` : 'No changes yet'
                  : 'Saved. Look up the customer again to make further edits.'}
                <span className="mono" style={{ marginLeft: 10, fontSize: 12.5, color: T.color.textFaint }}>v{original?.version}</span>
              </span>
              <div className="row" style={{ marginLeft: 'auto', gap: 10 }}>
                {locked ? (
                  <>
                    <button type="button" className="btn" onClick={cancel}>Cancel</button>
                    <button type="submit" className="btn primary" disabled={touched && hasErrors}><Save size={16} /> Save changes</button>
                  </>
                ) : (
                  <button type="button" className="btn" onClick={() => lookup(String(draft.custNum))}><RotateCcw size={16} /> Edit again</button>
                )}
              </div>
            </div>
          </Card>
        </form>
      )}
    </ModernizedLayout>
  );
}
