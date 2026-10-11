import React, { useMemo, useState } from 'react';
import { ArrowRight, Columns2, ExternalLink, FileCode2, Search, X } from 'lucide-react';
import { PageHeader, EmptyState } from '../components/ui';
import { ablSourceUrl, APP_SOURCE_BLOB, PROGRAMS, type ProgramId } from '../data/modernization';
import customerMaintSrc from '../data/abl/customer_maint.p?raw';
import custOrdersSrc from '../data/abl/cust_orders.p?raw';
import orderReportSrc from '../data/abl/sample-order-report.p?raw';
import updateCreditSrc from '../data/abl/sample-update-credit.p?raw';

/**
 * ABL to modern stack reference: the translation layer FlowPilot applies
 * when it reads a .p program, plus the concrete line-by-line mapping for
 * each Sports2000 program that was modernized.
 */

interface Mapping {
  category: string;
  abl: string;
  ablDescription: string;
  modern: string;
  modernDescription: string;
  notes?: string;
}

const MAPPINGS: Mapping[] = [
  // Data access
  {
    category: 'Data Access',
    abl: 'FOR EACH Customer NO-LOCK',
    ablDescription: 'Iterate over a table without locking',
    modern: "useEffect(() => { fetch('/api/customers').then(r => r.json()).then(setCustomers); }, []);",
    modernDescription: 'React useEffect + fetch, async and non-blocking',
  },
  {
    category: 'Data Access',
    abl: 'FIND FIRST Customer WHERE Customer.CustNum = id NO-LOCK NO-ERROR',
    ablDescription: 'Lookup by primary key',
    modern: "GET /api/customers/{id}\nresponse: 200 OK | 404 Not Found",
    modernDescription: 'REST endpoint with idempotent semantics',
  },
  {
    category: 'Data Access',
    abl: 'CREATE Customer.\nASSIGN Customer.Name = ...',
    ablDescription: 'Insert a new record',
    modern: "POST /api/customers\nbody: { name, address, ... }\nresponse: 201 Created",
    modernDescription: 'POST with Pydantic validation, returns created ID',
  },

  // Locking & concurrency
  {
    category: 'Locking',
    abl: 'EXCLUSIVE-LOCK',
    ablDescription: 'Block other users until UPDATE commits',
    modern: 'Optimistic locking with ETag / If-Match header',
    modernDescription: 'API returns 412 Precondition Failed if record changed since read',
    notes: 'Removes lock-wait timeouts, a common source of production incidents in ABL systems.',
  },
  {
    category: 'Locking',
    abl: 'FIND ... EXCLUSIVE-LOCK NO-WAIT',
    ablDescription: 'Try-lock, fail fast',
    modern: 'Database-level row lock or Redis distributed lock',
    modernDescription: 'PostgreSQL SELECT ... FOR UPDATE NOWAIT',
  },
  {
    category: 'Locking',
    abl: 'TRANSACTION:\n  ...\n  RELEASE Customer.\nEND.',
    ablDescription: 'Begin/commit transaction with explicit release',
    modern: 'async with session.begin():',
    modernDescription: 'SQLAlchemy AsyncSession context manager',
  },

  // UI
  {
    category: 'UI',
    abl: 'DEFINE FRAME fMain ...',
    ablDescription: 'Character-based form layout',
    modern: 'React functional component with form state',
    modernDescription: 'useState for each field, controlled inputs, inline validation',
  },
  {
    category: 'UI',
    abl: 'DISPLAY Customer.Name COLON 15 WITH FRAME fMain.',
    ablDescription: 'Render a field on screen',
    modern: '<input value={name} onChange={(e) => setName(e.target.value)} />',
    modernDescription: 'Controlled HTML input',
  },
  {
    category: 'UI',
    abl: 'UPDATE Customer.Name Customer.Address WITH FRAME fMain.',
    ablDescription: 'Read user input then commit',
    modern: '<form onSubmit={save}>...</form>',
    modernDescription: 'HTML form with onSubmit handler calling fetch(PUT)',
  },
  {
    category: 'UI',
    abl: 'MESSAGE "..." VIEW-AS ALERT-BOX.',
    ablDescription: 'Modal alert',
    modern: 'Toast notification or inline error banner',
    modernDescription: 'Non-blocking, dismissable, accessible',
  },

  // Reports
  {
    category: 'Reports',
    abl: 'OUTPUT TO PRINTER.\nFOR EACH Customer NO-LOCK BREAK BY State:\n  DISPLAY ...',
    ablDescription: 'Print a grouped report',
    modern: 'React table with group-by + Print to PDF',
    modernDescription: 'window.print() with CSS @page rules, printable and downloadable',
  },
  {
    category: 'Reports',
    abl: 'ACCUMULATE Customer.Balance (TOTAL).',
    ablDescription: 'Running totals',
    modern: 'reduce() in JavaScript or SQL aggregate functions',
    modernDescription: 'array.reduce((sum, c) => sum + c.balance, 0)',
  },

  // Programs / control flow
  {
    category: 'Programs',
    abl: 'RUN myproc.p (INPUT iCust, OUTPUT cName).',
    ablDescription: 'Call a sub-program with parameters',
    modern: 'function call or imported module',
    modernDescription: 'import { getCustomer } from "./customers"; const name = await getCustomer(id);',
  },
  {
    category: 'Programs',
    abl: 'INCLUDE common-defs.i',
    ablDescription: 'Include file with shared definitions',
    modern: 'TypeScript types/interfaces in shared module',
    modernDescription: 'export type Customer = { ... }, imported wherever needed',
  },
  {
    category: 'Programs',
    abl: 'REPEAT:\n  ...\n  IF cond THEN LEAVE.\nEND.',
    ablDescription: 'Loop with break',
    modern: 'while (true) { ... if (cond) break; }',
    modernDescription: 'Standard JS/TS loop control',
  },

  // Schema
  {
    category: 'Schema',
    abl: 'DEFINE TEMP-TABLE ttFoo ...',
    ablDescription: 'In-memory temp table',
    modern: 'Local TypeScript array or React state',
    modernDescription: 'const [rows, setRows] = useState<Row[]>([]);',
  },
  {
    category: 'Schema',
    abl: '.df file (database schema)',
    ablDescription: 'Schema definition for tables, fields, indexes',
    modern: 'SQLAlchemy models or Prisma schema',
    modernDescription: 'class Customer(Base): __tablename__ = "customer" ...',
  },

  // Errors
  {
    category: 'Errors',
    abl: 'ERROR-STATUS:ERROR / ERROR-STATUS:GET-MESSAGE(1)',
    ablDescription: 'Read last operation error',
    modern: 'try { ... } catch (err) { ... }',
    modernDescription: 'Structured exception handling',
  },
  {
    category: 'Errors',
    abl: 'NO-ERROR (suffix)',
    ablDescription: 'Suppress errors, check ERROR-STATUS',
    modern: 'Result<T, E> pattern or try/catch',
    modernDescription: 'Explicit error shape in TypeScript',
  },
];


