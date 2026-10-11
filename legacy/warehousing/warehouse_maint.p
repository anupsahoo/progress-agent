/*------------------------------------------------------------------------
    File        : warehouse_maint.p
    Purpose     : Maintain Warehouse records
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-12  kpo  add lock retry
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{warehousing/wh_defs.i}
{warehousing/warehouse_lookup.i}

DEFINE VARIABLE pWarehouseNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Warehouse Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pWarehouseNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Warehouse Lookup ".

DEFINE FRAME fMain
    Warehouse.WarehouseNum COLON 22
    Warehouse.WarehouseName COLON 22
    Warehouse.Country COLON 22
    Warehouse.Address COLON 22
    Warehouse.Address2 COLON 22
    Warehouse.City COLON 22
    Warehouse.State COLON 22 SKIP(1)
    Warehouse.PostalCode COLON 22
    Warehouse.Phone COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Warehouse Maintenance ".

ON LEAVE OF Warehouse.WarehouseNum IN FRAME fMain DO:
    /* VALEXP: warehousenum > 0 */
    IF NOT (INPUT Warehouse.WarehouseNum > 0) THEN DO:
        MESSAGE "Entrer a number greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pWarehouseNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Warehouse WHERE Warehouse.WarehouseNum = pWarehouseNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Warehouse THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Warehouse is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Warehouse THEN DO:
        MESSAGE "Warehouse not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Warehouse.
            ASSIGN Warehouse.WarehouseNum = pWarehouseNum.
        END.

        DISPLAY Warehouse.WarehouseNum WITH FRAME fMain.
        UPDATE
            Warehouse.WarehouseName
            Warehouse.Country
            Warehouse.Address
            Warehouse.Address2
            Warehouse.City
            Warehouse.State
            Warehouse.PostalCode
            Warehouse.Phone
            WITH FRAME fMain.

        RUN warehousing/warehouse_val.p (INPUT ROWID(Warehouse), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Warehouse", INPUT STRING(ROWID(Warehouse)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Warehouse saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Warehouse.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

