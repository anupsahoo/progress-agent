import type { Feedback } from './types';
import { feedbackLabels as L } from './types';

// Replaces feedback_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function FeedbackDetail({ row, onEdit, onBack }: { row: Feedback; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="feedback-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Contact}</dt><dd data-testid="detail-Contact">{String(row.Contact ?? '')}</dd>
        <dt>{L.Company}</dt><dd data-testid="detail-Company">{String(row.Company ?? '')}</dd>
        <dt>{L.EmailAddress}</dt><dd data-testid="detail-EmailAddress">{String(row.EmailAddress ?? '')}</dd>
        <dt>{L.Phone}</dt><dd data-testid="detail-Phone">{String(row.Phone ?? '')}</dd>
        <dt>{L.Fax}</dt><dd data-testid="detail-Fax">{String(row.Fax ?? '')}</dd>
        <dt>{L.Comments}</dt><dd data-testid="detail-Comments">{String(row.Comments ?? '')}</dd>
        <dt>{L.Department}</dt><dd data-testid="detail-Department">{String(row.Department ?? '')}</dd>
        <dt>{L.Rating}</dt><dd data-testid="detail-Rating">{String(row.Rating ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
