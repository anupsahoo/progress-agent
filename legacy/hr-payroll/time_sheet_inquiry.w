&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : time_sheet_inquiry.w
    Purpose     : Read-only TimeSheet inquiry with record navigation
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR TimeSheet SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    TimeSheet.EmpNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.DayRecorded AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.TypeRecorded AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.AMTimeIn AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.AMTimeOut AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.PMTimeIn AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.PMTimeOut AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.RegularHours AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    TimeSheet.OvertimeHours AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 11.90 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 14 TITLE "TimeSheet Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE TimeSheet THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE TimeSheet THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE TimeSheet THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE TimeSheet THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE TimeSheet THEN
    DISPLAY TimeSheet.EmpNum
            TimeSheet.DayRecorded
            TimeSheet.TypeRecorded
            TimeSheet.AMTimeIn
            TimeSheet.AMTimeOut
            TimeSheet.PMTimeIn
            TimeSheet.PMTimeOut
            TimeSheet.RegularHours
            TimeSheet.OvertimeHours
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH TimeSheet NO-LOCK BY TimeSheet.EmpNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

