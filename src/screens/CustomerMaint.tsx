import React, { useState } from 'react';
import { C, PageHeader, BeforeAfter } from '../components/Shell';
import { customers as initial, customerById, type Customer } from '../data/sports';

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

export function CustomerMaint() {
  const [db, setDb] = useState<Customer[]>(initial);
  const [custNumInput, setCustNumInput] = useState('3');
  const [draft, setDraft] = useState<Customer | null>(customerById(3) || null);
  const [saved, setSaved] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = () => {
    const n = parseInt(custNumInput, 10);
    const found = db.find(c => c.custNum === n);
    if (!found) {
      setError(`Customer #${n} not found.`);
      setDraft(null);
      return;
    }
    setError(null);
    setDraft({ ...found });
    setSaved(null);
  };

  const save = (e: React.FormEvent) => {
    e.preventDefault();
    if (!draft) return;
    setDb(db.map(c => c.custNum === draft.custNum ? draft : c));
    setSaved(`Customer #${draft.custNum} updated.`);
    setTimeout(() => setSaved(null), 3000);
  };

  return (
    <div>
      <PageHeader
        title="Customer Maintenance"
        subtitle="Update customer information. Originally a character-based ABL frame; now a responsive form with inline validation and optimistic save."
        source="sports/customer_maint.p"
      />

      <BeforeAfter beforeContent={PROGRESS_SCREEN}>
        <form onSubmit={save}>
          <div style={{
            display: 'flex', gap: 8, marginBottom: 20,
            padding: 12, background: C.card, borderRadius: 8,
          }}>
            <Label text="Customer Number">
              <input
                value={custNumInput}
                onChange={e => setCustNumInput(e.target.value)}
                style={inputStyle}
                type="number"
              />
            </Label>
            <button type="button" onClick={load} style={primaryBtn}>
              Load
            </button>
          </div>

          {error && <div style={errorBox}>{error}</div>}
          {saved && <div style={successBox}>✓ {saved}</div>}

          {draft && (
            <>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
                <Field label="Customer Name"
                  value={draft.name}
                  onChange={v => setDraft({ ...draft, name: v })}
                />
                <Field label="Contact"
                  value={draft.contact}
                  onChange={v => setDraft({ ...draft, contact: v })}
                />
                <Field label="Address Line 1"
                  value={draft.address}
                  onChange={v => setDraft({ ...draft, address: v })}
                  wide
                />
                <Field label="Address Line 2"
                  value={draft.address2}
                  onChange={v => setDraft({ ...draft, address2: v })}
                  wide
                />
                <Field label="City"
                  value={draft.city}
                  onChange={v => setDraft({ ...draft, city: v })}
                />
                <Field label="State / Region"
                  value={draft.state}
                  onChange={v => setDraft({ ...draft, state: v })}
                />
                <Field label="Postal Code"
                  value={draft.postalCode}
                  onChange={v => setDraft({ ...draft, postalCode: v })}
                />
                <Field label="Phone"
                  value={draft.phone}
                  onChange={v => setDraft({ ...draft, phone: v })}
                />
              </div>

              <div style={{ marginTop: 22, display: 'flex', gap: 8, alignItems: 'center', flexWrap: 'wrap' }}>
                <Pill label="Credit Limit" value={`$${draft.creditLimit.toLocaleString()}`} color={C.ind} />
                <Pill label="Balance" value={`$${draft.balance.toFixed(2)}`} color={draft.balance > draft.creditLimit * 0.8 ? C.red : C.green} />
                <Pill label="Terms" value={draft.terms} color={C.t2} />
                <Pill label="Sales Rep" value={draft.salesRep} color={C.t2} />
                <button type="submit" style={{ ...primaryBtn, marginLeft: 'auto' }}>Save Changes</button>
              </div>

              {draft.comments && (
                <div style={{
                  marginTop: 16, padding: '10px 14px',
                  background: '#fef3c7', border: `1px solid ${C.amber}`,
                  borderRadius: 6, fontSize: 13, color: '#92400e',
                }}>
                  <strong>Note:</strong> {draft.comments}
                </div>
              )}
            </>
          )}
        </form>
      </BeforeAfter>

      <DiffNote rows={[
        ['Input method', 'UPDATE frame with F-keys', 'HTML form with tab navigation'],
        ['Validation', 'Post-submit (EXCLUSIVE-LOCK)', 'Inline + optimistic'],
        ['Save', 'Blocking until UPDATE complete', 'Non-blocking, async persistence'],
        ['Error handling', 'MESSAGE ... VIEW-AS ALERT-BOX', 'Inline banner with dismiss'],
      ]} />
    </div>
  );
}

