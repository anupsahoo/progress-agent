/*------------------------------------------------------------------------
    File        : inv_trans_post.p
    Purpose     : Post inventory transactions to item balances
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-12  jkm  remove dead code
 *  2008-05  kpo  audit fields
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{inventory/in_defs.i}

DEFINE INPUT PARAMETER pInvTransNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bInventoryTrans FOR InventoryTrans.
DEFINE BUFFER bItem FOR Item.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bInventoryTrans EXCLUSIVE-LOCK WHERE bInventoryTrans.InvTransNum = pInvTransNum NO-WAIT NO-ERROR.
    IF LOCKED bInventoryTrans THEN DO:
        pcResult = "LOCKED: InventoryTrans in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bInventoryTrans THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bItem EXCLUSIVE-LOCK
        WHERE bItem.Itemnum = bInventoryTrans.Itemnum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bItem)
               ttWork.Action = "UPDATE".
        IF bItem.Price < 0 THEN DO:
            ttWork.Note = "negative Price".
            bItem.Price = 0.
        END.
    END.

    /* Never leave a negative Qty behind */
    ASSIGN bInventoryTrans.Qty = MAX(0, bInventoryTrans.Qty).
    RUN shared/audit_log.p (INPUT "InventoryTrans", INPUT STRING(ROWID(bInventoryTrans)), INPUT "inv_trans_post.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE load-item-onorder0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.OnOrder < 0 THEN plOk = NO.
    WHEN bItem.OnOrder > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.OnOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-inventory-trans-qty1 :
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

PROCEDURE map-item-reorder2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.ReOrder < 0 THEN plOk = NO.
    WHEN bItem.ReOrder > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.ReOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-inventory-trans-qty3 :
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

PROCEDURE flag-item-onhand4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Onhand < 0 THEN plOk = NO.
    WHEN bItem.Onhand > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Onhand above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-item-minqty5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Minqty < 0 THEN plOk = NO.
    WHEN bItem.Minqty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Minqty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-item-allocated6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Allocated < 0 THEN plOk = NO.
    WHEN bItem.Allocated > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Allocated above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-item-reorder7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.ReOrder < 0 THEN plOk = NO.
    WHEN bItem.ReOrder > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.ReOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-item-onhand8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Onhand < 0 THEN plOk = NO.
    WHEN bItem.Onhand > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Onhand above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-inventory-trans-qty9 :
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

PROCEDURE reset-inventory-trans-qty10 :
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
    WHEN bInventoryTrans.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-inventory-trans-qty11 :
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
    WHEN bInventoryTrans.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-item-minqty12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Minqty < 0 THEN plOk = NO.
    WHEN bItem.Minqty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Minqty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-item-onorder13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.OnOrder < 0 THEN plOk = NO.
    WHEN bItem.OnOrder > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.OnOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-item-minqty14 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Minqty < 0 THEN plOk = NO.
    WHEN bItem.Minqty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Minqty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

