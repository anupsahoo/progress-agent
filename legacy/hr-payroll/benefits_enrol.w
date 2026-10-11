&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : benefits_enrol.w
    Purpose     : Benefits enrolment
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{hr-payroll/hr_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Employee SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Employee.EmpNum COLUMN-LABEL "Emp No"
    Employee.LastName COLUMN-LABEL "Last Name"
    Employee.FirstName COLUMN-LABEL "First Name"
    Employee.Address COLUMN-LABEL "Address"
    Employee.Address2 COLUMN-LABEL "Address2"
    Employee.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR Benefits SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Benefits.EmpNum COLUMN-LABEL "Emp No"
    Benefits.HealthCare COLUMN-LABEL "Health Care"
    Benefits.LifeInsurance COLUMN-LABEL "Life Insurance"
    Benefits.Pension401K COLUMN-LABEL "Pension401K"
    Benefits.StockPurchase COLUMN-LABEL "Stock Purchase"
    Benefits.MedicalSpending COLUMN-LABEL "Medical Spending"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Benefits enrolment".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Benefits NO-LOCK WHERE Benefits.EmpNum = Employee.EmpNum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Employee NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Employee THEN RUN hr-payroll/employee_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Benefits enrolment" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE round-family-relativename0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.RelativeName = "" OR bFamily.RelativeName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.RelativeName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.RelativeName) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-benefits-medicalspending1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBenefits FOR Benefits.
  FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBenefits THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBenefits.MedicalSpending < 0 THEN plOk = NO.
    WHEN bBenefits.MedicalSpending > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Benefits.MedicalSpending above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-employee-sickdaysleft2 :
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
    WHEN bEmployee.SickDaysLeft > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-benefits-dependentcare4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBenefits FOR Benefits.
  FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBenefits THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBenefits.DependentCare < 0 THEN plOk = NO.
    WHEN bBenefits.DependentCare > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Benefits.DependentCare above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-family-relation5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.Relation = "" OR bFamily.Relation = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.Relation is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.Relation) > 15 THEN plOk = NO.
END PROCEDURE.

