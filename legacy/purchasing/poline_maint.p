/*------------------------------------------------------------------------
    File        : poline_maint.p
    Purpose     : Maintain POLine records
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-10  rdh  appserver split
 *  2004-11  kpo  new report column
 *  2000-02  mab  audit fields
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{purchasing/po_defs.i}
{purchasing/poline_lookup.i}

DEFINE VARIABLE pPONum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Order Num".
DEFINE VARIABLE pLinenum AS INTEGER NO-UNDO FORMAT ">>9" LABEL "Line Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pPONum COLON 18
    pLinenum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " POLine Lookup ".

DEFINE FRAME fMain
    POLine.Linenum COLON 22
    POLine.Itemnum COLON 22
    POLine.Price COLON 22
    POLine.Qty COLON 22
    POLine.Discount COLON 22
    POLine.ExtendedPrice COLON 22
    POLine.PONum COLON 22 SKIP(1)
    POLine.POLineStatus COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " POLine Maintenance ".

ON LEAVE OF POLine.Itemnum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST item WHERE item.Itemnum = INPUT POLine.Itemnum)) THEN DO:
        MESSAGE "Item must be on file" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF POLine.Price IN FRAME fMain DO:
    IF INPUT POLine.Price < 0 THEN DO:
        MESSAGE "Price cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF POLine.ExtendedPrice IN FRAME fMain DO:
    IF INPUT POLine.ExtendedPrice < 0 THEN DO:
        MESSAGE "Extended Price cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF POLine.PONum IN FRAME fMain DO:
    IF NOT (can-find(FIRST purchaseorder WHERE purchaseorder.PONum = INPUT POLine.PONum)) THEN DO:
        MESSAGE "Purchase order must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pPONum pLinenum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST POLine WHERE POLine.PONum = pPONum
      AND POLine.Linenum = pLinenum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED POLine THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "POLine is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE POLine THEN DO:
        MESSAGE "POLine not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE POLine.
            ASSIGN POLine.PONum = pPONum
                   POLine.Linenum = pLinenum.
        END.

        DISPLAY POLine.PONum POLine.Linenum WITH FRAME fMain.
        UPDATE
            POLine.Itemnum
            POLine.Price
            POLine.Qty
            POLine.Discount
            POLine.ExtendedPrice
            POLine.POLineStatus
            WITH FRAME fMain.

        RUN purchasing/poline_val.p (INPUT ROWID(POLine), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "POLine", INPUT STRING(ROWID(POLine)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "POLine saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE POLine.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

