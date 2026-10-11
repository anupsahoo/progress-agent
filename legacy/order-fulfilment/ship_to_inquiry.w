&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : ship_to_inquiry.w
    Purpose     : Read-only ShipTo inquiry with record navigation
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR ShipTo SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    ShipTo.CustNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.ShipToID AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.Contact AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.Address AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.Address2 AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.City AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.State AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.PostalCode AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.Phone AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.Comments AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    ShipTo.Name AT ROW 12.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 14.10 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 17 TITLE "ShipTo Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE ShipTo THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE ShipTo THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE ShipTo THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE ShipTo THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE ShipTo THEN
    DISPLAY ShipTo.CustNum
            ShipTo.ShipToID
            ShipTo.Contact
            ShipTo.Address
            ShipTo.Address2
            ShipTo.City
            ShipTo.State
            ShipTo.PostalCode
            ShipTo.Phone
            ShipTo.Comments
            ShipTo.Name
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH ShipTo NO-LOCK BY ShipTo.CustNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