type ProgKey = 'customer_maint' | 'cust_orders' | 'order_report' | 'update_credit';

const SOURCES: Record<ProgKey, { src: string; program: ProgramId; screen: string; route: string }> = {
  customer_maint: { src: customerMaintSrc, program: 'customer_maint', screen: 'src/screens/CustomerMaint.tsx', route: 'customer-maint' },
  cust_orders: { src: custOrdersSrc, program: 'cust_orders', screen: 'src/screens/CustomerOrders.tsx', route: 'customer-orders' },
  order_report: { src: orderReportSrc, program: 'order_report', screen: 'src/screens/OrderReport.tsx', route: 'order-report' },
  update_credit: { src: updateCreditSrc, program: 'update_credit', screen: 'src/screens/UpdateCredit.tsx', route: 'update-credit' },
};

interface ProgMap { prog: ProgKey; category: string; lines: [number, number]; title: string; modern: string; modernDescription: string }

const PROGRAM_MAPS: ProgMap[] = [
  // customer_maint.p
  { prog: 'customer_maint', category: 'UI', lines: [6, 6], title: 'Prompt variable', modern: "const [custNumInput, setCustNumInput] = useState('3');", modernDescription: 'Search box state, labelled "Customer number", digits only.' },
  { prog: 'customer_maint', category: 'UI', lines: [9, 17], title: 'Frame layout', modern: '<Card>\n  <div className="form-grid">\n    {FIELDS.map((f) => <Field label={f.label} ... />)}\n  </div>\n</Card>', modernDescription: 'SIDE-LABELS COLON 15 becomes a responsive labelled form grid.' },
  { prog: 'customer_maint', category: 'Programs', lines: [19, 21], title: 'Repeat and prompt', modern: '<form onSubmit={() => lookup(custNumInput)}>\n  <input id="custnum" ... />\n  <button type="submit">Look up</button>\n</form>', modernDescription: 'The REPEAT loop becomes a search form you can submit again, with recent lookups.' },
  { prog: 'customer_maint', category: 'Locking', lines: [24, 26], title: 'Find with exclusive lock', modern: 'const found = db.find((c) => c.custNum === n);\nsetOriginal(found);   // version captured\nsetLocked(true);      // record held for editing', modernDescription: 'EXCLUSIVE-LOCK becomes an optimistic version check: no lock is held while a user types.' },
  { prog: 'customer_maint', category: 'UI', lines: [34, 41], title: 'Display and update fields', modern: '<input value={draft.name}\n  onChange={(e) => edit(\'name\', e.target.value)} />\n// validate(): x(30) -> max 30 characters', modernDescription: 'Each UPDATE field becomes a controlled input; FORMAT widths become validation rules.' },
  { prog: 'customer_maint', category: 'UI', lines: [44, 44], title: 'Success message', modern: "setMessage({ kind: 'success', text: 'Record updated successfully.' });", modernDescription: 'Same text, verbatim, as an inline status alert instead of a modal box.' },
  { prog: 'customer_maint', category: 'Errors', lines: [28, 48], title: 'Not found branch', modern: "if (!found) {\n  setMessage({ kind: 'error', text: 'Customer not found.' });\n  return;\n}", modernDescription: 'IF AVAILABLE / ELSE MESSAGE becomes an early return with an accessible error alert.' },
  { prog: 'customer_maint', category: 'Locking', lines: [50, 50], title: 'Release the lock', modern: 'const saved = { ...draft, version: original.version + 1 };\nsetLocked(false);', modernDescription: 'RELEASE becomes a version bump; a stale save is rejected rather than blocked.' },
  // cust_orders.p
  { prog: 'cust_orders', category: 'UI', lines: [4, 8], title: 'Customer frame', modern: '<Card title={<>{customer.name} · #{customer.custNum} · {customer.city}</>}>', modernDescription: 'The "Customer Info" frame becomes the card header.' },
  { prog: 'cust_orders', category: 'UI', lines: [11, 16], title: 'Orders frame, 10 DOWN', modern: "<DataTable columns={[\n  'Order #', 'Date', 'Shipped', 'Status', 'Total',\n]} pageSize={10} />", modernDescription: 'A fixed 10-row DOWN frame becomes a sortable, paged table with totals.' },
  { prog: 'cust_orders', category: 'Data Access', lines: [21, 22], title: 'Read without locking', modern: 'const customer = customerById(n);\n// GET /api/customers/{n}  ->  200 | 404', modernDescription: 'NO-LOCK read becomes a plain GET; nothing is held.' },
  { prog: 'cust_orders', category: 'UI', lines: [27, 28], title: 'Clear the frame', modern: 'setCustNum(n); // rows are replaced, not appended', modernDescription: 'CLEAR FRAME ALL is implicit: React re-renders from new state.' },
  { prog: 'cust_orders', category: 'Data Access', lines: [30, 39], title: 'Iterate related orders', modern: 'const custOrders = ordersByCustomer(custNum);\n<DataTable rows={custOrders} onRowClick={setOpenOrder} />', modernDescription: 'FOR EACH ... DOWN WITH FRAME becomes a filtered array bound to a table.' },
  { prog: 'cust_orders', category: 'Errors', lines: [41, 42], title: 'Not found', modern: '{notFound && <div role="alert">Customer not found.</div>}', modernDescription: 'Same message, verbatim.' },
  // sample-order-report.p
  { prog: 'order_report', category: 'Programs', lines: [7, 7], title: 'Input parameter', modern: '// #order-report/:custNum\nexport function OrderReport({ param }: { param?: string })', modernDescription: 'The INPUT PARAMETER becomes a route parameter and an input on the page.' },
  { prog: 'order_report', category: 'Errors', lines: [12, 18], title: 'Missing customer', modern: '{!customer && <div role="alert">Customer {custNum} not found.</div>}', modernDescription: 'FIND ... NO-ERROR plus RETURN becomes a guarded render.' },
  { prog: 'order_report', category: 'Reports', lines: [22, 30], title: 'Orders, newest first', modern: '[...ordersByCustomer(custNum)]\n  .sort((a, b) => b.orderDate.localeCompare(a.orderDate))', modernDescription: 'BY OrderDate DESCENDING becomes a sort; each order is a collapsible section.' },
  { prog: 'order_report', category: 'Data Access', lines: [35, 45], title: 'Lines joined to items', modern: 'linesByOrder(o.orderNum).map((l) => ({\n  ...l, item: itemById(l.itemNum),\n}))', modernDescription: 'FOR EACH OrderLine OF Order with FIND Item becomes a join in the data layer.' },
  { prog: 'order_report', category: 'Reports', lines: [32, 49], title: 'Accumulators', modern: 'const total = lines.reduce((s, l) => s + l.extendedPrice, 0);', modernDescription: 'ASSIGN running totals become a reduce().' },
  { prog: 'order_report', category: 'UI', lines: [52, 54], title: 'Per-order totals message', modern: '<tfoot><tr><td>Order {n}: {lines.length} lines, total</td>\n  <td>{fmtMoney(total)}</td></tr></tfoot>', modernDescription: 'One alert box per order becomes a table footer row.' },
  // sample-update-credit.p
  { prog: 'update_credit', category: 'Schema', lines: [11, 12], title: 'Rule constants', modern: 'const DEFAULT_THRESHOLD = 0.8;\nconst DEFAULT_INCREASE = 1.2;\n<input type="range" value={threshold} />', modernDescription: 'Hard-coded INITIAL values become adjustable rule parameters with a reset.' },
  { prog: 'update_credit', category: 'Schema', lines: [14, 19], title: 'Temp-table', modern: 'interface Change {\n  custNum: number; name: string;\n  balance: number; oldLimit: number; newLimit: number;\n}', modernDescription: 'TEMP-TABLE becomes a typed interface held in React state.' },
  { prog: 'update_credit', category: 'Locking', lines: [21, 23], title: 'Select and lock candidates', modern: 'db.filter((c) => c.creditLimit > 0\n  && c.balance > c.creditLimit * threshold)', modernDescription: 'FOR EACH ... EXCLUSIVE-LOCK WHERE becomes a preview filter; the lock is taken only when changes are applied.' },
  { prog: 'update_credit', category: 'Data Access', lines: [25, 38], title: 'Record and apply changes', modern: 'const changes = selected.map((c) => ({ ..., newLimit: c.creditLimit * increase }));\nsetDb(db.map((c) => byId.has(c.custNum) ? { ...c, creditLimit: byId.get(c.custNum)! } : c));', modernDescription: 'CREATE / ASSIGN become one unit of work, applied after confirmation.' },
  { prog: 'update_credit', category: 'Reports', lines: [41, 50], title: 'Change list', modern: '<Card title="Change log"><table>...</table></Card>', modernDescription: 'The DISPLAY ... DOWN frame becomes a persistent change log per run.' },
  { prog: 'update_credit', category: 'UI', lines: [52, 53], title: 'Result message', modern: '<div className="alert success">{n} customer(s) updated.</div>', modernDescription: 'Same text, verbatim.' },
];

