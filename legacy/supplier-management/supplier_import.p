/*------------------------------------------------------------------------
    File        : supplier_import.p
    Purpose     : Import Supplier from CSV with upsert
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{supplier-management/tt_supplier.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttSupplier.
    IMPORT DELIMITER "," ttSupplier.SupplierIDNum ttSupplier.Name ttSupplier.Address ttSupplier.Address2 ttSupplier.City ttSupplier.State ttSupplier.PostalCode ttSupplier.Country ttSupplier.Phone ttSupplier.Comments ttSupplier.Password ttSupplier.LoginDate ttSupplier.ShipAmount ttSupplier.Discount NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttSupplier.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttSupplier:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Supplier EXCLUSIVE-LOCK WHERE Supplier.SupplierIDNum = ttSupplier.SupplierIDNum NO-ERROR.
        IF NOT AVAILABLE Supplier THEN CREATE Supplier.
        BUFFER-COPY ttSupplier EXCEPT RowState ErrorMsg TO Supplier.
        RUN supplier-management/supplier_val.p (INPUT ROWID(Supplier), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

