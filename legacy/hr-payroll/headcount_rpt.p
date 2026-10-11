/*------------------------------------------------------------------------
    File        : headcount_rpt.p
    Purpose     : Headcount by department
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-10  tlw  appserver split
 *  2011-02  ssp  audit fields
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Headcount by department" SKIP(1).

FOR EACH Employee NO-LOCK
    BREAK BY Employee.City:
    dLine = 0.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY Employee.City).
    DISPLAY STREAM sOut Employee.EmpNum Employee.LastName Employee.FirstName Employee.Address dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(Employee.City) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  City total: " ACCUM SUB-TOTAL BY Employee.City dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE derive-employee-vacationdaysleft0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-employee-vacationdaysleft1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-employee-sickdaysleft2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-department-deptname3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bDepartment FOR Department.
  FIND bDepartment WHERE ROWID(bDepartment) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bDepartment THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bDepartment.DeptName = "" OR bDepartment.DeptName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Department.DeptName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bDepartment.DeptName) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-employee-sickdaysleft4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-employee-vacationdaysleft5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-employee-vacationdaysleft6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-employee-sickdaysleft7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-department-deptcode8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bDepartment FOR Department.
  FIND bDepartment WHERE ROWID(bDepartment) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bDepartment THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bDepartment.DeptCode = "" OR bDepartment.DeptCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Department.DeptCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bDepartment.DeptCode) > 3 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-employee-vacationdaysleft9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

