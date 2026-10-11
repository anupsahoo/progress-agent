import type { InventoryTrans } from './types';
import { inventoryTransLabels as L } from './types';

// Replaces inventory_trans_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function InventoryTransDetail({ row, onEdit, onBack }: { row: InventoryTrans; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="inventory-trans-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.InvTransNum}</dt><dd data-testid="detail-InvTransNum">{String(row.InvTransNum ?? '')}</dd>
        <dt>{L.WarehouseNum}</dt><dd data-testid="detail-WarehouseNum">{String(row.WarehouseNum ?? '')}</dd>
        <dt>{L.BinNum}</dt><dd data-testid="detail-BinNum">{String(row.BinNum ?? '')}</dd>
        <dt>{L.Qty}</dt><dd data-testid="detail-Qty">{String(row.Qty ?? '')}</dd>
        <dt>{L.Itemnum}</dt><dd data-testid="detail-Itemnum">{String(row.Itemnum ?? '')}</dd>
        <dt>{L.TransDate}</dt><dd data-testid="detail-TransDate">{String(row.TransDate ?? '')}</dd>
        <dt>{L.InvType}</dt><dd data-testid="detail-InvType">{String(row.InvType ?? '')}</dd>
        <dt>{L.PONum}</dt><dd data-testid="detail-PONum">{String(row.PONum ?? '')}</dd>
        <dt>{L.Ordernum}</dt><dd data-testid="detail-Ordernum">{String(row.Ordernum ?? '')}</dd>
        <dt>{L.Transtime}</dt><dd data-testid="detail-Transtime">{String(row.Transtime ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
