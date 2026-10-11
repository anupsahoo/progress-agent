import type { POLine } from './types';
import { pOLineLabels as L } from './types';

// Replaces po_line_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function POLineDetail({ row, onEdit, onBack }: { row: POLine; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="po-line-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Linenum}</dt><dd data-testid="detail-Linenum">{String(row.Linenum ?? '')}</dd>
        <dt>{L.Itemnum}</dt><dd data-testid="detail-Itemnum">{String(row.Itemnum ?? '')}</dd>
        <dt>{L.Price}</dt><dd data-testid="detail-Price">{String(row.Price ?? '')}</dd>
        <dt>{L.Qty}</dt><dd data-testid="detail-Qty">{String(row.Qty ?? '')}</dd>
        <dt>{L.Discount}</dt><dd data-testid="detail-Discount">{String(row.Discount ?? '')}</dd>
        <dt>{L.ExtendedPrice}</dt><dd data-testid="detail-ExtendedPrice">{String(row.ExtendedPrice ?? '')}</dd>
        <dt>{L.PONum}</dt><dd data-testid="detail-PONum">{String(row.PONum ?? '')}</dd>
        <dt>{L.POLineStatus}</dt><dd data-testid="detail-POLineStatus">{String(row.POLineStatus ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
