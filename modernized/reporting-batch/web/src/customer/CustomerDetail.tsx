import type { Customer } from './types';
import { customerLabels as L } from './types';

// Replaces customer_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function CustomerDetail({ row, onEdit, onBack }: { row: Customer; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="customer-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.CustNum}</dt><dd data-testid="detail-CustNum">{String(row.CustNum ?? '')}</dd>
        <dt>{L.Country}</dt><dd data-testid="detail-Country">{String(row.Country ?? '')}</dd>
        <dt>{L.Name}</dt><dd data-testid="detail-Name">{String(row.Name ?? '')}</dd>
        <dt>{L.Address}</dt><dd data-testid="detail-Address">{String(row.Address ?? '')}</dd>
        <dt>{L.Address2}</dt><dd data-testid="detail-Address2">{String(row.Address2 ?? '')}</dd>
        <dt>{L.City}</dt><dd data-testid="detail-City">{String(row.City ?? '')}</dd>
        <dt>{L.State}</dt><dd data-testid="detail-State">{String(row.State ?? '')}</dd>
        <dt>{L.PostalCode}</dt><dd data-testid="detail-PostalCode">{String(row.PostalCode ?? '')}</dd>
        <dt>{L.Contact}</dt><dd data-testid="detail-Contact">{String(row.Contact ?? '')}</dd>
        <dt>{L.Phone}</dt><dd data-testid="detail-Phone">{String(row.Phone ?? '')}</dd>
        <dt>{L.SalesRep}</dt><dd data-testid="detail-SalesRep">{String(row.SalesRep ?? '')}</dd>
        <dt>{L.CreditLimit}</dt><dd data-testid="detail-CreditLimit">{String(row.CreditLimit ?? '')}</dd>
        <dt>{L.Balance}</dt><dd data-testid="detail-Balance">{String(row.Balance ?? '')}</dd>
        <dt>{L.Terms}</dt><dd data-testid="detail-Terms">{String(row.Terms ?? '')}</dd>
        <dt>{L.Discount}</dt><dd data-testid="detail-Discount">{String(row.Discount ?? '')}</dd>
        <dt>{L.Comments}</dt><dd data-testid="detail-Comments">{String(row.Comments ?? '')}</dd>
        <dt>{L.Fax}</dt><dd data-testid="detail-Fax">{String(row.Fax ?? '')}</dd>
        <dt>{L.EmailAddress}</dt><dd data-testid="detail-EmailAddress">{String(row.EmailAddress ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
    </section>
  );
}
