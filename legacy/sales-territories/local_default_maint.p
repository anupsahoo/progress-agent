/*------------------------------------------------------------------------
    File        : local_default_maint.p
    Purpose     : Maintain LocalDefault records
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-07  tlw  fix rounding
 *  2014-03  tlw  performance: use index
 *  2010-01  tlw  fix rounding
 *  2010-10  rdh  add lock retry
 *  2007-09  ssp  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{sales-territories/st_defs.i}
{sales-territories/local_default_lookup.i}

DEFINE VARIABLE pLocalDefNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Local Default Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pLocalDefNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " LocalDefault Lookup ".

DEFINE FRAME fMain
    LocalDefault.Country COLON 22
    LocalDefault.Region1Label COLON 22
    LocalDefault.Region2Label COLON 22
    LocalDefault.PostalLabel COLON 22
    LocalDefault.PostalFormat COLON 22
    LocalDefault.TelFormat COLON 22
    LocalDefault.CurrencySymbol COLON 22 SKIP(1)
    LocalDefault.DateFormat COLON 22
    LocalDefault.LocalDefNum COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " LocalDefault Maintenance ".

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pLocalDefNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST LocalDefault WHERE LocalDefault.LocalDefNum = pLocalDefNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED LocalDefault THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "LocalDefault is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE LocalDefault THEN DO:
        MESSAGE "LocalDefault not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE LocalDefault.
            ASSIGN LocalDefault.LocalDefNum = pLocalDefNum.
        END.

        DISPLAY LocalDefault.LocalDefNum WITH FRAME fMain.
        UPDATE
            LocalDefault.Country
            LocalDefault.Region1Label
            LocalDefault.Region2Label
            LocalDefault.PostalLabel
            LocalDefault.PostalFormat
            LocalDefault.TelFormat
            LocalDefault.CurrencySymbol
            LocalDefault.DateFormat
            WITH FRAME fMain.

        RUN sales-territories/local_default_val.p (INPUT ROWID(LocalDefault), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "LocalDefault", INPUT STRING(ROWID(LocalDefault)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "LocalDefault saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE LocalDefault.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

