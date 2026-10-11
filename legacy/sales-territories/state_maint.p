/*------------------------------------------------------------------------
    File        : state_maint.p
    Purpose     : Maintain State records
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-01  tlw  credit hold rule
 *  2015-06  tlw  remove dead code
 *  2010-09  rdh  Y2K date window
 *  1999-01  rdh  performance: use index
 *  2010-10  kpo  audit fields
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{sales-territories/st_defs.i}
{sales-territories/state_lookup.i}

DEFINE VARIABLE pState AS CHARACTER NO-UNDO FORMAT "x(20)" LABEL "State".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pState COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " State Lookup ".

DEFINE FRAME fMain
    State.State COLON 22
    State.StateName COLON 22
    State.Region COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " State Maintenance ".

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pState WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST State WHERE State.State = pState
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED State THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "State is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE State THEN DO:
        MESSAGE "State not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE State.
            ASSIGN State.State = pState.
        END.

        DISPLAY State.State WITH FRAME fMain.
        UPDATE
            State.StateName
            State.Region
            WITH FRAME fMain.

        RUN sales-territories/state_val.p (INPUT ROWID(State), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "State", INPUT STRING(ROWID(State)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "State saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE State.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

