&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : order_entry.w
    Purpose     : Order entry: header, lines and pricing
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{order-entry/oe_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Order SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Order.Ordernum COLUMN-LABEL "Order Num"
    Order.CustNum COLUMN-LABEL "Cust Num"
    Order.OrderDate COLUMN-LABEL "Ordered"
    Order.ShipDate COLUMN-LABEL "Shipped"
    Order.PromiseDate COLUMN-LABEL "Promised"
    Order.Carrier COLUMN-LABEL "Carrier"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR OrderLine SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    OrderLine.Ordernum COLUMN-LABEL "Order Num"
    OrderLine.Linenum COLUMN-LABEL "Line Num"
    OrderLine.Itemnum COLUMN-LABEL "Item Num"
    OrderLine.Price COLUMN-LABEL "Price"
    OrderLine.Qty COLUMN-LABEL "Qty"
    OrderLine.Discount COLUMN-LABEL "Discount"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Order entry: header, lines and pricing".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH OrderLine NO-LOCK WHERE OrderLine.Ordernum = Order.Ordernum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Order NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Order THEN RUN order-entry/order_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Order entry: header, lines and pricing" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE map-order-line-extendedprice0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.ExtendedPrice < 0 THEN plOk = NO.
    WHEN bOrderLine.ExtendedPrice > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.ExtendedPrice above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-order-line-qty1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Qty < 0 THEN plOk = NO.
    WHEN bOrderLine.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-order-line-price2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Price < 0 THEN plOk = NO.
    WHEN bOrderLine.Price > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-order-line-qty3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrderLine FOR OrderLine.
  FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrderLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bOrderLine.Qty < 0 THEN plOk = NO.
    WHEN bOrderLine.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

