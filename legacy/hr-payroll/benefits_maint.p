/*------------------------------------------------------------------------
    File        : benefits_maint.p
    Purpose     : Maintain Benefits records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-06  tlw  add lock retry
 *  2009-12  mab  new report column
 *  2002-08  ssp  audit fields
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{hr-payroll/hr_defs.i}
{hr-payroll/benefits_lookup.i}

DEFINE VARIABLE pEmpNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Emp No".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pEmpNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Benefits Lookup ".

DEFINE FRAME fMain
    Benefits.EmpNum COLON 22
    Benefits.HealthCare COLON 22
    Benefits.LifeInsurance COLON 22
    Benefits.Pension401K COLON 22
    Benefits.StockPurchase COLON 22
    Benefits.MedicalSpending COLON 22
    Benefits.DependentCare COLON 22 SKIP(1)
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Benefits Maintenance ".

ON LEAVE OF Benefits.EmpNum IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST employee WHERE employee.EmpNum = INPUT Benefits.EmpNum)) THEN DO:
        MESSAGE "Employee must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pEmpNum WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Benefits WHERE Benefits.EmpNum = pEmpNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Benefits THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Benefits is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Benefits THEN DO:
        MESSAGE "Benefits not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Benefits.
            ASSIGN Benefits.EmpNum = pEmpNum.
        END.

        DISPLAY Benefits.EmpNum WITH FRAME fMain.
        UPDATE
            Benefits.HealthCare
            Benefits.LifeInsurance
            Benefits.Pension401K
            Benefits.StockPurchase
            Benefits.MedicalSpending
            Benefits.DependentCare
            WITH FRAME fMain.

        RUN hr-payroll/benefits_val.p (INPUT ROWID(Benefits), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Benefits", INPUT STRING(ROWID(Benefits)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Benefits saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Benefits.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

