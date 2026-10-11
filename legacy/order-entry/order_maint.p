/*------------------------------------------------------------------------
    File        : order_maint.p
    Purpose     : Maintain Order records
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-11  rdh  Y2K date window
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{order-entry/oe_defs.i}
{order-entry/order_lookup.i}

DEFINE VARIABLE pOrdernum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Order Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pOrdernum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Order Lookup ".

DEFINE FRAME fMain
    Order.Ordernum COLON 22
    Order.CustNum COLON 22
    Order.OrderDate COLON 22
    Order.ShipDate COLON 22
    Order.PromiseDate COLON 22
    Order.Carrier COLON 22
    Order.Instructions COLON 22 SKIP(1)
    Order.PO COLON 22
    Order.Terms COLON 22
    Order.SalesRep COLON 22
    Order.BillToID COLON 22
    Order.ShipToID COLON 22
    Order.OrderStatus COLON 22
    Order.WarehouseNum COLON 22 SKIP(1)
    Order.Creditcard COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Order Maintenance ".

ON LEAVE OF Order.Ordernum IN FRAME fMain DO:
    /* VALEXP: ordernum > 0 */
    IF NOT (INPUT Order.Ordernum > 0) THEN DO:
        MESSAGE "Order number must be greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Order.CustNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST customer WHERE customer.CustNum = INPUT Order.CustNum)) THEN DO:
        MESSAGE "Customer must already exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Order.OrderDate IN FRAME fMain DO:
    IF INPUT Order.OrderDate <> ? AND INPUT Order.OrderDate > TODAY + 3650 THEN DO:
        MESSAGE "Ordered is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Order.ShipDate IN FRAME fMain DO:
    IF INPUT Order.ShipDate <> ? AND INPUT Order.ShipDate > TODAY + 3650 THEN DO:
        MESSAGE "Shipped is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Order.PromiseDate IN FRAME fMain DO:
    IF INPUT Order.PromiseDate <> ? AND INPUT Order.PromiseDate > TODAY + 3650 THEN DO:
        MESSAGE "Promised is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Order.WarehouseNum IN FRAME fMain DO:
    IF NOT ((INPUT Order.WarehouseNum = 0) or can-find(FIRST warehouse WHERE warehouse.WarehouseNum = INPUT Order.WarehouseNum)) THEN DO:
        MESSAGE "Entrer a number greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pOrdernum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Order WHERE Order.Ordernum = pOrdernum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Order THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Order is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Order THEN DO:
        MESSAGE "Order not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Order.
            ASSIGN Order.Ordernum = pOrdernum.
        END.

        DISPLAY Order.Ordernum WITH FRAME fMain.
        UPDATE
            Order.CustNum
            Order.OrderDate
            Order.ShipDate
            Order.PromiseDate
            Order.Carrier
            Order.Instructions
            Order.PO
            Order.Terms
            Order.SalesRep
            Order.BillToID
            Order.ShipToID
            Order.OrderStatus
            Order.WarehouseNum
            Order.Creditcard
            WITH FRAME fMain.

        RUN order-entry/order_val.p (INPUT ROWID(Order), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Order", INPUT STRING(ROWID(Order)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Order saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Order.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

