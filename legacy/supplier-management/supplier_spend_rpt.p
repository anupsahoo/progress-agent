/*------------------------------------------------------------------------
    File        : supplier_spend_rpt.p
    Purpose     : Spend by supplier and month
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-06  kpo  remove dead code
 *  2005-08  mab  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Spend by supplier and month" SKIP(1).

FOR EACH Supplier NO-LOCK
    BREAK BY Supplier.City:
    dLine = 0.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY Supplier.City).
    DISPLAY STREAM sOut Supplier.SupplierIDNum Supplier.Name Supplier.Address Supplier.Address2 dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(Supplier.City) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  City total: " ACCUM SUB-TOTAL BY Supplier.City dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE post-purchase-order-postatus0 :
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

PROCEDURE round-purchase-order-postatus1 :
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

PROCEDURE apply-purchase-order-postatus2 :
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

PROCEDURE load-supplier-shipamount3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-supplier-discount4 :
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
    WHEN bSupplier.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

