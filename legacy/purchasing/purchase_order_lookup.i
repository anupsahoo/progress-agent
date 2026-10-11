/*------------------------------------------------------------------------
    File        : purchase_order_lookup.i
    Purpose     : PurchaseOrder lookup helpers. {&NO-PURCHASEORDER-FUNCS} suppresses the functions.
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-07  tlw  credit hold rule
 */

/* purchase_order_lookup.i : PurchaseOrder lookup helpers. {&NO-PURCHASEORDER-FUNCS} suppresses the functions. */

&IF DEFINED(PURCHASE_ORDER_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE PURCHASE_ORDER_LOOKUP_I YES

DEFINE BUFFER bLkPurchaseOrder FOR PurchaseOrder.

FUNCTION PurchaseOrderExists RETURNS LOGICAL (INPUT pPONum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkPurchaseOrder WHERE bLkPurchaseOrder.PONum = pPONum).
END FUNCTION.

FUNCTION PurchaseOrderDesc RETURNS CHARACTER (INPUT pPONum AS INTEGER):
  FIND FIRST bLkPurchaseOrder NO-LOCK WHERE bLkPurchaseOrder.PONum = pPONum NO-ERROR.
  RETURN (IF AVAILABLE bLkPurchaseOrder THEN bLkPurchaseOrder.POStatus ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-purchase_order :
  DEFINE INPUT  PARAMETER pPONum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkPurchaseOrder NO-LOCK WHERE bLkPurchaseOrder.PONum = pPONum NO-ERROR.
  pRowid = IF AVAILABLE bLkPurchaseOrder THEN ROWID(bLkPurchaseOrder) ELSE ?.
END PROCEDURE.

&ENDIF

