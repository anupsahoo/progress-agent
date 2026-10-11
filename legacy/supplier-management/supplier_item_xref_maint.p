/*------------------------------------------------------------------------
    File        : supplier_item_xref_maint.p
    Purpose     : Maintain SupplierItemXref records
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-03  kpo  audit fields
 *  2010-08  kpo  performance: use index
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{supplier-management/sm_defs.i}
{supplier-management/supplier_item_xref_lookup.i}

DEFINE VARIABLE pSupplierIDNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Supplier ID".
DEFINE VARIABLE pItemnum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Item #".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pSupplierIDNum COLON 18
    pItemnum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " SupplierItemXref Lookup ".

DEFINE FRAME fMain
    SupplierItemXref.SupplierIDNum COLON 22
    SupplierItemXref.Itemnum COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " SupplierItemXref Maintenance ".

ON LEAVE OF SupplierItemXref.SupplierIDNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST supplier WHERE supplier.SupplierIDNum = INPUT SupplierItemXref.SupplierIDNum)) THEN DO:
        MESSAGE "Supplier must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF SupplierItemXref.Itemnum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST item WHERE item.Itemnum = INPUT SupplierItemXref.Itemnum)) THEN DO:
        MESSAGE "Item must be on file." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pSupplierIDNum pItemnum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST SupplierItemXref WHERE SupplierItemXref.SupplierIDNum = pSupplierIDNum
      AND SupplierItemXref.Itemnum = pItemnum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED SupplierItemXref THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "SupplierItemXref is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE SupplierItemXref THEN DO:
        MESSAGE "SupplierItemXref not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE SupplierItemXref.
            ASSIGN SupplierItemXref.SupplierIDNum = pSupplierIDNum
                   SupplierItemXref.Itemnum = pItemnum.
        END.

        DISPLAY SupplierItemXref.SupplierIDNum SupplierItemXref.Itemnum WITH FRAME fMain.
        UPDATE
            WITH FRAME fMain.

        RUN supplier-management/supplier_item_xref_val.p (INPUT ROWID(SupplierItemXref), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "SupplierItemXref", INPUT STRING(ROWID(SupplierItemXref)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "SupplierItemXref saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE SupplierItemXref.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

