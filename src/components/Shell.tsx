import React, { useEffect, useMemo, useRef, useState } from 'react';
import {
  ArrowLeftRight, BarChart3, ClipboardList, CreditCard, FileText, LayoutDashboard, Menu, Package,
  Search, UserCog, Users,
} from 'lucide-react';
import { customers, orders, customerLabel } from '../data/sports';

interface NavItem { id: string; label: string; icon: React.ReactNode }

const NAV: NavItem[] = [
  { id: 'dashboard', label: 'Dashboard', icon: <LayoutDashboard size={18} /> },
  { id: 'customer-list', label: 'Customers', icon: <Users size={18} /> },
  { id: 'customer-maint', label: 'Customer maintenance', icon: <UserCog size={18} /> },
  { id: 'customer-orders', label: 'Orders', icon: <Package size={18} /> },
  { id: 'order-report', label: 'Order report', icon: <FileText size={18} /> },
  { id: 'update-credit', label: 'Credit management', icon: <CreditCard size={18} /> },
];
const NAV_MOD: NavItem[] = [
  { id: 'mapping', label: 'Legacy ↔ modern mapping', icon: <ArrowLeftRight size={18} /> },
  { id: 'roi', label: 'ROI', icon: <BarChart3 size={18} /> },
];

export function Shell({ children, onNavigate, currentRoute }: {
  children: React.ReactNode;
  onNavigate: (route: string) => void;
  currentRoute: string;
}) {
  const [menuOpen, setMenuOpen] = useState(false);
  const go = (id: string) => { setMenuOpen(false); onNavigate(id); };

  const item = (n: NavItem) => (
    <a
      key={n.id}
      href={`#${n.id}`}
      className={`nav-item ${currentRoute === n.id ? 'active' : ''}`}
      aria-current={currentRoute === n.id ? 'page' : undefined}
      onClick={(e) => { e.preventDefault(); go(n.id); }}
    >
      {n.icon}<span>{n.label}</span>
    </a>
  );

  return (
    <div className="app">
      {menuOpen && <div className="scrim" style={{ zIndex: 25 }} onClick={() => setMenuOpen(false)} />}
      <aside className={`sidebar ${menuOpen ? 'open' : ''}`}>
        <a href="#dashboard" className="brand" onClick={(e) => { e.preventDefault(); go('dashboard'); }}>
          <span className="brand-mark"><Logo /></span>
          <span>
            <div className="brand-name">Sports2000</div>
            <div className="brand-sub">Back office</div>
          </span>
        </a>
        <nav className="nav-group" aria-label="Operations">
          <div className="nav-label">Operations</div>
          {NAV.map(item)}
        </nav>
        <nav className="nav-group" aria-label="Modernization">
          <div className="nav-label">Modernization</div>
          {NAV_MOD.map(item)}
        </nav>
        <div className="sidebar-foot">
          Modernized from Progress OpenEdge by <strong>FlowPilot</strong> · <strong>CogenSight</strong>
        </div>
      </aside>

      <div className="main-col">
        <header className="topbar">
          <button className="btn ghost icon menu-btn" onClick={() => setMenuOpen(true)} aria-label="Open menu"><Menu size={20} /></button>
          <GlobalSearch onNavigate={go} />
          <div className="topbar-right">
            <span className="env-badge" title="Running the modernized build">
              <span className="dot" /><span>Modernized<span className="long"> · React + TypeScript</span></span>
            </span>
            <div className="user">
              <span className="avatar" aria-hidden>AS</span>
              <div className="user-meta">
                <div className="n">Alex Stone</div>
                <div className="r">Operations manager</div>
              </div>
            </div>
          </div>
        </header>

        <main className="content">{children}</main>

        <footer className="footer">
          <span className="credit">
            <ClipboardList size={15} />
            Modernized from <b>Progress OpenEdge</b> by <b>FlowPilot</b> · <b>CogenSight</b>
          </span>
          <span>Sports2000 sample data · Demo environment</span>
        </footer>
      </div>
    </div>
  );
}

