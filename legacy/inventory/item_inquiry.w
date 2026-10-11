&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : item_inquiry.w
    Purpose     : Read-only Item inquiry with record navigation
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR Item SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    Item.Itemnum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.ItemName AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Price AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Onhand AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Allocated AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.ReOrder AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.OnOrder AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.CatPage AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.CatDescription AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Category1 AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Category2 AT ROW 12.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Special AT ROW 13.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Weight AT ROW 14.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    Item.Minqty AT ROW 15.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 17.40 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 20 TITLE "Item Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE Item THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE Item THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE Item THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE Item THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE Item THEN
    DISPLAY Item.Itemnum
            Item.ItemName
            Item.Price
            Item.Onhand
            Item.Allocated
            Item.ReOrder
            Item.OnOrder
            Item.CatPage
            Item.CatDescription
            Item.Category1
            Item.Category2
            Item.Special
            Item.Weight
            Item.Minqty
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH Item NO-LOCK BY Item.Itemnum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

