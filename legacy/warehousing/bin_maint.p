/*------------------------------------------------------------------------
    File        : bin_maint.p
    Purpose     : Maintain Bin records
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-11  mab  Y2K date window
 *  2010-11  tlw  remove dead code
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{warehousing/wh_defs.i}
{warehousing/bin_lookup.i}

DEFINE VARIABLE pBinNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Bin Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pBinNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Bin Lookup ".

DEFINE FRAME fMain
    Bin.WarehouseNum COLON 22
    Bin.Itemnum COLON 22
    Bin.Qty COLON 22
    Bin.BinNum COLON 22
    Bin.BinName COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Bin Maintenance ".

ON LEAVE OF Bin.WarehouseNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST warehouse WHERE warehouse.WarehouseNum = INPUT Bin.WarehouseNum)) THEN DO:
        MESSAGE "Warehouse must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Bin.Itemnum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST item WHERE item.Itemnum = INPUT Bin.Itemnum)) THEN DO:
        MESSAGE "Item must be on file" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pBinNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Bin WHERE Bin.BinNum = pBinNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Bin THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Bin is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Bin THEN DO:
        MESSAGE "Bin not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Bin.
            ASSIGN Bin.BinNum = pBinNum.
        END.

        DISPLAY Bin.BinNum WITH FRAME fMain.
        UPDATE
            Bin.WarehouseNum
            Bin.Itemnum
            Bin.Qty
            Bin.BinName
            WITH FRAME fMain.

        RUN warehousing/bin_val.p (INPUT ROWID(Bin), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Bin", INPUT STRING(ROWID(Bin)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Bin saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Bin.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

