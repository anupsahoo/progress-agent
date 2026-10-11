&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : local_default_inquiry.w
    Purpose     : Read-only LocalDefault inquiry with record navigation
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR LocalDefault SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    LocalDefault.Country AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.Region1Label AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.Region2Label AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.PostalLabel AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.PostalFormat AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.TelFormat AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.CurrencySymbol AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.DateFormat AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    LocalDefault.LocalDefNum AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 11.90 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 14 TITLE "LocalDefault Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE LocalDefault THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE LocalDefault THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE LocalDefault THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE LocalDefault THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE LocalDefault THEN
    DISPLAY LocalDefault.Country
            LocalDefault.Region1Label
            LocalDefault.Region2Label
            LocalDefault.PostalLabel
            LocalDefault.PostalFormat
            LocalDefault.TelFormat
            LocalDefault.CurrencySymbol
            LocalDefault.DateFormat
            LocalDefault.LocalDefNum
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH LocalDefault NO-LOCK BY LocalDefault.LocalDefNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

