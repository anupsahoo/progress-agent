import type { Order } from './types';
import { orderLabels as L } from './types';

// Replaces order_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function OrderDetail({ row, onEdit, onBack }: { row: Order; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="order-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Ordernum}</dt><dd data-testid="detail-Ordernum">{String(row.Ordernum ?? '')}</dd>
        <dt>{L.CustNum}</dt><dd data-testid="detail-CustNum">{String(row.CustNum ?? '')}</dd>
        <dt>{L.OrderDate}</dt><dd data-testid="detail-OrderDate">{String(row.OrderDate ?? '')}</dd>
        <dt>{L.ShipDate}</dt><dd data-testid="detail-ShipDate">{String(row.ShipDate ?? '')}</dd>
        <dt>{L.PromiseDate}</dt><dd data-testid="detail-PromiseDate">{String(row.PromiseDate ?? '')}</dd>
        <dt>{L.Carrier}</dt><dd data-testid="detail-Carrier">{String(row.Carrier ?? '')}</dd>
        <dt>{L.Instructions}</dt><dd data-testid="detail-Instructions">{String(row.Instructions ?? '')}</dd>
        <dt>{L.PO}</dt><dd data-testid="detail-PO">{String(row.PO ?? '')}</dd>
        <dt>{L.Terms}</dt><dd data-testid="detail-Terms">{String(row.Terms ?? '')}</dd>
        <dt>{L.SalesRep}</dt><dd data-testid="detail-SalesRep">{String(row.SalesRep ?? '')}</dd>
        <dt>{L.BillToID}</dt><dd data-testid="detail-BillToID">{String(row.BillToID ?? '')}</dd>
        <dt>{L.ShipToID}</dt><dd data-testid="detail-ShipToID">{String(row.ShipToID ?? '')}</dd>
        <dt>{L.OrderStatus}</dt><dd data-testid="detail-OrderStatus">{String(row.OrderStatus ?? '')}</dd>
        <dt>{L.WarehouseNum}</dt><dd data-testid="detail-WarehouseNum">{String(row.WarehouseNum ?? '')}</dd>
        <dt>{L.Creditcard}</dt><dd data-testid="detail-Creditcard">{String(row.Creditcard ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
    </section>
  );
}
