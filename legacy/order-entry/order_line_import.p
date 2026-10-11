/*------------------------------------------------------------------------
    File        : order_line_import.p
    Purpose     : Import OrderLine from CSV with upsert
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{order-entry/tt_order_line.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttOrderLine.
    IMPORT DELIMITER "," ttOrderLine.Ordernum ttOrderLine.Linenum ttOrderLine.Itemnum ttOrderLine.Price ttOrderLine.Qty ttOrderLine.Discount ttOrderLine.ExtendedPrice ttOrderLine.OrderLineStatus NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttOrderLine.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttOrderLine:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST OrderLine EXCLUSIVE-LOCK WHERE OrderLine.Ordernum = ttOrderLine.Ordernum AND OrderLine.Linenum = ttOrderLine.Linenum NO-ERROR.
        IF NOT AVAILABLE OrderLine THEN CREATE OrderLine.
        BUFFER-COPY ttOrderLine EXCEPT RowState ErrorMsg TO OrderLine.
        RUN order-entry/order_line_val.p (INPUT ROWID(OrderLine), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

