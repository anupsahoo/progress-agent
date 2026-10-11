/*------------------------------------------------------------------------
    File        : packing_slip.p
    Purpose     : Packing slip print
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-12  mab  remove dead code
 *  2011-02  mab  fix rounding
 *  2010-11  ssp  Y2K date window
 *  2016-05  mab  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Packing slip print" SKIP(1).

FOR EACH Order NO-LOCK
    BREAK BY Order.Carrier:
    dLine = 0.
    FOR EACH OrderLine NO-LOCK WHERE OrderLine.Ordernum = Order.Ordernum:
        dLine = dLine + OrderLine.Price.
    END.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY Order.Carrier).
    DISPLAY STREAM sOut Order.Ordernum Order.CustNum Order.OrderDate Order.ShipDate dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(Order.Carrier) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  Carrier total: " ACCUM SUB-TOTAL BY Order.Carrier dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE calc-ship-to-address20 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Address2 = "" OR bShipTo.Address2 = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Address2 is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Address2) > 35 THEN plOk = NO.
END PROCEDURE.