const PROG_ORDER: ProgKey[] = ['customer_maint', 'cust_orders', 'order_report', 'update_credit'];
const ALL_CATEGORIES = Array.from(new Set([...MAPPINGS.map((m) => m.category), ...PROGRAM_MAPS.map((m) => m.category)]));

function AblSnippet({ prog, lines }: { prog: ProgKey; lines: [number, number] }) {
  const { src, program } = SOURCES[prog];
  const file = PROGRAMS[program].source;
  const all = src.replace(/\r/g, '').split('\n');
  const rows = all.slice(lines[0] - 1, lines[1]);
  return (
    <div className="snip dark">
      <div className="snip-head">
        <span><FileCode2 size={14} /> {file.split('/').pop()}</span>
        <a href={ablSourceUrl(file, lines)} target="_blank" rel="noopener noreferrer">
          L{lines[0]}{lines[1] !== lines[0] ? `–${lines[1]}` : ''} <ExternalLink size={13} />
        </a>
      </div>
      <pre>{rows.map((r, i) => (
        <div key={i} className="snip-line"><span className="ln">{lines[0] + i}</span><span>{r || ' '}</span></div>
      ))}</pre>
    </div>
  );
}

function ModernSnippet({ code, file }: { code: string; file?: string }) {
  return (
    <div className="snip light">
      {file && (
        <div className="snip-head">
          <span><FileCode2 size={14} /> {file.split('/').pop()}</span>
          <a href={APP_SOURCE_BLOB + file} target="_blank" rel="noopener noreferrer">source <ExternalLink size={13} /></a>
        </div>
      )}
      <pre>{code}</pre>
    </div>
  );
}

