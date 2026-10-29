import type { BillTo } from './types';
import { billToLabels as L } from './types';

// Replaces bill_to_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function BillToDetail({ row, onEdit, onBack }: { row: BillTo; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="bill-to-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.CustNum}</dt><dd data-testid="detail-CustNum">{String(row.CustNum ?? '')}</dd>
        <dt>{L.BillToID}</dt><dd data-testid="detail-BillToID">{String(row.BillToID ?? '')}</dd>
        <dt>{L.Name}</dt><dd data-testid="detail-Name">{String(row.Name ?? '')}</dd>
        <dt>{L.Address}</dt><dd data-testid="detail-Address">{String(row.Address ?? '')}</dd>
        <dt>{L.Address2}</dt><dd data-testid="detail-Address2">{String(row.Address2 ?? '')}</dd>
        <dt>{L.City}</dt><dd data-testid="detail-City">{String(row.City ?? '')}</dd>
        <dt>{L.State}</dt><dd data-testid="detail-State">{String(row.State ?? '')}</dd>
        <dt>{L.PostalCode}</dt><dd data-testid="detail-PostalCode">{String(row.PostalCode ?? '')}</dd>
        <dt>{L.Contact}</dt><dd data-testid="detail-Contact">{String(row.Contact ?? '')}</dd>
        <dt>{L.Phone}</dt><dd data-testid="detail-Phone">{String(row.Phone ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
