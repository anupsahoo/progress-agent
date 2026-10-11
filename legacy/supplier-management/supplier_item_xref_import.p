/*------------------------------------------------------------------------
    File        : supplier_item_xref_import.p
    Purpose     : Import SupplierItemXref from CSV with upsert
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{supplier-management/tt_supplier_item_xref.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttSupplierItemXref.
    IMPORT DELIMITER "," ttSupplierItemXref.SupplierIDNum ttSupplierItemXref.Itemnum NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttSupplierItemXref.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttSupplierItemXref:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST SupplierItemXref EXCLUSIVE-LOCK WHERE SupplierItemXref.SupplierIDNum = ttSupplierItemXref.SupplierIDNum AND SupplierItemXref.Itemnum = ttSupplierItemXref.Itemnum NO-ERROR.
        IF NOT AVAILABLE SupplierItemXref THEN CREATE SupplierItemXref.
        BUFFER-COPY ttSupplierItemXref EXCEPT RowState ErrorMsg TO SupplierItemXref.
        RUN supplier-management/supplier_item_xref_val.p (INPUT ROWID(SupplierItemXref), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

