/*------------------------------------------------------------------------
    File        : employee_maint.p
    Purpose     : Maintain Employee records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-06  mab  Y2K date window
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{hr-payroll/hr_defs.i}
{hr-payroll/employee_lookup.i}

DEFINE VARIABLE pEmpNum AS INTEGER NO-UNDO FORMAT "zzzzzzzzz9" LABEL "Emp No".
DEFINE VARIABLE lNew     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRetry   AS INTEGER   NO-UNDO.

DEFINE FRAME fKey
    pEmpNum COLON 18
    WITH SIDE-LABELS THREE-D ROW 2 CENTERED TITLE " Employee Lookup ".

DEFINE FRAME fMain
    Employee.EmpNum COLON 22
    Employee.LastName COLON 22
    Employee.FirstName COLON 22
    Employee.Address COLON 22
    Employee.Address2 COLON 22
    Employee.City COLON 22
    Employee.State COLON 22 SKIP(1)
    Employee.PostalCode COLON 22
    Employee.HomePhone COLON 22
    Employee.WorkPhone COLON 22
    Employee.DeptCode COLON 22
    Employee.Position COLON 22
    Employee.Birthdate COLON 22
    Employee.StartDate COLON 22 SKIP(1)
    Employee.VacationDaysLeft COLON 22
    Employee.SickDaysLeft COLON 22
    WITH SIDE-LABELS THREE-D KEEP-TAB-ORDER ROW 6 CENTERED 1 DOWN
    TITLE " Employee Maintenance ".

ON LEAVE OF Employee.DeptCode IN FRAME fMain DO:
    IF NOT (CAN-FIND(FIRST department WHERE department.DeptCode = INPUT Employee.DeptCode)) THEN DO:
        MESSAGE "Department must exist." VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Employee.Birthdate IN FRAME fMain DO:
    IF INPUT Employee.Birthdate <> ? AND INPUT Employee.Birthdate > TODAY + 3650 THEN DO:
        MESSAGE "Birthdate is too far in the future." VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

ON LEAVE OF Employee.StartDate IN FRAME fMain DO:
    IF INPUT Employee.StartDate <> ? AND INPUT Employee.StartDate > TODAY + 3650 THEN DO:
        MESSAGE "Start Date is too far in the future." VIEW-AS ALERT-BOX WARNING.
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
        FIND FIRST Employee WHERE Employee.EmpNum = pEmpNum
             EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF LOCKED Employee THEN DO:
            iRetry = iRetry + 1.
            IF iRetry > gMaxLockRetry THEN DO:
                MESSAGE "Employee is being changed by another user. Try again later." VIEW-AS ALERT-BOX WARNING.
                NEXT MAIN-LOOP.
            END.
            PAUSE 1 NO-MESSAGE.
            NEXT FIND-BLOCK.
        END.
        LEAVE FIND-BLOCK.
    END.

    IF NOT AVAILABLE Employee THEN DO:
        MESSAGE "Employee not found. Create a new record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lNew.
        IF NOT lNew THEN NEXT MAIN-LOOP.
    END.

    TRANS-BLOCK:
    DO TRANSACTION ON ERROR UNDO TRANS-BLOCK, RETRY TRANS-BLOCK:
        IF lNew THEN DO:
            CREATE Employee.
            ASSIGN Employee.EmpNum = pEmpNum.
        END.

        DISPLAY Employee.EmpNum WITH FRAME fMain.
        UPDATE
            Employee.LastName
            Employee.FirstName
            Employee.Address
            Employee.Address2
            Employee.City
            Employee.State
            Employee.PostalCode
            Employee.HomePhone
            Employee.WorkPhone
            Employee.DeptCode
            Employee.Position
            Employee.Birthdate
            Employee.StartDate
            Employee.VacationDaysLeft
            Employee.SickDaysLeft
            WITH FRAME fMain.

        RUN hr-payroll/employee_val.p (INPUT ROWID(Employee), OUTPUT lOk, OUTPUT cMsg).
        IF NOT lOk THEN DO:
            MESSAGE cMsg VIEW-AS ALERT-BOX ERROR.
            UNDO TRANS-BLOCK, RETRY TRANS-BLOCK.
        END.

        RUN shared/audit_log.p (INPUT "Employee", INPUT STRING(ROWID(Employee)), INPUT (IF lNew THEN "CREATE" ELSE "UPDATE")).
    END. /* TRANS-BLOCK */

    MESSAGE "Employee saved." VIEW-AS ALERT-BOX INFORMATION.
    RELEASE Employee.
END. /* MAIN-LOOP */

HIDE FRAME fMain NO-PAUSE.
HIDE FRAME fKey NO-PAUSE.

