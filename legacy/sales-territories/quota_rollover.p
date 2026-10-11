/*------------------------------------------------------------------------
    File        : quota_rollover.p
    Purpose     : Year-end quota roll forward
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-08  kpo  remove dead code
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

FOR EACH Salesrep NO-LOCK:
    cKey = "Salesrep|" + STRING(Salesrep.RepName).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1.
END.

OUTPUT TO VALUE(gLogDir + "quota_rollover_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE derive-salesrep-repname0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-salesrep-repname1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-salesrep-salesrep2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.SalesRep = "" OR bSalesrep.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-salesrep-region3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.Region = "" OR bSalesrep.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.Region) > 8 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-salesrep-salesrep4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.SalesRep = "" OR bSalesrep.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-salesrep-repname5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-salesrep-repname6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-salesrep-region7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.Region = "" OR bSalesrep.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.Region) > 8 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-salesrep-repname8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-salesrep-repname9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-salesrep-repname10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSalesrep FOR Salesrep.
  FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSalesrep THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bSalesrep.RepName = "" OR bSalesrep.RepName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Salesrep.RepName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bSalesrep.RepName) > 30 THEN plOk = NO.
END PROCEDURE.

