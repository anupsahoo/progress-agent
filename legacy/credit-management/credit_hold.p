/*------------------------------------------------------------------------
    File        : credit_hold.p
    Purpose     : Place and release credit holds
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-03  kpo  performance: use index
 *  2011-02  jkm  fix rounding
 *  2003-03  kpo  audit fields
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{credit-management/cr_defs.i}

DEFINE INPUT PARAMETER pCustNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bCustomer FOR Customer.
DEFINE BUFFER bOrder FOR Order.
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

    FOR EACH bOrder EXCLUSIVE-LOCK
        WHERE bOrder.CustNum = bCustomer.CustNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bOrder)
               ttWork.Action = "UPDATE".
    END.

    /* Never leave a negative Credit Limit behind */
    ASSIGN bCustomer.CreditLimit = MAX(0, bCustomer.CreditLimit).
    RUN shared/audit_log.p (INPUT "Customer", INPUT STRING(ROWID(bCustomer)), INPUT "credit_hold.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE check-order-salesrep0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.SalesRep = "" OR bOrder.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-order-po1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.PO = "" OR bOrder.PO = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.PO is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.PO) > 20 THEN plOk = NO.
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
    WHEN bCustomer.CreditLimit > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-order-terms3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Terms = "" OR bOrder.Terms = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Terms is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Terms) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-order-carrier4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Carrier = "" OR bOrder.Carrier = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Carrier is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Carrier) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-customer-discount5 :
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
    WHEN bCustomer.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-customer-discount6 :
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
    WHEN bCustomer.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-customer-creditlimit7 :
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
    WHEN bCustomer.CreditLimit > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-customer-discount8 :
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
    WHEN bCustomer.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-customer-creditlimit9 :
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
    WHEN bCustomer.CreditLimit > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-order-orderstatus10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.OrderStatus = "" OR bOrder.OrderStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.OrderStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.OrderStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-order-creditcard11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Creditcard = "" OR bOrder.Creditcard = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Creditcard is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Creditcard) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-customer-balance12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Balance < 0 THEN plOk = NO.
    WHEN bCustomer.Balance > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Balance above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-order-po13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.PO = "" OR bOrder.PO = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.PO is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.PO) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-order-po14 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.PO = "" OR bOrder.PO = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.PO is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.PO) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-order-instructions15 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Instructions = "" OR bOrder.Instructions = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Instructions is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Instructions) > 50 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-order-carrier16 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Carrier = "" OR bOrder.Carrier = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Carrier is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Carrier) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-customer-discount17 :
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

PROCEDURE round-customer-discount18 :
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
    WHEN bCustomer.Discount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-order-carrier19 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Carrier = "" OR bOrder.Carrier = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Carrier is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Carrier) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-customer-discount20 :
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

PROCEDURE post-customer-balance21 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Balance < 0 THEN plOk = NO.
    WHEN bCustomer.Balance > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Balance above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

