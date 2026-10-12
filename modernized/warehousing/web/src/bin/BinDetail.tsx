import type { Bin } from './types';
import { binLabels as L } from './types';

// Replaces bin_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function BinDetail({ row, onEdit, onBack }: { row: Bin; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="bin-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.WarehouseNum}</dt><dd data-testid="detail-WarehouseNum">{String(row.WarehouseNum ?? '')}</dd>
        <dt>{L.Itemnum}</dt><dd data-testid="detail-Itemnum">{String(row.Itemnum ?? '')}</dd>
        <dt>{L.Qty}</dt><dd data-testid="detail-Qty">{String(row.Qty ?? '')}</dd>
        <dt>{L.BinNum}</dt><dd data-testid="detail-BinNum">{String(row.BinNum ?? '')}</dd>
        <dt>{L.BinName}</dt><dd data-testid="detail-BinName">{String(row.BinName ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
