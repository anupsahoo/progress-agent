import React from 'react';
import { C } from '../components/Shell';

interface HomeProps {
  onNavigate: (route: string) => void;
}

const MODULES = [
  {
    route: 'customer-maint',
    title: 'Customer Maintenance',
    source: 'customer_maint.p',
    lines: 51,
    description: 'Update a customer record. Classic ABL FRAME + FIND + UPDATE. Modernized to a React form with inline validation and optimistic save.',
    tables: ['Customer'],
    color: '#7c7cf0',
  },
  {
    route: 'customer-orders',
    title: 'Customer Orders',
    source: 'cust_orders.p',
    lines: 43,
    description: 'Look up a customer and view their orders. Originally a REPEAT loop with two frames. Now a master-detail React view.',
    tables: ['Customer', 'Order'],
    color: '#50b050',
  },
  {
    route: 'customer-list',
    title: 'Customer List',
    source: 'sample-customer-list.p',
    lines: 28,
    description: 'Paginated report of all customers sorted by state & name. Originally scrolled text output. Now a sortable/filterable table with summary.',
    tables: ['Customer'],
    color: '#3b8ff0',
  },
  {
    route: 'order-report',
    title: 'Order Report',
    source: 'sample-order-report.p',
    lines: 55,
    description: 'Detailed order report with line items for a specific customer. Parent-child drill-down with subtotals.',
    tables: ['Customer', 'Order', 'OrderLine', 'Item'],
    color: '#f59e0b',
  },
  {
    route: 'update-credit',
    title: 'Credit Limit Update',
    source: 'sample-update-credit.p',
    lines: 53,
    description: 'Batch credit limit adjustment for customers exceeding 80% balance-to-limit. Preview changes before applying.',
    tables: ['Customer'],
    color: '#ef4444',
  },
];

