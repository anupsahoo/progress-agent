import { useEffect, useState } from 'react';
import type { Warehouse } from './types';
import { warehouseLabels as L } from './types';
import { warehouseService } from './service';

// Replaces warehousing/warehouse_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function WarehouseList({ onOpen, onNew }: { onOpen: (row: Warehouse) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Warehouse[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Warehouse; asc: boolean }>({ key: 'WarehouseNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      warehouseService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="warehouse-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Warehouse</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'WarehouseNum', asc: s.key === 'WarehouseNum' ? !s.asc : true }))}>{L.WarehouseNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'WarehouseName', asc: s.key === 'WarehouseName' ? !s.asc : true }))}>{L.WarehouseName}</th>
            <th onClick={() => setSort((s) => ({ key: 'Country', asc: s.key === 'Country' ? !s.asc : true }))}>{L.Country}</th>
            <th onClick={() => setSort((s) => ({ key: 'Address', asc: s.key === 'Address' ? !s.asc : true }))}>{L.Address}</th>
            <th onClick={() => setSort((s) => ({ key: 'Address2', asc: s.key === 'Address2' ? !s.asc : true }))}>{L.Address2}</th>
            <th onClick={() => setSort((s) => ({ key: 'City', asc: s.key === 'City' ? !s.asc : true }))}>{L.City}</th>
            <th onClick={() => setSort((s) => ({ key: 'State', asc: s.key === 'State' ? !s.asc : true }))}>{L.State}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.WarehouseNum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.WarehouseNum ?? '')}</td>
              <td>{String(r.WarehouseName ?? '')}</td>
              <td>{String(r.Country ?? '')}</td>
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
