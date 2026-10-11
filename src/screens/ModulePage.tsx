import React, { useEffect, useMemo, useState } from 'react';
import {
  CheckCircle2, CircleAlert, Clock3, Database, ExternalLink, FileCode2, GitMerge, GitPullRequest,
  Hourglass, Layers, Lock, RotateCcw, Save, SquareTerminal,
} from 'lucide-react';
import { FEATURED_BY_MODULE, moduleById, type EstateField, type EstateModule, type EstateScreen } from '../data/estate';
import { useLive, type PullInfo } from '../data/live';
import { display, kindOf, maxChars, parse, ruleText, validate, boolOptions } from '../data/formats';
import { Card, DataTable, EmptyState, Field, PageHeader, type Column } from '../components/ui';
import { Terminal, TLine } from '../components/Terminal';
import { CompareSplit, LegacyStage, ModeToggle, useCompareMode } from '../components/Compare';
import { APP_SOURCE_BLOB, LIFECYCLE } from '../data/modernization';
import { CustomerList } from './CustomerList';
import { CustomerMaint } from './CustomerMaint';
import { CustomerOrders } from './CustomerOrders';
import { OrderReport } from './OrderReport';
import { UpdateCredit } from './UpdateCredit';

const fmtInt = (n: number) => n.toLocaleString('en-US');

/* ---------------- status badge ---------------- */

export function StatusBadge({ status, pr, size = 'md' }: { status: 'legacy' | 'merged' | 'pr'; pr?: PullInfo; size?: 'sm' | 'md' }) {
  const short = size === 'sm';
  if (status === 'merged') return <span className={`sbadge merged ${size}`}><GitMerge size={short ? 13 : 15} /> {short ? 'Merged' : 'Modernized · merged'}</span>;
  if (status === 'pr' && pr) {
    return (
      <a className={`sbadge pr ${size}`} href={pr.url} target="_blank" rel="noopener noreferrer" onClick={(e) => e.stopPropagation()}>
        <GitPullRequest size={short ? 13 : 15} /> {short ? `PR #${pr.number} in review` : `Modernized · PR #${pr.number} in review`} <ExternalLink size={12} />
      </a>
    );
  }
  return <span className={`sbadge legacy ${size}`}><Hourglass size={short ? 13 : 15} /> {short ? 'Legacy' : 'Legacy · awaiting modernization'}</span>;
}

/* ---------------- legacy terminal for an estate screen ---------------- */

function legacyLines(s: EstateScreen) {
  const text = s.legacyScreen || `${s.title}\n(no screen captured)`;
  return text.replace(/\r/g, '').split('\n');
}

export function EstateTerminal({ screen, big, rows }: { screen: EstateScreen; big: boolean; rows?: number }) {
  const lines = legacyLines(screen);
  const cols = Math.max(48, ...lines.map((l) => [...l].length)) + 1;
  // Tag lines that show a field so the compare view can trace them.
  const mapFor = (l: string) => {
    const f = screen.fields.find((x) => x.label && l.includes(x.label + ':')) ?? screen.fields.find((x) => x.label && l.includes(x.label));
    return f ? `f-${f.name}` : undefined;
  };
  return (
    <Terminal program={screen.program ?? `${screen.table.toLowerCase()}.p`} cols={cols} rows={rows ?? lines.length}
      maxFont={big ? 21 : 16}>
      {lines.map((l, i) => <TLine key={i} map={mapFor(l)}>{l}</TLine>)}
    </Terminal>
  );
}

/* ---------------- module page ---------------- */

const FEATURED_COMPONENTS: Record<string, (p: { onNavigate: (r: string) => void }) => React.ReactNode> = {
  'customer-list': ({ onNavigate }) => <CustomerList onNavigate={onNavigate} />,
  'customer-maint': () => <CustomerMaint />,
  'customer-orders': ({ onNavigate }) => <CustomerOrders onNavigate={onNavigate} />,
  'order-report': () => <OrderReport />,
  'update-credit': () => <UpdateCredit />,
};

export function ModulePage({ id, tab, onNavigate }: { id: string; tab?: string; onNavigate: (r: string) => void }) {
  const live = useLive();
  const m = moduleById(id);
  if (!m) {
    return <Card><EmptyState title="Module not found." sub="Choose a module from the sidebar." /></Card>;
  }
  const status = live.status(m.id);
  return status === 'legacy'
    ? <LegacyModule m={m} tab={tab} onNavigate={onNavigate} />
    : <ModernModule m={m} tab={tab} onNavigate={onNavigate} />;
}

