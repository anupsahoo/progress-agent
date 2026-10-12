import type { Employee } from './types';
import { employeeLabels as L } from './types';

// Replaces employee_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function EmployeeDetail({ row, onEdit, onBack }: { row: Employee; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="employee-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.EmpNum}</dt><dd data-testid="detail-EmpNum">{String(row.EmpNum ?? '')}</dd>
        <dt>{L.LastName}</dt><dd data-testid="detail-LastName">{String(row.LastName ?? '')}</dd>
        <dt>{L.FirstName}</dt><dd data-testid="detail-FirstName">{String(row.FirstName ?? '')}</dd>
        <dt>{L.Address}</dt><dd data-testid="detail-Address">{String(row.Address ?? '')}</dd>
        <dt>{L.Address2}</dt><dd data-testid="detail-Address2">{String(row.Address2 ?? '')}</dd>
        <dt>{L.City}</dt><dd data-testid="detail-City">{String(row.City ?? '')}</dd>
        <dt>{L.State}</dt><dd data-testid="detail-State">{String(row.State ?? '')}</dd>
        <dt>{L.PostalCode}</dt><dd data-testid="detail-PostalCode">{String(row.PostalCode ?? '')}</dd>
        <dt>{L.HomePhone}</dt><dd data-testid="detail-HomePhone">{String(row.HomePhone ?? '')}</dd>
        <dt>{L.WorkPhone}</dt><dd data-testid="detail-WorkPhone">{String(row.WorkPhone ?? '')}</dd>
        <dt>{L.DeptCode}</dt><dd data-testid="detail-DeptCode">{String(row.DeptCode ?? '')}</dd>
        <dt>{L.Position}</dt><dd data-testid="detail-Position">{String(row.Position ?? '')}</dd>
        <dt>{L.Birthdate}</dt><dd data-testid="detail-Birthdate">{String(row.Birthdate ?? '')}</dd>
        <dt>{L.StartDate}</dt><dd data-testid="detail-StartDate">{String(row.StartDate ?? '')}</dd>
        <dt>{L.VacationDaysLeft}</dt><dd data-testid="detail-VacationDaysLeft">{String(row.VacationDaysLeft ?? '')}</dd>
        <dt>{L.SickDaysLeft}</dt><dd data-testid="detail-SickDaysLeft">{String(row.SickDaysLeft ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
