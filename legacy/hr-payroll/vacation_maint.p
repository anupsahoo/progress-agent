/*------------------------------------------------------------------------
    File        : vacation_maint.p
    Purpose     : Maintain Vacation records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-10  tlw  remove dead code
 *  2002-07  tlw  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{hr-payroll/hr_defs.i}
{hr-payroll/vacation_lookup.i}

DEFINE VARIABLE pEmpNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Emp No".
DEFINE VARIABLE pStartDate AS DATE NO-UNDO FORMAT "99/99/9999" LABEL "Start Date".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pEmpNum COLON 18
    pStartDate COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Vacation Lookup ".

DEFINE FRAME fMain
    Vacation.EmpNum COLON 22
    Vacation.StartDate COLON 22
    Vacation.EndDate COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Vacation Maintenance ".

ON LEAVE OF Vacation.EmpNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(employee WHERE employee.empnum = vacation.empnum)) THEN DO:
        MESSAGE "Employee must exist" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Vacation.StartDate IN FRAME fMain DO:
    IF INPUT Vacation.StartDate <> ? AND INPUT Vacation.StartDate > TODAY + 3650 THEN DO:
        MESSAGE "Start Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Vacation.EndDate IN FRAME fMain DO:
    IF INPUT Vacation.EndDate <> ? AND INPUT Vacation.EndDate > TODAY + 3650 THEN DO:
        MESSAGE "End Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pEmpNum pStartDate WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Vacation WHERE Vacation.EmpNum = pEmpNum
      AND Vacation.StartDate = pStartDate
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Vacation THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Vacation is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Vacation THEN DO:
        MESSAGE "Vacation not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Vacation.
            ASSIGN Vacation.EmpNum = pEmpNum
                   Vacation.StartDate = pStartDate.
        END.

        DISPLAY Vacation.EmpNum Vacation.StartDate WITH FRAME fMain.
        UPDATE
            Vacation.EndDate
            WITH FRAME fMain.

        RUN hr-payroll/vacation_val.p (INPUT ROWID(Vacation), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Vacation", INPUT STRING(ROWID(Vacation)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Vacation saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Vacation.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

