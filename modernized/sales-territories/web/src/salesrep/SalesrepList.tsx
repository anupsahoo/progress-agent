import { useEffect, useState } from 'react';
import type { Salesrep } from './types';
import { salesrepLabels as L } from './types';
import { salesrepService } from './service';

// Replaces sales-territories/salesrep_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function SalesrepList({ onOpen, onNew }: { onOpen: (row: Salesrep) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Salesrep[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Salesrep; asc: boolean }>({ key: 'SalesRep', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      salesrepService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="salesrep-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Salesrep</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'SalesRep', asc: s.key === 'SalesRep' ? !s.asc : true }))}>{L.SalesRep}</th>
            <th onClick={() => setSort((s) => ({ key: 'RepName', asc: s.key === 'RepName' ? !s.asc : true }))}>{L.RepName}</th>
            <th onClick={() => setSort((s) => ({ key: 'Region', asc: s.key === 'Region' ? !s.asc : true }))}>{L.Region}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.SalesRep)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.SalesRep ?? '')}</td>
              <td>{String(r.RepName ?? '')}</td>
              <td>{String(r.Region ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
