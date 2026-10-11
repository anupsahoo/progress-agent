import React, { useEffect, useMemo, useState } from 'react';
import { ArrowDown, ArrowUp, ChevronLeft, ChevronRight, ChevronsUpDown, Inbox, Search, X } from 'lucide-react';
import { T, fmtPct } from '../theme';

/* ---------------- Page header ---------------- */

export function PageHeader({ title, subtitle, crumbs, actions }: {
  title: string;
  subtitle?: React.ReactNode;
  crumbs?: string[];
  actions?: React.ReactNode;
}) {
  return (
    <div className="page-head">
      <div style={{ minWidth: 0 }}>
        {crumbs && (
          <div className="crumbs">
            {crumbs.map((c, i) => (
              <React.Fragment key={c}>
                {i > 0 && <ChevronRight size={14} />}
                <span>{c}</span>
              </React.Fragment>
            ))}
          </div>
        )}
        <h1 className="page-title">{title}</h1>
        {subtitle && <p className="page-sub">{subtitle}</p>}
      </div>
      {actions && <div className="page-actions">{actions}</div>}
    </div>
  );
}

/* ---------------- Card ---------------- */

export function Card({ title, sub, actions, children, pad = true, style }: {
  title?: React.ReactNode;
  sub?: React.ReactNode;
  actions?: React.ReactNode;
  children?: React.ReactNode;
  pad?: boolean;
  style?: React.CSSProperties;
}) {
  return (
    <section className="card" style={style}>
      {(title || actions) && (
        <div className="card-head">
          <div style={{ minWidth: 0 }}>
            {title && <div className="card-title">{title}</div>}
            {sub && <div className="card-sub">{sub}</div>}
          </div>
          {actions && <div className="row" style={{ gap: 8 }}>{actions}</div>}
        </div>
      )}
      {pad ? <div className="card-body">{children}</div> : children}
    </section>
  );
}

/* ---------------- KPI ---------------- */

export function Kpi({ label, value, foot, icon, tone = 'brand' }: {
  label: string;
  value: React.ReactNode;
  foot?: React.ReactNode;
  icon?: React.ReactNode;
  tone?: 'brand' | 'success' | 'warning' | 'danger';
}) {
  const tones = {
    brand: [T.color.brandSoft, T.color.brand],
    success: [T.color.successSoft, T.color.success],
    warning: [T.color.warningSoft, T.color.warning],
    danger: [T.color.dangerSoft, T.color.danger],
  } as const;
  const [bg, fg] = tones[tone];
  return (
    <div className="card kpi">
      <div className="kpi-top">
        <span>{label}</span>
        {icon && <span className="kpi-icon" style={{ background: bg, color: fg }}>{icon}</span>}
      </div>
      <div className="kpi-value">{value}</div>
      {foot && <div className="kpi-foot">{foot}</div>}
    </div>
  );
}

/* ---------------- Pills ---------------- */

export type Tone = 'success' | 'warning' | 'danger' | 'neutral' | 'brand';

export function Pill({ tone = 'neutral', children, dot }: { tone?: Tone; children: React.ReactNode; dot?: boolean }) {
  return <span className={`pill ${tone}`}>{dot && <span className="dot" />}{children}</span>;
}

export function StatusPill({ status }: { status: string }) {
  const s = status.toLowerCase();
  const tone: Tone = s === 'shipped' ? 'success' : s.includes('back') ? 'warning' : s.includes('ordered') ? 'brand' : 'neutral';
  return <Pill tone={tone} dot>{status}</Pill>;
}

export function utilTone(r: number): Tone {
  return r >= 0.8 ? 'danger' : r >= 0.5 ? 'warning' : 'success';
}

export function UtilMeter({ ratio, width = 90 }: { ratio: number; width?: number }) {
  const tone = utilTone(ratio);
  const color = tone === 'danger' ? '#4A78C2' : tone === 'warning' ? '#2C64B8' : '#3A9A2E';
  return (
    <div className="util">
      <div className="meter" style={{ width }}>
        <span style={{ width: `${Math.min(100, ratio * 100)}%`, background: color }} />
      </div>
      <span className="v" style={{ color: tone === 'danger' ? T.color.danger : T.color.text }}>{fmtPct(ratio)}</span>
    </div>
  );
}

/* ---------------- Form field ---------------- */

