&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/*------------------------------------------------------------------------
    File        : cust_360.w
    Purpose     : Customer 360 inquiry: profile, ship-to addresses and feedback
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

CREATE WIDGET-POOL.
{shared/sysdefs.i}
{customer-management/cm_defs.i}

DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.
DEFINE QUERY qMaster FOR Customer SCROLLING.
DEFINE BROWSE brMaster QUERY qMaster NO-LOCK DISPLAY
    Customer.CustNum COLUMN-LABEL "Cust Num"
    Customer.Country COLUMN-LABEL "Country"
    Customer.Name COLUMN-LABEL "Name"
    Customer.Address COLUMN-LABEL "Address"
    Customer.Address2 COLUMN-LABEL "Address2"
    Customer.City COLUMN-LABEL "City"
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
    WITH THREE-D SIZE 124 BY 22 TITLE "Customer 360 inquiry: profile, ship-to addresses and feedback".

ON VALUE-CHANGED OF brMaster IN FRAME fMain DO:
  OPEN QUERY qDetail FOR EACH ShipTo NO-LOCK WHERE ShipTo.CustNum = Customer.CustNum.
END.

ON CHOOSE OF btnRefresh IN FRAME fMain DO:
  OPEN QUERY qMaster FOR EACH Customer NO-LOCK.
  APPLY "VALUE-CHANGED":U TO brMaster.
END.

ON CHOOSE OF btnOpen IN FRAME fMain DO:
  IF AVAILABLE Customer THEN RUN customer-management/customer_maint.p.
END.

ON CHOOSE OF btnClose IN FRAME fMain DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

CREATE WINDOW wWin ASSIGN TITLE = "Customer 360 inquiry: profile, ship-to addresses and feedback" HEIGHT = 22 WIDTH = 124.
CURRENT-WINDOW = wWin.
ENABLE ALL WITH FRAME fMain.
APPLY "CHOOSE":U TO btnRefresh.
WAIT-FOR CLOSE OF THIS-PROCEDURE.

PROCEDURE post-ship-to-city0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.City = "" OR bShipTo.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ship-to-postalcode1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.PostalCode = "" OR bShipTo.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

