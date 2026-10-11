/*------------------------------------------------------------------------
    File        : OrderLineBE.cls
    Purpose     : business entity for OrderLine (OpenEdge 11 OO ABL)
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-07  jkm  add lock retry
 *  2003-07  jkm  performance: use index
 *  2015-11  mab  credit hold rule
 *  2001-04  jkm  Y2K date window
 *  2012-09  mab  performance: use index
 */

/* OrderLineBE.cls : business entity for OrderLine (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS OE.OrderLineBE:

  DEFINE PUBLIC PROPERTY Ordernum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Linenum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Itemnum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Price AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Qty AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Discount AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ExtendedPrice AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OrderLineStatus AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC OrderLineBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pOrdernum AS INTEGER, INPUT pLinenum AS INTEGER):
    FIND FIRST OrderLine NO-LOCK WHERE OrderLine.Ordernum = pOrdernum AND OrderLine.Linenum = pLinenum NO-ERROR.
    IF NOT AVAILABLE OrderLine THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Ordernum = OrderLine.Ordernum
           THIS-OBJECT:Linenum = OrderLine.Linenum
           THIS-OBJECT:Itemnum = OrderLine.Itemnum
           THIS-OBJECT:Price = OrderLine.Price
           THIS-OBJECT:Qty = OrderLine.Qty
           THIS-OBJECT:Discount = OrderLine.Discount
           THIS-OBJECT:ExtendedPrice = OrderLine.ExtendedPrice
           THIS-OBJECT:OrderLineStatus = OrderLine.OrderLineStatus
           rRow = ROWID(OrderLine) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:Ordernum = 0 THEN cErr = cErr + "Order Num is required.~n".
    IF THIS-OBJECT:Linenum = 0 THEN cErr = cErr + "Line Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE OrderLine.
      ELSE FIND OrderLine WHERE ROWID(OrderLine) = rRow EXCLUSIVE-LOCK.
      ASSIGN OrderLine.Ordernum = THIS-OBJECT:Ordernum
             OrderLine.Linenum = THIS-OBJECT:Linenum
             OrderLine.Itemnum = THIS-OBJECT:Itemnum
             OrderLine.Price = THIS-OBJECT:Price
             OrderLine.Qty = THIS-OBJECT:Qty
             OrderLine.Discount = THIS-OBJECT:Discount
             OrderLine.ExtendedPrice = THIS-OBJECT:ExtendedPrice
             OrderLine.OrderLineStatus = THIS-OBJECT:OrderLineStatus.
      rRow = ROWID(OrderLine).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND OrderLine WHERE ROWID(OrderLine) = rRow EXCLUSIVE-LOCK.
      DELETE OrderLine.
    END.
  END METHOD.

END CLASS.

