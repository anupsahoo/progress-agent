/*------------------------------------------------------------------------
    File        : purchase_order_import.p
    Purpose     : Import PurchaseOrder from CSV with upsert
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{purchasing/tt_purchase_order.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttPurchaseOrder.
    IMPORT DELIMITER "," ttPurchaseOrder.PONum ttPurchaseOrder.DateEntered ttPurchaseOrder.SupplierIDNum ttPurchaseOrder.ReceiveDate ttPurchaseOrder.POStatus NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttPurchaseOrder.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttPurchaseOrder:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST PurchaseOrder EXCLUSIVE-LOCK WHERE PurchaseOrder.PONum = ttPurchaseOrder.PONum NO-ERROR.
        IF NOT AVAILABLE PurchaseOrder THEN CREATE PurchaseOrder.
        BUFFER-COPY ttPurchaseOrder EXCEPT RowState ErrorMsg TO PurchaseOrder.
        RUN purchasing/purchase_order_val.p (INPUT ROWID(PurchaseOrder), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

