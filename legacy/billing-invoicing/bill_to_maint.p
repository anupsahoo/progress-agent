/*------------------------------------------------------------------------
    File        : bill_to_maint.p
    Purpose     : Maintain BillTo records
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-08  rdh  fix rounding
 *  2006-10  tlw  Y2K date window
 *  2008-07  tlw  Y2K date window
 *  2003-08  rdh  new report column
 *  2002-05  rdh  remove dead code
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{billing-invoicing/bi_defs.i}
{billing-invoicing/bill_to_lookup.i}

DEFINE VARIABLE pCustNum AS INTEGER NO-UNDO FORMAT ">>>>9" LABEL "Cust Num".
DEFINE VARIABLE pBillToID AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "BillToID".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pCustNum COLON 18
    pBillToID COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " BillTo Lookup ".

DEFINE FRAME fMain
    BillTo.CustNum COLON 22
    BillTo.BillToID COLON 22
    BillTo.Name COLON 22
    BillTo.Address COLON 22
    BillTo.Address2 COLON 22
    BillTo.City COLON 22
    BillTo.State COLON 22 SKIP(1)
    BillTo.PostalCode COLON 22
    BillTo.Contact COLON 22
    BillTo.Phone COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " BillTo Maintenance ".

ON LEAVE OF BillTo.CustNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST customer WHERE customer.CustNum = INPUT BillTo.CustNum)) THEN DO:
        MESSAGE "Customer number must be greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pCustNum pBillToID WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST BillTo WHERE BillTo.CustNum = pCustNum
      AND BillTo.BillToID = pBillToID
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED BillTo THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "BillTo is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE BillTo THEN DO:
        MESSAGE "BillTo not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE BillTo.
            ASSIGN BillTo.CustNum = pCustNum
                   BillTo.BillToID = pBillToID.
        END.

        DISPLAY BillTo.CustNum BillTo.BillToID WITH FRAME fMain.
        UPDATE
            BillTo.Name
            BillTo.Address
            BillTo.Address2
            BillTo.City
            BillTo.State
            BillTo.PostalCode
            BillTo.Contact
            BillTo.Phone
            WITH FRAME fMain.

        RUN billing-invoicing/bill_to_val.p (INPUT ROWID(BillTo), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "BillTo", INPUT STRING(ROWID(BillTo)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "BillTo saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE BillTo.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

