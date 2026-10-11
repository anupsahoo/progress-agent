import type { Family } from './types';
import { familyLabels as L } from './types';

// Replaces family_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function FamilyDetail({ row, onEdit, onBack }: { row: Family; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="family-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.EmpNum}</dt><dd data-testid="detail-EmpNum">{String(row.EmpNum ?? '')}</dd>
        <dt>{L.RelativeName}</dt><dd data-testid="detail-RelativeName">{String(row.RelativeName ?? '')}</dd>
        <dt>{L.Relation}</dt><dd data-testid="detail-Relation">{String(row.Relation ?? '')}</dd>
        <dt>{L.Birthdate}</dt><dd data-testid="detail-Birthdate">{String(row.Birthdate ?? '')}</dd>
        <dt>{L.CoveredOnBenefits}</dt><dd data-testid="detail-CoveredOnBenefits">{String(row.CoveredOnBenefits ?? '')}</dd>
        <dt>{L.BenefitDate}</dt><dd data-testid="detail-BenefitDate">{String(row.BenefitDate ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
