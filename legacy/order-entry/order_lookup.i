/*------------------------------------------------------------------------
    File        : order_lookup.i
    Purpose     : Order lookup helpers. {&NO-ORDER-FUNCS} suppresses the functions.
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-05  tlw  performance: use index
 *  2000-07  kpo  audit fields
 *  1999-06  mab  credit hold rule
 *  2008-02  ssp  credit hold rule
 *  2013-10  mab  add lock retry
 */

/* order_lookup.i : Order lookup helpers. {&NO-ORDER-FUNCS} suppresses the functions. */

&IF DEFINED(ORDER_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE ORDER_LOOKUP_I YES

DEFINE BUFFER bLkOrder FOR Order.

FUNCTION OrderExists RETURNS LOGICAL (INPUT pOrdernum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkOrder WHERE bLkOrder.Ordernum = pOrdernum).
END FUNCTION.

FUNCTION OrderDesc RETURNS CHARACTER (INPUT pOrdernum AS INTEGER):
  FIND FIRST bLkOrder NO-LOCK WHERE bLkOrder.Ordernum = pOrdernum NO-ERROR.
  RETURN (IF AVAILABLE bLkOrder THEN bLkOrder.Carrier ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-order :
  DEFINE INPUT  PARAMETER pOrdernum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkOrder NO-LOCK WHERE bLkOrder.Ordernum = pOrdernum NO-ERROR.
  pRowid = IF AVAILABLE bLkOrder THEN ROWID(bLkOrder) ELSE ?.
END PROCEDURE.

&ENDIF

