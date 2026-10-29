import { useEffect, useState } from 'react';
import type { ShipTo } from './types';
import { shipToLabels as L } from './types';
import { shipToService } from './service';

// Replaces order-fulfilment/ship_to_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function ShipToList({ onOpen, onNew }: { onOpen: (row: ShipTo) => void; onNew: () => void }) {
  const [rows, setRows] = useState<ShipTo[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof ShipTo; asc: boolean }>({ key: 'CustNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      shipToService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="ship-to-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>ShipTo</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'CustNum', asc: s.key === 'CustNum' ? !s.asc : true }))}>{L.CustNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'ShipToID', asc: s.key === 'ShipToID' ? !s.asc : true }))}>{L.ShipToID}</th>
            <th onClick={() => setSort((s) => ({ key: 'Contact', asc: s.key === 'Contact' ? !s.asc : true }))}>{L.Contact}</th>
            <th onClick={() => setSort((s) => ({ key: 'Address', asc: s.key === 'Address' ? !s.asc : true }))}>{L.Address}</th>
            <th onClick={() => setSort((s) => ({ key: 'Address2', asc: s.key === 'Address2' ? !s.asc : true }))}>{L.Address2}</th>
            <th onClick={() => setSort((s) => ({ key: 'City', asc: s.key === 'City' ? !s.asc : true }))}>{L.City}</th>
            <th onClick={() => setSort((s) => ({ key: 'State', asc: s.key === 'State' ? !s.asc : true }))}>{L.State}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.CustNum) + '|' + String(r.ShipToID)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.CustNum ?? '')}</td>
              <td>{String(r.ShipToID ?? '')}</td>
              <td>{String(r.Contact ?? '')}</td>
              <td>{String(r.Address ?? '')}</td>
              <td>{String(r.Address2 ?? '')}</td>
              <td>{String(r.City ?? '')}</td>
              <td>{String(r.State ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
