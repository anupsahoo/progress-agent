/*------------------------------------------------------------------------
    File        : delete_order.p
    Purpose     : schema DELETE trigger for Order, referential integrity
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-01  ssp  appserver split
 *  2010-12  mab  add lock retry
 *  2011-08  tlw  add lock retry
 */

/* trg/delete_order.p : schema DELETE trigger for Order, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Order.

{shared/sysdefs.i}

IF CAN-FIND(FIRST InventoryTrans WHERE InventoryTrans.Ordernum = Order.Ordernum) THEN DO:
  MESSAGE "Cannot delete Order: InventoryTrans records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Invoice WHERE Invoice.OrderNum = Order.Ordernum) THEN DO:
  MESSAGE "Cannot delete Order: Invoice records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST OrderLine WHERE OrderLine.Ordernum = Order.Ordernum) THEN DO:
  MESSAGE "Cannot delete Order: OrderLine records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Table VALEXP: 1 = 1 */

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/order_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Order.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Order by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/order.q") APPEND.
EXPORT "Order" "D" STRING(NOW) Order.Ordernum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Order", INPUT STRING(ROWID(Order)), INPUT "DELETE").

