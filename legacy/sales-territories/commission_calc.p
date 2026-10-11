/*------------------------------------------------------------------------
    File        : commission_calc.p
    Purpose     : Commission accrual from shipped orders
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-09  rdh  add lock retry
 *  2015-10  kpo  new report column
 *  2001-03  ssp  add lock retry
 *  2002-08  ssp  audit fields
 *  2008-11  rdh  audit fields
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bSalesrep FOR Salesrep.
DEFINE BUFFER bOrder FOR Order.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bSalesrep WHERE ROWID(bSalesrep) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bSalesrep THEN RETURN ERROR "Salesrep not found".

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE calc-salesrep-salesrep0 :
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

PROCEDURE flag-salesrep-region1 :
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

PROCEDURE apply-salesrep-salesrep2 :
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

PROCEDURE reset-salesrep-region3 :
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

PROCEDURE calc-salesrep-repname4 :
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

PROCEDURE check-order-po5 :
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

PROCEDURE reset-order-orderstatus7 :
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

