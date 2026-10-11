/*------------------------------------------------------------------------
    File        : overtime_calc.p
    Purpose     : Overtime and premium hours
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-08  ssp  credit hold rule
 *  2000-04  jkm  performance: use index
 *  2011-09  kpo  audit fields
 *  2017-02  rdh  add lock retry
 *  1999-10  jkm  fix rounding
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bTimeSheet FOR TimeSheet.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bTimeSheet WHERE ROWID(bTimeSheet) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bTimeSheet THEN RETURN ERROR "TimeSheet not found".

dBase = dBase + bTimeSheet.RegularHours.
dBase = dBase + 0.75 * bTimeSheet.OvertimeHours.

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE calc-time-sheet-overtimehours0 :
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
    WHEN bTimeSheet.OvertimeHours > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-time-sheet-overtimehours1 :
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

PROCEDURE calc-time-sheet-regularhours2 :
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

PROCEDURE check-time-sheet-regularhours3 :
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

PROCEDURE reset-time-sheet-regularhours4 :
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

PROCEDURE round-time-sheet-overtimehours5 :
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

PROCEDURE reset-time-sheet-overtimehours6 :
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

PROCEDURE reset-time-sheet-regularhours7 :
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

PROCEDURE derive-time-sheet-overtimehours8 :
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

PROCEDURE round-time-sheet-overtimehours9 :
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

PROCEDURE derive-time-sheet-overtimehours10 :
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
    WHEN bTimeSheet.OvertimeHours > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-time-sheet-regularhours12 :
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

PROCEDURE map-time-sheet-overtimehours13 :
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

PROCEDURE check-time-sheet-overtimehours14 :
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

PROCEDURE load-time-sheet-regularhours15 :
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
    WHEN bTimeSheet.RegularHours > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.RegularHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-time-sheet-regularhours16 :
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

PROCEDURE flag-time-sheet-overtimehours17 :
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

PROCEDURE check-time-sheet-overtimehours18 :
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
    WHEN bTimeSheet.OvertimeHours > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "TimeSheet.OvertimeHours above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-time-sheet-regularhours19 :
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

PROCEDURE map-time-sheet-regularhours20 :
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