function Logo() {
  return (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" aria-hidden>
      <path d="M4 15.5c2.5 2.5 6.5 3 9.5 1.2M20 8.5c-2.5-2.5-6.5-3-9.5-1.2" stroke="#fff" strokeWidth="2.2" strokeLinecap="round" />
      <circle cx="12" cy="12" r="2.6" fill="#fff" />
    </svg>
  );
}

function GlobalSearch({ onNavigate }: { onNavigate: (r: string) => void }) {
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const [hl, setHl] = useState(0);
  const ref = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const h = (e: KeyboardEvent) => {
      const tag = (e.target as HTMLElement)?.tagName;
      if (e.key === '/' && tag !== 'INPUT' && tag !== 'TEXTAREA' && tag !== 'SELECT') { e.preventDefault(); ref.current?.focus(); }
    };
    window.addEventListener('keydown', h);
    return () => window.removeEventListener('keydown', h);
  }, []);

  const results = useMemo(() => {
    const s = q.trim().toLowerCase();
    if (!s) return [] as { key: string; group: string; label: string; sub: string; route: string }[];
    const cs = customers
      .filter((c) => `${c.name} ${c.city} ${c.contact} ${c.custNum}`.toLowerCase().includes(s))
      .slice(0, 6)
      .map((c) => ({ key: `c${c.custNum}`, group: 'Customers', label: c.name, sub: `#${c.custNum} · ${c.city}, ${c.country}`, route: `customer-list/${c.custNum}` }));
    const os = orders
      .filter((o) => `order ${o.orderNum} ${customerLabel(o.custNum)} ${o.status}`.toLowerCase().includes(s))
      .slice(0, 5)
      .map((o) => ({ key: `o${o.orderNum}`, group: 'Orders', label: `Order #${o.orderNum}`, sub: `${customerLabel(o.custNum)} · ${o.status}`, route: `customer-orders/${o.custNum}` }));
    return [...cs, ...os];
  }, [q]);

  const pick = (r: { route: string }) => { onNavigate(r.route); setQ(''); setOpen(false); ref.current?.blur(); };

  return (
    <div className="search">
      <Search size={17} className="icon" />
      <input
        ref={ref}
        value={q}
        placeholder="Search customers and orders"
        aria-label="Search customers and orders"
        onChange={(e) => { setQ(e.target.value); setOpen(true); setHl(0); }}
        onFocus={() => setOpen(true)}
        onBlur={() => setTimeout(() => setOpen(false), 120)}
        onKeyDown={(e) => {
          if (e.key === 'ArrowDown') { e.preventDefault(); setHl((h) => Math.min(results.length - 1, h + 1)); }
          if (e.key === 'ArrowUp') { e.preventDefault(); setHl((h) => Math.max(0, h - 1)); }
          if (e.key === 'Enter' && results[hl]) pick(results[hl]);
          if (e.key === 'Escape') { setOpen(false); ref.current?.blur(); }
        }}
      />
      <span className="kbd">/</span>
      {open && q.trim() && (
        <div className="search-pop">
          {results.length === 0 && <div className="empty">No customers or orders match "{q}".</div>}
          {results.map((r, i) => (
            <React.Fragment key={r.key}>
              {(i === 0 || results[i - 1].group !== r.group) && <div className="grp">{r.group}</div>}
              <button className={i === hl ? 'hl' : ''} onMouseDown={(e) => { e.preventDefault(); pick(r); }} onMouseEnter={() => setHl(i)}>
                {r.group === 'Customers' ? <Users size={16} /> : <Package size={16} />}
                <span style={{ fontWeight: 600 }}>{r.label}</span>
                <span className="muted" style={{ fontSize: 13.5, marginLeft: 'auto' }}>{r.sub}</span>
              </button>
            </React.Fragment>
          ))}
        </div>
      )}
    </div>
  );
}
