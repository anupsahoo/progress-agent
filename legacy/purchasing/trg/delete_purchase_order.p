/*------------------------------------------------------------------------
    File        : delete_purchase_order.p
    Purpose     : schema DELETE trigger for PurchaseOrder, referential integrity
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-02  kpo  Y2K date window
 */

/* trg/delete_purchase_order.p : schema DELETE trigger for PurchaseOrder, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF PurchaseOrder.

{shared/sysdefs.i}

IF CAN-FIND(FIRST InventoryTrans WHERE InventoryTrans.PONum = PurchaseOrder.PONum) THEN DO:
  MESSAGE "Cannot delete PurchaseOrder: InventoryTrans records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST POLine WHERE POLine.PONum = PurchaseOrder.PONum) THEN DO:
  MESSAGE "Cannot delete PurchaseOrder: POLine records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/purchase_order_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT PurchaseOrder.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of PurchaseOrder by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/purchase_order.q") APPEND.
EXPORT "PurchaseOrder" "D" STRING(NOW) PurchaseOrder.PONum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "PurchaseOrder", INPUT STRING(ROWID(PurchaseOrder)), INPUT "DELETE").

