/*------------------------------------------------------------------------
    File        : write_vacation.p
    Purpose     : schema WRITE trigger for Vacation, field-level audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-02  jkm  audit fields
 *  2004-03  ssp  new report column
 *  2015-05  jkm  Y2K date window
 *  2015-04  rdh  credit hold rule
 */

/* trg/write_vacation.p : schema WRITE trigger for Vacation, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Vacation OLD BUFFER oldVacation.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN hr-payroll/vacation_val.p (INPUT ROWID(Vacation), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Vacation write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Vacation.EmpNum <> oldVacation.EmpNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Vacation.EmpNum", INPUT STRING(oldVacation.EmpNum), INPUT STRING(Vacation.EmpNum)).
END.
IF Vacation.StartDate <> oldVacation.StartDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Vacation.StartDate", INPUT STRING(oldVacation.StartDate), INPUT STRING(Vacation.StartDate)).
END.
IF Vacation.EndDate <> oldVacation.EndDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Vacation.EndDate", INPUT STRING(oldVacation.EndDate), INPUT STRING(Vacation.EndDate)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/vacation.q") APPEND.
  EXPORT "Vacation" "W" STRING(NOW) Vacation.EmpNum Vacation.StartDate.
  OUTPUT CLOSE.
END.

