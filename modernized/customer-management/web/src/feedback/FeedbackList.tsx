import { useEffect, useState } from 'react';
import type { Feedback } from './types';
import { feedbackLabels as L } from './types';
import { feedbackService } from './service';

// Replaces customer-management/feedback_browse.w (DEFINE BROWSE, START-SEARCH sort, BEGINS filter).
export function FeedbackList({ onOpen, onNew }: { onOpen: (row: Feedback) => void; onNew: () => void }) {
  const [rows, setRows] = useState<Feedback[]>([]);
  const [total, setTotal] = useState(0);
  const [q, setQ] = useState('');
  const [sort, setSort] = useState<{ key: keyof Feedback; asc: boolean }>({ key: 'Department', asc: true });
  const [error, setError] = useState('');

  useEffect(() => {
    const id = setTimeout(() => {
      feedbackService.list(q).then((r) => { setRows(r.items); setTotal(r.total); setError(''); }).catch((e) => setError(String(e.message || e)));
    }, 200);
    return () => clearTimeout(id);
  }, [q]);

  const sorted = [...rows].sort((a, b) => {
    const x = a[sort.key] as any, y = b[sort.key] as any;
    return (x > y ? 1 : x < y ? -1 : 0) * (sort.asc ? 1 : -1);
  });

  return (
    <section data-testid="feedback-list">
      <header style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 12 }}>
        <h2 style={{ margin: 0 }}>Feedback</h2>
        <input data-testid="search" placeholder="Search" value={q} onChange={(e) => setQ(e.target.value)} />
        <span data-testid="total">{total} records</span>
        <button data-testid="new" onClick={onNew}>New</button>
      </header>
      {error && <div role="alert">{error}</div>}
      <table>
        <thead>
          <tr>
            <th onClick={() => setSort((s) => ({ key: 'Contact', asc: s.key === 'Contact' ? !s.asc : true }))}>{L.Contact}</th>
            <th onClick={() => setSort((s) => ({ key: 'Company', asc: s.key === 'Company' ? !s.asc : true }))}>{L.Company}</th>
            <th onClick={() => setSort((s) => ({ key: 'EmailAddress', asc: s.key === 'EmailAddress' ? !s.asc : true }))}>{L.EmailAddress}</th>
            <th onClick={() => setSort((s) => ({ key: 'Phone', asc: s.key === 'Phone' ? !s.asc : true }))}>{L.Phone}</th>
            <th onClick={() => setSort((s) => ({ key: 'Fax', asc: s.key === 'Fax' ? !s.asc : true }))}>{L.Fax}</th>
            <th onClick={() => setSort((s) => ({ key: 'Comments', asc: s.key === 'Comments' ? !s.asc : true }))}>{L.Comments}</th>
            <th onClick={() => setSort((s) => ({ key: 'Department', asc: s.key === 'Department' ? !s.asc : true }))}>{L.Department}</th>
          </tr>
        </thead>
        <tbody>
          {sorted.map((r) => (
            <tr key={String(r.Department)} data-testid="row" onDoubleClick={() => onOpen(r)}>
              <td>{String(r.Contact ?? '')}</td>
              <td>{String(r.Company ?? '')}</td>
              <td>{String(r.EmailAddress ?? '')}</td>
              <td>{String(r.Phone ?? '')}</td>
              <td>{String(r.Fax ?? '')}</td>
              <td>{String(r.Comments ?? '')}</td>
              <td>{String(r.Department ?? '')}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
