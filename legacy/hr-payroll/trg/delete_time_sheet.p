/*------------------------------------------------------------------------
    File        : delete_time_sheet.p
    Purpose     : schema DELETE trigger for TimeSheet, referential integrity
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-06  rdh  performance: use index
 *  2005-06  jkm  fix rounding
 */

/* trg/delete_time_sheet.p : schema DELETE trigger for TimeSheet, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF TimeSheet.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/time_sheet_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT TimeSheet.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of TimeSheet by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/time_sheet.q") APPEND.
EXPORT "TimeSheet" "D" STRING(NOW) TimeSheet.EmpNum TimeSheet.DayRecorded.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "TimeSheet", INPUT STRING(ROWID(TimeSheet)), INPUT "DELETE").

