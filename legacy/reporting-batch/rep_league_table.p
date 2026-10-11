/*------------------------------------------------------------------------
    File        : rep_league_table.p
    Purpose     : Sales rep league table
    Module      : Reporting & Batch
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-12  tlw  add lock retry
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Sales rep league table" SKIP(1).

FOR EACH Salesrep NO-LOCK
    BREAK BY Salesrep.SalesRep:
    dLine = 0.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY Salesrep.SalesRep).
    DISPLAY STREAM sOut Salesrep.SalesRep Salesrep.RepName Salesrep.Region dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(Salesrep.SalesRep) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  Sales Rep total: " ACCUM SUB-TOTAL BY Salesrep.SalesRep dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE reset-order-salesrep0 :
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

