import { useEffect, useState } from 'react';
import type { Department } from './types';
import { departmentLabels as L } from './types';
import { departmentService } from './service';

// Replaces hr-payroll/department_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function DepartmentList({ onOpen, onNew }: { onOpen: (row: Department) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Department[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Department; asc: boolean }>({ key: 'DeptCode', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      departmentService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="department-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Department</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'DeptCode', asc: s.key === 'DeptCode' ? !s.asc : true }))}>{L.DeptCode}</th>
            <th onClick={() => setSort((s) => ({ key: 'DeptName', asc: s.key === 'DeptName' ? !s.asc : true }))}>{L.DeptName}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.DeptCode)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.DeptCode ?? '')}</td>
              <td>{String(r.DeptName ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
