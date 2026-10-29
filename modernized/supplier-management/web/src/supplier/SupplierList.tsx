import { useEffect, useState } from 'react';
import type { Supplier } from './types';
import { supplierLabels as L } from './types';
import { supplierService } from './service';

// Replaces supplier-management/supplier_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function SupplierList({ onOpen, onNew }: { onOpen: (row: Supplier) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Supplier[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Supplier; asc: boolean }>({ key: 'SupplierIDNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      supplierService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="supplier-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Supplier</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'SupplierIDNum', asc: s.key === 'SupplierIDNum' ? !s.asc : true }))}>{L.SupplierIDNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'Name', asc: s.key === 'Name' ? !s.asc : true }))}>{L.Name}</th>
            <th onClick={() => setSort((s) => ({ key: 'Address', asc: s.key === 'Address' ? !s.asc : true }))}>{L.Address}</th>
            <th onClick={() => setSort((s) => ({ key: 'Address2', asc: s.key === 'Address2' ? !s.asc : true }))}>{L.Address2}</th>
            <th onClick={() => setSort((s) => ({ key: 'City', asc: s.key === 'City' ? !s.asc : true }))}>{L.City}</th>
            <th onClick={() => setSort((s) => ({ key: 'State', asc: s.key === 'State' ? !s.asc : true }))}>{L.State}</th>
            <th onClick={() => setSort((s) => ({ key: 'PostalCode', asc: s.key === 'PostalCode' ? !s.asc : true }))}>{L.PostalCode}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.SupplierIDNum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.SupplierIDNum ?? '')}</td>
              <td>{String(r.Name ?? '')}</td>
              <td>{String(r.Address ?? '')}</td>
              <td>{String(r.Address2 ?? '')}</td>
              <td>{String(r.City ?? '')}</td>
              <td>{String(r.State ?? '')}</td>
              <td>{String(r.PostalCode ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
