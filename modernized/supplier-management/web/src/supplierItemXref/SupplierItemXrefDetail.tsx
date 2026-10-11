import type { SupplierItemXref } from './types';
import { supplierItemXrefLabels as L } from './types';

// Replaces supplier_item_xref_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function SupplierItemXrefDetail({ row, onEdit, onBack }: { row: SupplierItemXref; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="supplier-item-xref-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.SupplierIDNum}</dt><dd data-testid="detail-SupplierIDNum">{String(row.SupplierIDNum ?? '')}</dd>
        <dt>{L.Itemnum}</dt><dd data-testid="detail-Itemnum">{String(row.Itemnum ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
