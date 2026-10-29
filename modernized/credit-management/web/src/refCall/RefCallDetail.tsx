import type { RefCall } from './types';
import { refCallLabels as L } from './types';

// Replaces ref_call_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function RefCallDetail({ row, onEdit, onBack }: { row: RefCall; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="ref-call-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.CallNum}</dt><dd data-testid="detail-CallNum">{String(row.CallNum ?? '')}</dd>
        <dt>{L.CustNum}</dt><dd data-testid="detail-CustNum">{String(row.CustNum ?? '')}</dd>
        <dt>{L.CallDate}</dt><dd data-testid="detail-CallDate">{String(row.CallDate ?? '')}</dd>
        <dt>{L.SalesRep}</dt><dd data-testid="detail-SalesRep">{String(row.SalesRep ?? '')}</dd>
        <dt>{L.Parent}</dt><dd data-testid="detail-Parent">{String(row.Parent ?? '')}</dd>
        <dt>{L.Txt}</dt><dd data-testid="detail-Txt">{String(row.Txt ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
