/*------------------------------------------------------------------------
    File        : department_maint.p
    Purpose     : Maintain Department records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-06  tlw  fix rounding
 *  2006-04  kpo  performance: use index
 *  2009-04  mab  remove dead code
 *  2012-08  mab  add lock retry
 *  2014-10  jkm  appserver split
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{hr-payroll/hr_defs.i}
{hr-payroll/department_lookup.i}

DEFINE VARIABLE pDeptCode AS CHARACTER NO-UNDO FORMAT "x(3)" LABEL "Dept Code".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pDeptCode COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Department Lookup ".

DEFINE FRAME fMain
    Department.DeptCode COLON 22
    Department.DeptName COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Department Maintenance ".

MAIN-LOOP:
REPEAT ON ENDKEY UNDO, LEAVE:
    CLEAR FRAME fMain ALL NO-PAUSE.
    UPDATE pDeptCode WITH FRAME fKey.

    ASSIGN iRetry = 0 lNew = NO.
    FIND-BLOCK:
    REPEAT:
        FIND FIRST Department WHERE Department.DeptCode = pDeptCode
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Department THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Department is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Department THEN DO:
        MESSAGE "Department not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Department.
            ASSIGN Department.DeptCode = pDeptCode.
        END.

        DISPLAY Department.DeptCode WITH FRAME fMain.
        UPDATE
            Department.DeptName
            WITH FRAME fMain.

        RUN hr-payroll/department_val.p (INPUT ROWID(Department), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Department", INPUT STRING(ROWID(Department)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Department saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Department.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

