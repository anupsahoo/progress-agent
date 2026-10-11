/*------------------------------------------------------------------------
    File        : item_maint.p
    Purpose     : Maintain Item records
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-05  tlw  appserver split
 *  2006-12  tlw  credit hold rule
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{inventory/in_defs.i}
{inventory/item_lookup.i}

DEFINE VARIABLE pItemnum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Item Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pItemnum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Item Lookup ".

DEFINE FRAME fMain
    Item.Itemnum COLON 22
    Item.ItemName COLON 22
    Item.Price COLON 22
    Item.Onhand COLON 22
    Item.Allocated COLON 22
    Item.ReOrder COLON 22
    Item.OnOrder COLON 22 SKIP(1)
    Item.CatPage COLON 22
    Item.CatDescription COLON 22
    Item.Category1 COLON 22
    Item.Category2 COLON 22
    Item.Special COLON 22
    Item.Weight COLON 22
    Item.Minqty COLON 22 SKIP(1)
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Item Maintenance ".

ON LEAVE OF Item.Itemnum IN FRAME fMain DO:
    /* VALEXP: itemnum >= 0 */
    IF NOT (INPUT Item.Itemnum >= 0) THEN DO:
        MESSAGE "Item number must be greater or equal to 0" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Item.Price IN FRAME fMain DO:
    IF INPUT Item.Price < 0 THEN DO:
        MESSAGE "Price cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Item.Weight IN FRAME fMain DO:
    IF INPUT Item.Weight < 0 THEN DO:
        MESSAGE "Weight cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pItemnum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Item WHERE Item.Itemnum = pItemnum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Item THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Item is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Item THEN DO:
        MESSAGE "Item not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Item.
            ASSIGN Item.Itemnum = pItemnum.
        END.

        DISPLAY Item.Itemnum WITH FRAME fMain.
        UPDATE
            Item.ItemName
            Item.Price
            Item.Onhand
            Item.Allocated
            Item.ReOrder
            Item.OnOrder
            Item.CatPage
            Item.CatDescription
            Item.Category1
            Item.Category2
            Item.Special
            Item.Weight
            Item.Minqty
            WITH FRAME fMain.

        RUN inventory/item_val.p (INPUT ROWID(Item), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Item", INPUT STRING(ROWID(Item)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Item saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Item.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

