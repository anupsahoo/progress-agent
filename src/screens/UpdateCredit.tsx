import React, { useMemo, useState } from 'react';
import { CheckCircle2, RotateCcw, ShieldCheck, TrendingUp } from 'lucide-react';
import { customers as initial, utilisation, type Customer } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, EmptyState, Kpi, Modal, Pill, UtilMeter } from '../components/ui';
import { T, fmtMoney } from '../theme';

/** Legacy defaults from sample-update-credit.p */
const DEFAULT_THRESHOLD = 0.8;
const DEFAULT_INCREASE = 1.2;

interface Change { custNum: number; name: string; balance: number; oldLimit: number; newLimit: number }

const ablNum = (n: number) => n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

/** R1: Balance > CreditLimit * threshold AND CreditLimit > 0 */
const isCandidate = (c: Customer, threshold: number) => c.creditLimit > 0 && c.balance > c.creditLimit * threshold;

function legacyScreen() {
  const rows = initial.filter((c) => isCandidate(c, DEFAULT_THRESHOLD));
  const lines = rows.map((c) => `${String(c.custNum).padStart(5)} ${c.name.slice(0, 20).padEnd(20)} ${ablNum(c.balance).padStart(11)} ${ablNum(c.creditLimit).padStart(11)} ${ablNum(c.creditLimit * DEFAULT_INCREASE).padStart(11)}`);
  return [
    '┌──────────────────── Credit Limit Updates ────────────────────┐',
    '│Cust# Name                     Balance   Old Limit   New Limit│',
    '│───── ──────────────────── ─────────── ─────────── ───────────│',
    ...lines.map((l) => `│${l.padEnd(62)}│`),
    '└──────────────────────────────────────────────────────────────┘',
    '',
    '            ┌─ Information ────────────────┐',
    `            │ ${`${rows.length} customer(s) updated.`.padEnd(29)}│`,
    '            │            [ OK ]            │',
    '            └──────────────────────────────┘',
  ].join('\n');
}
const SCREEN = legacyScreen();

