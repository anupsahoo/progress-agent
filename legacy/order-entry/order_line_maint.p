/*------------------------------------------------------------------------
    File        : order_line_maint.p
    Purpose     : Maintain OrderLine records
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-01  rdh  new report column
 *  2014-02  kpo  fix rounding
 *  2001-08  kpo  Y2K date window
 *  2015-09  ssp  add lock retry
 *  2008-12  mab  audit fields
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{order-entry/oe_defs.i}
{order-entry/order_line_lookup.i}

DEFINE VARIABLE pOrdernum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Order Num".
DEFINE VARIABLE pLinenum AS INTEGER NO-UNDO FORMAT ">>9" LABEL "Line Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pOrdernum COLON 18
    pLinenum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " OrderLine Lookup ".

DEFINE FRAME fMain
    OrderLine.Ordernum COLON 22
    OrderLine.Linenum COLON 22
    OrderLine.Itemnum COLON 22
    OrderLine.Price COLON 22
    OrderLine.Qty COLON 22
    OrderLine.Discount COLON 22
    OrderLine.ExtendedPrice COLON 22 SKIP(1)
    OrderLine.OrderLineStatus COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " OrderLine Maintenance ".

ON LEAVE OF OrderLine.Ordernum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST order WHERE order.Ordernum = INPUT OrderLine.Ordernum)) THEN DO:
        MESSAGE "Order must exist" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF OrderLine.Itemnum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST item WHERE item.Itemnum = INPUT OrderLine.Itemnum)) THEN DO:
        MESSAGE "Item must be on file" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF OrderLine.Price IN FRAME fMain DO:
    IF INPUT OrderLine.Price < 0 THEN DO:
        MESSAGE "Price cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF OrderLine.ExtendedPrice IN FRAME fMain DO:
    IF INPUT OrderLine.ExtendedPrice < 0 THEN DO:
        MESSAGE "Extended Price cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pOrdernum pLinenum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST OrderLine WHERE OrderLine.Ordernum = pOrdernum
      AND OrderLine.Linenum = pLinenum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED OrderLine THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "OrderLine is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE OrderLine THEN DO:
        MESSAGE "OrderLine not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE OrderLine.
            ASSIGN OrderLine.Ordernum = pOrdernum
                   OrderLine.Linenum = pLinenum.
        END.

        DISPLAY OrderLine.Ordernum OrderLine.Linenum WITH FRAME fMain.
        UPDATE
            OrderLine.Itemnum
            OrderLine.Price
            OrderLine.Qty
            OrderLine.Discount
            OrderLine.ExtendedPrice
            OrderLine.OrderLineStatus
            WITH FRAME fMain.

        RUN order-entry/order_line_val.p (INPUT ROWID(OrderLine), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "OrderLine", INPUT STRING(ROWID(OrderLine)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "OrderLine saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE OrderLine.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

