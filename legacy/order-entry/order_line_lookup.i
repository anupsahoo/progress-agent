/*------------------------------------------------------------------------
    File        : order_line_lookup.i
    Purpose     : OrderLine lookup helpers. {&NO-ORDERLINE-FUNCS} suppresses the functions.
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-05  tlw  add lock retry
 */

/* order_line_lookup.i : OrderLine lookup helpers. {&NO-ORDERLINE-FUNCS} suppresses the functions. */

&IF DEFINED(ORDER_LINE_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE ORDER_LINE_LOOKUP_I YES

DEFINE BUFFER bLkOrderLine FOR OrderLine.

FUNCTION OrderLineExists RETURNS LOGICAL (INPUT pOrdernum AS INTEGER, INPUT pLinenum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkOrderLine WHERE bLkOrderLine.Ordernum = pOrdernum AND bLkOrderLine.Linenum = pLinenum).
END FUNCTION.

FUNCTION OrderLineDesc RETURNS CHARACTER (INPUT pOrdernum AS INTEGER, INPUT pLinenum AS INTEGER):
  FIND FIRST bLkOrderLine NO-LOCK WHERE bLkOrderLine.Ordernum = pOrdernum AND bLkOrderLine.Linenum = pLinenum NO-ERROR.
  RETURN (IF AVAILABLE bLkOrderLine THEN bLkOrderLine.OrderLineStatus ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-order_line :
  DEFINE INPUT  PARAMETER pOrdernum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pLinenum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkOrderLine NO-LOCK WHERE bLkOrderLine.Ordernum = pOrdernum AND bLkOrderLine.Linenum = pLinenum NO-ERROR.
  pRowid = IF AVAILABLE bLkOrderLine THEN ROWID(bLkOrderLine) ELSE ?.
END PROCEDURE.

&ENDIF

