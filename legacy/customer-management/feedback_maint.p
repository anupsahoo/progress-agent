/*------------------------------------------------------------------------
    File        : feedback_maint.p
    Purpose     : Maintain Feedback records
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-07  mab  add lock retry
 *  1999-04  rdh  credit hold rule
 *  2014-08  ssp  audit fields
 *  2002-01  tlw  Y2K date window
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{customer-management/cm_defs.i}
{customer-management/feedback_lookup.i}

DEFINE VARIABLE pDepartment AS CHARACTER NO-UNDO FORMAT "x(15)" LABEL "Department".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pDepartment COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Feedback Lookup ".

DEFINE FRAME fMain
    Feedback.Contact COLON 22
    Feedback.Company COLON 22
    Feedback.EmailAddress COLON 22
    Feedback.Phone COLON 22
    Feedback.Fax COLON 22
    Feedback.Comments COLON 22
    Feedback.Department COLON 22 SKIP(1)
    Feedback.Rating COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Feedback Maintenance ".

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pDepartment WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Feedback WHERE Feedback.Department = pDepartment
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Feedback THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Feedback is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Feedback THEN DO:
        MESSAGE "Feedback not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Feedback.
            ASSIGN Feedback.Department = pDepartment.
        END.

        DISPLAY Feedback.Department WITH FRAME fMain.
        UPDATE
            Feedback.Contact
            Feedback.Company
            Feedback.EmailAddress
            Feedback.Phone
            Feedback.Fax
            Feedback.Comments
            Feedback.Rating
            WITH FRAME fMain.

        RUN customer-management/feedback_val.p (INPUT ROWID(Feedback), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Feedback", INPUT STRING(ROWID(Feedback)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Feedback saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Feedback.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

