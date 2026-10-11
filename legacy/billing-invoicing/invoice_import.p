/*------------------------------------------------------------------------
    File        : invoice_import.p
    Purpose     : Import Invoice from CSV with upsert
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{billing-invoicing/tt_invoice.i}

DEFINE INPUT  PARAMETER pcFile   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER piLoaded AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER piReject AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.

INPUT FROM VALUE(pcFile).
IMPORT ^. /* skip header */
REPEAT:
    CREATE ttInvoice.
    IMPORT DELIMITER "," ttInvoice.Invoicenum ttInvoice.CustNum ttInvoice.InvoiceDate ttInvoice.Amount ttInvoice.TotalPaid ttInvoice.Adjustment ttInvoice.OrderNum ttInvoice.ShipCharge NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        DELETE ttInvoice.
        piReject = piReject + 1.
        NEXT.
    END.
END.
INPUT CLOSE.

FOR EACH ttInvoice:
    DO TRANSACTION ON ERROR UNDO, NEXT:
        FIND FIRST Invoice EXCLUSIVE-LOCK WHERE Invoice.Invoicenum = ttInvoice.Invoicenum NO-ERROR.
        IF NOT AVAILABLE Invoice THEN CREATE Invoice.
        BUFFER-COPY ttInvoice EXCEPT RowState ErrorMsg TO Invoice.
        RUN billing-invoicing/invoice_val.p (INPUT ROWID(Invoice), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            piReject = piReject + 1.
            UNDO, NEXT.
        END.
        piLoaded = piLoaded + 1.
    END.
END.