export function Home({ onNavigate }: HomeProps) {
  return (
    <div>
      {/* Hero */}
      <section style={{
        background: `linear-gradient(135deg, ${C.ind} 0%, ${C.indL} 100%)`,
        color: 'white',
        borderRadius: 16,
        padding: '48px 40px',
        marginBottom: 40,
        boxShadow: '0 10px 30px rgba(59, 91, 219, 0.3)',
        position: 'relative',
        overflow: 'hidden',
      }}>
        <div style={{
          position: 'absolute', top: -60, right: -60,
          width: 280, height: 280, borderRadius: '50%',
          background: 'rgba(255,255,255,0.08)',
        }} />
        <div style={{ position: 'relative', zIndex: 1, maxWidth: 680 }}>
          <div style={{
            display: 'inline-flex', alignItems: 'center', gap: 8,
            padding: '6px 14px', borderRadius: 20,
            background: 'rgba(255,255,255,0.18)',
            fontSize: 11, fontWeight: 700, fontFamily: C.mono,
            textTransform: 'uppercase', letterSpacing: '0.08em',
            marginBottom: 18,
          }}>
            <span style={{ width: 7, height: 7, borderRadius: '50%', background: '#4ade80' }} />
            Live demo
          </div>
          <h1 style={{
            fontSize: 42, fontWeight: 800, letterSpacing: '-0.02em',
            margin: '0 0 12px', lineHeight: 1.1,
          }}>
            Progress OpenEdge → Modern React
          </h1>
          <p style={{
            fontSize: 17, lineHeight: 1.55, margin: '0 0 28px',
            opacity: 0.92, maxWidth: 600,
          }}>
            Five legacy ABL programs from the <code style={{ background: 'rgba(255,255,255,0.18)', padding: '2px 7px', borderRadius: 4, fontFamily: C.mono }}>sports2000</code> demo database, auto-modernized by FlowPilot AI into React components. Same business logic, modern UI.
          </p>
          <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
            <button
              onClick={() => onNavigate('customer-maint')}
              style={{
                padding: '11px 22px', borderRadius: 8, fontSize: 14, fontWeight: 700,
                background: 'white', color: C.ind, border: 'none',
                cursor: 'pointer', boxShadow: '0 4px 14px rgba(0,0,0,0.15)',
              }}
            >Start with Customer Maintenance →</button>
            <button
              onClick={() => onNavigate('roi')}
              style={{
                padding: '11px 22px', borderRadius: 8, fontSize: 14, fontWeight: 700,
                background: 'rgba(255,255,255,0.18)', color: 'white',
                border: '1.5px solid rgba(255,255,255,0.4)', cursor: 'pointer',
              }}
            >See ROI Calculator →</button>
            <a
              href="https://github.com/anupsahoo/progress-agent"
              target="_blank"
              rel="noopener noreferrer"
              style={{
                padding: '11px 22px', borderRadius: 8, fontSize: 14, fontWeight: 700,
                background: 'rgba(255,255,255,0.15)', color: 'white',
                border: '1.5px solid rgba(255,255,255,0.4)', textDecoration: 'none',
              }}
            >View source on GitHub ↗</a>
          </div>
        </div>
      </section>

      {/* Modules grid */}
      <div style={{ marginBottom: 20 }}>
        <div style={{
          fontSize: 11, fontWeight: 700, color: C.t3, fontFamily: C.mono,
          textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 8,
        }}>
          Modernized modules
        </div>
        <h2 style={{ fontSize: 22, fontWeight: 700, color: C.t1, margin: 0, letterSpacing: '-0.01em' }}>
          Click any module to see the before/after comparison
        </h2>
      </div>

      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))',
        gap: 18,
      }}>
        {MODULES.map((m) => (
          <button
            key={m.route}
            onClick={() => onNavigate(m.route)}
            style={{
              textAlign: 'left',
              background: 'white',
              border: `1px solid ${C.bdr}`,
              borderLeft: `3px solid ${m.color}`,
              borderRadius: 12,
              padding: 20,
              cursor: 'pointer',
              transition: 'all 0.15s',
              boxShadow: '0 1px 3px rgba(0,0,0,0.04)',
              fontFamily: 'inherit',
            }}
            onMouseEnter={e => {
              e.currentTarget.style.transform = 'translateY(-2px)';
              e.currentTarget.style.boxShadow = '0 8px 16px rgba(0,0,0,0.08)';
              e.currentTarget.style.borderColor = m.color;
              e.currentTarget.style.borderLeftColor = m.color;
            }}
            onMouseLeave={e => {
              e.currentTarget.style.transform = 'translateY(0)';
              e.currentTarget.style.boxShadow = '0 1px 3px rgba(0,0,0,0.04)';
              e.currentTarget.style.borderColor = C.bdr;
              e.currentTarget.style.borderLeftColor = m.color;
            }}
          >
            <div style={{
              fontSize: 10, fontWeight: 700, color: m.color, fontFamily: C.mono,
              textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 6,
            }}>
              {m.source} &middot; {m.lines} lines
            </div>
            <h3 style={{ fontSize: 17, fontWeight: 700, color: C.t1, margin: '0 0 8px' }}>
              {m.title}
            </h3>
            <p style={{ fontSize: 13, color: C.t2, margin: '0 0 14px', lineHeight: 1.55 }}>
              {m.description}
            </p>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
              {m.tables.map(t => (
                <span key={t} style={{
                  fontSize: 10, padding: '2px 8px', borderRadius: 4,
                  background: C.indUL, color: C.ind, fontFamily: C.mono, fontWeight: 600,
                }}>{t}</span>
              ))}
            </div>
          </button>
        ))}
      </div>

      {/* How it works */}
      <section style={{ marginTop: 48, background: 'white', borderRadius: 12, padding: 28, border: `1px solid ${C.bdr}` }}>
        <h2 style={{ fontSize: 18, fontWeight: 700, color: C.t1, margin: '0 0 16px' }}>
          How this website was built
        </h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 16 }}>
          <Step n="1" label="Progress .p files" text="5 ABL programs from the sports2000 demo database." />
          <Step n="2" label="FlowPilot AI analyzes" text="Identifies tables, business logic, UI frames, locking strategy." />
          <Step n="3" label="Generates React + FastAPI" text="One component per screen, matching the original behavior." />
          <Step n="4" label="Opens 3 PRs per program" text="UI / UI Tests / API + Tests — with human approval between each." />
          <Step n="5" label="Auto-deploys to Pages" text="This live site. Built from sports2000 JSON data." />
        </div>
      </section>
    </div>
  );
}

function Step({ n, label, text }: { n: string; label: string; text: string }) {
  return (
    <div>
      <div style={{
        width: 28, height: 28, borderRadius: '50%', background: C.indUL, color: C.ind,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontWeight: 800, fontSize: 12, marginBottom: 8, fontFamily: C.mono,
      }}>
        {n}
      </div>
      <div style={{ fontSize: 13, fontWeight: 700, color: C.t1, marginBottom: 2 }}>{label}</div>
      <div style={{ fontSize: 12, color: C.t3, lineHeight: 1.5 }}>{text}</div>
    </div>
  );
}
