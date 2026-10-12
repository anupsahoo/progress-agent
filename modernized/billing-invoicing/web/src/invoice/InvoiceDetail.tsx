import type { Invoice } from './types';
import { invoiceLabels as L } from './types';

// Replaces invoice_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function InvoiceDetail({ row, onEdit, onBack }: { row: Invoice; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="invoice-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Invoicenum}</dt><dd data-testid="detail-Invoicenum">{String(row.Invoicenum ?? '')}</dd>
        <dt>{L.CustNum}</dt><dd data-testid="detail-CustNum">{String(row.CustNum ?? '')}</dd>
        <dt>{L.InvoiceDate}</dt><dd data-testid="detail-InvoiceDate">{String(row.InvoiceDate ?? '')}</dd>
        <dt>{L.Amount}</dt><dd data-testid="detail-Amount">{String(row.Amount ?? '')}</dd>
        <dt>{L.TotalPaid}</dt><dd data-testid="detail-TotalPaid">{String(row.TotalPaid ?? '')}</dd>
        <dt>{L.Adjustment}</dt><dd data-testid="detail-Adjustment">{String(row.Adjustment ?? '')}</dd>
        <dt>{L.OrderNum}</dt><dd data-testid="detail-OrderNum">{String(row.OrderNum ?? '')}</dd>
        <dt>{L.ShipCharge}</dt><dd data-testid="detail-ShipCharge">{String(row.ShipCharge ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
