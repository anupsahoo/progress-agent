/*------------------------------------------------------------------------
    File        : time_sheet_maint.p
    Purpose     : Maintain TimeSheet records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-09  mab  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{hr-payroll/hr_defs.i}
{hr-payroll/time_sheet_lookup.i}

DEFINE VARIABLE pEmpNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Emp No".
DEFINE VARIABLE pDayRecorded AS DATE NO-UNDO FORMAT "99/99/9999" LABEL "Day Recorded".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pEmpNum COLON 18
    pDayRecorded COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " TimeSheet Lookup ".

DEFINE FRAME fMain
    TimeSheet.EmpNum COLON 22
    TimeSheet.DayRecorded COLON 22
    TimeSheet.TypeRecorded COLON 22
    TimeSheet.AMTimeIn COLON 22
    TimeSheet.AMTimeOut COLON 22
    TimeSheet.PMTimeIn COLON 22
    TimeSheet.PMTimeOut COLON 22 SKIP(1)
    TimeSheet.RegularHours COLON 22
    TimeSheet.OvertimeHours COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " TimeSheet Maintenance ".

ON LEAVE OF TimeSheet.EmpNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST employee WHERE employee.EmpNum = INPUT TimeSheet.EmpNum)) THEN DO:
        MESSAGE "Employee must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF TimeSheet.DayRecorded IN FRAME fMain DO:
    IF INPUT TimeSheet.DayRecorded <> ? AND INPUT TimeSheet.DayRecorded > TODAY + 3650 THEN DO:
        MESSAGE "Day Recorded is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF TimeSheet.RegularHours IN FRAME fMain DO:
    IF INPUT TimeSheet.RegularHours < 0 THEN DO:
        MESSAGE "Regular Hours cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF TimeSheet.OvertimeHours IN FRAME fMain DO:
    IF INPUT TimeSheet.OvertimeHours < 0 THEN DO:
        MESSAGE "Overtime Hours cannot be negative." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pEmpNum pDayRecorded WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST TimeSheet WHERE TimeSheet.EmpNum = pEmpNum
      AND TimeSheet.DayRecorded = pDayRecorded
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED TimeSheet THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "TimeSheet is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE TimeSheet THEN DO:
        MESSAGE "TimeSheet not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE TimeSheet.
            ASSIGN TimeSheet.EmpNum = pEmpNum
                   TimeSheet.DayRecorded = pDayRecorded.
        END.

        DISPLAY TimeSheet.EmpNum TimeSheet.DayRecorded WITH FRAME fMain.
        UPDATE
            TimeSheet.TypeRecorded
            TimeSheet.AMTimeIn
            TimeSheet.AMTimeOut
            TimeSheet.PMTimeIn
            TimeSheet.PMTimeOut
            TimeSheet.RegularHours
            TimeSheet.OvertimeHours
            WITH FRAME fMain.

        RUN hr-payroll/time_sheet_val.p (INPUT ROWID(TimeSheet), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "TimeSheet", INPUT STRING(ROWID(TimeSheet)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "TimeSheet saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE TimeSheet.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

