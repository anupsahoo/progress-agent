/*------------------------------------------------------------------------
    File        : supplier_maint.p
    Purpose     : Maintain Supplier records
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-06  tlw  performance: use index
 *  2011-09  ssp  new report column
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{supplier-management/sm_defs.i}
{supplier-management/supplier_lookup.i}

DEFINE VARIABLE pSupplierIDNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Supplier ID".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pSupplierIDNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Supplier Lookup ".

DEFINE FRAME fMain
    Supplier.SupplierIDNum COLON 22
    Supplier.Name COLON 22
    Supplier.Address COLON 22
    Supplier.Address2 COLON 22
    Supplier.City COLON 22
    Supplier.State COLON 22
    Supplier.PostalCode COLON 22 SKIP(1)
    Supplier.Country COLON 22
    Supplier.Phone COLON 22
    Supplier.Comments COLON 22
    Supplier.Password COLON 22
    Supplier.LoginDate COLON 22
    Supplier.ShipAmount COLON 22
    Supplier.Discount COLON 22 SKIP(1)
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Supplier Maintenance ".

ON LEAVE OF Supplier.SupplierIDNum IN FRAME fMain DO:
    /* VALEXP: supplier.SupplierIDnum > 0 */
    IF NOT (INPUT Supplier.SupplierIDNum > 0) THEN DO:
        MESSAGE "Supplier number must be greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Supplier.LoginDate IN FRAME fMain DO:
    IF INPUT Supplier.LoginDate <> ? AND INPUT Supplier.LoginDate > TODAY + 3650 THEN DO:
        MESSAGE "Login Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Supplier.Discount IN FRAME fMain DO:
    /* VALEXP: Discount >= 0 */
    IF NOT (INPUT Supplier.Discount >= 0) THEN DO:
        MESSAGE "Discount must be greater or equal to 0" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pSupplierIDNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Supplier WHERE Supplier.SupplierIDNum = pSupplierIDNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Supplier THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Supplier is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Supplier THEN DO:
        MESSAGE "Supplier not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Supplier.
            ASSIGN Supplier.SupplierIDNum = pSupplierIDNum.
        END.

        DISPLAY Supplier.SupplierIDNum WITH FRAME fMain.
        UPDATE
            Supplier.Name
            Supplier.Address
            Supplier.Address2
            Supplier.City
            Supplier.State
            Supplier.PostalCode
            Supplier.Country
            Supplier.Phone
            Supplier.Comments
            Supplier.Password
            Supplier.LoginDate
            Supplier.ShipAmount
            Supplier.Discount
            WITH FRAME fMain.

        RUN supplier-management/supplier_val.p (INPUT ROWID(Supplier), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Supplier", INPUT STRING(ROWID(Supplier)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Supplier saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Supplier.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

