import React, { useMemo, useState } from 'react';
import { CheckCircle2, RotateCcw, ShieldCheck, TrendingUp } from 'lucide-react';
import { customers as initial, utilisation, type Customer } from '../data/sports';
import { ModernizedLayout } from '../components/ModernizationPanel';
import { Card, EmptyState, Kpi, Modal, Pill, UtilMeter } from '../components/ui';
import { T, fmtMoney } from '../theme';
import { Terminal, TFrame, TLine, TT } from '../components/Terminal';
import type { MapInfo } from '../components/Compare';

function describeCredit(key: string): MapInfo | undefined {
  if (key.startsWith('cc-')) return { legacy: 'FOR EACH Customer EXCLUSIVE-LOCK WHERE Balance > CreditLimit * dThreshold AND CreditLimit > 0', modern: '<tr> in Proposed changes, with a checkbox to leave it out', note: 'The legacy run updates every match at once; the modern screen previews first.', lines: [21, 38] };
  if (key.startsWith('log-')) return { legacy: 'CREATE ttCreditChange. ASSIGN ... / DISPLAY ttCreditChange WITH DOWN TITLE "Credit Limit Updates"', modern: '<tr> in the Change log', lines: [28, 50] };
  switch (key) {
    case 'threshold': return { legacy: 'DEFINE VARIABLE dThreshold AS DECIMAL NO-UNDO INITIAL 0.8.', modern: '<input type="range"> Threshold, default 80%', note: 'A hard-coded constant becomes an adjustable rule parameter.', lines: [11, 11] };
    case 'increase': return { legacy: 'DEFINE VARIABLE dIncrease AS DECIMAL NO-UNDO INITIAL 1.2.', modern: '<input type="range"> Increase, default x1.20', lines: [12, 12] };
    case 'f-changes': return { legacy: 'DISPLAY ... WITH DOWN WIDTH 90 TITLE "Credit Limit Updates"', modern: '<Card title="Proposed changes"> table', lines: [42, 50] };
    case 'msg': return { legacy: 'MESSAGE iUpdated "customer(s) updated." VIEW-AS ALERT-BOX INFORMATION.', modern: '<div className="alert success">n customer(s) updated.</div>', note: 'Same text, verbatim.', lines: [52, 53] };
    case 'fkey-F1': return { legacy: 'RUN sample-update-credit.p  (applies immediately)', modern: '<button>Apply to n customers</button> + confirmation', note: 'One unit of work in both; the modern screen asks before committing.', lines: [21, 39] };
  }
  return undefined;
}

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
  const [ack, setAck] = useState(0);

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

  const showRun = runs.length > 0 && ack < runs.length;
  const legacy = ({ big }: { big: boolean }) => {
    const W = 64;
    const list: { custNum: number; name: string; balance: number; oldLimit: number; newLimit: number }[] = showRun
      ? runs[0].changes
      : selected.map((c) => ({ custNum: c.custNum, name: c.name, balance: c.balance, oldLimit: c.creditLimit, newLimit: c.creditLimit * increase }));
    return (
      <Terminal program="sports/sample-update-credit.p" cols={W} rows={17} maxFont={big ? 22 : 17}
        status={showRun ? `${runs[0].changes.length} record(s) committed.` : 'Press F1 to RUN the update. Records are locked EXCLUSIVE-LOCK.'}
        fkeys={[{ k: 'F1', label: 'RUN', onClick: selected.length ? apply : undefined }, { k: 'F2', label: 'HELP' }, { k: 'F4', label: 'END-ERROR' }]}
        alert={showRun ? { kind: 'info', text: `${runs[0].changes.length} customer(s) updated.`, map: 'msg', onOk: () => setAck(runs.length) } : null}>
        <TLine><TT dim>{'DEFINE VARIABLE '}</TT><span data-map="threshold"><TT bright>{`dThreshold = ${threshold.toFixed(2)}`}</TT></span><TT dim>{'   '}</TT><span data-map="increase"><TT bright>{`dIncrease = ${increase.toFixed(2)}`}</TT></span></TLine>
        <TLine><TT dim>{showRun ? `-- run at ${runs[0].at}` : '-- preview: rows the FOR EACH ... EXCLUSIVE-LOCK will update'}</TT></TLine>
        <TFrame title="Credit Limit Updates" width={W} map="f-changes" lines={[
          <span className="tb">{'Cust# Name                     Balance   Old Limit   New Limit'}</span>,
          <span className="td">{'───── ──────────────────── ─────────── ─────────── ───────────'}</span>,
          ...(list.length === 0 ? ['', '  (no customers over the threshold)'] : list.map((c) => (
            <span data-map={`${showRun ? 'log' : 'cc'}-${c.custNum}`}>
              {`${String(c.custNum).padStart(5)} ${c.name.slice(0, 20).padEnd(20)} ${ablNum(c.balance).padStart(11)} ${ablNum(c.oldLimit).padStart(11)} ${ablNum(c.newLimit).padStart(11)}`}
            </span>
          ))),
        ]} />
      </Terminal>
    );
  };

  return (
    <ModernizedLayout
      program="update_credit"
      title="Credit management"
      subtitle="Raise limits for customers close to their credit limit. Preview the changes, then apply them in one step."
      crumbs={['Finance', 'Credit management']}
      legacyScreen={SCREEN}
      compare={{ legacy, describe: describeCredit }}
    >
      <div className="grid-kpi" style={{ gridTemplateColumns: 'repeat(3, minmax(0, 1fr))' }}>
        <Kpi label="Over threshold" value={candidates.length} tone={candidates.length ? 'danger' : 'success'} icon={<TrendingUp size={18} />} foot={`Balance above ${Math.round(threshold * 100)}% of limit`} />
        <Kpi label="Balance at risk" value={fmtMoney(exposure)} tone="warning" foot="Owed by those customers" />
        <Kpi label="Additional credit" value={`+${fmtMoney(added)}`} tone="brand" icon={<ShieldCheck size={18} />} foot={`${selected.length} selected for update`} />
      </div>

      <Card title="Rule parameters" sub="Defaults come from the original program: balance over 80% of limit, limit raised by 20%."
        actions={isDefault ? <Pill tone="success" dot>Legacy defaults</Pill> : <button className="btn sm" onClick={() => { setThreshold(DEFAULT_THRESHOLD); setIncrease(DEFAULT_INCREASE); }}><RotateCcw size={14} /> Reset to defaults</button>}>
        <div className="grid-2">
          <Slider map="threshold" label="Threshold" value={threshold} min={0.5} max={0.95} step={0.05} onChange={setThreshold}
            display={`Balance > ${Math.round(threshold * 100)}% of limit`} />
          <Slider map="increase" label="Increase" value={increase} min={1.05} max={1.5} step={0.05} onChange={setIncrease}
            display={`New limit = old x ${increase.toFixed(2)}`} />
        </div>
      </Card>

      <Card pad={false} title={<span data-map="f-changes">Proposed changes</span>} sub="Clear a row to leave that customer unchanged."
        actions={<button className="btn primary" data-map="fkey-F1" disabled={selected.length === 0} onClick={() => setConfirm(true)}>Apply to {selected.length} customer{selected.length === 1 ? '' : 's'}</button>}>
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
                  <th>Customer</th><th style={{ textAlign: 'right' }}>Balance</th><th className="c-hide">Utilisation</th>
                  <th style={{ textAlign: 'right' }}>Old limit</th><th style={{ textAlign: 'right' }}>New limit</th>
                </tr>
              </thead>
              <tbody>
                {candidates.map((c) => {
                  const on = !excluded.has(c.custNum);
                  return (
                    <tr key={c.custNum} data-map={`cc-${c.custNum}`} className="clickable" onClick={() => toggle(c.custNum)} style={{ opacity: on ? 1 : 0.55 }}>
                      <td><input type="checkbox" checked={on} onChange={() => toggle(c.custNum)} onClick={(e) => e.stopPropagation()} aria-label={`Include ${c.name}`} /></td>
                      <td><div className="cell-strong">{c.name}</div><div className="cell-sub mono">#{c.custNum}</div></td>
                      <td className="num right">{fmtMoney(c.balance)}</td>
                      <td className="c-hide"><UtilMeter ratio={utilisation(c)} width={80} /></td>
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
            <div className="alert success" data-map={i === 0 ? 'msg' : undefined} style={{ margin: 16 }}>
              <CheckCircle2 size={18} /><span><b>{r.changes.length} customer(s) updated.</b> <span className="muted">Applied at {r.at}</span></span>
            </div>
            <div className="table-wrap">
              <table className="table">
                <thead><tr><th>Cust #</th><th>Name</th><th style={{ textAlign: 'right' }}>Balance</th><th style={{ textAlign: 'right' }}>Old limit</th><th style={{ textAlign: 'right' }}>New limit</th></tr></thead>
                <tbody>
                  {r.changes.map((c) => (
                    <tr key={c.custNum} data-map={i === 0 ? `log-${c.custNum}` : undefined}>
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

function Slider({ label, value, min, max, step, onChange, display, map }: { map?: string; label: string; value: number; min: number; max: number; step: number; onChange: (v: number) => void; display: string }) {
  return (
    <div className="field" data-map={map}>
      <label style={{ justifyContent: 'space-between' }}>{label}<span className="num" style={{ color: T.color.text }}>{display}</span></label>
      <input className="range" type="range" min={min} max={max} step={step} value={value}
        onChange={(e) => onChange(Math.round(parseFloat(e.target.value) * 100) / 100)} aria-label={label} />
    </div>
  );
}