export function UpdateCredit() {
  const [db, setDb] = useState<Customer[]>(initial);
  const [threshold, setThreshold] = useState(DEFAULT_THRESHOLD);
  const [increase, setIncrease] = useState(DEFAULT_INCREASE);
  const [excluded, setExcluded] = useState<Set<number>>(new Set());
  const [confirm, setConfirm] = useState(false);
  const [runs, setRuns] = useState<{ at: string; changes: Change[] }[]>([]);

  const candidates = useMemo(
    () => db.filter((c) => isCandidate(c, threshold)).sort((a, b) => utilisation(b) - utilisation(a)),
    [db, threshold],
  );
  const selected = candidates.filter((c) => !excluded.has(c.custNum));
  const added = selected.reduce((s, c) => s + c.creditLimit * increase - c.creditLimit, 0);
  const exposure = candidates.reduce((s, c) => s + c.balance, 0);
  const isDefault = threshold === DEFAULT_THRESHOLD && increase === DEFAULT_INCREASE;

  const toggle = (n: number) => setExcluded((s) => { const x = new Set(s); x.has(n) ? x.delete(n) : x.add(n); return x; });

  // R2 to R5: apply as one unit of work and record the change list.
  const apply = () => {
    const changes: Change[] = selected.map((c) => ({ custNum: c.custNum, name: c.name, balance: c.balance, oldLimit: c.creditLimit, newLimit: c.creditLimit * increase }));
    const byId = new Map(changes.map((ch) => [ch.custNum, ch.newLimit]));
    setDb(db.map((c) => (byId.has(c.custNum) ? { ...c, creditLimit: byId.get(c.custNum)! } : c)));
    setRuns([{ at: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }), changes }, ...runs]);
    setExcluded(new Set());
    setConfirm(false);
  };

  return (
    <ModernizedLayout
      program="update_credit"
      title="Credit management"
      subtitle="Raise limits for customers close to their credit limit. Preview the changes, then apply them in one step."
      crumbs={['Finance', 'Credit management']}
      legacyScreen={SCREEN}
    >
      <div className="grid-kpi" style={{ gridTemplateColumns: 'repeat(3, minmax(0, 1fr))' }}>
        <Kpi label="Over threshold" value={candidates.length} tone={candidates.length ? 'danger' : 'success'} icon={<TrendingUp size={18} />} foot={`Balance above ${Math.round(threshold * 100)}% of limit`} />
        <Kpi label="Balance at risk" value={fmtMoney(exposure)} tone="warning" foot="Owed by those customers" />
        <Kpi label="Additional credit" value={`+${fmtMoney(added)}`} tone="brand" icon={<ShieldCheck size={18} />} foot={`${selected.length} selected for update`} />
      </div>

      <Card title="Rule parameters" sub="Defaults come from the original program: balance over 80% of limit, limit raised by 20%."
        actions={isDefault ? <Pill tone="success" dot>Legacy defaults</Pill> : <button className="btn sm" onClick={() => { setThreshold(DEFAULT_THRESHOLD); setIncrease(DEFAULT_INCREASE); }}><RotateCcw size={14} /> Reset to defaults</button>}>
        <div className="grid-2">
          <Slider label="Threshold" value={threshold} min={0.5} max={0.95} step={0.05} onChange={setThreshold}
            display={`Balance > ${Math.round(threshold * 100)}% of limit`} />
          <Slider label="Increase" value={increase} min={1.05} max={1.5} step={0.05} onChange={setIncrease}
            display={`New limit = old x ${increase.toFixed(2)}`} />
        </div>
      </Card>

      <Card pad={false} title="Proposed changes" sub="Clear a row to leave that customer unchanged."
        actions={<button className="btn primary" disabled={selected.length === 0} onClick={() => setConfirm(true)}>Apply to {selected.length} customer{selected.length === 1 ? '' : 's'}</button>}>
        {candidates.length === 0 ? (
          <EmptyState title="No customers are over the threshold." sub="Lower the threshold to preview more customers." icon={<CheckCircle2 size={28} color={T.color.success} />} />
        ) : (
          <div className="table-wrap">
            <table className="table">
              <thead>
                <tr>
                  <th style={{ width: 48 }}>
                    <input type="checkbox" aria-label="Select all" checked={selected.length === candidates.length}
                      onChange={(e) => setExcluded(e.target.checked ? new Set() : new Set(candidates.map((c) => c.custNum)))} />
                  </th>
                  <th>Customer</th><th style={{ textAlign: 'right' }}>Balance</th><th>Utilisation</th>
                  <th style={{ textAlign: 'right' }}>Old limit</th><th style={{ textAlign: 'right' }}>New limit</th>
                </tr>
              </thead>
              <tbody>
                {candidates.map((c) => {
                  const on = !excluded.has(c.custNum);
                  return (
                    <tr key={c.custNum} className={`clickable ${on ? '' : ''}`} onClick={() => toggle(c.custNum)} style={{ opacity: on ? 1 : 0.55 }}>
                      <td><input type="checkbox" checked={on} onChange={() => toggle(c.custNum)} onClick={(e) => e.stopPropagation()} aria-label={`Include ${c.name}`} /></td>
                      <td><div className="cell-strong">{c.name}</div><div className="cell-sub mono">#{c.custNum}</div></td>
                      <td className="num right">{fmtMoney(c.balance)}</td>
                      <td><UtilMeter ratio={utilisation(c)} width={80} /></td>
                      <td className="num right muted">{fmtMoney(c.creditLimit)}</td>
                      <td className="num right cell-strong" style={{ color: on ? T.color.success : undefined }}>{fmtMoney(c.creditLimit * increase)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      <Card pad={false} title="Change log" sub="Each run records customer, balance, old limit and new limit.">
        {runs.length === 0 ? (
          <EmptyState title="No adjustments applied in this session." />
        ) : runs.map((r, i) => (
          <div key={i} style={{ borderTop: i ? `1px solid ${T.color.border}` : 0 }}>
            <div className="alert success" style={{ margin: 16 }}>
              <CheckCircle2 size={18} /><span><b>{r.changes.length} customer(s) updated.</b> <span className="muted">Applied at {r.at}</span></span>
            </div>
            <div className="table-wrap">
              <table className="table">
                <thead><tr><th>Cust #</th><th>Name</th><th style={{ textAlign: 'right' }}>Balance</th><th style={{ textAlign: 'right' }}>Old limit</th><th style={{ textAlign: 'right' }}>New limit</th></tr></thead>
                <tbody>
                  {r.changes.map((c) => (
                    <tr key={c.custNum}>
                      <td className="mono">{c.custNum}</td><td className="cell-strong">{c.name}</td>
                      <td className="num right">{fmtMoney(c.balance)}</td><td className="num right muted">{fmtMoney(c.oldLimit)}</td>
                      <td className="num right cell-strong" style={{ color: T.color.success }}>{fmtMoney(c.newLimit)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        ))}
      </Card>

      <Modal open={confirm} onClose={() => setConfirm(false)} title="Apply credit limit changes?">
        <p style={{ marginTop: 0 }}>
          {selected.length} customer{selected.length === 1 ? '' : 's'} will have their credit limit raised by {Math.round((increase - 1) * 100)}%,
          adding <b className="num">{fmtMoney(added)}</b> of credit in total. All changes are applied together.
        </p>
        <ul style={{ paddingLeft: 20, margin: '0 0 20px', color: T.color.textSecondary }}>
          {selected.map((c) => <li key={c.custNum}>{c.name}: {fmtMoney(c.creditLimit)} to <b>{fmtMoney(c.creditLimit * increase)}</b></li>)}
        </ul>
        <div className="row" style={{ justifyContent: 'flex-end', gap: 10 }}>
          <button className="btn" onClick={() => setConfirm(false)}>Cancel</button>
          <button className="btn primary" onClick={apply}>Apply changes</button>
        </div>
      </Modal>
    </ModernizedLayout>
  );
}

function Slider({ label, value, min, max, step, onChange, display }: { label: string; value: number; min: number; max: number; step: number; onChange: (v: number) => void; display: string }) {
  return (
    <div className="field">
      <label style={{ justifyContent: 'space-between' }}>{label}<span className="num" style={{ color: T.color.text }}>{display}</span></label>
      <input className="range" type="range" min={min} max={max} step={step} value={value}
        onChange={(e) => onChange(Math.round(parseFloat(e.target.value) * 100) / 100)} aria-label={label} />
    </div>
  );
}
