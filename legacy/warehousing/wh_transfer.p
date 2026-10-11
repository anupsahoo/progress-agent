/*------------------------------------------------------------------------
    File        : wh_transfer.p
    Purpose     : Inter-warehouse stock transfer
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-02  mab  audit fields
 *  1999-08  rdh  performance: use index
 *  1999-11  tlw  Y2K date window
 *  2013-09  mab  remove dead code
 *  2004-04  jkm  Y2K date window
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{warehousing/wh_defs.i}

DEFINE INPUT PARAMETER pWarehouseNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bWarehouse FOR Warehouse.
DEFINE BUFFER bBin FOR Bin.
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
    FIND FIRST bWarehouse EXCLUSIVE-LOCK WHERE bWarehouse.WarehouseNum = pWarehouseNum NO-WAIT NO-ERROR.
    IF LOCKED bWarehouse THEN DO:
        pcResult = "LOCKED: Warehouse in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bWarehouse THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bBin EXCLUSIVE-LOCK
        WHERE bBin.WarehouseNum = bWarehouse.WarehouseNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bBin)
               ttWork.Action = "UPDATE".
        IF bBin.Qty < 0 THEN DO:
            ttWork.Note = "negative Qty".
            bBin.Qty = 0.
        END.
    END.

    FOR EACH bInventoryTrans EXCLUSIVE-LOCK
        WHERE bInventoryTrans.WarehouseNum = bWarehouse.WarehouseNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bInventoryTrans)
               ttWork.Action = "UPDATE".
        IF bInventoryTrans.Qty < 0 THEN DO:
            ttWork.Note = "negative Qty".
            bInventoryTrans.Qty = 0.
        END.
    END.

    RUN shared/audit_log.p (INPUT "Warehouse", INPUT STRING(ROWID(bWarehouse)), INPUT "wh_transfer.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE flag-warehouse-city0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.City = "" OR bWarehouse.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-bin-qty1 :
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

PROCEDURE flag-warehouse-postalcode2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.PostalCode = "" OR bWarehouse.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-inventory-trans-qty3 :
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

PROCEDURE round-inventory-trans-qty4 :
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
    WHEN bInventoryTrans.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-bin-qty5 :
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

PROCEDURE calc-inventory-trans-qty6 :
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

PROCEDURE flag-warehouse-postalcode7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.PostalCode = "" OR bWarehouse.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-bin-qty8 :
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

PROCEDURE calc-inventory-trans-qty9 :
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
    WHEN bInventoryTrans.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-warehouse-postalcode10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.PostalCode = "" OR bWarehouse.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-inventory-trans-qty11 :
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
    WHEN bInventoryTrans.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-bin-qty12 :
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

PROCEDURE map-bin-qty13 :
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

PROCEDURE calc-bin-qty14 :
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

PROCEDURE calc-inventory-trans-qty15 :
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

PROCEDURE map-inventory-trans-qty16 :
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
    WHEN bInventoryTrans.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

