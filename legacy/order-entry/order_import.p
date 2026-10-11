/*------------------------------------------------------------------------
    File        : order_import.p
    Purpose     : Import Order from CSV with upsert
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{order-entry/tt_order.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttOrder.
    IMPORT DELIMITER "," ttOrder.Ordernum ttOrder.CustNum ttOrder.OrderDate ttOrder.ShipDate ttOrder.PromiseDate ttOrder.Carrier ttOrder.Instructions ttOrder.PO ttOrder.Terms ttOrder.SalesRep ttOrder.BillToID ttOrder.ShipToID ttOrder.OrderStatus ttOrder.WarehouseNum ttOrder.Creditcard NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttOrder.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttOrder:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Order EXCLUSIVE-LOCK WHERE Order.Ordernum = ttOrder.Ordernum NO-ERROR.
        IF NOT AVAILABLE Order THEN CREATE Order.
        BUFFER-COPY ttOrder EXCEPT RowState ErrorMsg TO Order.
        RUN order-entry/order_val.p (INPUT ROWID(Order), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

