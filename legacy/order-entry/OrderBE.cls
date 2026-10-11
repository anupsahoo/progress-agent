/*------------------------------------------------------------------------
    File        : OrderBE.cls
    Purpose     : business entity for Order (OpenEdge 11 OO ABL)
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-07  jkm  new report column
 *  2004-12  jkm  audit fields
 *  1999-02  kpo  credit hold rule
 */

/* OrderBE.cls : business entity for Order (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS OE.OrderBE:

  DEFINE PUBLIC PROPERTY Ordernum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CustNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OrderDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ShipDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PromiseDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Carrier AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Instructions AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PO AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Terms AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY SalesRep AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY BillToID AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ShipToID AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OrderStatus AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY WarehouseNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Creditcard AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC OrderBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pOrdernum AS INTEGER):
    FIND FIRST Order NO-LOCK WHERE Order.Ordernum = pOrdernum NO-ERROR.
    IF NOT AVAILABLE Order THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Ordernum = Order.Ordernum
           THIS-OBJECT:CustNum = Order.CustNum
           THIS-OBJECT:OrderDate = Order.OrderDate
           THIS-OBJECT:ShipDate = Order.ShipDate
           THIS-OBJECT:PromiseDate = Order.PromiseDate
           THIS-OBJECT:Carrier = Order.Carrier
           THIS-OBJECT:Instructions = Order.Instructions
           THIS-OBJECT:PO = Order.PO
           THIS-OBJECT:Terms = Order.Terms
           THIS-OBJECT:SalesRep = Order.SalesRep
           THIS-OBJECT:BillToID = Order.BillToID
           THIS-OBJECT:ShipToID = Order.ShipToID
           THIS-OBJECT:OrderStatus = Order.OrderStatus
           THIS-OBJECT:WarehouseNum = Order.WarehouseNum
           THIS-OBJECT:Creditcard = Order.Creditcard
           rRow = ROWID(Order) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:Ordernum = 0 THEN cErr = cErr + "Order Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Order.
      ELSE FIND Order WHERE ROWID(Order) = rRow EXCLUSIVE-LOCK.
      ASSIGN Order.Ordernum = THIS-OBJECT:Ordernum
             Order.CustNum = THIS-OBJECT:CustNum
             Order.OrderDate = THIS-OBJECT:OrderDate
             Order.ShipDate = THIS-OBJECT:ShipDate
             Order.PromiseDate = THIS-OBJECT:PromiseDate
             Order.Carrier = THIS-OBJECT:Carrier
             Order.Instructions = THIS-OBJECT:Instructions
             Order.PO = THIS-OBJECT:PO
             Order.Terms = THIS-OBJECT:Terms
             Order.SalesRep = THIS-OBJECT:SalesRep
             Order.BillToID = THIS-OBJECT:BillToID
             Order.ShipToID = THIS-OBJECT:ShipToID
             Order.OrderStatus = THIS-OBJECT:OrderStatus
             Order.WarehouseNum = THIS-OBJECT:WarehouseNum
             Order.Creditcard = THIS-OBJECT:Creditcard.
      rRow = ROWID(Order).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Order WHERE ROWID(Order) = rRow EXCLUSIVE-LOCK.
      DELETE Order.
    END.
  END METHOD.

END CLASS.