/* ─── Small helpers ─────────────────────────────────────── */

const inputStyle: React.CSSProperties = {
  padding: '8px 12px', borderRadius: 6, border: `1px solid ${C.bdr}`,
  fontSize: 14, fontFamily: C.sans, outline: 'none',
  width: '100%',
};

const primaryBtn: React.CSSProperties = {
  padding: '8px 18px', borderRadius: 6, border: 'none',
  background: C.ind, color: 'white', fontSize: 13, fontWeight: 700,
  cursor: 'pointer', fontFamily: C.sans,
};

const errorBox: React.CSSProperties = {
  padding: '10px 14px', borderRadius: 6, marginBottom: 14,
  background: '#fee2e2', color: '#991b1b', fontSize: 13,
  border: `1px solid #fecaca`,
};
const successBox: React.CSSProperties = {
  padding: '10px 14px', borderRadius: 6, marginBottom: 14,
  background: '#d1fae5', color: '#065f46', fontSize: 13,
  border: `1px solid #86efac`,
};

function Label({ text, children }: { text: string; children: React.ReactNode }) {
  return (
    <label style={{ flex: 1, fontSize: 13 }}>
      <div style={{ fontSize: 10, fontWeight: 700, color: C.t3, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: 4 }}>
        {text}
      </div>
      {children}
    </label>
  );
}

function Field({ label, value, onChange, wide }: { label: string; value: string; onChange: (v: string) => void; wide?: boolean }) {
  return (
    <div style={wide ? { gridColumn: '1 / -1' } : undefined}>
      <Label text={label}>
        <input value={value} onChange={e => onChange(e.target.value)} style={inputStyle} />
      </Label>
    </div>
  );
}

function Pill({ label, value, color }: { label: string; value: string; color: string }) {
  return (
    <div style={{
      padding: '5px 10px', borderRadius: 6,
      background: color + '14', color,
      fontSize: 12, fontFamily: C.mono, fontWeight: 700,
    }}>
      <span style={{ opacity: 0.75, marginRight: 6 }}>{label}:</span>{value}
    </div>
  );
}

function DiffNote({ rows }: { rows: [string, string, string][] }) {
  return (
    <div style={{
      background: 'white', border: `1px solid ${C.bdr}`,
      borderRadius: 12, padding: 20, marginTop: 8,
    }}>
      <div style={{ fontSize: 13, fontWeight: 700, color: C.t1, marginBottom: 12 }}>
        Key UX improvements
      </div>
      <table style={{ width: '100%', fontSize: 13, borderCollapse: 'collapse' }}>
        <thead>
          <tr style={{ color: C.t3 }}>
            <th style={{ textAlign: 'left', padding: '6px 0', fontSize: 10, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 700 }}>Aspect</th>
            <th style={{ textAlign: 'left', padding: '6px 0', fontSize: 10, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 700 }}>Before (ABL)</th>
            <th style={{ textAlign: 'left', padding: '6px 0', fontSize: 10, fontFamily: C.mono, textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 700 }}>After (React)</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => (
            <tr key={i} style={{ borderTop: `1px solid ${C.bdr}` }}>
              <td style={{ padding: '10px 12px 10px 0', fontWeight: 600, color: C.t1 }}>{r[0]}</td>
              <td style={{ padding: '10px 12px', color: C.t2, fontFamily: C.mono, fontSize: 12 }}>{r[1]}</td>
              <td style={{ padding: '10px 0', color: C.green, fontFamily: C.mono, fontSize: 12 }}>{r[2]}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
