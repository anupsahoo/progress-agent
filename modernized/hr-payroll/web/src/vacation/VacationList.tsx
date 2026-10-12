import { useEffect, useState } from 'react';
import type { Vacation } from './types';
import { vacationLabels as L } from './types';
import { vacationService } from './service';

// Replaces hr-payroll/vacation_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function VacationList({ onOpen, onNew }: { onOpen: (row: Vacation) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Vacation[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Vacation; asc: boolean }>({ key: 'EmpNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      vacationService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="vacation-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Vacation</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'EmpNum', asc: s.key === 'EmpNum' ? !s.asc : true }))}>{L.EmpNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'StartDate', asc: s.key === 'StartDate' ? !s.asc : true }))}>{L.StartDate}</th>
            <th onClick={() => setSort((s) => ({ key: 'EndDate', asc: s.key === 'EndDate' ? !s.asc : true }))}>{L.EndDate}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.EmpNum) + '|' + String(r.StartDate)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.EmpNum ?? '')}</td>
              <td>{String(r.StartDate ?? '')}</td>
              <td>{String(r.EndDate ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
