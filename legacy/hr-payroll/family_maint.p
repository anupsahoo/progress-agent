/*------------------------------------------------------------------------
    File        : family_maint.p
    Purpose     : Maintain Family records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-03  kpo  new report column
 *  2000-03  tlw  fix rounding
 *  2009-02  mab  audit fields
 *  2017-10  rdh  credit hold rule
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{hr-payroll/hr_defs.i}
{hr-payroll/family_lookup.i}

DEFINE VARIABLE pEmpNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Emp No".
DEFINE VARIABLE pRelativeName AS CHARACTER NO-UNDO FORMAT "x(15)" LABEL "Relative Name".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pEmpNum COLON 18
    pRelativeName COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Family Lookup ".

DEFINE FRAME fMain
    Family.EmpNum COLON 22
    Family.RelativeName COLON 22
    Family.Relation COLON 22
    Family.Birthdate COLON 22
    Family.CoveredOnBenefits COLON 22
    Family.BenefitDate COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Family Maintenance ".

ON LEAVE OF Family.EmpNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST employee WHERE employee.EmpNum = INPUT Family.EmpNum)) THEN DO:
        MESSAGE "Employee must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Family.Birthdate IN FRAME fMain DO:
    IF INPUT Family.Birthdate <> ? AND INPUT Family.Birthdate > TODAY + 3650 THEN DO:
        MESSAGE "Birthdate is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Family.BenefitDate IN FRAME fMain DO:
    IF INPUT Family.BenefitDate <> ? AND INPUT Family.BenefitDate > TODAY + 3650 THEN DO:
        MESSAGE "Benefit Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pEmpNum pRelativeName WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Family WHERE Family.EmpNum = pEmpNum
      AND Family.RelativeName = pRelativeName
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Family THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Family is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Family THEN DO:
        MESSAGE "Family not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Family.
            ASSIGN Family.EmpNum = pEmpNum
                   Family.RelativeName = pRelativeName.
        END.

        DISPLAY Family.EmpNum Family.RelativeName WITH FRAME fMain.
        UPDATE
            Family.Relation
            Family.Birthdate
            Family.CoveredOnBenefits
            Family.BenefitDate
            WITH FRAME fMain.

        RUN hr-payroll/family_val.p (INPUT ROWID(Family), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Family", INPUT STRING(ROWID(Family)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Family saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Family.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

