&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : inventory_trans_inquiry.w
    Purpose     : Read-only InventoryTrans inquiry with record navigation
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qNav FOR InventoryTrans SCROLLING.

DEFINE BUTTON btnFirst LABEL "First" SIZE 10 BY 1.14.
DEFINE BUTTON btnPrev LABEL "Prev" SIZE 10 BY 1.14.
DEFINE BUTTON btnNext LABEL "Next" SIZE 10 BY 1.14.
DEFINE BUTTON btnLast LABEL "Last" SIZE 10 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 10 BY 1.14.

DEFINE FRAME fView
    InventoryTrans.InvTransNum AT ROW 1.50 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.WarehouseNum AT ROW 2.60 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.BinNum AT ROW 3.70 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.Qty AT ROW 4.80 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.Itemnum AT ROW 5.90 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.TransDate AT ROW 7.00 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.InvType AT ROW 8.10 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.PONum AT ROW 9.20 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.Ordernum AT ROW 10.30 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    InventoryTrans.Transtime AT ROW 11.40 COL 22 COLON-ALIGNED VIEW-AS FILL-IN
    btnFirst AT ROW 13.00 COL 4 btnPrev btnNext btnLast btnClose
    WITH SIDE-LABELS THREE-D SIZE 90 BY 15 TITLE "InventoryTrans Inquiry".

ON CHOOSE OF btnFirst IN FRAME fView DO:
  GET FIRST qNav.
  IF NOT AVAILABLE InventoryTrans THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnPrev IN FRAME fView DO:
  GET PREV qNav.
  IF NOT AVAILABLE InventoryTrans THEN GET FIRST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnNext IN FRAME fView DO:
  GET NEXT qNav.
  IF NOT AVAILABLE InventoryTrans THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnLast IN FRAME fView DO:
  GET LAST qNav.
  IF NOT AVAILABLE InventoryTrans THEN GET LAST qNav.
  RUN show-record.
END.

ON CHOOSE OF btnClose IN FRAME fView DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

PROCEDURE show-record :
  IF AVAILABLE InventoryTrans THEN
    DISPLAY InventoryTrans.InvTransNum
            InventoryTrans.WarehouseNum
            InventoryTrans.BinNum
            InventoryTrans.Qty
            InventoryTrans.Itemnum
            InventoryTrans.TransDate
            InventoryTrans.InvType
            InventoryTrans.PONum
            InventoryTrans.Ordernum
            InventoryTrans.Transtime
        WITH FRAME fView.
END PROCEDURE.

OPEN QUERY qNav FOR EACH InventoryTrans NO-LOCK BY InventoryTrans.InvTransNum.
GET FIRST qNav.
RUN show-record.
ENABLE btnFirst btnPrev btnNext btnLast btnClose WITH FRAME fView.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

