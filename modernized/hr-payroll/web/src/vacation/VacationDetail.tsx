import type { Vacation } from './types';
import { vacationLabels as L } from './types';

// Replaces vacation_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function VacationDetail({ row, onEdit, onBack }: { row: Vacation; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="vacation-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.EmpNum}</dt><dd data-testid="detail-EmpNum">{String(row.EmpNum ?? '')}</dd>
        <dt>{L.StartDate}</dt><dd data-testid="detail-StartDate">{String(row.StartDate ?? '')}</dd>
        <dt>{L.EndDate}</dt><dd data-testid="detail-EndDate">{String(row.EndDate ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
