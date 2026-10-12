import type { TimeSheet } from './types';
import { timeSheetLabels as L } from './types';

// Replaces time_sheet_inquiry.w (read-only FILL-INs with First/Prev/Next/Last).
export function TimeSheetDetail({ row, onEdit, onBack }: { row: TimeSheet; onEdit?: () => void; onBack: () => void }) {
  return (
    <section data-testid="time-sheet-detail">
      <dl style={{ display: 'grid', gridTemplateColumns: '180px 1fr', gap: '6px 16px' }}>
        <dt>{L.EmpNum}</dt><dd data-testid="detail-EmpNum">{String(row.EmpNum ?? '')}</dd>
        <dt>{L.DayRecorded}</dt><dd data-testid="detail-DayRecorded">{String(row.DayRecorded ?? '')}</dd>
        <dt>{L.TypeRecorded}</dt><dd data-testid="detail-TypeRecorded">{String(row.TypeRecorded ?? '')}</dd>
        <dt>{L.AMTimeIn}</dt><dd data-testid="detail-AMTimeIn">{String(row.AMTimeIn ?? '')}</dd>
        <dt>{L.AMTimeOut}</dt><dd data-testid="detail-AMTimeOut">{String(row.AMTimeOut ?? '')}</dd>
        <dt>{L.PMTimeIn}</dt><dd data-testid="detail-PMTimeIn">{String(row.PMTimeIn ?? '')}</dd>
        <dt>{L.PMTimeOut}</dt><dd data-testid="detail-PMTimeOut">{String(row.PMTimeOut ?? '')}</dd>
        <dt>{L.RegularHours}</dt><dd data-testid="detail-RegularHours">{String(row.RegularHours ?? '')}</dd>
        <dt>{L.OvertimeHours}</dt><dd data-testid="detail-OvertimeHours">{String(row.OvertimeHours ?? '')}</dd>
      </dl>
      <button onClick={onBack}>Back</button>
      {onEdit && <button data-testid="edit" onClick={onEdit}>Edit</button>}
    </section>
  );
}