function ModuleStats({ m }: { m: EstateModule }) {
  const tables = m.tables;
  return (
    <div className="mod-stats">
      <div><FileCode2 size={18} /><b>{fmtInt(m.programs)}</b><span>ABL programs</span></div>
      <div><Layers size={18} /><b>{fmtInt(m.lines)}</b><span>lines of ABL</span></div>
      <div><SquareTerminal size={18} /><b>{m.screens.length}</b><span>character screens</span></div>
      <div><Database size={18} /><b>{tables.length || '–'}</b><span>{tables.length ? tables.slice(0, 3).join(', ') : 'tables'}</span></div>
    </div>
  );
}

function LegacyModule({ m, tab, onNavigate }: { m: EstateModule; tab?: string; onNavigate: (r: string) => void }) {
  const live = useLive();
  const screen = m.screens.find((s) => s.id === tab) ?? m.screens[0];
  const [ago, setAgo] = useState(0);
  useEffect(() => {
    const t = setInterval(() => setAgo(live.checkedAt ? Math.round((Date.now() - live.checkedAt) / 1000) : 0), 1000);
    return () => clearInterval(t);
  }, [live.checkedAt]);
  return (
    <>
      <PageHeader title={m.title} crumbs={['Modules', m.title]} subtitle={m.description || undefined} actions={<StatusBadge status="legacy" />} />
      <ModuleStats m={m} />
      {m.screens.length > 1 && (
        <div className="seg mod-tabs" role="tablist">
          {m.screens.map((s) => (
            <button key={s.id} className={s.id === screen?.id ? 'on' : ''} onClick={() => onNavigate(`m/${m.id}/${s.id}`)}>{s.title}</button>
          ))}
        </div>
      )}
      <div className="legacy-mod">
        <div>
          {screen ? <EstateTerminal screen={screen} big /> : <Card><EmptyState title="No screens captured for this module." /></Card>}
          {screen && <p className="legacy-hint">The original Progress OpenEdge character screen{screen.program ? <> from <code>{screen.program}</code></> : null}, as users see it today.</p>}
        </div>
        <aside className="card legacy-side">
          <div className="ls-head">
            <span className="ls-ic"><Hourglass size={20} /></span>
            <div>
              <div className="ls-t">Awaiting modernization</div>
              <div className="ls-s">{fmtInt(m.programs)} programs · {fmtInt(m.lines)} lines</div>
            </div>
          </div>
          <ol className="steps dim">
            {LIFECYCLE.slice(0, 6).map((s) => (
              <li key={s.t}><span className="ok"><Clock3 size={12} /></span><div><div className="s-t">{s.t}</div><div className="s-d">{s.d}</div></div></li>
            ))}
          </ol>
          {m.programList.length > 0 && (
            <>
              <div className="section-title" style={{ marginTop: 6 }}>Programs in this module · {m.programList.length}</div>
              <ul className="prog-list">
                {m.programList.slice(0, 12).map((p) => (
                  <li key={p.path}>
                    <a href={APP_SOURCE_BLOB + p.path} target="_blank" rel="noopener noreferrer" className="mono">{p.path.split('/').pop()}</a>
                    <span>{p.kind}{p.lines ? ` · ${p.lines} lines` : ''}</span>
                  </li>
                ))}
              </ul>
              {m.programList.length > 12 && <div className="muted" style={{ fontSize: 13 }}>and {m.programList.length - 12} more</div>}
            </>
          )}
          {screen && screen.fields.length > 0 && (
            <>
              <div className="section-title" style={{ marginTop: 6 }}>Fields on this screen</div>
              <div className="chips">{screen.fields.map((f) => <span key={f.name} className="tag">{f.name} <span className="muted">{f.format}</span></span>)}</div>
            </>
          )}
          <div className="ls-watch"><span className="pulse" /> Watching for a FlowPilot pull request{live.checkedAt ? ` · checked ${ago}s ago` : ''}. This page switches to the modern screen automatically.</div>
        </aside>
      </div>
    </>
  );
}

