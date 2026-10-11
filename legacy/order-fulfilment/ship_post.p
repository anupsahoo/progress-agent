/*------------------------------------------------------------------------
    File        : ship_post.p
    Purpose     : Post shipment to stock and order status
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-12  tlw  audit fields
 *  2012-05  jkm  new report column
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{order-fulfilment/of_defs.i}

DEFINE INPUT PARAMETER pOrdernum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bOrder FOR Order.
DEFINE BUFFER bOrderLine FOR OrderLine.
DEFINE BUFFER bInventoryTrans FOR InventoryTrans.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bOrder EXCLUSIVE-LOCK WHERE bOrder.Ordernum = pOrdernum NO-WAIT NO-ERROR.
    IF LOCKED bOrder THEN DO:
        pcResult = "LOCKED: Order in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bOrder THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bOrderLine EXCLUSIVE-LOCK
        WHERE bOrderLine.Ordernum = bOrder.Ordernum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bOrderLine)
               ttWork.Action = "UPDATE".
        IF bOrderLine.Price < 0 THEN DO:
            ttWork.Note = "negative Price".
            bOrderLine.Price = 0.
        END.
    END.

    FOR EACH bInventoryTrans EXCLUSIVE-LOCK
        WHERE bInventoryTrans.Ordernum = bOrder.Ordernum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bInventoryTrans)
               ttWork.Action = "UPDATE".
        IF bInventoryTrans.Qty < 0 THEN DO:
            ttWork.Note = "negative Qty".
            bInventoryTrans.Qty = 0.
        END.
    END.

    RUN shared/audit_log.p (INPUT "Order", INPUT STRING(ROWID(bOrder)), INPUT "ship_post.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE flag-order-po0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.PO = "" OR bOrder.PO = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.PO is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.PO) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-inventory-trans-qty1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInventoryTrans FOR InventoryTrans.
  FIND bInventoryTrans WHERE ROWID(bInventoryTrans) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInventoryTrans THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInventoryTrans.Qty < 0 THEN plOk = NO.
    WHEN bInventoryTrans.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-order-line-extendedprice2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.ExtendedPrice < 0 THEN plOk = NO.
    WHEN bOrderLine.ExtendedPrice > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-inventory-trans-qty3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bInventoryTrans FOR InventoryTrans.
  FIND bInventoryTrans WHERE ROWID(bInventoryTrans) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bInventoryTrans THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bInventoryTrans.Qty < 0 THEN plOk = NO.
    WHEN bInventoryTrans.Qty > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-order-carrier4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Carrier = "" OR bOrder.Carrier = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Carrier is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Carrier) > 25 THEN plOk = NO.
END PROCEDURE.

