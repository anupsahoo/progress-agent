import { useEffect, useState } from 'react';
import type { PurchaseOrder } from './types';
import { purchaseOrderLabels as L } from './types';
import { purchaseOrderService } from './service';

// Replaces purchasing/purchase_order_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function PurchaseOrderList({ onOpen, onNew }: { onOpen: (row: PurchaseOrder) => void; onNew: () => void }) {
  const [rows, setRows] = useState<PurchaseOrder[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof PurchaseOrder; asc: boolean }>({ key: 'PONum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      purchaseOrderService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="purchase-order-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>PurchaseOrder</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'PONum', asc: s.key === 'PONum' ? !s.asc : true }))}>{L.PONum}</th>
            <th onClick={() => setSort((s) => ({ key: 'DateEntered', asc: s.key === 'DateEntered' ? !s.asc : true }))}>{L.DateEntered}</th>
            <th onClick={() => setSort((s) => ({ key: 'SupplierIDNum', asc: s.key === 'SupplierIDNum' ? !s.asc : true }))}>{L.SupplierIDNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'ReceiveDate', asc: s.key === 'ReceiveDate' ? !s.asc : true }))}>{L.ReceiveDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'POStatus', asc: s.key === 'POStatus' ? !s.asc : true }))}>{L.POStatus}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.PONum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.PONum ?? '')}</td>
              <td>{String(r.DateEntered ?? '')}</td>
              <td>{String(r.SupplierIDNum ?? '')}</td>
              <td>{String(r.ReceiveDate ?? '')}</td>
              <td>{String(r.POStatus ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
