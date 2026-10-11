&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : supplier_onboard.w
    Purpose     : Supplier onboarding and item cross reference
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{supplier-management/sm_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Supplier SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Supplier.SupplierIDNum COLUMN-LABEL "Supplier ID"
    Supplier.Name COLUMN-LABEL "Name"
    Supplier.Address COLUMN-LABEL "Address"
    Supplier.Address2 COLUMN-LABEL "Address2"
    Supplier.City COLUMN-LABEL "City"
    Supplier.State COLUMN-LABEL "State"
    WITH SIZE 120 BY 9 SEPARATORS.

DEFINE QUERY qDetail FOR SupplierItemXref SCROLLING.
DEFINE BROWSE brDetail QUERY qDetail NO-LOCK DISPLAY
    SupplierItemXref.SupplierIDNum COLUMN-LABEL "Supplier ID"
    SupplierItemXref.Itemnum COLUMN-LABEL "Item #"
    WITH SIZE 120 BY 8 SEPARATORS.

DEFINE BUTTON btnRefresh LABEL "Refresh" SIZE 12 BY 1.14.
DEFINE BUTTON btnOpen LABEL "Open" SIZE 12 BY 1.14.
DEFINE BUTTON btnPrint LABEL "Print" SIZE 12 BY 1.14.
DEFINE BUTTON btnClose LABEL "Close" SIZE 12 BY 1.14.

DEFINE FRAME fMain
    brMaster AT ROW 1.5 COL 2
    brDetail AT ROW 11 COL 2
    btnRefresh AT ROW 20 COL 2 btnOpen btnPrint btnClose
    WITH THREE-D SIZE 124 BY 22 TITLE "Supplier onboarding and item cross reference".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH SupplierItemXref NO-LOCK WHERE SupplierItemXref.SupplierIDNum = Supplier.SupplierIDNum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Supplier NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Supplier THEN RUN supplier-management/supplier_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Supplier onboarding and item cross reference" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE load-supplier-shipamount0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

