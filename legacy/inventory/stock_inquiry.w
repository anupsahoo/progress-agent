&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : stock_inquiry.w
    Purpose     : Stock by item, bin and warehouse
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{inventory/in_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Item SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Item.Itemnum COLUMN-LABEL "Item Num"
    Item.ItemName COLUMN-LABEL "Item Name"
    Item.Price COLUMN-LABEL "Price"
    Item.Onhand COLUMN-LABEL "On Hand"
    Item.Allocated COLUMN-LABEL "Allocated"
    Item.ReOrder COLUMN-LABEL "Re Order"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR Bin SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Bin.WarehouseNum COLUMN-LABEL "Warehouse Num"
    Bin.Itemnum COLUMN-LABEL "Item Num"
    Bin.Qty COLUMN-LABEL "Qty"
    Bin.BinNum COLUMN-LABEL "Bin Num"
    Bin.BinName COLUMN-LABEL "Bin Name"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Stock by item, bin and warehouse".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Bin NO-LOCK WHERE Bin.Itemnum = Item.Itemnum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Item NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Item THEN RUN inventory/item_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Stock by item, bin and warehouse" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE reset-item-onhand0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Onhand < 0 THEN plOk = NO.
    WHEN bItem.Onhand > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Onhand above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-bin-qty1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-bin-qty2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-item-price3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Price < 0 THEN plOk = NO.
    WHEN bItem.Price > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-bin-qty4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-bin-qty5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-bin-qty6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-item-reorder7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.ReOrder < 0 THEN plOk = NO.
    WHEN bItem.ReOrder > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.ReOrder above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

