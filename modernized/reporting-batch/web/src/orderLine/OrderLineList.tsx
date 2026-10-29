import { useEffect, useState } from 'react';
import type { OrderLine } from './types';
import { orderLineLabels as L } from './types';
import { orderLineService } from './service';

// Replaces reporting-batch/order_line_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function OrderLineList({ onOpen }: { onOpen: (row: OrderLine) => void }) {
  const [rows, setRows] = useState<OrderLine[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof OrderLine; asc: boolean }>({ key: 'Ordernum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      orderLineService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="order-line-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>OrderLine</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'Ordernum', asc: s.key === 'Ordernum' ? !s.asc : true }))}>{L.Ordernum}</th>
            <th onClick={() => setSort((s) => ({ key: 'Linenum', asc: s.key === 'Linenum' ? !s.asc : true }))}>{L.Linenum}</th>
            <th onClick={() => setSort((s) => ({ key: 'Itemnum', asc: s.key === 'Itemnum' ? !s.asc : true }))}>{L.Itemnum}</th>
            <th onClick={() => setSort((s) => ({ key: 'Price', asc: s.key === 'Price' ? !s.asc : true }))}>{L.Price}</th>
            <th onClick={() => setSort((s) => ({ key: 'Qty', asc: s.key === 'Qty' ? !s.asc : true }))}>{L.Qty}</th>
            <th onClick={() => setSort((s) => ({ key: 'Discount', asc: s.key === 'Discount' ? !s.asc : true }))}>{L.Discount}</th>
            <th onClick={() => setSort((s) => ({ key: 'ExtendedPrice', asc: s.key === 'ExtendedPrice' ? !s.asc : true }))}>{L.ExtendedPrice}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.Ordernum) + '|' + String(r.Linenum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.Ordernum ?? '')}</td>
              <td>{String(r.Linenum ?? '')}</td>
              <td>{String(r.Itemnum ?? '')}</td>
              <td>{String(r.Price ?? '')}</td>
              <td>{String(r.Qty ?? '')}</td>
              <td>{String(r.Discount ?? '')}</td>
              <td>{String(r.ExtendedPrice ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
