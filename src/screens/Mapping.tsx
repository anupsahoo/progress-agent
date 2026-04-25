import React, { useState } from 'react';
import { C, PageHeader } from '../components/Shell';

/**
 * ABL → Modern stack reference. Shows that we deeply understand Progress
 * — not just running an LLM on it. This is what a product company wants
 * to see in a partner.
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
    modernDescription: 'React useEffect + fetch — async, non-blocking',
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
    notes: 'Eliminates lock-wait timeouts (the #1 Progress production incident).',
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
    modernDescription: 'window.print() + CSS @page rules — printable + downloadable',
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
    modernDescription: 'export type Customer = { ... } — imported wherever needed',
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

const CATEGORIES = Array.from(new Set(MAPPINGS.map(m => m.category)));
const CATEGORY_COLORS: Record<string, string> = {
  'Data Access': '#3b5bdb',
  'Locking': '#ef4444',
  'UI': '#7c7cf0',
  'Reports': '#f59e0b',
  'Programs': '#10b981',
  'Schema': '#0ea5e9',
  'Errors': '#dc2626',
};

export function Mapping() {
  const [filter, setFilter] = useState<string>('all');
  const filtered = filter === 'all' ? MAPPINGS : MAPPINGS.filter(m => m.category === filter);

  return (
    <div>
      <PageHeader
        title="ABL → Modern Stack Reference"
        subtitle="Every Progress OpenEdge ABL construct mapped to its modern equivalent. This is the translation layer FlowPilot AI applies during modernization."
      />

      {/* Filter chips */}
      <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 24 }}>
        <FilterChip label="All" value="all" current={filter} count={MAPPINGS.length} onClick={setFilter} color={C.t2} />
        {CATEGORIES.map(cat => (
          <FilterChip
            key={cat}
            label={cat}
            value={cat}
            current={filter}
            count={MAPPINGS.filter(m => m.category === cat).length}
            color={CATEGORY_COLORS[cat] || C.ind}
            onClick={setFilter}
          />
        ))}
      </div>

      {/* Mappings */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        {filtered.map((m, i) => (
          <MappingRow key={i} mapping={m} color={CATEGORY_COLORS[m.category] || C.ind} />
        ))}
      </div>

      {/* Footer */}
      <div style={{
        background: 'white', border: `1px solid ${C.bdr}`, borderRadius: 12,
        padding: 22, marginTop: 24, fontSize: 13, color: C.t2, lineHeight: 1.7,
      }}>
        <div style={{ fontSize: 13, fontWeight: 700, color: C.t1, marginBottom: 8 }}>
          About this reference
        </div>
        FlowPilot AI's modernization workflow applies these mappings automatically when reading a `.p` file.
        The agent identifies each ABL construct (FRAME, FOR EACH, EXCLUSIVE-LOCK, etc.) and emits the
        equivalent React + FastAPI code. Every transformation is auditable in the generated PR — reviewers
        see exactly what was changed and why.
      </div>
    </div>
  );
}

function FilterChip({ label, value, current, count, color, onClick }: {
  label: string; value: string; current: string; count: number; color: string; onClick: (v: string) => void;
}) {
  const active = current === value;
  return (
    <button
      onClick={() => onClick(value)}
      style={{
        padding: '7px 14px', borderRadius: 20, fontSize: 12, fontWeight: 700,
        background: active ? color : 'white',
        color: active ? 'white' : color,
        border: `1.5px solid ${color}`,
        cursor: 'pointer', fontFamily: C.sans, transition: 'all 0.12s',
        display: 'inline-flex', alignItems: 'center', gap: 6,
      }}
    >
      {label}
      <span style={{
        fontSize: 10, padding: '1px 7px', borderRadius: 10,
        background: active ? 'rgba(255,255,255,0.25)' : color + '22',
        fontFamily: C.mono,
      }}>{count}</span>
    </button>
  );
}

function MappingRow({ mapping, color }: { mapping: Mapping; color: string }) {
  return (
    <div style={{
      background: 'white', border: `1px solid ${C.bdr}`,
      borderLeft: `3px solid ${color}`, borderRadius: 10,
      overflow: 'hidden',
    }}>
      <div style={{
        padding: '8px 16px', background: color + '0d',
        borderBottom: `1px solid ${C.bdr}`,
        fontSize: 10, fontWeight: 700, color, fontFamily: C.mono,
        textTransform: 'uppercase', letterSpacing: '0.06em',
      }}>
        {mapping.category}
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 0 }}>
        {/* ABL side */}
        <div style={{
          padding: 18, background: '#0f172a', color: '#e2e8f0',
          borderRight: `1px solid ${C.bdr}`,
        }}>
          <div style={{
            fontSize: 9, fontWeight: 700, color: '#94a3b8', fontFamily: C.mono,
            textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 8,
          }}>
            Progress ABL
          </div>
          <pre style={{
            margin: 0, fontFamily: C.mono, fontSize: 12, lineHeight: 1.6,
            whiteSpace: 'pre-wrap', color: '#cbd5e1',
          }}>{mapping.abl}</pre>
          <div style={{ fontSize: 12, color: '#94a3b8', marginTop: 10, fontStyle: 'italic' }}>
            {mapping.ablDescription}
          </div>
        </div>

        {/* Modern side */}
        <div style={{ padding: 18 }}>
          <div style={{
            fontSize: 9, fontWeight: 700, color: C.green, fontFamily: C.mono,
            textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 8,
          }}>
            Modern stack
          </div>
          <pre style={{
            margin: 0, fontFamily: C.mono, fontSize: 12, lineHeight: 1.6,
            whiteSpace: 'pre-wrap', color: C.t1,
            background: '#f8fafc', padding: 10, borderRadius: 6,
          }}>{mapping.modern}</pre>
          <div style={{ fontSize: 12, color: C.t2, marginTop: 10, lineHeight: 1.5 }}>
            {mapping.modernDescription}
          </div>
          {mapping.notes && (
            <div style={{
              marginTop: 10, padding: '8px 12px', borderRadius: 6,
              background: C.amber + '14', color: '#92400e',
              fontSize: 12, lineHeight: 1.5, fontWeight: 500,
            }}>
              <strong>Note:</strong> {mapping.notes}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
