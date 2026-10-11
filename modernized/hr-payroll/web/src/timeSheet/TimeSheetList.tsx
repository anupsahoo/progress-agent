import { useEffect, useState } from 'react';
import type { TimeSheet } from './types';
import { timeSheetLabels as L } from './types';
import { timeSheetService } from './service';

// Replaces hr-payroll/time_sheet_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function TimeSheetList({ onOpen, onNew }: { onOpen: (row: TimeSheet) => void; onNew: () => void }) {
  const [rows, setRows] = useState<TimeSheet[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof TimeSheet; asc: boolean }>({ key: 'EmpNum', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      timeSheetService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="time-sheet-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>TimeSheet</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'EmpNum', asc: s.key === 'EmpNum' ? !s.asc : true }))}>{L.EmpNum}</th>
            <th onClick={() => setSort((s) => ({ key: 'DayRecorded', asc: s.key === 'DayRecorded' ? !s.asc : true }))}>{L.DayRecorded}</th>
            <th onClick={() => setSort((s) => ({ key: 'TypeRecorded', asc: s.key === 'TypeRecorded' ? !s.asc : true }))}>{L.TypeRecorded}</th>
            <th onClick={() => setSort((s) => ({ key: 'AMTimeIn', asc: s.key === 'AMTimeIn' ? !s.asc : true }))}>{L.AMTimeIn}</th>
            <th onClick={() => setSort((s) => ({ key: 'AMTimeOut', asc: s.key === 'AMTimeOut' ? !s.asc : true }))}>{L.AMTimeOut}</th>
            <th onClick={() => setSort((s) => ({ key: 'PMTimeIn', asc: s.key === 'PMTimeIn' ? !s.asc : true }))}>{L.PMTimeIn}</th>
            <th onClick={() => setSort((s) => ({ key: 'PMTimeOut', asc: s.key === 'PMTimeOut' ? !s.asc : true }))}>{L.PMTimeOut}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.EmpNum) + '|' + String(r.DayRecorded)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.EmpNum ?? '')}</td>
              <td>{String(r.DayRecorded ?? '')}</td>
              <td>{String(r.TypeRecorded ?? '')}</td>
              <td>{String(r.AMTimeIn ?? '')}</td>
              <td>{String(r.AMTimeOut ?? '')}</td>
              <td>{String(r.PMTimeIn ?? '')}</td>
              <td>{String(r.PMTimeOut ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
