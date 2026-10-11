&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : delivery_track.w
    Purpose     : Delivery tracking inquiry
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{order-fulfilment/of_defs.i}

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

DEFINE QUERY qDetail FOR ShipTo SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    ShipTo.CustNum COLUMN-LABEL "Cust Num"
    ShipTo.ShipToID COLUMN-LABEL "Ship To ID"
    ShipTo.Contact COLUMN-LABEL "Contact"
    ShipTo.Address COLUMN-LABEL "Address"
    ShipTo.Address2 COLUMN-LABEL "Address2"
    ShipTo.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Delivery tracking inquiry".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH ShipTo NO-LOCK WHERE ShipTo.CustNum = Order.CustNum.
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

CREATE WINDOW wWin ASSIGN TITLE = "Delivery tracking inquiry" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE reset-order-carrier0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Carrier = "" OR bOrder.Carrier = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Carrier is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Carrier) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-ship-to-comments1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Comments = "" OR bShipTo.Comments = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Comments is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Comments) > 80 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-order-creditcard2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.Creditcard = "" OR bOrder.Creditcard = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.Creditcard is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.Creditcard) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ship-to-contact3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Contact = "" OR bShipTo.Contact = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Contact is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Contact) > 30 THEN plOk = NO.
END PROCEDURE.

