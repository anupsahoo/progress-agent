/*------------------------------------------------------------------------
    File        : ship_to_maint.p
    Purpose     : Maintain ShipTo records
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-11  ssp  remove dead code
 *  2010-11  ssp  audit fields
 *  2004-11  rdh  add lock retry
 *  2004-06  tlw  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{order-fulfilment/of_defs.i}
{order-fulfilment/ship_to_lookup.i}

DEFINE VARIABLE pCustNum AS INTEGER NO-UNDO FORMAT ">>>>9" LABEL "Cust Num".
DEFINE VARIABLE pShipToID AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Ship To ID".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pCustNum COLON 18
    pShipToID COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " ShipTo Lookup ".

DEFINE FRAME fMain
    ShipTo.CustNum COLON 22
    ShipTo.ShipToID COLON 22
    ShipTo.Contact COLON 22
    ShipTo.Address COLON 22
    ShipTo.Address2 COLON 22
    ShipTo.City COLON 22
    ShipTo.State COLON 22 SKIP(1)
    ShipTo.PostalCode COLON 22
    ShipTo.Phone COLON 22
    ShipTo.Comments COLON 22
    ShipTo.Name COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " ShipTo Maintenance ".

ON LEAVE OF ShipTo.CustNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST customer WHERE customer.CustNum = INPUT ShipTo.CustNum)) THEN DO:
        MESSAGE "Customer must exist" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pCustNum pShipToID WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST ShipTo WHERE ShipTo.CustNum = pCustNum
      AND ShipTo.ShipToID = pShipToID
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED ShipTo THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "ShipTo is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE ShipTo THEN DO:
        MESSAGE "ShipTo not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE ShipTo.
            ASSIGN ShipTo.CustNum = pCustNum
                   ShipTo.ShipToID = pShipToID.
        END.

        DISPLAY ShipTo.CustNum ShipTo.ShipToID WITH FRAME fMain.
        UPDATE
            ShipTo.Contact
            ShipTo.Address
            ShipTo.Address2
            ShipTo.City
            ShipTo.State
            ShipTo.PostalCode
            ShipTo.Phone
            ShipTo.Comments
            ShipTo.Name
            WITH FRAME fMain.

        RUN order-fulfilment/ship_to_val.p (INPUT ROWID(ShipTo), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "ShipTo", INPUT STRING(ROWID(ShipTo)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "ShipTo saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE ShipTo.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

