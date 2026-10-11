&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : employee_inquiry.w
    Purpose     : Read-only Employee inquiry with record navigation
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR Employee SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    Employee.EmpNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.LastName AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.FirstName AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.Address AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.Address2 AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.City AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.State AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.PostalCode AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.HomePhone AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.WorkPhone AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.DeptCode AT ROW 12.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.Position AT ROW 13.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.Birthdate AT ROW 14.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.StartDate AT ROW 15.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.VacationDaysLeft AT ROW 16.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Employee.SickDaysLeft AT ROW 18.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 19.60 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 22 TITLE "Employee Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE Employee THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE Employee THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE Employee THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE Employee THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE Employee THEN
    DISPLAY Employee.EmpNum
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
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH Employee NO-LOCK BY Employee.EmpNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

