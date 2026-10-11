/*------------------------------------------------------------------------
    File        : po_open_rpt.p
    Purpose     : Open purchase orders by supplier
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-11  jkm  add lock retry
 *  2011-03  mab  credit hold rule
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Open purchase orders by supplier" SKIP(1).

FOR EACH PurchaseOrder NO-LOCK
    BREAK BY PurchaseOrder.POStatus:
    dLine = 0.
    FOR EACH Supplier NO-LOCK WHERE Supplier.SupplierIDNum = PurchaseOrder.SupplierIDNum:
        dLine = dLine + Supplier.ShipAmount.
    END.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY PurchaseOrder.POStatus).
    DISPLAY STREAM sOut PurchaseOrder.PONum PurchaseOrder.DateEntered PurchaseOrder.SupplierIDNum PurchaseOrder.ReceiveDate dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(PurchaseOrder.POStatus) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  PO Status total: " ACCUM SUB-TOTAL BY PurchaseOrder.POStatus dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE derive-supplier-shipamount0 :
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

PROCEDURE calc-supplier-discount1 :
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
    WHEN bSupplier.Discount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-supplier-shipamount2 :
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
    WHEN bSupplier.ShipAmount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