function openSideBySide(route: string) {
  try { localStorage.setItem('sports2000.compare-mode', 'split'); } catch { /* ignore */ }
  window.location.hash = `#${route}`;
  window.scrollTo({ top: 0 });
}

export function Mapping() {
  const [view, setView] = useState<'programs' | 'reference'>('programs');
  const [cat, setCat] = useState<string>('all');
  const [prog, setProg] = useState<ProgKey | 'all'>('all');
  const [q, setQ] = useState('');
  const s = q.trim().toLowerCase();

  const progRows = useMemo(() => PROGRAM_MAPS.filter((m) => {
    if (cat !== 'all' && m.category !== cat) return false;
    if (prog !== 'all' && m.prog !== prog) return false;
    if (!s) return true;
    const code = SOURCES[m.prog].src.split('\n').slice(m.lines[0] - 1, m.lines[1]).join(' ');
    return `${m.title} ${code} ${m.modern} ${m.modernDescription} ${PROGRAMS[SOURCES[m.prog].program].source}`.toLowerCase().includes(s);
  }), [cat, prog, s]);

  const refRows = useMemo(() => MAPPINGS.filter((m) => (cat === 'all' || m.category === cat)
    && (!s || `${m.abl} ${m.ablDescription} ${m.modern} ${m.modernDescription}`.toLowerCase().includes(s))), [cat, s]);

  const countFor = (c: string) => (view === 'programs' ? PROGRAM_MAPS : MAPPINGS).filter((m) => m.category === c).length;
  const cats = ALL_CATEGORIES.filter((c) => countFor(c) > 0);

  return (
    <>
      <PageHeader
        title="Legacy ↔ modern mapping"
        crumbs={['Modernization', 'Mapping']}
        subtitle="Every Progress OpenEdge ABL construct and how it was translated. Program by program, each row links to the exact lines of the original source."
      />

      <div className="map-stats">
        <div><b>{PROG_ORDER.length}</b><span>programs mapped</span></div>
        <div><b>{PROGRAM_MAPS.length}</b><span>line-level mappings</span></div>
        <div><b>{MAPPINGS.length}</b><span>construct patterns</span></div>
        <div><b>{ALL_CATEGORIES.length}</b><span>categories</span></div>
      </div>

      <div className="map-filters">
        <div className="mode-toggle" role="radiogroup" aria-label="View">
          <button role="radio" aria-checked={view === 'programs'} className={view === 'programs' ? 'on' : ''} onClick={() => setView('programs')}>By program</button>
          <button role="radio" aria-checked={view === 'reference'} className={view === 'reference' ? 'on' : ''} onClick={() => setView('reference')}>Construct reference</button>
        </div>
        <div className="input-icon map-search">
          <Search size={18} />
          <input className="input" placeholder="Search ABL, React, rules or file names" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Search mappings" />
          {q && <button className="map-clear" onClick={() => setQ('')} aria-label="Clear search"><X size={16} /></button>}
        </div>
        <div className="map-chips" role="group" aria-label="Filter by category">
          <button className={cat === 'all' ? 'on' : ''} onClick={() => setCat('all')}>All categories</button>
          {cats.map((c) => (
            <button key={c} className={cat === c ? 'on' : ''} onClick={() => setCat(c)}>{c} <span>{countFor(c)}</span></button>
          ))}
        </div>
        {view === 'programs' && (
          <div className="map-chips" role="group" aria-label="Filter by program">
            <button className={prog === 'all' ? 'on' : ''} onClick={() => setProg('all')}>All programs</button>
            {PROG_ORDER.map((p) => (
              <button key={p} className={`mono ${prog === p ? 'on' : ''}`} onClick={() => setProg(p)}>{PROGRAMS[SOURCES[p].program].source.split('/').pop()}</button>
            ))}
          </div>
        )}
      </div>

      {view === 'programs' ? (
        <div className="stack" style={{ gap: 28 }}>
          {progRows.length === 0 && <div className="card"><EmptyState title="No mappings match your filters." /></div>}
          {PROG_ORDER.map((pk) => {
            const rows = progRows.filter((m) => m.prog === pk);
            if (!rows.length) return null;
            const P = PROGRAMS[SOURCES[pk].program];
            return (
              <section key={pk} className="card map-prog">
                <div className="map-prog-head">
                  <div>
                    <div className="map-prog-file"><FileCode2 size={18} /> <a href={ablSourceUrl(P.source)} target="_blank" rel="noopener noreferrer">{P.source}</a></div>
                    <div className="map-prog-title">{P.title} <span>· {P.lines} lines · {P.tables.join(', ')}</span></div>
                    <div className="map-prog-sum">{P.summary}</div>
                  </div>
                  <button className="btn primary" onClick={() => openSideBySide(SOURCES[pk].route)}><Columns2 size={16} /> Open side by side</button>
                </div>
                <div className="map-cols-head"><span>Progress ABL · original lines</span><span /><span>Modern · React + TypeScript</span></div>
                {rows.map((m, i) => (
                  <div key={i} className="map-row2">
                    <div>
                      <div className="map-row-title"><span className="pill neutral">{m.category}</span> {m.title}</div>
                      <AblSnippet prog={m.prog} lines={m.lines} />
                    </div>
                    <div className="map-arrow2"><ArrowRight size={20} /></div>
                    <div>
                      <div className="map-row-title muted">{m.modernDescription}</div>
                      <ModernSnippet code={m.modern} file={SOURCES[m.prog].screen} />
                    </div>
                  </div>
                ))}
              </section>
            );
          })}
        </div>
      ) : (
        <section className="card map-prog">
          <div className="map-cols-head"><span>Progress ABL</span><span /><span>Modern stack</span></div>
          {refRows.length === 0 && <EmptyState title="No mappings match your search." />}
          {refRows.map((m, i) => (
            <div key={i} className="map-row2">
              <div>
                <div className="map-row-title"><span className="pill neutral">{m.category}</span> {m.ablDescription}</div>
                <div className="snip dark"><pre>{m.abl}</pre></div>
              </div>
              <div className="map-arrow2"><ArrowRight size={20} /></div>
              <div>
                <div className="map-row-title muted">{m.modernDescription}</div>
                <ModernSnippet code={m.modern} />
                {m.notes && <div className="alert info" style={{ marginTop: 10 }}><span>{m.notes}</span></div>}
              </div>
            </div>
          ))}
        </section>
      )}
    </>
  );
}
