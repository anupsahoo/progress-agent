/*------------------------------------------------------------------------
    File        : payroll_run.p
    Purpose     : Bi-weekly payroll run
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-03  rdh  credit hold rule
 *  2014-04  tlw  remove dead code
 *  2013-06  tlw  new report column
 *  2006-03  mab  credit hold rule
 *  2008-09  jkm  new report column
 */

{shared/sysdefs.i}
{shared/dateutil.i}

DEFINE INPUT PARAMETER ptPeriodEnd AS DATE NO-UNDO.

DEFINE TEMP-TABLE ttSum NO-UNDO
    FIELD GroupKey AS CHARACTER
    FIELD Cnt      AS INTEGER
    FIELD Amount   AS DECIMAL
    INDEX ixKey IS PRIMARY UNIQUE GroupKey.

DEFINE VARIABLE cKey AS CHARACTER NO-UNDO.

FOR EACH Employee NO-LOCK
    WHERE Employee.Birthdate <= ptPeriodEnd:
    cKey = "Employee|" + STRING(Employee.LastName).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + Employee.VacationDaysLeft.
END.

FOR EACH TimeSheet NO-LOCK
    WHERE TimeSheet.DayRecorded <= ptPeriodEnd:
    cKey = "TimeSheet|" + STRING(TimeSheet.TypeRecorded).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + TimeSheet.RegularHours.
END.

OUTPUT TO VALUE(gLogDir + "payroll_run_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE apply-employee-sickdaysleft0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-time-sheet-regularhours1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.RegularHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.RegularHours > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.RegularHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-time-sheet-overtimehours2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.OvertimeHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.OvertimeHours > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-time-sheet-regularhours3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.RegularHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.RegularHours > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.RegularHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-time-sheet-regularhours4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.RegularHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.RegularHours > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.RegularHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-time-sheet-overtimehours5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.OvertimeHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.OvertimeHours > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-time-sheet-overtimehours6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.OvertimeHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.OvertimeHours > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-employee-sickdaysleft7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-employee-sickdaysleft8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-employee-vacationdaysleft9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-time-sheet-regularhours10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.RegularHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.RegularHours > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.RegularHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-time-sheet-overtimehours11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bTimeSheet FOR TimeSheet.
  FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bTimeSheet THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bTimeSheet.OvertimeHours < 0 THEN plOk = NO.
    WHEN bTimeSheet.OvertimeHours > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

