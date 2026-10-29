import { useEffect, useState } from 'react';
import type { Item } from './types';
import { itemLabels as L } from './types';
import { itemService } from './service';

// Replaces inventory/item_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function ItemList({ onOpen, onNew }: { onOpen: (row: Item) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Item[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Item; asc: boolean }>({ key: 'Itemnum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      itemService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="item-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Item</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'Itemnum', asc: s.key === 'Itemnum' ? !s.asc : true }))}>{L.Itemnum}</th>
            <th onClick={() => setSort((s) => ({ key: 'ItemName', asc: s.key === 'ItemName' ? !s.asc : true }))}>{L.ItemName}</th>
            <th onClick={() => setSort((s) => ({ key: 'Price', asc: s.key === 'Price' ? !s.asc : true }))}>{L.Price}</th>
            <th onClick={() => setSort((s) => ({ key: 'Onhand', asc: s.key === 'Onhand' ? !s.asc : true }))}>{L.Onhand}</th>
            <th onClick={() => setSort((s) => ({ key: 'Allocated', asc: s.key === 'Allocated' ? !s.asc : true }))}>{L.Allocated}</th>
            <th onClick={() => setSort((s) => ({ key: 'ReOrder', asc: s.key === 'ReOrder' ? !s.asc : true }))}>{L.ReOrder}</th>
            <th onClick={() => setSort((s) => ({ key: 'OnOrder', asc: s.key === 'OnOrder' ? !s.asc : true }))}>{L.OnOrder}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.Itemnum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.Itemnum ?? '')}</td>
              <td>{String(r.ItemName ?? '')}</td>
              <td>{String(r.Price ?? '')}</td>
              <td>{String(r.Onhand ?? '')}</td>
              <td>{String(r.Allocated ?? '')}</td>
              <td>{String(r.ReOrder ?? '')}</td>
              <td>{String(r.OnOrder ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
