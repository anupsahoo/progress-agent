import { useEffect, useState } from 'react';
import type { Invoice } from './types';
import { invoiceLabels as L } from './types';
import { invoiceService } from './service';

// Replaces billing-invoicing/invoice_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function InvoiceList({ onOpen, onNew }: { onOpen: (row: Invoice) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Invoice[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Invoice; asc: boolean }>({ key: 'Invoicenum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      invoiceService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="invoice-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Invoice</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'Invoicenum', asc: s.key === 'Invoicenum' ? !s.asc : true }))}>{L.Invoicenum}</th>
            <th onClick={() => setSort((s) => ({ key: 'CustNum', asc: s.key === 'CustNum' ? !s.asc : true }))}>{L.CustNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'InvoiceDate', asc: s.key === 'InvoiceDate' ? !s.asc : true }))}>{L.InvoiceDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'Amount', asc: s.key === 'Amount' ? !s.asc : true }))}>{L.Amount}</th>
            <th onClick={() => setSort((s) => ({ key: 'TotalPaid', asc: s.key === 'TotalPaid' ? !s.asc : true }))}>{L.TotalPaid}</th>
            <th onClick={() => setSort((s) => ({ key: 'Adjustment', asc: s.key === 'Adjustment' ? !s.asc : true }))}>{L.Adjustment}</th>
            <th onClick={() => setSort((s) => ({ key: 'OrderNum', asc: s.key === 'OrderNum' ? !s.asc : true }))}>{L.OrderNum}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.Invoicenum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.Invoicenum ?? '')}</td>
              <td>{String(r.CustNum ?? '')}</td>
              <td>{String(r.InvoiceDate ?? '')}</td>
              <td>{String(r.Amount ?? '')}</td>
              <td>{String(r.TotalPaid ?? '')}</td>
              <td>{String(r.Adjustment ?? '')}</td>
              <td>{String(r.OrderNum ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
