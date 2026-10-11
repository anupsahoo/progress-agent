/*------------------------------------------------------------------------
    File        : invoice_maint.p
    Purpose     : Maintain Invoice records
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-07  jkm  performance: use index
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{billing-invoicing/bi_defs.i}
{billing-invoicing/invoice_lookup.i}

DEFINE VARIABLE pInvoicenum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Invoice Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pInvoicenum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Invoice Lookup ".

DEFINE FRAME fMain
    Invoice.Invoicenum COLON 22
    Invoice.CustNum COLON 22
    Invoice.InvoiceDate COLON 22
    Invoice.Amount COLON 22
    Invoice.TotalPaid COLON 22
    Invoice.Adjustment COLON 22
    Invoice.OrderNum COLON 22 SKIP(1)
    Invoice.ShipCharge COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Invoice Maintenance ".

ON LEAVE OF Invoice.Invoicenum IN FRAME fMain DO:
    /* VALEXP: invoicenum > 0 */
    IF NOT (INPUT Invoice.Invoicenum > 0) THEN DO:
        MESSAGE "Invoice number cannot be zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Invoice.CustNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST customer WHERE customer.CustNum = INPUT Invoice.CustNum)) THEN DO:
        MESSAGE "The Customer number entered must be a valid one." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Invoice.InvoiceDate IN FRAME fMain DO:
    IF INPUT Invoice.InvoiceDate <> ? AND INPUT Invoice.InvoiceDate > TODAY + 3650 THEN DO:
        MESSAGE "Invoice Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Invoice.Amount IN FRAME fMain DO:
    IF INPUT Invoice.Amount < 0 THEN DO:
        MESSAGE "Amount cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Invoice.TotalPaid IN FRAME fMain DO:
    IF INPUT Invoice.TotalPaid < 0 THEN DO:
        MESSAGE "Total Paid cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Invoice.Adjustment IN FRAME fMain DO:
    IF INPUT Invoice.Adjustment < 0 THEN DO:
        MESSAGE "Adjustment cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Invoice.ShipCharge IN FRAME fMain DO:
    IF INPUT Invoice.ShipCharge < 0 THEN DO:
        MESSAGE "Ship Charge cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pInvoicenum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Invoice WHERE Invoice.Invoicenum = pInvoicenum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Invoice THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Invoice is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Invoice THEN DO:
        MESSAGE "Invoice not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Invoice.
            ASSIGN Invoice.Invoicenum = pInvoicenum.
        END.

        DISPLAY Invoice.Invoicenum WITH FRAME fMain.
        UPDATE
            Invoice.CustNum
            Invoice.InvoiceDate
            Invoice.Amount
            Invoice.TotalPaid
            Invoice.Adjustment
            Invoice.OrderNum
            Invoice.ShipCharge
            WITH FRAME fMain.

        RUN billing-invoicing/invoice_val.p (INPUT ROWID(Invoice), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Invoice", INPUT STRING(ROWID(Invoice)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Invoice saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Invoice.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

