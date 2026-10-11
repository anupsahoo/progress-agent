/*------------------------------------------------------------------------
    File        : wave_pick.p
    Purpose     : Wave picking across orders
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-12  tlw  credit hold rule
 *  2012-07  jkm  add lock retry
 *  2005-07  tlw  audit fields
 *  2007-06  ssp  performance: use index
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{order-fulfilment/of_defs.i}

DEFINE INPUT PARAMETER pOrdernum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bOrder FOR Order.
DEFINE BUFFER bOrderLine FOR OrderLine.
DEFINE BUFFER bBin FOR Bin.
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

    FOR EACH bBin EXCLUSIVE-LOCK
        WHERE bBin.WarehouseNum = bOrder.WarehouseNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bBin)
               ttWork.Action = "UPDATE".
        IF bBin.Qty < 0 THEN DO:
            ttWork.Note = "negative Qty".
            bBin.Qty = 0.
        END.
    END.

    RUN shared/audit_log.p (INPUT "Order", INPUT STRING(ROWID(bOrder)), INPUT "wave_pick.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE load-order-line-discount0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Discount < 0 THEN plOk = NO.
    WHEN bOrderLine.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-bin-qty1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-bin-qty2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-bin-qty3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-bin-qty4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-order-line-extendedprice5 :
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
    WHEN bOrderLine.ExtendedPrice > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-bin-qty6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-order-instructions7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Instructions = "" OR bOrder.Instructions = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Instructions is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Instructions) > 50 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-order-creditcard8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Creditcard = "" OR bOrder.Creditcard = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Creditcard is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Creditcard) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-bin-qty9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-order-orderstatus10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.OrderStatus = "" OR bOrder.OrderStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.OrderStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.OrderStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-bin-qty11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-order-instructions12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Instructions = "" OR bOrder.Instructions = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Instructions is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Instructions) > 50 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-order-carrier13 :
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

PROCEDURE flag-order-carrier14 :
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

PROCEDURE round-order-line-price15 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Price < 0 THEN plOk = NO.
    WHEN bOrderLine.Price > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-bin-qty16 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-bin-qty17 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-order-line-price18 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Price < 0 THEN plOk = NO.
    WHEN bOrderLine.Price > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-bin-qty19 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-order-line-extendedprice20 :
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
    WHEN bOrderLine.ExtendedPrice > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-bin-qty21 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-order-carrier22 :
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

