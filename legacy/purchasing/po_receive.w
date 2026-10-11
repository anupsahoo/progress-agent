&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : po_receive.w
    Purpose     : Goods receipt against purchase order
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{purchasing/po_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR PurchaseOrder SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    PurchaseOrder.PONum COLUMN-LABEL "PO Num"
    PurchaseOrder.DateEntered COLUMN-LABEL "Date Entered"
    PurchaseOrder.SupplierIDNum COLUMN-LABEL "Supplier ID"
    PurchaseOrder.ReceiveDate COLUMN-LABEL "Date Received"
    PurchaseOrder.POStatus COLUMN-LABEL "PO Status"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR POLine SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    POLine.Linenum COLUMN-LABEL "Line Num"
    POLine.Itemnum COLUMN-LABEL "Item Num"
    POLine.Price COLUMN-LABEL "Price"
    POLine.Qty COLUMN-LABEL "Qty"
    POLine.Discount COLUMN-LABEL "Discount"
    POLine.ExtendedPrice COLUMN-LABEL "Extended Price"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Goods receipt against purchase order".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH POLine NO-LOCK WHERE POLine.PONum = PurchaseOrder.PONum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH PurchaseOrder NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE PurchaseOrder THEN RUN purchasing/purchase_order_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Goods receipt against purchase order" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE post-purchase-order-postatus0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-poline-price1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Price < 0 THEN plOk = NO.
    WHEN bPOLine.Price > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-purchase-order-postatus2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-purchase-order-postatus3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-poline-discount4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPOLine FOR POLine.
  FIND bPOLine WHERE ROWID(bPOLine) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPOLine THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bPOLine.Discount < 0 THEN plOk = NO.
    WHEN bPOLine.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "POLine.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-purchase-order-postatus5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-purchase-order-postatus6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bPurchaseOrder FOR PurchaseOrder.
  FIND bPurchaseOrder WHERE ROWID(bPurchaseOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bPurchaseOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bPurchaseOrder.POStatus = "" OR bPurchaseOrder.POStatus = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "PurchaseOrder.POStatus is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bPurchaseOrder.POStatus) > 20 THEN plOk = NO.
END PROCEDURE.

