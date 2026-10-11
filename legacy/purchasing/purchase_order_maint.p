/*------------------------------------------------------------------------
    File        : purchase_order_maint.p
    Purpose     : Maintain PurchaseOrder records
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-09  kpo  performance: use index
 *  2003-08  rdh  fix rounding
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{purchasing/po_defs.i}
{purchasing/purchase_order_lookup.i}

DEFINE VARIABLE pPONum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "PO Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pPONum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " PurchaseOrder Lookup ".

DEFINE FRAME fMain
    PurchaseOrder.PONum COLON 22
    PurchaseOrder.DateEntered COLON 22
    PurchaseOrder.SupplierIDNum COLON 22
    PurchaseOrder.ReceiveDate COLON 22
    PurchaseOrder.POStatus COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " PurchaseOrder Maintenance ".

ON LEAVE OF PurchaseOrder.PONum IN FRAME fMain DO:
    /* VALEXP: ponum > 0 */
    IF NOT (INPUT PurchaseOrder.PONum > 0) THEN DO:
        MESSAGE "PO number must be greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF PurchaseOrder.DateEntered IN FRAME fMain DO:
    IF INPUT PurchaseOrder.DateEntered <> ? AND INPUT PurchaseOrder.DateEntered > TODAY + 3650 THEN DO:
        MESSAGE "Date Entered is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF PurchaseOrder.SupplierIDNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST supplier WHERE supplier.SupplierIDNum = INPUT PurchaseOrder.SupplierIDNum)) THEN DO:
        MESSAGE "Supplier must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF PurchaseOrder.ReceiveDate IN FRAME fMain DO:
    IF INPUT PurchaseOrder.ReceiveDate <> ? AND INPUT PurchaseOrder.ReceiveDate > TODAY + 3650 THEN DO:
        MESSAGE "Date Received is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pPONum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST PurchaseOrder WHERE PurchaseOrder.PONum = pPONum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED PurchaseOrder THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "PurchaseOrder is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE PurchaseOrder THEN DO:
        MESSAGE "PurchaseOrder not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE PurchaseOrder.
            ASSIGN PurchaseOrder.PONum = pPONum.
        END.

        DISPLAY PurchaseOrder.PONum WITH FRAME fMain.
        UPDATE
            PurchaseOrder.DateEntered
            PurchaseOrder.SupplierIDNum
            PurchaseOrder.ReceiveDate
            PurchaseOrder.POStatus
            WITH FRAME fMain.

        RUN purchasing/purchase_order_val.p (INPUT ROWID(PurchaseOrder), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "PurchaseOrder", INPUT STRING(ROWID(PurchaseOrder)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "PurchaseOrder saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE PurchaseOrder.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

