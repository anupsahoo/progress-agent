&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin
/*------------------------------------------------------------------------
    File        : feedback_browse.w
    Purpose     : Browse and search Feedback records
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

{shared/sysdefs.i}
{customer-management/cm_defs.i}

DEFINE VARIABLE cFilter   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSortBy   AS CHARACTER NO-UNDO INITIAL "Department".
DEFINE VARIABLE hQuery    AS HANDLE    NO-UNDO.
DEFINE VARIABLE lAscend   AS LOGICAL   NO-UNDO INITIAL YES.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK
&Scoped-define PROCEDURE-TYPE Window
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brFeedback
&Scoped-define INTERNAL-TABLES Feedback
&Scoped-define FIELDS-IN-QUERY-brFeedback Feedback.Contact Feedback.Company Feedback.EmailAddress Feedback.Phone Feedback.Fax Feedback.Comments Feedback.Department Feedback.Rating
&Scoped-define OPEN-QUERY-brFeedback OPEN QUERY brFeedback FOR EACH Feedback NO-LOCK BY Feedback.Department.
&ANALYZE-RESUME

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

DEFINE BUTTON btnAdd LABEL "&Add" SIZE 12 BY 1.14.
DEFINE BUTTON btnEdit LABEL "&Edit" SIZE 12 BY 1.14.
DEFINE BUTTON btnDelete LABEL "&Delete" SIZE 12 BY 1.14.
DEFINE BUTTON btnFilter LABEL "&Filter" SIZE 12 BY 1.14.
DEFINE BUTTON btnExport LABEL "&Export" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "&Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnExit LABEL "&Exit" SIZE 12 BY 1.14.
DEFINE VARIABLE fiSearch AS CHARACTER FORMAT "x(30)" LABEL "Search" VIEW-AS FILL-IN SIZE 30 BY 1 NO-UNDO.

DEFINE QUERY brFeedback FOR Feedback SCROLLING.

DEFINE BROWSE brFeedback
  QUERY brFeedback NO-LOCK DISPLAY
      Feedback.Contact COLUMN-LABEL "Contact Name" FORMAT "x(30)"
      Feedback.Company COLUMN-LABEL "Company" FORMAT "x(20)"
      Feedback.EmailAddress COLUMN-LABEL "Email" FORMAT "x(50)"
      Feedback.Phone COLUMN-LABEL "Phone" FORMAT "x(20)"
      Feedback.Fax COLUMN-LABEL "Fax" FORMAT "x(20)"
      Feedback.Comments COLUMN-LABEL "Comments" FORMAT "x(80)"
      Feedback.Department COLUMN-LABEL "Department" FORMAT "x(15)"
      Feedback.Rating COLUMN-LABEL "Rating" FORMAT "9"
  WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 16 FIT-LAST-COLUMN.

DEFINE FRAME fMain
    fiSearch AT ROW 1.48 COL 10 COLON-ALIGNED
    btnFilter AT ROW 1.48 COL 46
    brFeedback AT ROW 3 COL 2
    btnAdd AT ROW 19.6 COL 2
    btnEdit AT ROW 19.6 COL 16
    btnDelete AT ROW 19.6 COL 30
    btnExport AT ROW 19.6 COL 44
    btnPrint AT ROW 19.6 COL 58
    btnExit AT ROW 19.6 COL 108
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY SIDE-LABELS NO-UNDERLINE THREE-D AT COL 1 ROW 1 SIZE 121 BY 21.

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         TITLE              = "Feedback Browser"
         HEIGHT             = 21
         WIDTH              = 121
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF wWin DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON CHOOSE OF btnAdd IN FRAME fMain DO:
  RUN customer-management/feedback_maint.p.
  RUN open-query.
END.

ON CHOOSE OF btnEdit IN FRAME fMain DO:
  IF NOT AVAILABLE Feedback THEN RETURN NO-APPLY.
  RUN customer-management/feedback_maint.p.
  brFeedback:REFRESH().
END.

ON CHOOSE OF btnDelete IN FRAME fMain DO:
  DEFINE VARIABLE lYes AS LOGICAL NO-UNDO.
  IF NOT AVAILABLE Feedback THEN RETURN NO-APPLY.
  MESSAGE "Delete this Feedback?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lYes.
  IF NOT lYes THEN RETURN NO-APPLY.
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    FIND CURRENT Feedback EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF LOCKED Feedback THEN DO:
      MESSAGE "Record is locked by another user." VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
    END.
    DELETE Feedback.
  END.
  RUN open-query.
END.

ON CHOOSE OF btnFilter IN FRAME fMain OR RETURN OF fiSearch DO:
  ASSIGN cFilter = fiSearch:SCREEN-VALUE.
  RUN open-query.
END.

ON CHOOSE OF btnExport IN FRAME fMain DO:
  RUN customer-management/feedback_export.p (INPUT SESSION:TEMP-DIRECTORY + "feedback.csv").
END.

ON CHOOSE OF btnPrint IN FRAME fMain DO:
  RUN customer-management/feedback_report.p (INPUT "PRINTER").
END.

ON CHOOSE OF btnExit IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

ON MOUSE-SELECT-DBLCLICK OF brFeedback IN FRAME fMain DO:
  APPLY "CHOOSE":U TO btnEdit.
END.

ON VALUE-CHANGED OF brFeedback IN FRAME fMain DO:
  ASSIGN btnEdit:SENSITIVE = AVAILABLE Feedback
         btnDelete:SENSITIVE = AVAILABLE Feedback AND gUserCanDelete.
END.

ON START-SEARCH OF brFeedback IN FRAME fMain DO:
  DEFINE VARIABLE hCol AS HANDLE NO-UNDO.
  hCol = brFeedback:CURRENT-COLUMN.
  IF hCol:NAME = cSortBy THEN lAscend = NOT lAscend.
  ELSE ASSIGN cSortBy = hCol:NAME lAscend = YES.
  RUN open-query.
END.

/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN open-query.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

PROCEDURE open-query :
  DEFINE VARIABLE cWhere AS CHARACTER NO-UNDO.
  hQuery = QUERY brFeedback:HANDLE.
  IF cFilter > "" THEN cWhere = " WHERE Feedback.Contact BEGINS " + QUOTER(cFilter).
  hQuery:QUERY-PREPARE("FOR EACH Feedback NO-LOCK" + cWhere + " BY " + cSortBy + (IF lAscend THEN "" ELSE " DESCENDING")).
  hQuery:QUERY-OPEN().
  APPLY "VALUE-CHANGED":U TO brFeedback IN FRAME fMain.
END PROCEDURE.

PROCEDURE enable_UI :
  ENABLE fiSearch btnFilter brFeedback btnAdd btnEdit btnDelete btnExport btnPrint btnExit
      WITH FRAME fMain IN WINDOW wWin.
  VIEW wWin.
END PROCEDURE.

PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin) THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

