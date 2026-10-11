/*------------------------------------------------------------------------
    File        : territory_assign.p
    Purpose     : Assign customers to reps by state and region
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-09  kpo  audit fields
 *  1999-05  tlw  remove dead code
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{sales-territories/st_defs.i}

DEFINE INPUT PARAMETER pCustNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bCustomer FOR Customer.
DEFINE BUFFER bSalesrep FOR Salesrep.
DEFINE BUFFER bState FOR State.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bCustomer EXCLUSIVE-LOCK WHERE bCustomer.CustNum = pCustNum NO-WAIT NO-ERROR.
    IF LOCKED bCustomer THEN DO:
        pcResult = "LOCKED: Customer in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bCustomer THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bSalesrep EXCLUSIVE-LOCK
        WHERE bSalesrep.SalesRep = bCustomer.SalesRep:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bSalesrep)
               ttWork.Action = "UPDATE".
    END.

    FOR EACH bState EXCLUSIVE-LOCK
        WHERE bState.State = bCustomer.State:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bState)
               ttWork.Action = "UPDATE".
    END.

    /* Never leave a negative Credit Limit behind */
    ASSIGN bCustomer.CreditLimit = MAX(0, bCustomer.CreditLimit).
    RUN shared/audit_log.p (INPUT "Customer", INPUT STRING(ROWID(bCustomer)), INPUT "territory_assign.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE derive-state-region0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.Region = "" OR bState.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.Region) > 8 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-customer-creditlimit1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-customer-creditlimit2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-customer-discount3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Discount < 0 THEN plOk = NO.
    WHEN bCustomer.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-customer-creditlimit4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-salesrep-salesrep5 :
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

PROCEDURE calc-salesrep-region6 :
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

PROCEDURE derive-customer-creditlimit7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

