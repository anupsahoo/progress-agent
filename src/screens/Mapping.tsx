import React, { useMemo, useState } from 'react';
import { ArrowRight, Search } from 'lucide-react';
import { PageHeader, EmptyState } from '../components/ui';
import { T } from '../theme';

/**
 * ABL to modern stack reference: the translation layer FlowPilot applies
 * when it reads a .p program.
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

const CATEGORIES = Array.from(new Set(MAPPINGS.map((m) => m.category)));

export function Mapping() {
  const [filter, setFilter] = useState<string>('all');
  const [q, setQ] = useState('');
  const filtered = useMemo(() => {
    const s = q.trim().toLowerCase();
    return MAPPINGS.filter((m) => (filter === 'all' || m.category === filter)
      && (!s || `${m.abl} ${m.ablDescription} ${m.modern} ${m.modernDescription}`.toLowerCase().includes(s)));
  }, [filter, q]);

  return (
    <>
      <PageHeader
        title="Legacy ↔ modern mapping"
        crumbs={['Modernization', 'Mapping']}
        subtitle="How each Progress OpenEdge ABL construct is translated into the modern stack. FlowPilot applies these mappings when it reads a program, and every translation is visible in the pull request."
      />

      <div className="stack">
        <div className="card" style={{ padding: 14, display: 'flex', gap: 12, alignItems: 'center', flexWrap: 'wrap' }}>
          <div className="seg" role="tablist" aria-label="Filter by category">
            <button className={filter === 'all' ? 'on' : ''} onClick={() => setFilter('all')}>All <span className="count">{MAPPINGS.length}</span></button>
            {CATEGORIES.map((c) => (
              <button key={c} className={filter === c ? 'on' : ''} onClick={() => setFilter(c)}>
                {c} <span className="count">{MAPPINGS.filter((m) => m.category === c).length}</span>
              </button>
            ))}
          </div>
          <div className="input-icon" style={{ flex: 1, minWidth: 220, marginLeft: 'auto', maxWidth: 340 }}>
            <Search size={16} />
            <input className="input" style={{ height: 38 }} placeholder="Search constructs" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Search constructs" />
          </div>
        </div>

        <div className="card" style={{ overflow: 'hidden' }}>
          <div className="map-row map-head">
            <span>Category</span><span>Progress ABL</span><span /><span>Modern stack</span>
          </div>
          {filtered.length === 0 && <EmptyState title="No mappings match your search." />}
          {filtered.map((m, i) => (
            <div key={i} className="map-row">
              <div><span className="pill neutral">{m.category}</span></div>
              <div>
                <pre className="code dark">{m.abl}</pre>
                <div className="map-desc">{m.ablDescription}</div>
              </div>
              <div className="map-arrow"><ArrowRight size={18} color={T.color.textFaint} /></div>
              <div>
                <pre className="code light">{m.modern}</pre>
                <div className="map-desc">{m.modernDescription}</div>
                {m.notes && <div className="alert info" style={{ marginTop: 10, fontSize: 14 }}><span>{m.notes}</span></div>}
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}
