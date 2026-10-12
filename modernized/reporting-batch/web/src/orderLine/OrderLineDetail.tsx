import type { OrderLine } from './types';
import { orderLineLabels as L } from './types';

// Replaces order_line_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function OrderLineDetail({ row, onEdit, onBack }: { row: OrderLine; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="order-line-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Ordernum}</dt><dd data-testid="detail-Ordernum">{String(row.Ordernum ?? '')}</dd>
        <dt>{L.Linenum}</dt><dd data-testid="detail-Linenum">{String(row.Linenum ?? '')}</dd>
        <dt>{L.Itemnum}</dt><dd data-testid="detail-Itemnum">{String(row.Itemnum ?? '')}</dd>
        <dt>{L.Price}</dt><dd data-testid="detail-Price">{String(row.Price ?? '')}</dd>
        <dt>{L.Qty}</dt><dd data-testid="detail-Qty">{String(row.Qty ?? '')}</dd>
        <dt>{L.Discount}</dt><dd data-testid="detail-Discount">{String(row.Discount ?? '')}</dd>
        <dt>{L.ExtendedPrice}</dt><dd data-testid="detail-ExtendedPrice">{String(row.ExtendedPrice ?? '')}</dd>
        <dt>{L.OrderLineStatus}</dt><dd data-testid="detail-OrderLineStatus">{String(row.OrderLineStatus ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
    </section>
  );
}
