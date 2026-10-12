import { useEffect, useState } from 'react';
import type { Order } from './types';
import { orderLabels as L } from './types';
import { orderService } from './service';

// Replaces reporting-batch/order_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function OrderList({ onOpen }: { onOpen: (row: Order) => void }) {
  const [rows, setRows] = useState<Order[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Order; asc: boolean }>({ key: 'Ordernum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      orderService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="order-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Order</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'Ordernum', asc: s.key === 'Ordernum' ? !s.asc : true }))}>{L.Ordernum}</th>
            <th onClick={() => setSort((s) => ({ key: 'CustNum', asc: s.key === 'CustNum' ? !s.asc : true }))}>{L.CustNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'OrderDate', asc: s.key === 'OrderDate' ? !s.asc : true }))}>{L.OrderDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'ShipDate', asc: s.key === 'ShipDate' ? !s.asc : true }))}>{L.ShipDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'PromiseDate', asc: s.key === 'PromiseDate' ? !s.asc : true }))}>{L.PromiseDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'Carrier', asc: s.key === 'Carrier' ? !s.asc : true }))}>{L.Carrier}</th>
            <th onClick={() => setSort((s) => ({ key: 'Instructions', asc: s.key === 'Instructions' ? !s.asc : true }))}>{L.Instructions}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.Ordernum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.Ordernum ?? '')}</td>
              <td>{String(r.CustNum ?? '')}</td>
              <td>{String(r.OrderDate ?? '')}</td>
              <td>{String(r.ShipDate ?? '')}</td>
              <td>{String(r.PromiseDate ?? '')}</td>
              <td>{String(r.Carrier ?? '')}</td>
              <td>{String(r.Instructions ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