export function Field({ label, htmlFor, hint, error, children, className, extra }: {
  label: string;
  htmlFor?: string;
  hint?: React.ReactNode;
  error?: string | null;
  children: React.ReactNode;
  className?: string;
  extra?: React.ReactNode;
}) {
  return (
    <div className={`field ${className || ''}`}>
      <label htmlFor={htmlFor}>{label}{extra}</label>
      {children}
      {error ? <div className="err" role="alert">{error}</div> : hint ? <div className="hint">{hint}</div> : null}
    </div>
  );
}

/* ---------------- Data table ---------------- */

export interface Column<R> {
  key: string;
  header: string;
  render: (row: R) => React.ReactNode;
  sortValue?: (row: R) => string | number;
  align?: 'left' | 'right';
  width?: number | string;
}

type SortState = { key: string; dir: 'asc' | 'desc' } | null;

export function DataTable<R>({
  columns, rows, rowKey, searchText, searchPlaceholder = 'Search', toolbar, pageSize = 10,
  initialSort = null, onRowClick, selectedKey, footer, emptyText = 'No records match.', maxHeight, hideSearch, rowMap,
}: {
  /** Optional data-map key per row (used by the legacy/modern compare view). */
  rowMap?: (row: R) => string;
  columns: Column<R>[];
  rows: R[];
  rowKey: (row: R) => string | number;
  searchText?: (row: R) => string;
  searchPlaceholder?: string;
  toolbar?: React.ReactNode;
  pageSize?: number;
  initialSort?: SortState;
  onRowClick?: (row: R) => void;
  selectedKey?: string | number | null;
  footer?: (visible: R[]) => React.ReactNode;
  emptyText?: string;
  maxHeight?: number;
  hideSearch?: boolean;
}) {
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<SortState>(initialSort);
  const [page, setPage] = useState(0);

  const filtered = useMemo(() => {
    const s = q.trim().toLowerCase();
    if (!s || !searchText) return rows;
    return rows.filter((r) => searchText(r).toLowerCase().includes(s));
  }, [rows, q, searchText]);

  const sorted = useMemo(() => {
    if (!sort) return filtered;
    const col = columns.find((c) => c.key === sort.key);
    if (!col?.sortValue) return filtered;
    const sv = col.sortValue;
    const out = [...filtered].sort((a, b) => {
      const av = sv(a), bv = sv(b);
      const c = typeof av === 'number' && typeof bv === 'number' ? av - bv : String(av).localeCompare(String(bv));
      return sort.dir === 'asc' ? c : -c;
    });
    return out;
  }, [filtered, sort, columns]);

  const pages = Math.max(1, Math.ceil(sorted.length / pageSize));
  useEffect(() => { if (page > pages - 1) setPage(0); }, [pages, page]);
  const visible = sorted.slice(page * pageSize, page * pageSize + pageSize);

  const toggleSort = (key: string) => {
    setSort((s) => (!s || s.key !== key ? { key, dir: 'asc' } : s.dir === 'asc' ? { key, dir: 'desc' } : null));
  };

  return (
    <div>
      {(!hideSearch || toolbar) && (
        <div className="toolbar">
          {!hideSearch && searchText && (
            <div className="input-icon">
              <Search size={16} />
              <input className="input" value={q} onChange={(e) => { setQ(e.target.value); setPage(0); }} placeholder={searchPlaceholder} aria-label={searchPlaceholder} />
            </div>
          )}
          {toolbar}
        </div>
      )}
      <div className="table-wrap" style={maxHeight ? { maxHeight } : undefined}>
        <table className="table">
          <thead>
            <tr>
              {columns.map((c) => {
                const active = sort?.key === c.key;
                return (
                  <th
                    key={c.key}
                    className={`${c.sortValue ? 'sortable' : ''} ${c.align === 'right' ? 'right' : ''}`}
                    style={{ width: c.width, textAlign: c.align || 'left' }}
                    onClick={c.sortValue ? () => toggleSort(c.key) : undefined}
                    aria-sort={active ? (sort!.dir === 'asc' ? 'ascending' : 'descending') : undefined}
                  >
                    <span className="th">
                      {c.header}
                      {c.sortValue && (active
                        ? (sort!.dir === 'asc' ? <ArrowUp size={13} /> : <ArrowDown size={13} />)
                        : <ChevronsUpDown size={13} style={{ opacity: 0.45 }} />)}
                    </span>
                  </th>
                );
              })}
            </tr>
          </thead>
          <tbody>
            {visible.map((r) => {
              const k = rowKey(r);
              return (
                <tr
                  key={k}
                  data-map={rowMap?.(r)}
                  className={`${onRowClick ? 'clickable' : ''} ${selectedKey === k ? 'selected' : ''}`}
                  onClick={onRowClick ? () => onRowClick(r) : undefined}
                >
                  {columns.map((c) => (
                    <td key={c.key} style={{ textAlign: c.align || 'left' }}>{c.render(r)}</td>
                  ))}
                </tr>
              );
            })}
          </tbody>
          {footer && visible.length > 0 && <tfoot>{footer(sorted)}</tfoot>}
        </table>
        {visible.length === 0 && <EmptyState title={emptyText} />}
      </div>
      <div className="pager">
        <span className="num">
          {sorted.length === 0 ? 'No results' : `Showing ${page * pageSize + 1} to ${Math.min(sorted.length, (page + 1) * pageSize)} of ${sorted.length}`}
        </span>
        <div className="row">
          <button className="btn sm icon" onClick={() => setPage((p) => Math.max(0, p - 1))} disabled={page === 0} aria-label="Previous page"><ChevronLeft size={16} /></button>
          <span className="num" style={{ minWidth: 70, textAlign: 'center', color: T.color.textSecondary }}>Page {page + 1} of {pages}</span>
          <button className="btn sm icon" onClick={() => setPage((p) => Math.min(pages - 1, p + 1))} disabled={page >= pages - 1} aria-label="Next page"><ChevronRight size={16} /></button>
        </div>
      </div>
    </div>
  );
}

