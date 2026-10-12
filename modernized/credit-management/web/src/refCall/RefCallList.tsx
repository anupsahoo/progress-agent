import { useEffect, useState } from 'react';
import type { RefCall } from './types';
import { refCallLabels as L } from './types';
import { refCallService } from './service';

// Replaces credit-management/ref_call_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function RefCallList({ onOpen, onNew }: { onOpen: (row: RefCall) => void; onNew: () => void }) {
  const [rows, setRows] = useState<RefCall[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof RefCall; asc: boolean }>({ key: 'CallNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      refCallService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="ref-call-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>RefCall</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'CallNum', asc: s.key === 'CallNum' ? !s.asc : true }))}>{L.CallNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'CustNum', asc: s.key === 'CustNum' ? !s.asc : true }))}>{L.CustNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'CallDate', asc: s.key === 'CallDate' ? !s.asc : true }))}>{L.CallDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'SalesRep', asc: s.key === 'SalesRep' ? !s.asc : true }))}>{L.SalesRep}</th>
            <th onClick={() => setSort((s) => ({ key: 'Parent', asc: s.key === 'Parent' ? !s.asc : true }))}>{L.Parent}</th>
            <th onClick={() => setSort((s) => ({ key: 'Txt', asc: s.key === 'Txt' ? !s.asc : true }))}>{L.Txt}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.CallNum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.CallNum ?? '')}</td>
              <td>{String(r.CustNum ?? '')}</td>
              <td>{String(r.CallDate ?? '')}</td>
              <td>{String(r.SalesRep ?? '')}</td>
              <td>{String(r.Parent ?? '')}</td>
              <td>{String(r.Txt ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
