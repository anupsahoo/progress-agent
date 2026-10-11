&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin
/*------------------------------------------------------------------------
    File        : department_browse.w
    Purpose     : Browse and search Department records
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

{shared/sysdefs.i}
{hr-payroll/hr_defs.i}

DEFINE VARIABLE cFilter   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSortBy   AS CHARACTER NO-UNDO INITIAL "DeptCode".
DEFINE VARIABLE hQuery    AS HANDLE    NO-UNDO.
DEFINE VARIABLE lAscend   AS LOGICAL   NO-UNDO INITIAL YES.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK
&Scoped-define PROCEDURE-TYPE Window
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brDepartment
&Scoped-define INTERNAL-TABLES Department
&Scoped-define FIELDS-IN-QUERY-brDepartment Department.DeptCode Department.DeptName
&Scoped-define OPEN-QUERY-brDepartment OPEN QUERY brDepartment FOR EACH Department NO-LOCK BY Department.DeptCode.
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

DEFINE QUERY brDepartment FOR Department SCROLLING.

DEFINE BROWSE brDepartment
  QUERY brDepartment NO-LOCK DISPLAY
      Department.DeptCode COLUMN-LABEL "Dept Code" FORMAT "x(3)"
      Department.DeptName COLUMN-LABEL "Dept Name" FORMAT "x(15)"
  WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 16 FIT-LAST-COLUMN.

DEFINE FRAME fMain
    fiSearch AT ROW 1.48 COL 10 COLON-ALIGNED
    btnFilter AT ROW 1.48 COL 46
    brDepartment AT ROW 3 COL 2
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
         TITLE              = "Department Browser"
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
  RUN hr-payroll/department_maint.p.
  RUN open-query.
END.

ON CHOOSE OF btnEdit IN FRAME fMain DO:
  IF NOT AVAILABLE Department THEN RETURN NO-APPLY.
  RUN hr-payroll/department_maint.p.
  brDepartment:REFRESH().
END.

ON CHOOSE OF btnDelete IN FRAME fMain DO:
  DEFINE VARIABLE lYes AS LOGICAL NO-UNDO.
  IF NOT AVAILABLE Department THEN RETURN NO-APPLY.
  MESSAGE "Delete this Department?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lYes.
  IF NOT lYes THEN RETURN NO-APPLY.
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    FIND CURRENT Department EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF LOCKED Department THEN DO:
      MESSAGE "Record is locked by another user." VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
    END.
    DELETE Department.
  END.
  RUN open-query.
END.

ON CHOOSE OF btnFilter IN FRAME fMain OR RETURN OF fiSearch DO:
  ASSIGN cFilter = fiSearch:SCREEN-VALUE.
  RUN open-query.
END.

ON CHOOSE OF btnExport IN FRAME fMain DO:
  RUN hr-payroll/department_export.p (INPUT SESSION:TEMP-DIRECTORY + "department.csv").
END.

ON CHOOSE OF btnPrint IN FRAME fMain DO:
  RUN hr-payroll/department_report.p (INPUT "PRINTER").
END.

ON CHOOSE OF btnExit IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

ON MOUSE-SELECT-DBLCLICK OF brDepartment IN FRAME fMain DO:
  APPLY "CHOOSE":U TO btnEdit.
END.

ON VALUE-CHANGED OF brDepartment IN FRAME fMain DO:
  ASSIGN btnEdit:SENSITIVE = AVAILABLE Department
         btnDelete:SENSITIVE = AVAILABLE Department AND gUserCanDelete.
END.

ON START-SEARCH OF brDepartment IN FRAME fMain DO:
  DEFINE VARIABLE hCol AS HANDLE NO-UNDO.
  hCol = brDepartment:CURRENT-COLUMN.
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
  hQuery = QUERY brDepartment:HANDLE.
  IF cFilter > "" THEN cWhere = " WHERE Department.DeptName BEGINS " + QUOTER(cFilter).
  hQuery:QUERY-PREPARE("FOR EACH Department NO-LOCK" + cWhere + " BY " + cSortBy + (IF lAscend THEN "" ELSE " DESCENDING")).
  hQuery:QUERY-OPEN().
  APPLY "VALUE-CHANGED":U TO brDepartment IN FRAME fMain.
END PROCEDURE.

PROCEDURE enable_UI :
  ENABLE fiSearch btnFilter brDepartment btnAdd btnEdit btnDelete btnExport btnPrint btnExit
      WITH FRAME fMain IN WINDOW wWin.
  VIEW wWin.
END PROCEDURE.

PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin) THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