function ModernModule({ m, tab, onNavigate }: { m: EstateModule; tab?: string; onNavigate: (r: string) => void }) {
  const live = useLive();
  const featured = FEATURED_BY_MODULE[m.id] ?? [];
  const tabs = [
    ...featured.map((f) => ({ id: f.route, title: f.title, featured: true })),
    ...m.screens.map((s) => ({ id: s.id, title: s.title, featured: false })),
  ];
  const cur = tabs.find((t) => t.id === tab) ?? tabs[0];
  const screen = m.screens.find((s) => s.id === cur?.id);

  return (
    <>
      <div className="mod-bar">
        <div className="mod-bar-top">
          <div style={{ minWidth: 0 }}>
            <div className="crumbs">Modules</div>
            <div className="mod-bar-title">{m.title}</div>
          </div>
          <StatusBadge status={live.status(m.id)} pr={live.prs[m.id]} />
        </div>
        {tabs.length > 1 && (
          <div className="mod-bar-tabs" role="tablist">
            {tabs.map((t) => (
              <button key={t.id} role="tab" aria-selected={t.id === cur?.id} className={t.id === cur?.id ? 'on' : ''} onClick={() => onNavigate(`m/${m.id}/${t.id}`)}>{t.title}</button>
            ))}
          </div>
        )}
      </div>
      {cur?.featured
        ? <React.Fragment key={cur.id}>{FEATURED_COMPONENTS[cur.id]?.({ onNavigate })}</React.Fragment>
        : screen
          ? <GenericScreen key={screen.id} m={m} screen={screen} />
          : <Card><EmptyState title="No screens in this module." /></Card>}
    </>
  );
}

/* ---------------- generic data-driven screen ---------------- */

type Row = Record<string, unknown>;

