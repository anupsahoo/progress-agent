/*------------------------------------------------------------------------
    File        : refcall_followup.p
    Purpose     : Reference call follow-up scheduling
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-03  kpo  Y2K date window
 *  2002-08  kpo  credit hold rule
 *  2009-08  kpo  performance: use index
 *  2013-03  ssp  fix rounding
 *  2001-10  jkm  new report column
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{credit-management/cr_defs.i}

DEFINE INPUT PARAMETER pCallNum AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bRefCall FOR RefCall.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bRefCall EXCLUSIVE-LOCK WHERE bRefCall.CallNum = pCallNum NO-WAIT NO-ERROR.
    IF LOCKED bRefCall THEN DO:
        pcResult = "LOCKED: RefCall in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bRefCall THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    RUN shared/audit_log.p (INPUT "RefCall", INPUT STRING(ROWID(bRefCall)), INPUT "refcall_followup.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE flag-ref-call-callnum0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.CallNum = "" OR bRefCall.CallNum = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.CallNum is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.CallNum) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-ref-call-parent1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Parent = "" OR bRefCall.Parent = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Parent is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Parent) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-ref-call-callnum2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.CallNum = "" OR bRefCall.CallNum = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.CallNum is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.CallNum) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-ref-call-parent3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Parent = "" OR bRefCall.Parent = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Parent is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Parent) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-ref-call-callnum4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.CallNum = "" OR bRefCall.CallNum = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.CallNum is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.CallNum) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-ref-call-txt5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Txt = "" OR bRefCall.Txt = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Txt is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Txt) > 300 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ref-call-salesrep6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.SalesRep = "" OR bRefCall.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-ref-call-callnum7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.CallNum = "" OR bRefCall.CallNum = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.CallNum is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.CallNum) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-ref-call-parent8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Parent = "" OR bRefCall.Parent = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Parent is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Parent) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ref-call-salesrep9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.SalesRep = "" OR bRefCall.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-ref-call-txt10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Txt = "" OR bRefCall.Txt = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Txt is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Txt) > 300 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-ref-call-callnum11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.CallNum = "" OR bRefCall.CallNum = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.CallNum is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.CallNum) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ref-call-callnum12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.CallNum = "" OR bRefCall.CallNum = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.CallNum is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.CallNum) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-ref-call-parent13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Parent = "" OR bRefCall.Parent = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Parent is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Parent) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ref-call-parent14 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Parent = "" OR bRefCall.Parent = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Parent is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Parent) > 6 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-ref-call-parent15 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bRefCall FOR RefCall.
  FIND bRefCall WHERE ROWID(bRefCall) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bRefCall THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bRefCall.Parent = "" OR bRefCall.Parent = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "RefCall.Parent is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bRefCall.Parent) > 6 THEN plOk = NO.
END PROCEDURE.

