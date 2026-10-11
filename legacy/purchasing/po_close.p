/*------------------------------------------------------------------------
    File        : po_close.p
    Purpose     : Close fully received purchase orders
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-04  mab  remove dead code
 *  2001-10  rdh  fix rounding
 *  2003-08  mab  credit hold rule
 *  2011-09  mab  audit fields
 *  2003-06  kpo  add lock retry
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{purchasing/po_defs.i}

DEFINE INPUT PARAMETER pPONum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
DEFINE BUFFER bPOLine FOR POLine.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bPurchaseOrder EXCLUSIVE-LOCK WHERE bPurchaseOrder.PONum = pPONum NO-WAIT NO-ERROR.
    IF LOCKED bPurchaseOrder THEN DO:
        pcResult = "LOCKED: PurchaseOrder in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bPurchaseOrder THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bPOLine EXCLUSIVE-LOCK
        WHERE bPOLine.PONum = bPurchaseOrder.PONum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bPOLine)
               ttWork.Action = "UPDATE".
        IF bPOLine.Price < 0 THEN DO:
            ttWork.Note = "negative Price".
            bPOLine.Price = 0.
        END.
    END.

    RUN shared/audit_log.p (INPUT "PurchaseOrder", INPUT STRING(ROWID(bPurchaseOrder)), INPUT "po_close.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE derive-poline-price0 :
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
    WHEN bPOLine.Price > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-poline-discount1 :
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
    WHEN bPOLine.Discount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

