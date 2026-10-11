/*------------------------------------------------------------------------
    File        : customer_maint.p
    Purpose     : Maintain Customer records
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-12  kpo  fix rounding
 *  2002-10  tlw  add lock retry
 *  2008-08  rdh  fix rounding
 *  2007-10  kpo  add lock retry
 *  2004-04  jkm  credit hold rule
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{customer-management/cm_defs.i}
{customer-management/customer_lookup.i}

DEFINE VARIABLE pCustNum AS INTEGER NO-UNDO FORMAT ">>>>9" LABEL "Cust Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pCustNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Customer Lookup ".

DEFINE FRAME fMain
    Customer.CustNum COLON 22
    Customer.Country COLON 22
    Customer.Name COLON 22
    Customer.Address COLON 22
    Customer.Address2 COLON 22
    Customer.City COLON 22
    Customer.State COLON 22 SKIP(1)
    Customer.PostalCode COLON 22
    Customer.Contact COLON 22
    Customer.Phone COLON 22
    Customer.SalesRep COLON 22
    Customer.CreditLimit COLON 22
    Customer.Balance COLON 22
    Customer.Terms COLON 22 SKIP(1)
    Customer.Discount COLON 22
    Customer.Comments COLON 22
    Customer.Fax COLON 22
    Customer.EmailAddress COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Customer Maintenance ".

ON LEAVE OF Customer.CustNum IN FRAME fMain DO:
    /* VALEXP: custnum > 0 */
    IF NOT (INPUT Customer.CustNum > 0) THEN DO:
        MESSAGE "Customer number must be greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Customer.SalesRep IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST Salesrep WHERE Salesrep.SalesRep = INPUT Customer.SalesRep)) THEN DO:
        MESSAGE "The Sales Rep's name you've entered must exist in the Salesrep table." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Customer.CreditLimit IN FRAME fMain DO:
    /* VALEXP: CreditLimit >= 0 AND CreditLimit <= 9999999 */
    IF NOT (INPUT Customer.CreditLimit >= 0) THEN DO:
        MESSAGE "Credit Limit must be >= 0 and <= 9,999,999" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Customer.Balance IN FRAME fMain DO:
    IF INPUT Customer.Balance < 0 THEN DO:
        MESSAGE "Balance cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Customer.Discount IN FRAME fMain DO:
    /* VALEXP: Discount >= 0 */
    IF NOT (INPUT Customer.Discount >= 0) THEN DO:
        MESSAGE "Discount must be greater or equal to 0" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pCustNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Customer WHERE Customer.CustNum = pCustNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Customer THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Customer is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Customer THEN DO:
        MESSAGE "Customer not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Customer.
            ASSIGN Customer.CustNum = pCustNum.
        END.

        DISPLAY Customer.CustNum WITH FRAME fMain.
        UPDATE
            Customer.Country
            Customer.Name
            Customer.Address
            Customer.Address2
            Customer.City
            Customer.State
            Customer.PostalCode
            Customer.Contact
            Customer.Phone
            Customer.SalesRep
            Customer.CreditLimit
            Customer.Balance
            Customer.Terms
            Customer.Discount
            Customer.Comments
            Customer.Fax
            Customer.EmailAddress
            WITH FRAME fMain.

        RUN customer-management/customer_val.p (INPUT ROWID(Customer), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Customer", INPUT STRING(ROWID(Customer)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Customer saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Customer.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

