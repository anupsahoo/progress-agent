/*------------------------------------------------------------------------
    File        : daily_sales_flash.p
    Purpose     : Daily sales flash report
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-01  tlw  new report column
 *  2005-07  kpo  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Daily sales flash report" SKIP(1).

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

PROCEDURE reset-order-po0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.PO = "" OR bOrder.PO = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.PO is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.PO) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-order-line-price1 :
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
    WHEN bOrderLine.Price > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "OrderLine.Price above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-order-salesrep2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bOrder FOR Order.
  FIND bOrder WHERE ROWID(bOrder) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bOrder THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bOrder.SalesRep = "" OR bOrder.SalesRep = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Order.SalesRep is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bOrder.SalesRep) > 4 THEN plOk = NO.
END PROCEDURE.

