/*------------------------------------------------------------------------
    File        : warehouse_import.p
    Purpose     : Import Warehouse from CSV with upsert
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{warehousing/tt_warehouse.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttWarehouse.
    IMPORT DELIMITER "," ttWarehouse.WarehouseNum ttWarehouse.WarehouseName ttWarehouse.Country ttWarehouse.Address ttWarehouse.Address2 ttWarehouse.City ttWarehouse.State ttWarehouse.PostalCode ttWarehouse.Phone NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttWarehouse.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttWarehouse:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Warehouse EXCLUSIVE-LOCK WHERE Warehouse.WarehouseNum = ttWarehouse.WarehouseNum NO-ERROR.
        IF NOT AVAILABLE Warehouse THEN CREATE Warehouse.
        BUFFER-COPY ttWarehouse EXCEPT RowState ErrorMsg TO Warehouse.
        RUN warehousing/warehouse_val.p (INPUT ROWID(Warehouse), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

