import type { Item } from './types';
import { itemLabels as L } from './types';

// Replaces item_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function ItemDetail({ row, onEdit, onBack }: { row: Item; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="item-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Itemnum}</dt><dd data-testid="detail-Itemnum">{String(row.Itemnum ?? '')}</dd>
        <dt>{L.ItemName}</dt><dd data-testid="detail-ItemName">{String(row.ItemName ?? '')}</dd>
        <dt>{L.Price}</dt><dd data-testid="detail-Price">{String(row.Price ?? '')}</dd>
        <dt>{L.Onhand}</dt><dd data-testid="detail-Onhand">{String(row.Onhand ?? '')}</dd>
        <dt>{L.Allocated}</dt><dd data-testid="detail-Allocated">{String(row.Allocated ?? '')}</dd>
        <dt>{L.ReOrder}</dt><dd data-testid="detail-ReOrder">{String(row.ReOrder ?? '')}</dd>
        <dt>{L.OnOrder}</dt><dd data-testid="detail-OnOrder">{String(row.OnOrder ?? '')}</dd>
        <dt>{L.CatPage}</dt><dd data-testid="detail-CatPage">{String(row.CatPage ?? '')}</dd>
        <dt>{L.CatDescription}</dt><dd data-testid="detail-CatDescription">{String(row.CatDescription ?? '')}</dd>
        <dt>{L.Category1}</dt><dd data-testid="detail-Category1">{String(row.Category1 ?? '')}</dd>
        <dt>{L.Category2}</dt><dd data-testid="detail-Category2">{String(row.Category2 ?? '')}</dd>
        <dt>{L.Special}</dt><dd data-testid="detail-Special">{String(row.Special ?? '')}</dd>
        <dt>{L.Weight}</dt><dd data-testid="detail-Weight">{String(row.Weight ?? '')}</dd>
        <dt>{L.Minqty}</dt><dd data-testid="detail-Minqty">{String(row.Minqty ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
