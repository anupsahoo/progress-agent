/*------------------------------------------------------------------------
    File        : po_receipt_post.p
    Purpose     : Post receipts to stock and close lines
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-05  kpo  audit fields
 *  2003-07  rdh  appserver split
 *  2017-11  rdh  new report column
 *  2010-05  mab  remove dead code
 *  2014-01  jkm  credit hold rule
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{purchasing/po_defs.i}

DEFINE INPUT PARAMETER pPONum AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pLinenum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bPOLine FOR POLine.
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
    FIND FIRST bPOLine EXCLUSIVE-LOCK WHERE bPOLine.PONum = pPONum AND bPOLine.Linenum = pLinenum NO-WAIT NO-ERROR.
    IF LOCKED bPOLine THEN DO:
        pcResult = "LOCKED: POLine in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bPOLine THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bInventoryTrans EXCLUSIVE-LOCK
        WHERE bInventoryTrans.Itemnum = bPOLine.Itemnum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bInventoryTrans)
               ttWork.Action = "UPDATE".
        IF bInventoryTrans.Qty < 0 THEN DO:
            ttWork.Note = "negative Qty".
            bInventoryTrans.Qty = 0.
        END.
    END.

    /* Never leave a negative Price behind */
    ASSIGN bPOLine.Price = MAX(0, bPOLine.Price).
    RUN shared/audit_log.p (INPUT "POLine", INPUT STRING(ROWID(bPOLine)), INPUT "po_receipt_post.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE calc-poline-discount0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Discount < 0 THEN plOk = NO.
    WHEN bPOLine.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-poline-price1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Price < 0 THEN plOk = NO.
    WHEN bPOLine.Price > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-inventory-trans-qty2 :
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

PROCEDURE apply-poline-extendedprice3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.ExtendedPrice < 0 THEN plOk = NO.
    WHEN bPOLine.ExtendedPrice > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-inventory-trans-qty4 :
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

PROCEDURE derive-inventory-trans-qty5 :
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
    WHEN bInventoryTrans.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "InventoryTrans.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-inventory-trans-qty7 :
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

PROCEDURE reset-poline-qty8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Qty < 0 THEN plOk = NO.
    WHEN bPOLine.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-inventory-trans-qty9 :
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

