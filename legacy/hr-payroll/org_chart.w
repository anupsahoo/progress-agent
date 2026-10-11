&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : org_chart.w
    Purpose     : Department and employee directory
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{hr-payroll/hr_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Department SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Department.DeptCode COLUMN-LABEL "Dept Code"
    Department.DeptName COLUMN-LABEL "Dept Name"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR Employee SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Employee.EmpNum COLUMN-LABEL "Emp No"
    Employee.LastName COLUMN-LABEL "Last Name"
    Employee.FirstName COLUMN-LABEL "First Name"
    Employee.Address COLUMN-LABEL "Address"
    Employee.Address2 COLUMN-LABEL "Address2"
    Employee.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Department and employee directory".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Employee NO-LOCK WHERE Employee.DeptCode = Department.DeptCode.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Department NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Department THEN RUN hr-payroll/department_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Department and employee directory" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE map-employee-vacationdaysleft0 :
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

PROCEDURE load-department-deptname1 :
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

PROCEDURE calc-department-deptname2 :
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

PROCEDURE apply-employee-sickdaysleft3 :
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

PROCEDURE post-employee-vacationdaysleft4 :
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

PROCEDURE check-department-deptcode5 :
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

PROCEDURE flag-employee-sickdaysleft6 :
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
    WHEN bEmployee.SickDaysLeft > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

