/*------------------------------------------------------------------------
    File        : delete_vacation.p
    Purpose     : schema DELETE trigger for Vacation, referential integrity
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-09  jkm  remove dead code
 *  2006-02  tlw  remove dead code
 */

/* trg/delete_vacation.p : schema DELETE trigger for Vacation, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Vacation.

{shared/sysdefs.i}

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/vacation_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Vacation.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Vacation by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/vacation.q") APPEND.
EXPORT "Vacation" "D" STRING(NOW) Vacation.EmpNum Vacation.StartDate.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Vacation", INPUT STRING(ROWID(Vacation)), INPUT "DELETE").

