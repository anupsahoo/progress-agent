/*------------------------------------------------------------------------
    File        : bill_to_import.p
    Purpose     : Import BillTo from CSV with upsert
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{billing-invoicing/tt_bill_to.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttBillTo.
    IMPORT DELIMITER "," ttBillTo.CustNum ttBillTo.BillToID ttBillTo.Name ttBillTo.Address ttBillTo.Address2 ttBillTo.City ttBillTo.State ttBillTo.PostalCode ttBillTo.Contact ttBillTo.Phone NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttBillTo.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttBillTo:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST BillTo EXCLUSIVE-LOCK WHERE BillTo.CustNum = ttBillTo.CustNum AND BillTo.BillToID = ttBillTo.BillToID NO-ERROR.
        IF NOT AVAILABLE BillTo THEN CREATE BillTo.
        BUFFER-COPY ttBillTo EXCEPT RowState ErrorMsg TO BillTo.
        RUN billing-invoicing/bill_to_val.p (INPUT ROWID(BillTo), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

