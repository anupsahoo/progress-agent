&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : order_line_inquiry.w
    Purpose     : Read-only OrderLine inquiry with record navigation
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR OrderLine SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    OrderLine.Ordernum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.Linenum AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.Itemnum AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.Price AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.Qty AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.Discount AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.ExtendedPrice AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    OrderLine.OrderLineStatus AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 10.80 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 13 TITLE "OrderLine Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE OrderLine THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE OrderLine THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE OrderLine THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE OrderLine THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE OrderLine THEN
    DISPLAY OrderLine.Ordernum
            OrderLine.Linenum
            OrderLine.Itemnum
            OrderLine.Price
            OrderLine.Qty
            OrderLine.Discount
            OrderLine.ExtendedPrice
            OrderLine.OrderLineStatus
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH OrderLine NO-LOCK BY OrderLine.Ordernum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

