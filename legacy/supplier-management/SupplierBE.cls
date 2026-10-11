/*------------------------------------------------------------------------
    File        : SupplierBE.cls
    Purpose     : business entity for Supplier (OpenEdge 11 OO ABL)
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-07  ssp  appserver split
 *  2011-09  ssp  fix rounding
 *  2015-08  rdh  add lock retry
 */

/* SupplierBE.cls : business entity for Supplier (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS SM.SupplierBE:

  DEFINE PUBLIC PROPERTY SupplierIDNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Name AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Country AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Phone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Comments AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Password AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY LoginDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ShipAmount AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Discount AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC SupplierBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pSupplierIDNum AS INTEGER):
    FIND FIRST Supplier NO-LOCK WHERE Supplier.SupplierIDNum = pSupplierIDNum NO-ERROR.
    IF NOT AVAILABLE Supplier THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:SupplierIDNum = Supplier.SupplierIDNum
           THIS-OBJECT:Name = Supplier.Name
           THIS-OBJECT:Address = Supplier.Address
           THIS-OBJECT:Address2 = Supplier.Address2
           THIS-OBJECT:City = Supplier.City
           THIS-OBJECT:State = Supplier.State
           THIS-OBJECT:PostalCode = Supplier.PostalCode
           THIS-OBJECT:Country = Supplier.Country
           THIS-OBJECT:Phone = Supplier.Phone
           THIS-OBJECT:Comments = Supplier.Comments
           THIS-OBJECT:Password = Supplier.Password
           THIS-OBJECT:LoginDate = Supplier.LoginDate
           THIS-OBJECT:ShipAmount = Supplier.ShipAmount
           THIS-OBJECT:Discount = Supplier.Discount
           rRow = ROWID(Supplier) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:SupplierIDNum = 0 THEN cErr = cErr + "Supplier ID is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Supplier.
      ELSE FIND Supplier WHERE ROWID(Supplier) = rRow EXCLUSIVE-LOCK.
      ASSIGN Supplier.SupplierIDNum = THIS-OBJECT:SupplierIDNum
             Supplier.Name = THIS-OBJECT:Name
             Supplier.Address = THIS-OBJECT:Address
             Supplier.Address2 = THIS-OBJECT:Address2
             Supplier.City = THIS-OBJECT:City
             Supplier.State = THIS-OBJECT:State
             Supplier.PostalCode = THIS-OBJECT:PostalCode
             Supplier.Country = THIS-OBJECT:Country
             Supplier.Phone = THIS-OBJECT:Phone
             Supplier.Comments = THIS-OBJECT:Comments
             Supplier.Password = THIS-OBJECT:Password
             Supplier.LoginDate = THIS-OBJECT:LoginDate
             Supplier.ShipAmount = THIS-OBJECT:ShipAmount
             Supplier.Discount = THIS-OBJECT:Discount.
      rRow = ROWID(Supplier).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Supplier WHERE ROWID(Supplier) = rRow EXCLUSIVE-LOCK.
      DELETE Supplier.
    END.
  END METHOD.

END CLASS.

