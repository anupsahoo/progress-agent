/*------------------------------------------------------------------------
    File        : ship_to_import.p
    Purpose     : Import ShipTo from CSV with upsert
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{order-fulfilment/tt_ship_to.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttShipTo.
    IMPORT DELIMITER "," ttShipTo.CustNum ttShipTo.ShipToID ttShipTo.Contact ttShipTo.Address ttShipTo.Address2 ttShipTo.City ttShipTo.State ttShipTo.PostalCode ttShipTo.Phone ttShipTo.Comments ttShipTo.Name NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttShipTo.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttShipTo:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST ShipTo EXCLUSIVE-LOCK WHERE ShipTo.CustNum = ttShipTo.CustNum AND ShipTo.ShipToID = ttShipTo.ShipToID NO-ERROR.
        IF NOT AVAILABLE ShipTo THEN CREATE ShipTo.
        BUFFER-COPY ttShipTo EXCEPT RowState ErrorMsg TO ShipTo.
        RUN order-fulfilment/ship_to_val.p (INPUT ROWID(ShipTo), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

