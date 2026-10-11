import { useEffect, useState } from 'react';
import type { SupplierItemXref } from './types';
import { supplierItemXrefLabels as L } from './types';
import { supplierItemXrefService } from './service';

// Replaces supplier-management/supplier_item_xref_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function SupplierItemXrefList({ onOpen, onNew }: { onOpen: (row: SupplierItemXref) => void; onNew: () => void }) {
  const [rows, setRows] = useState<SupplierItemXref[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof SupplierItemXref; asc: boolean }>({ key: 'SupplierIDNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      supplierItemXrefService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="supplier-item-xref-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>SupplierItemXref</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'SupplierIDNum', asc: s.key === 'SupplierIDNum' ? !s.asc : true }))}>{L.SupplierIDNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'Itemnum', asc: s.key === 'Itemnum' ? !s.asc : true }))}>{L.Itemnum}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.SupplierIDNum) + '|' + String(r.Itemnum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.SupplierIDNum ?? '')}</td>
              <td>{String(r.Itemnum ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
