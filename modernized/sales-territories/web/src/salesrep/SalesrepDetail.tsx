import type { Salesrep } from './types';
import { salesrepLabels as L } from './types';

// Replaces salesrep_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function SalesrepDetail({ row, onEdit, onBack }: { row: Salesrep; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="salesrep-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.SalesRep}</dt><dd data-testid="detail-SalesRep">{String(row.SalesRep ?? '')}</dd>
        <dt>{L.RepName}</dt><dd data-testid="detail-RepName">{String(row.RepName ?? '')}</dd>
        <dt>{L.Region}</dt><dd data-testid="detail-Region">{String(row.Region ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
