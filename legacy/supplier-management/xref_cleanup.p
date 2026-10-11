/*------------------------------------------------------------------------
    File        : xref_cleanup.p
    Purpose     : Remove cross references for discontinued items
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-07  kpo  add lock retry
 *  2011-02  jkm  Y2K date window
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{supplier-management/sm_defs.i}

DEFINE INPUT PARAMETER pSupplierIDNum AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pItemnum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bSupplierItemXref FOR SupplierItemXref.
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
    FIND FIRST bSupplierItemXref EXCLUSIVE-LOCK WHERE bSupplierItemXref.SupplierIDNum = pSupplierIDNum AND bSupplierItemXref.Itemnum = pItemnum NO-WAIT NO-ERROR.
    IF LOCKED bSupplierItemXref THEN DO:
        pcResult = "LOCKED: SupplierItemXref in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bSupplierItemXref THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bItem EXCLUSIVE-LOCK
        WHERE bItem.Itemnum = bSupplierItemXref.Itemnum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bItem)
               ttWork.Action = "UPDATE".
        IF bItem.Price < 0 THEN DO:
            ttWork.Note = "negative Price".
            bItem.Price = 0.
        END.
    END.

    RUN shared/audit_log.p (INPUT "SupplierItemXref", INPUT STRING(ROWID(bSupplierItemXref)), INPUT "xref_cleanup.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE post-item-onorder0 :
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

PROCEDURE check-item-weight1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Weight < 0 THEN plOk = NO.
    WHEN bItem.Weight > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Weight above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-item-onorder5 :
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

PROCEDURE reset-item-onhand6 :
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

PROCEDURE map-item-reorder10 :
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
    WHEN bItem.ReOrder > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.ReOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-item-onorder11 :
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
    WHEN bItem.OnOrder > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.OnOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

