import { useEffect, useState } from 'react';
import type { InventoryTrans } from './types';
import { inventoryTransLabels as L } from './types';
import { inventoryTransService } from './service';

// Replaces inventory/inventory_trans_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function InventoryTransList({ onOpen, onNew }: { onOpen: (row: InventoryTrans) => void; onNew: () => void }) {
  const [rows, setRows] = useState<InventoryTrans[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof InventoryTrans; asc: boolean }>({ key: 'InvTransNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      inventoryTransService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="inventory-trans-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>InventoryTrans</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'InvTransNum', asc: s.key === 'InvTransNum' ? !s.asc : true }))}>{L.InvTransNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'WarehouseNum', asc: s.key === 'WarehouseNum' ? !s.asc : true }))}>{L.WarehouseNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'BinNum', asc: s.key === 'BinNum' ? !s.asc : true }))}>{L.BinNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'Qty', asc: s.key === 'Qty' ? !s.asc : true }))}>{L.Qty}</th>
            <th onClick={() => setSort((s) => ({ key: 'Itemnum', asc: s.key === 'Itemnum' ? !s.asc : true }))}>{L.Itemnum}</th>
            <th onClick={() => setSort((s) => ({ key: 'TransDate', asc: s.key === 'TransDate' ? !s.asc : true }))}>{L.TransDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'InvType', asc: s.key === 'InvType' ? !s.asc : true }))}>{L.InvType}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.InvTransNum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.InvTransNum ?? '')}</td>
              <td>{String(r.WarehouseNum ?? '')}</td>
              <td>{String(r.BinNum ?? '')}</td>
              <td>{String(r.Qty ?? '')}</td>
              <td>{String(r.Itemnum ?? '')}</td>
              <td>{String(r.TransDate ?? '')}</td>
              <td>{String(r.InvType ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
