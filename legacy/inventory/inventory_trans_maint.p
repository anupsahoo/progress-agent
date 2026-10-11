/*------------------------------------------------------------------------
    File        : inventory_trans_maint.p
    Purpose     : Maintain InventoryTrans records
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-12  ssp  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{inventory/in_defs.i}
{inventory/inventory_trans_lookup.i}

DEFINE VARIABLE pInvTransNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Inventory Trans Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pInvTransNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " InventoryTrans Lookup ".

DEFINE FRAME fMain
    InventoryTrans.InvTransNum COLON 22
    InventoryTrans.WarehouseNum COLON 22
    InventoryTrans.BinNum COLON 22
    InventoryTrans.Qty COLON 22
    InventoryTrans.Itemnum COLON 22
    InventoryTrans.TransDate COLON 22
    InventoryTrans.InvType COLON 22 SKIP(1)
    InventoryTrans.PONum COLON 22
    InventoryTrans.Ordernum COLON 22
    InventoryTrans.Transtime COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " InventoryTrans Maintenance ".

ON LEAVE OF InventoryTrans.Itemnum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST item WHERE item.Itemnum = INPUT InventoryTrans.Itemnum)) THEN DO:
        MESSAGE "Item must be on file." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF InventoryTrans.TransDate IN FRAME fMain DO:
    IF INPUT InventoryTrans.TransDate <> ? AND INPUT InventoryTrans.TransDate > TODAY + 3650 THEN DO:
        MESSAGE "Trans Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pInvTransNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST InventoryTrans WHERE InventoryTrans.InvTransNum = pInvTransNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED InventoryTrans THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "InventoryTrans is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE InventoryTrans THEN DO:
        MESSAGE "InventoryTrans not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE InventoryTrans.
            ASSIGN InventoryTrans.InvTransNum = pInvTransNum.
        END.

        DISPLAY InventoryTrans.InvTransNum WITH FRAME fMain.
        UPDATE
            InventoryTrans.WarehouseNum
            InventoryTrans.BinNum
            InventoryTrans.Qty
            InventoryTrans.Itemnum
            InventoryTrans.TransDate
            InventoryTrans.InvType
            InventoryTrans.PONum
            InventoryTrans.Ordernum
            InventoryTrans.Transtime
            WITH FRAME fMain.

        RUN inventory/inventory_trans_val.p (INPUT ROWID(InventoryTrans), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "InventoryTrans", INPUT STRING(ROWID(InventoryTrans)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "InventoryTrans saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE InventoryTrans.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

