/*------------------------------------------------------------------------
    File        : supplier_scorecard.p
    Purpose     : On-time delivery and discount scorecard
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-06  tlw  fix rounding
 *  2010-02  kpo  credit hold rule
 *  2013-03  jkm  performance: use index
 *  2009-05  ssp  audit fields
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bSupplier FOR Supplier.
DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bSupplier THEN RETURN ERROR "Supplier not found".

dBase = dBase + bSupplier.ShipAmount.
dBase = dBase + 0.75 * bSupplier.Discount.

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE calc-supplier-discount0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-purchase-order-postatus1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-purchase-order-postatus2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

