import type { Warehouse } from './types';
import { warehouseLabels as L } from './types';

// Replaces warehouse_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function WarehouseDetail({ row, onEdit, onBack }: { row: Warehouse; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="warehouse-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.WarehouseNum}</dt><dd data-testid="detail-WarehouseNum">{String(row.WarehouseNum ?? '')}</dd>
        <dt>{L.WarehouseName}</dt><dd data-testid="detail-WarehouseName">{String(row.WarehouseName ?? '')}</dd>
        <dt>{L.Country}</dt><dd data-testid="detail-Country">{String(row.Country ?? '')}</dd>
        <dt>{L.Address}</dt><dd data-testid="detail-Address">{String(row.Address ?? '')}</dd>
        <dt>{L.Address2}</dt><dd data-testid="detail-Address2">{String(row.Address2 ?? '')}</dd>
        <dt>{L.City}</dt><dd data-testid="detail-City">{String(row.City ?? '')}</dd>
        <dt>{L.State}</dt><dd data-testid="detail-State">{String(row.State ?? '')}</dd>
        <dt>{L.PostalCode}</dt><dd data-testid="detail-PostalCode">{String(row.PostalCode ?? '')}</dd>
        <dt>{L.Phone}</dt><dd data-testid="detail-Phone">{String(row.Phone ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