export function EmptyState({ title, sub, icon }: { title: string; sub?: string; icon?: React.ReactNode }) {
  return (
    <div className="empty-state">
      {icon || <Inbox size={28} color={T.color.textFaint} />}
      <div className="t">{title}</div>
      {sub && <div style={{ marginTop: 4, fontSize: 14 }}>{sub}</div>}
    </div>
  );
}

/* ---------------- Drawer / Modal ---------------- */

function useEsc(open: boolean, onClose: () => void) {
  useEffect(() => {
    if (!open) return;
    const h = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose(); };
    window.addEventListener('keydown', h);
    return () => window.removeEventListener('keydown', h);
  }, [open, onClose]);
}

export function Drawer({ open, onClose, title, subtitle, children, footer }: {
  open: boolean;
  onClose: () => void;
  title: React.ReactNode;
  subtitle?: React.ReactNode;
  children: React.ReactNode;
  footer?: React.ReactNode;
}) {
  useEsc(open, onClose);
  if (!open) return null;
  return (
    <>
      <div className="scrim" onClick={onClose} />
      <aside className="drawer" role="dialog" aria-modal="true">
        <div className="drawer-head">
          <div style={{ minWidth: 0 }}>
            <div style={{ fontSize: 20, fontWeight: 700, letterSpacing: '-0.02em' }}>{title}</div>
            {subtitle && <div style={{ color: T.color.textMuted, fontSize: 14.5, marginTop: 4 }}>{subtitle}</div>}
          </div>
          <button className="btn ghost icon" onClick={onClose} aria-label="Close"><X size={18} /></button>
        </div>
        <div className="drawer-body">{children}</div>
        {footer && <div className="drawer-foot">{footer}</div>}
      </aside>
    </>
  );
}

export function Modal({ open, onClose, title, children }: { open: boolean; onClose: () => void; title: string; children: React.ReactNode }) {
  useEsc(open, onClose);
  if (!open) return null;
  return (
    <>
      <div className="scrim" onClick={onClose} />
      <div className="modal" role="dialog" aria-modal="true">
        <div className="drawer-head">
          <div style={{ fontSize: 18, fontWeight: 700 }}>{title}</div>
          <button className="btn ghost icon" onClick={onClose} aria-label="Close"><X size={18} /></button>
        </div>
        <div style={{ padding: 24 }}>{children}</div>
      </div>
    </>
  );
}

/* ---------------- Toasts ---------------- */

export function useToasts() {
  const [items, setItems] = useState<{ id: number; text: React.ReactNode; icon?: React.ReactNode }[]>([]);
  const push = (text: React.ReactNode, icon?: React.ReactNode) => {
    const id = Date.now() + Math.random();
    setItems((xs) => [...xs, { id, text, icon }]);
    setTimeout(() => setItems((xs) => xs.filter((x) => x.id !== id)), 3200);
  };
  const node = (
    <div className="toast-wrap" aria-live="polite">
      {items.map((t) => <div key={t.id} className="toast">{t.icon}{t.text}</div>)}
    </div>
  );
  return { push, node };
}

export function initials(name: string) {
  return name.split(/\s+/).filter(Boolean).slice(0, 2).map((w) => w[0]).join('').toUpperCase();
}
