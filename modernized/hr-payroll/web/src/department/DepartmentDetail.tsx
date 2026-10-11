import type { Department } from './types';
import { departmentLabels as L } from './types';

// Replaces department_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function DepartmentDetail({ row, onEdit, onBack }: { row: Department; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="department-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.DeptCode}</dt><dd data-testid="detail-DeptCode">{String(row.DeptCode ?? '')}</dd>
        <dt>{L.DeptName}</dt><dd data-testid="detail-DeptName">{String(row.DeptName ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
