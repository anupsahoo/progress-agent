/*------------------------------------------------------------------------
    File        : write_order.p
    Purpose     : schema WRITE trigger for Order, field-level audit
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-01  rdh  audit fields
 *  2005-03  jkm  new report column
 *  2004-10  mab  new report column
 */

/* trg/write_order.p : schema WRITE trigger for Order, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Order OLD BUFFER oldOrder.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN order-entry/order_val.p (INPUT ROWID(Order), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Order write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Order.Ordernum <> oldOrder.Ordernum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.Ordernum", INPUT STRING(oldOrder.Ordernum), INPUT STRING(Order.Ordernum)).
END.
IF Order.CustNum <> oldOrder.CustNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.CustNum", INPUT STRING(oldOrder.CustNum), INPUT STRING(Order.CustNum)).
END.
IF Order.OrderDate <> oldOrder.OrderDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.OrderDate", INPUT STRING(oldOrder.OrderDate), INPUT STRING(Order.OrderDate)).
END.
IF Order.ShipDate <> oldOrder.ShipDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.ShipDate", INPUT STRING(oldOrder.ShipDate), INPUT STRING(Order.ShipDate)).
END.
IF Order.PromiseDate <> oldOrder.PromiseDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.PromiseDate", INPUT STRING(oldOrder.PromiseDate), INPUT STRING(Order.PromiseDate)).
END.
IF Order.Carrier <> oldOrder.Carrier THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.Carrier", INPUT STRING(oldOrder.Carrier), INPUT STRING(Order.Carrier)).
END.
IF Order.Instructions <> oldOrder.Instructions THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.Instructions", INPUT STRING(oldOrder.Instructions), INPUT STRING(Order.Instructions)).
END.
IF Order.PO <> oldOrder.PO THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.PO", INPUT STRING(oldOrder.PO), INPUT STRING(Order.PO)).
END.
IF Order.Terms <> oldOrder.Terms THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.Terms", INPUT STRING(oldOrder.Terms), INPUT STRING(Order.Terms)).
END.
IF Order.SalesRep <> oldOrder.SalesRep THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.SalesRep", INPUT STRING(oldOrder.SalesRep), INPUT STRING(Order.SalesRep)).
END.
IF Order.BillToID <> oldOrder.BillToID THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.BillToID", INPUT STRING(oldOrder.BillToID), INPUT STRING(Order.BillToID)).
END.
IF Order.ShipToID <> oldOrder.ShipToID THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.ShipToID", INPUT STRING(oldOrder.ShipToID), INPUT STRING(Order.ShipToID)).
END.
IF Order.OrderStatus <> oldOrder.OrderStatus THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.OrderStatus", INPUT STRING(oldOrder.OrderStatus), INPUT STRING(Order.OrderStatus)).
END.
IF Order.WarehouseNum <> oldOrder.WarehouseNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.WarehouseNum", INPUT STRING(oldOrder.WarehouseNum), INPUT STRING(Order.WarehouseNum)).
END.
IF Order.Creditcard <> oldOrder.Creditcard THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Order.Creditcard", INPUT STRING(oldOrder.Creditcard), INPUT STRING(Order.Creditcard)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/order.q") APPEND.
  EXPORT "Order" "W" STRING(NOW) Order.Ordernum.
  OUTPUT CLOSE.
END.

