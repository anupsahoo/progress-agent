import type { Supplier } from './types';
import { supplierLabels as L } from './types';

// Replaces supplier_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function SupplierDetail({ row, onEdit, onBack }: { row: Supplier; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="supplier-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.SupplierIDNum}</dt><dd data-testid="detail-SupplierIDNum">{String(row.SupplierIDNum ?? '')}</dd>
        <dt>{L.Name}</dt><dd data-testid="detail-Name">{String(row.Name ?? '')}</dd>
        <dt>{L.Address}</dt><dd data-testid="detail-Address">{String(row.Address ?? '')}</dd>
        <dt>{L.Address2}</dt><dd data-testid="detail-Address2">{String(row.Address2 ?? '')}</dd>
        <dt>{L.City}</dt><dd data-testid="detail-City">{String(row.City ?? '')}</dd>
        <dt>{L.State}</dt><dd data-testid="detail-State">{String(row.State ?? '')}</dd>
        <dt>{L.PostalCode}</dt><dd data-testid="detail-PostalCode">{String(row.PostalCode ?? '')}</dd>
        <dt>{L.Country}</dt><dd data-testid="detail-Country">{String(row.Country ?? '')}</dd>
        <dt>{L.Phone}</dt><dd data-testid="detail-Phone">{String(row.Phone ?? '')}</dd>
        <dt>{L.Comments}</dt><dd data-testid="detail-Comments">{String(row.Comments ?? '')}</dd>
        <dt>{L.Password}</dt><dd data-testid="detail-Password">{String(row.Password ?? '')}</dd>
        <dt>{L.LoginDate}</dt><dd data-testid="detail-LoginDate">{String(row.LoginDate ?? '')}</dd>
        <dt>{L.ShipAmount}</dt><dd data-testid="detail-ShipAmount">{String(row.ShipAmount ?? '')}</dd>
        <dt>{L.Discount}</dt><dd data-testid="detail-Discount">{String(row.Discount ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
