&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : bin_transfer.w
    Purpose     : Move stock between bins
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{warehousing/wh_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Bin SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Bin.WarehouseNum COLUMN-LABEL "Warehouse Num"
    Bin.Itemnum COLUMN-LABEL "Item Num"
    Bin.Qty COLUMN-LABEL "Qty"
    Bin.BinNum COLUMN-LABEL "Bin Num"
    Bin.BinName COLUMN-LABEL "Bin Name"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR Warehouse SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    Warehouse.WarehouseNum COLUMN-LABEL "Warehouse Num"
    Warehouse.WarehouseName COLUMN-LABEL "Warehouse Name"
    Warehouse.Country COLUMN-LABEL "Country"
    Warehouse.Address COLUMN-LABEL "Address"
    Warehouse.Address2 COLUMN-LABEL "Address2"
    Warehouse.City COLUMN-LABEL "City"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Move stock between bins".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH Warehouse NO-LOCK WHERE Warehouse.WarehouseNum = Bin.WarehouseNum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Bin NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Bin THEN RUN warehousing/bin_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Move stock between bins" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE derive-warehouse-address20 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.Address2 = "" OR bWarehouse.Address2 = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.Address2 is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.Address2) > 35 THEN plOk = NO.
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
    WHEN bBin.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-bin-qty2 :
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

PROCEDURE map-bin-qty3 :
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

