&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : supplier_inquiry.w
    Purpose     : Read-only Supplier inquiry with record navigation
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR Supplier SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    Supplier.SupplierIDNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Name AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Address AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Address2 AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.City AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.State AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.PostalCode AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Country AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Phone AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Comments AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Password AT ROW 12.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.LoginDate AT ROW 13.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.ShipAmount AT ROW 14.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Supplier.Discount AT ROW 15.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 17.40 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 20 TITLE "Supplier Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE Supplier THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE Supplier THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE Supplier THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE Supplier THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE Supplier THEN
    DISPLAY Supplier.SupplierIDNum
            Supplier.Name
            Supplier.Address
            Supplier.Address2
            Supplier.City
            Supplier.State
            Supplier.PostalCode
            Supplier.Country
            Supplier.Phone
            Supplier.Comments
            Supplier.Password
            Supplier.LoginDate
            Supplier.ShipAmount
            Supplier.Discount
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH Supplier NO-LOCK BY Supplier.SupplierIDNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

