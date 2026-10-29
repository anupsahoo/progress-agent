import type { LocalDefault } from './types';
import { localDefaultLabels as L } from './types';

// Replaces local_default_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function LocalDefaultDetail({ row, onEdit, onBack }: { row: LocalDefault; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="local-default-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.Country}</dt><dd data-testid="detail-Country">{String(row.Country ?? '')}</dd>
        <dt>{L.Region1Label}</dt><dd data-testid="detail-Region1Label">{String(row.Region1Label ?? '')}</dd>
        <dt>{L.Region2Label}</dt><dd data-testid="detail-Region2Label">{String(row.Region2Label ?? '')}</dd>
        <dt>{L.PostalLabel}</dt><dd data-testid="detail-PostalLabel">{String(row.PostalLabel ?? '')}</dd>
        <dt>{L.PostalFormat}</dt><dd data-testid="detail-PostalFormat">{String(row.PostalFormat ?? '')}</dd>
        <dt>{L.TelFormat}</dt><dd data-testid="detail-TelFormat">{String(row.TelFormat ?? '')}</dd>
        <dt>{L.CurrencySymbol}</dt><dd data-testid="detail-CurrencySymbol">{String(row.CurrencySymbol ?? '')}</dd>
        <dt>{L.DateFormat}</dt><dd data-testid="detail-DateFormat">{String(row.DateFormat ?? '')}</dd>
        <dt>{L.LocalDefNum}</dt><dd data-testid="detail-LocalDefNum">{String(row.LocalDefNum ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
