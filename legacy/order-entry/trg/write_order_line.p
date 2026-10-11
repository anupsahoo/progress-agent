/*------------------------------------------------------------------------
    File        : write_order_line.p
    Purpose     : schema WRITE trigger for OrderLine, field-level audit
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-12  rdh  remove dead code
 *  2013-12  jkm  credit hold rule
 */

/* trg/write_order_line.p : schema WRITE trigger for OrderLine, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF OrderLine OLD BUFFER oldOrderLine.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN order-entry/order_line_val.p (INPUT ROWID(OrderLine), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "OrderLine write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF OrderLine.Ordernum <> oldOrderLine.Ordernum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.Ordernum", INPUT STRING(oldOrderLine.Ordernum), INPUT STRING(OrderLine.Ordernum)).
END.
IF OrderLine.Linenum <> oldOrderLine.Linenum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.Linenum", INPUT STRING(oldOrderLine.Linenum), INPUT STRING(OrderLine.Linenum)).
END.
IF OrderLine.Itemnum <> oldOrderLine.Itemnum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.Itemnum", INPUT STRING(oldOrderLine.Itemnum), INPUT STRING(OrderLine.Itemnum)).
END.
IF OrderLine.Price <> oldOrderLine.Price THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.Price", INPUT STRING(oldOrderLine.Price), INPUT STRING(OrderLine.Price)).
END.
IF OrderLine.Qty <> oldOrderLine.Qty THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.Qty", INPUT STRING(oldOrderLine.Qty), INPUT STRING(OrderLine.Qty)).
END.
IF OrderLine.Discount <> oldOrderLine.Discount THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.Discount", INPUT STRING(oldOrderLine.Discount), INPUT STRING(OrderLine.Discount)).
END.
IF OrderLine.ExtendedPrice <> oldOrderLine.ExtendedPrice THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.ExtendedPrice", INPUT STRING(oldOrderLine.ExtendedPrice), INPUT STRING(OrderLine.ExtendedPrice)).
END.
IF OrderLine.OrderLineStatus <> oldOrderLine.OrderLineStatus THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "OrderLine.OrderLineStatus", INPUT STRING(oldOrderLine.OrderLineStatus), INPUT STRING(OrderLine.OrderLineStatus)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/order_line.q") APPEND.
  EXPORT "OrderLine" "W" STRING(NOW) OrderLine.Ordernum OrderLine.Linenum.
  OUTPUT CLOSE.
END.

