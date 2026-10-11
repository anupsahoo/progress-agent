import { useEffect, useState } from 'react';
import type { Benefits } from './types';
import { benefitsLabels as L } from './types';
import { benefitsService } from './service';

// Replaces hr-payroll/benefits_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function BenefitsList({ onOpen, onNew }: { onOpen: (row: Benefits) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Benefits[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Benefits; asc: boolean }>({ key: 'EmpNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      benefitsService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="benefits-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Benefits</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'EmpNum', asc: s.key === 'EmpNum' ? !s.asc : true }))}>{L.EmpNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'HealthCare', asc: s.key === 'HealthCare' ? !s.asc : true }))}>{L.HealthCare}</th>
            <th onClick={() => setSort((s) => ({ key: 'LifeInsurance', asc: s.key === 'LifeInsurance' ? !s.asc : true }))}>{L.LifeInsurance}</th>
            <th onClick={() => setSort((s) => ({ key: 'Pension401K', asc: s.key === 'Pension401K' ? !s.asc : true }))}>{L.Pension401K}</th>
            <th onClick={() => setSort((s) => ({ key: 'StockPurchase', asc: s.key === 'StockPurchase' ? !s.asc : true }))}>{L.StockPurchase}</th>
            <th onClick={() => setSort((s) => ({ key: 'MedicalSpending', asc: s.key === 'MedicalSpending' ? !s.asc : true }))}>{L.MedicalSpending}</th>
            <th onClick={() => setSort((s) => ({ key: 'DependentCare', asc: s.key === 'DependentCare' ? !s.asc : true }))}>{L.DependentCare}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.EmpNum)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.EmpNum ?? '')}</td>
              <td>{String(r.HealthCare ?? '')}</td>
              <td>{String(r.LifeInsurance ?? '')}</td>
              <td>{String(r.Pension401K ?? '')}</td>
              <td>{String(r.StockPurchase ?? '')}</td>
              <td>{String(r.MedicalSpending ?? '')}</td>
              <td>{String(r.DependentCare ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
