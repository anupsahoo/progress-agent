/*------------------------------------------------------------------------
    File        : write_time_sheet.p
    Purpose     : schema WRITE trigger for TimeSheet, field-level audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-02  ssp  add lock retry
 *  2007-01  tlw  credit hold rule
 *  2013-03  kpo  fix rounding
 *  2012-05  ssp  Y2K date window
 *  2012-01  jkm  new report column
 */

/* trg/write_time_sheet.p : schema WRITE trigger for TimeSheet, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF TimeSheet OLD BUFFER oldTimeSheet.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN hr-payroll/time_sheet_val.p (INPUT ROWID(TimeSheet), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "TimeSheet write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF TimeSheet.EmpNum <> oldTimeSheet.EmpNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.EmpNum", INPUT STRING(oldTimeSheet.EmpNum), INPUT STRING(TimeSheet.EmpNum)).
END.
IF TimeSheet.DayRecorded <> oldTimeSheet.DayRecorded THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.DayRecorded", INPUT STRING(oldTimeSheet.DayRecorded), INPUT STRING(TimeSheet.DayRecorded)).
END.
IF TimeSheet.TypeRecorded <> oldTimeSheet.TypeRecorded THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.TypeRecorded", INPUT STRING(oldTimeSheet.TypeRecorded), INPUT STRING(TimeSheet.TypeRecorded)).
END.
IF TimeSheet.AMTimeIn <> oldTimeSheet.AMTimeIn THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.AMTimeIn", INPUT STRING(oldTimeSheet.AMTimeIn), INPUT STRING(TimeSheet.AMTimeIn)).
END.
IF TimeSheet.AMTimeOut <> oldTimeSheet.AMTimeOut THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.AMTimeOut", INPUT STRING(oldTimeSheet.AMTimeOut), INPUT STRING(TimeSheet.AMTimeOut)).
END.
IF TimeSheet.PMTimeIn <> oldTimeSheet.PMTimeIn THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.PMTimeIn", INPUT STRING(oldTimeSheet.PMTimeIn), INPUT STRING(TimeSheet.PMTimeIn)).
END.
IF TimeSheet.PMTimeOut <> oldTimeSheet.PMTimeOut THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.PMTimeOut", INPUT STRING(oldTimeSheet.PMTimeOut), INPUT STRING(TimeSheet.PMTimeOut)).
END.
IF TimeSheet.RegularHours <> oldTimeSheet.RegularHours THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.RegularHours", INPUT STRING(oldTimeSheet.RegularHours), INPUT STRING(TimeSheet.RegularHours)).
END.
IF TimeSheet.OvertimeHours <> oldTimeSheet.OvertimeHours THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "TimeSheet.OvertimeHours", INPUT STRING(oldTimeSheet.OvertimeHours), INPUT STRING(TimeSheet.OvertimeHours)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/time_sheet.q") APPEND.
  EXPORT "TimeSheet" "W" STRING(NOW) TimeSheet.EmpNum TimeSheet.DayRecorded.
  OUTPUT CLOSE.
END.

