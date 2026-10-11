&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : bill_to_inquiry.w
    Purpose     : Read-only BillTo inquiry with record navigation
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR BillTo SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    BillTo.CustNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.BillToID AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.Name AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.Address AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.Address2 AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.City AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.State AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.PostalCode AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.Contact AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    BillTo.Phone AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 13.00 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 15 TITLE "BillTo Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE BillTo THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE BillTo THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE BillTo THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE BillTo THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE BillTo THEN
    DISPLAY BillTo.CustNum
            BillTo.BillToID
            BillTo.Name
            BillTo.Address
            BillTo.Address2
            BillTo.City
            BillTo.State
            BillTo.PostalCode
            BillTo.Contact
            BillTo.Phone
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH BillTo NO-LOCK BY BillTo.CustNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