function GenericScreen({ m, screen }: { m: EstateModule; screen: EstateScreen }) {
  const [mode, setMode] = useCompareMode();
  const fields = screen.fields.length ? screen.fields : Object.keys(screen.sampleRows[0] ?? {}).map((k) => ({ name: k, label: k, type: 'character', format: '', editable: true }));
  const keyField = fields.find((f) => !f.editable) ?? fields[0];
  const [rows, setRows] = useState<Row[]>(() => screen.sampleRows.map((r) => ({ ...r })));
  const [sel, setSel] = useState(0);
  const current = rows[sel];
  const [draft, setDraft] = useState<Record<string, string>>({});
  const [touched, setTouched] = useState(false);
  const [msg, setMsg] = useState<{ kind: 'error' | 'success'; text: string } | null>(null);

  useEffect(() => {
    if (!current) return;
    const d: Record<string, string> = {};
    fields.forEach((f) => { d[f.name] = display(f, current[f.name]).replace(/,/g, kindOf(f) === 'dec' || kindOf(f) === 'int' ? '' : ','); });
    setDraft(d); setTouched(false);
  }, [sel, rows]); // eslint-disable-line react-hooks/exhaustive-deps

  const errors = useMemo(() => {
    const e: Record<string, string> = {};
    fields.forEach((f) => { if (f.editable) { const x = validate(f, draft[f.name] ?? ''); if (x) e[f.name] = x; } });
    return e;
  }, [draft]); // eslint-disable-line react-hooks/exhaustive-deps
  const dirty = current ? fields.filter((f) => (draft[f.name] ?? '') !== display(f, current[f.name]).replace(/,/g, kindOf(f) === 'dec' || kindOf(f) === 'int' ? '' : ',')) : [];

  const save = (e?: React.FormEvent) => {
    e?.preventDefault();
    setTouched(true);
    if (Object.keys(errors).length) { setMsg(null); return; }
    const next: Row = { ...current };
    fields.forEach((f) => { if (f.editable) next[f.name] = parse(f, draft[f.name] ?? ''); });
    setRows(rows.map((r, i) => (i === sel ? next : r)));
    setMsg({ kind: 'success', text: 'Record updated successfully.' });
  };

  const cols: Column<Row & { __i: number }>[] = fields.slice(0, 6).map((f, i) => ({
    key: f.name,
    header: f.label,
    align: kindOf(f) === 'dec' || kindOf(f) === 'int' ? 'right' : 'left',
    render: (r) => <span className={`${i === 0 ? 'cell-strong' : ''} ${kindOf(f) !== 'text' ? 'num' : ''}`}>{display(f, r[f.name])}</span>,
    sortValue: (r) => (typeof r[f.name] === 'number' ? (r[f.name] as number) : String(r[f.name] ?? '')),
  }));
  const tableRows = rows.map((r, i) => ({ ...r, __i: i }) as Row & { __i: number });

  const modern = (
    <>
      <Card pad={false} title={`${screen.title}`} sub={`${rows.length} ${screen.table || 'record'} record${rows.length === 1 ? '' : 's'} · select one to edit`}>
        <DataTable columns={cols} rows={tableRows} rowKey={(r) => r.__i} selectedKey={sel} onRowClick={(r) => { setSel(r.__i); setMsg(null); }}
          searchText={(r) => fields.map((f) => display(f, r[f.name])).join(' ')} searchPlaceholder={`Search ${screen.table || 'records'}`} pageSize={8} />
      </Card>
      {current ? (
        <form onSubmit={save} noValidate>
          <Card title={<span>{keyField ? `${keyField.label} ${display(keyField, current[keyField.name])}` : 'Record'}</span>} sub={screen.table ? `${screen.table} table` : undefined}>
            <div className="form-grid">
              {fields.map((f) => {
                const k = kindOf(f);
                const err = touched || dirty.includes(f) ? errors[f.name] : undefined;
                const span = k === 'text' && (maxChars(f) ?? 0) > 28 ? 'span-4 c-full' : 'span-2';
                return (
                  <Field key={f.name} label={f.label} htmlFor={`g-${f.name}`} className={span} error={err}
                    hint={f.editable ? ruleText(f) : 'Read only'}
                    extra={!f.editable ? <Lock size={13} aria-label="Read only" /> : dirty.includes(f) ? <span className="pill brand" style={{ height: 20, fontSize: 11.5, padding: '0 7px' }}>Edited</span> : undefined}>
                    {k === 'bool' && f.editable ? (
                      <select id={`g-${f.name}`} data-map={`f-${f.name}`} className="select" value={draft[f.name] ?? ''} onChange={(e) => setDraft({ ...draft, [f.name]: e.target.value })}>
                        {boolOptions(f).map((o) => <option key={o} value={o}>{o}</option>)}
                      </select>
                    ) : (
                      <input id={`g-${f.name}`} data-map={`f-${f.name}`} className={`input ${k !== 'text' ? 'mono' : ''} ${err ? 'invalid' : dirty.includes(f) ? 'dirty' : ''}`}
                        value={draft[f.name] ?? ''} readOnly={!f.editable} aria-invalid={!!err}
                        inputMode={k === 'int' || k === 'dec' ? 'decimal' : undefined}
                        onChange={(e) => { setDraft({ ...draft, [f.name]: e.target.value }); if (msg) setMsg(null); }} />
                    )}
                  </Field>
                );
              })}
            </div>
            {msg && (
              <div className={`alert ${msg.kind}`} role="status" style={{ marginTop: 18 }}>
                {msg.kind === 'success' ? <CheckCircle2 size={18} /> : <CircleAlert size={18} />}<span>{msg.text}</span>
              </div>
            )}
            <div className="row" style={{ marginTop: 20, paddingTop: 16, borderTop: '1px solid var(--color-border)', flexWrap: 'wrap' }}>
              <span className="muted" style={{ fontSize: 14 }}>{dirty.length ? `${dirty.length} unsaved change${dirty.length > 1 ? 's' : ''}` : 'No changes yet'}</span>
              <div className="row" style={{ marginLeft: 'auto', gap: 10 }}>
                <button type="button" className="btn" disabled={!dirty.length} onClick={() => setRows([...rows])}><RotateCcw size={16} /> Reset</button>
                <button type="submit" className="btn primary" data-map="fkey-F1"><Save size={16} /> Save changes</button>
              </div>
            </div>
          </Card>
        </form>
      ) : (
        <Card><EmptyState title="No sample records for this screen." /></Card>
      )}
    </>
  );

  const describe = (k: string) => {
    const f = fields.find((x) => `f-${x.name}` === k);
    if (f) return { legacy: `${screen.table ? screen.table + '.' : ''}${f.name}  FORMAT "${f.format}"`, modern: `<Field label="${f.label}"> · ${ruleText(f)}`, note: f.editable ? 'UPDATE field becomes a validated input.' : 'DISPLAY-only field becomes read only.' };
    if (k === 'fkey-F1') return { legacy: 'F1 = GO', modern: '<button type="submit">Save changes</button>' };
    return undefined;
  };

  return (
    <>
      <div className="compare-bar">
        <ModeToggle mode={mode} onChange={setMode} />
        <div className="compare-meta">
          <span className="cm-src"><FileCode2 size={15} /> <span className="mono">{screen.program ?? m.id}</span></span>
          <span className="cm-dot" /><span>{fields.length} fields</span>
          <span className="cm-dot" /><span>{rows.length} sample records</span>
        </div>
      </div>
      {mode === 'split' ? (
        <CompareSplit legacy={<EstateTerminal screen={screen} big={false} />} describe={describe} source={screen.program ?? ''} legacyLabel={screen.program}>
          {modern}
        </CompareSplit>
      ) : mode === 'legacy' ? (
        <LegacyStage hint="The original character screen this module replaced.">
          <EstateTerminal screen={screen} big />
        </LegacyStage>
      ) : <div className="stack">{modern}</div>}
    </>
  );
}

/* ---------------- legacy wrapper for a hand-built route whose module is not modernized ---------------- */

export function LegacyGate({ moduleId, onNavigate }: { moduleId: string; onNavigate: (r: string) => void }) {
  const m = moduleById(moduleId);
  if (!m) return null;
  return <LegacyModule m={m} onNavigate={onNavigate} />;
}

