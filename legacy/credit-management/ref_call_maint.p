/*------------------------------------------------------------------------
    File        : ref_call_maint.p
    Purpose     : Maintain RefCall records
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-04  ssp  Y2K date window
 *  2014-04  tlw  remove dead code
 *  1999-06  mab  audit fields
 *  2010-06  tlw  appserver split
 *  2002-05  tlw  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{credit-management/cr_defs.i}
{credit-management/ref_call_lookup.i}

DEFINE VARIABLE pCallNum AS CHARACTER NO-UNDO FORMAT "x(6)" LABEL "Call Num".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pCallNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " RefCall Lookup ".

DEFINE FRAME fMain
    RefCall.CallNum COLON 22
    RefCall.CustNum COLON 22
    RefCall.CallDate COLON 22
    RefCall.SalesRep COLON 22
    RefCall.Parent COLON 22
    RefCall.Txt COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " RefCall Maintenance ".

ON LEAVE OF RefCall.CustNum IN FRAME fMain DO:
    /* VALEXP: custnum > 0 */
    IF NOT (INPUT RefCall.CustNum > 0) THEN DO:
        MESSAGE "Customer number must be greater than zero" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF RefCall.CallDate IN FRAME fMain DO:
    IF INPUT RefCall.CallDate <> ? AND INPUT RefCall.CallDate > TODAY + 3650 THEN DO:
        MESSAGE "Call Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pCallNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST RefCall WHERE RefCall.CallNum = pCallNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED RefCall THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "RefCall is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE RefCall THEN DO:
        MESSAGE "RefCall not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE RefCall.
            ASSIGN RefCall.CallNum = pCallNum.
        END.

        DISPLAY RefCall.CallNum WITH FRAME fMain.
        UPDATE
            RefCall.CustNum
            RefCall.CallDate
            RefCall.SalesRep
            RefCall.Parent
            RefCall.Txt
            WITH FRAME fMain.

        RUN credit-management/ref_call_val.p (INPUT ROWID(RefCall), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "RefCall", INPUT STRING(ROWID(RefCall)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "RefCall saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE RefCall.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

