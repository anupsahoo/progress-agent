import { useEffect, useState } from 'react';
import type { LocalDefault } from './types';
import { localDefaultLabels as L } from './types';
import { localDefaultService } from './service';

// Replaces sales-territories/local_default_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function LocalDefaultList({ onOpen, onNew }: { onOpen: (row: LocalDefault) => void; onNew: () => void }) {
  const [rows, setRows] = useState<LocalDefault[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof LocalDefault; asc: boolean }>({ key: 'LocalDefNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      localDefaultService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="local-default-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>LocalDefault</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'Country', asc: s.key === 'Country' ? !s.asc : true }))}>{L.Country}</th>
            <th onClick={() => setSort((s) => ({ key: 'Region1Label', asc: s.key === 'Region1Label' ? !s.asc : true }))}>{L.Region1Label}</th>
            <th onClick={() => setSort((s) => ({ key: 'Region2Label', asc: s.key === 'Region2Label' ? !s.asc : true }))}>{L.Region2Label}</th>
            <th onClick={() => setSort((s) => ({ key: 'PostalLabel', asc: s.key === 'PostalLabel' ? !s.asc : true }))}>{L.PostalLabel}</th>
            <th onClick={() => setSort((s) => ({ key: 'PostalFormat', asc: s.key === 'PostalFormat' ? !s.asc : true }))}>{L.PostalFormat}</th>
            <th onClick={() => setSort((s) => ({ key: 'TelFormat', asc: s.key === 'TelFormat' ? !s.asc : true }))}>{L.TelFormat}</th>
            <th onClick={() => setSort((s) => ({ key: 'CurrencySymbol', asc: s.key === 'CurrencySymbol' ? !s.asc : true }))}>{L.CurrencySymbol}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.LocalDefNum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.Country ?? '')}</td>
              <td>{String(r.Region1Label ?? '')}</td>
              <td>{String(r.Region2Label ?? '')}</td>
              <td>{String(r.PostalLabel ?? '')}</td>
              <td>{String(r.PostalFormat ?? '')}</td>
              <td>{String(r.TelFormat ?? '')}</td>
              <td>{String(r.CurrencySymbol ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
