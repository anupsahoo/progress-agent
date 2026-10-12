import { useEffect, useState } from 'react';
import type { Family } from './types';
import { familyLabels as L } from './types';
import { familyService } from './service';

// Replaces hr-payroll/family_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function FamilyList({ onOpen, onNew }: { onOpen: (row: Family) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Family[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Family; asc: boolean }>({ key: 'EmpNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      familyService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="family-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Family</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'EmpNum', asc: s.key === 'EmpNum' ? !s.asc : true }))}>{L.EmpNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'RelativeName', asc: s.key === 'RelativeName' ? !s.asc : true }))}>{L.RelativeName}</th>
            <th onClick={() => setSort((s) => ({ key: 'Relation', asc: s.key === 'Relation' ? !s.asc : true }))}>{L.Relation}</th>
            <th onClick={() => setSort((s) => ({ key: 'Birthdate', asc: s.key === 'Birthdate' ? !s.asc : true }))}>{L.Birthdate}</th>
            <th onClick={() => setSort((s) => ({ key: 'CoveredOnBenefits', asc: s.key === 'CoveredOnBenefits' ? !s.asc : true }))}>{L.CoveredOnBenefits}</th>
            <th onClick={() => setSort((s) => ({ key: 'BenefitDate', asc: s.key === 'BenefitDate' ? !s.asc : true }))}>{L.BenefitDate}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.EmpNum) + '|' + String(r.RelativeName)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.EmpNum ?? '')}</td>
              <td>{String(r.RelativeName ?? '')}</td>
              <td>{String(r.Relation ?? '')}</td>
              <td>{String(r.Birthdate ?? '')}</td>
              <td>{String(r.CoveredOnBenefits ?? '')}</td>
              <td>{String(r.BenefitDate ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
