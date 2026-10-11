/*------------------------------------------------------------------------
    File        : pick_list.p
    Purpose     : Pick list by warehouse and bin
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-02  kpo  fix rounding
 *  2014-03  jkm  credit hold rule
 *  2001-05  kpo  credit hold rule
 *  2012-05  mab  Y2K date window
 *  2016-04  mab  performance: use index
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Pick list by warehouse and bin" SKIP(1).

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

