/*------------------------------------------------------------------------
    File        : purchase_order_val.p
    Purpose     : Business validation for PurchaseOrder
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.

FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bPurchaseOrder THEN DO:
  ASSIGN plOk = NO pcMsg = "PurchaseOrder record not found.".
  RETURN.
END.

/* PONum: ponum > 0 */
IF NOT (bPurchaseOrder.PONum > 0) THEN
  RUN add-error ("PO number must be greater than zero").

IF bPurchaseOrder.DateEntered <> ? AND YEAR(bPurchaseOrder.DateEntered) < 1950 THEN
  RUN add-error ("Date Entered is before the 1950 date window.").

/* SupplierIDNum: CAN-FIND(supplier OF purchaseorder) */
IF NOT CAN-FIND(FIRST Supplier WHERE Supplier.SupplierIDNum = bPurchaseOrder.SupplierIDNum) THEN
  RUN add-error ("Supplier must exist.").

IF bPurchaseOrder.ReceiveDate <> ? AND YEAR(bPurchaseOrder.ReceiveDate) < 1950 THEN
  RUN add-error ("Date Received is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

