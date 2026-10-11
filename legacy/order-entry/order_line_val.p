/*------------------------------------------------------------------------
    File        : order_line_val.p
    Purpose     : Business validation for OrderLine
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bOrderLine FOR OrderLine.

FIND bOrderLine WHERE ROWID(bOrderLine) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bOrderLine THEN DO:
  ASSIGN plOk = NO pcMsg = "OrderLine record not found.".
  RETURN.
END.

/* Ordernum: CAN-FIND(order OF orderline) */
IF NOT CAN-FIND(FIRST Order WHERE Order.Ordernum = bOrderLine.Ordernum) THEN
  RUN add-error ("Order must exist").

/* Itemnum: CAN-FIND(item OF orderline) */
IF NOT CAN-FIND(FIRST Item WHERE Item.Itemnum = bOrderLine.Itemnum) THEN
  RUN add-error ("Item must be on file").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

