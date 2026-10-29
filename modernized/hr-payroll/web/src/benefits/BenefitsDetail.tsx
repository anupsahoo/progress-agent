import type { Benefits } from './types';
import { benefitsLabels as L } from './types';

// Replaces benefits_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function BenefitsDetail({ row, onEdit, onBack }: { row: Benefits; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="benefits-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.EmpNum}</dt><dd data-testid="detail-EmpNum">{String(row.EmpNum ?? '')}</dd>
        <dt>{L.HealthCare}</dt><dd data-testid="detail-HealthCare">{String(row.HealthCare ?? '')}</dd>
        <dt>{L.LifeInsurance}</dt><dd data-testid="detail-LifeInsurance">{String(row.LifeInsurance ?? '')}</dd>
        <dt>{L.Pension401K}</dt><dd data-testid="detail-Pension401K">{String(row.Pension401K ?? '')}</dd>
        <dt>{L.StockPurchase}</dt><dd data-testid="detail-StockPurchase">{String(row.StockPurchase ?? '')}</dd>
        <dt>{L.MedicalSpending}</dt><dd data-testid="detail-MedicalSpending">{String(row.MedicalSpending ?? '')}</dd>
        <dt>{L.DependentCare}</dt><dd data-testid="detail-DependentCare">{String(row.DependentCare ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
