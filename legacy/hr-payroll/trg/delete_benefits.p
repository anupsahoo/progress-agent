/*------------------------------------------------------------------------
    File        : delete_benefits.p
    Purpose     : schema DELETE trigger for Benefits, referential integrity
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-06  tlw  credit hold rule
 *  2006-12  jkm  credit hold rule
 *  2017-09  mab  credit hold rule
 */

/* trg/delete_benefits.p : schema DELETE trigger for Benefits, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Benefits.

{shared/sysdefs.i}

IF CAN-FIND(FIRST Employee WHERE Employee.EmpNum = Benefits.EmpNum) THEN DO:
  MESSAGE "Cannot delete Benefits: Employee records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Family WHERE Family.EmpNum = Benefits.EmpNum) THEN DO:
  MESSAGE "Cannot delete Benefits: Family records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST TimeSheet WHERE TimeSheet.EmpNum = Benefits.EmpNum) THEN DO:
  MESSAGE "Cannot delete Benefits: TimeSheet records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Vacation WHERE Vacation.EmpNum = Benefits.EmpNum) THEN DO:
  MESSAGE "Cannot delete Benefits: Vacation records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/benefits_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Benefits.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Benefits by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/benefits.q") APPEND.
EXPORT "Benefits" "D" STRING(NOW) Benefits.EmpNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Benefits", INPUT STRING(ROWID(Benefits)), INPUT "DELETE").

