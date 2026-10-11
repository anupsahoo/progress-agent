import type { State } from './types';
import { stateLabels as L } from './types';

// Replaces state_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function StateDetail({ row, onEdit, onBack }: { row: State; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="state-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.State}</dt><dd data-testid="detail-State">{String(row.State ?? '')}</dd>
        <dt>{L.StateName}</dt><dd data-testid="detail-StateName">{String(row.StateName ?? '')}</dd>
        <dt>{L.Region}</dt><dd data-testid="detail-Region">{String(row.Region ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
