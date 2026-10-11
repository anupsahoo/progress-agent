&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : vacation_inquiry.w
    Purpose     : Read-only Vacation inquiry with record navigation
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR Vacation SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    Vacation.EmpNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Vacation.StartDate AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Vacation.EndDate AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 5.30 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 8 TITLE "Vacation Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE Vacation THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE Vacation THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE Vacation THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE Vacation THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE Vacation THEN
    DISPLAY Vacation.EmpNum
            Vacation.StartDate
            Vacation.EndDate
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH Vacation NO-LOCK BY Vacation.EmpNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

