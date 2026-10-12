import { useEffect, useState } from 'react';
import type { State } from './types';
import { stateLabels as L } from './types';
import { stateService } from './service';

// Replaces sales-territories/state_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function StateList({ onOpen, onNew }: { onOpen: (row: State) => void; onNew: () => void }) {
  const [rows, setRows] = useState<State[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof State; asc: boolean }>({ key: 'State', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      stateService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="state-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>State</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'State', asc: s.key === 'State' ? !s.asc : true }))}>{L.State}</th>
            <th onClick={() => setSort((s) => ({ key: 'StateName', asc: s.key === 'StateName' ? !s.asc : true }))}>{L.StateName}</th>
            <th onClick={() => setSort((s) => ({ key: 'Region', asc: s.key === 'Region' ? !s.asc : true }))}>{L.Region}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.State)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.State ?? '')}</td>
              <td>{String(r.StateName ?? '')}</td>
              <td>{String(r.Region ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
