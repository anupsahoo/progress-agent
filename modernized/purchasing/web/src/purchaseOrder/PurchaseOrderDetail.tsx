import type { PurchaseOrder } from './types';
import { purchaseOrderLabels as L } from './types';

// Replaces purchase_order_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function PurchaseOrderDetail({ row, onEdit, onBack }: { row: PurchaseOrder; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="purchase-order-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.PONum}</dt><dd data-testid="detail-PONum">{String(row.PONum ?? '')}</dd>
        <dt>{L.DateEntered}</dt><dd data-testid="detail-DateEntered">{String(row.DateEntered ?? '')}</dd>
        <dt>{L.SupplierIDNum}</dt><dd data-testid="detail-SupplierIDNum">{String(row.SupplierIDNum ?? '')}</dd>
        <dt>{L.ReceiveDate}</dt><dd data-testid="detail-ReceiveDate">{String(row.ReceiveDate ?? '')}</dd>
        <dt>{L.POStatus}</dt><dd data-testid="detail-POStatus">{String(row.POStatus ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
