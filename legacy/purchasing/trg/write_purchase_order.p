/*------------------------------------------------------------------------
    File        : write_purchase_order.p
    Purpose     : schema WRITE trigger for PurchaseOrder, field-level audit
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-06  ssp  new report column
 *  2004-12  jkm  audit fields
 *  2013-10  rdh  performance: use index
 */

/* trg/write_purchase_order.p : schema WRITE trigger for PurchaseOrder, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF PurchaseOrder OLD BUFFER oldPurchaseOrder.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN purchasing/purchase_order_val.p (INPUT ROWID(PurchaseOrder), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "PurchaseOrder write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF PurchaseOrder.PONum <> oldPurchaseOrder.PONum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "PurchaseOrder.PONum", INPUT STRING(oldPurchaseOrder.PONum), INPUT STRING(PurchaseOrder.PONum)).
END.
IF PurchaseOrder.DateEntered <> oldPurchaseOrder.DateEntered THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "PurchaseOrder.DateEntered", INPUT STRING(oldPurchaseOrder.DateEntered), INPUT STRING(PurchaseOrder.DateEntered)).
END.
IF PurchaseOrder.SupplierIDNum <> oldPurchaseOrder.SupplierIDNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "PurchaseOrder.SupplierIDNum", INPUT STRING(oldPurchaseOrder.SupplierIDNum), INPUT STRING(PurchaseOrder.SupplierIDNum)).
END.
IF PurchaseOrder.ReceiveDate <> oldPurchaseOrder.ReceiveDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "PurchaseOrder.ReceiveDate", INPUT STRING(oldPurchaseOrder.ReceiveDate), INPUT STRING(PurchaseOrder.ReceiveDate)).
END.
IF PurchaseOrder.POStatus <> oldPurchaseOrder.POStatus THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "PurchaseOrder.POStatus", INPUT STRING(oldPurchaseOrder.POStatus), INPUT STRING(PurchaseOrder.POStatus)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/purchase_order.q") APPEND.
  EXPORT "PurchaseOrder" "W" STRING(NOW) PurchaseOrder.PONum.
  OUTPUT CLOSE.
END.

