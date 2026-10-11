/*------------------------------------------------------------------------
    File        : WarehouseBE.cls
    Purpose     : business entity for Warehouse (OpenEdge 11 OO ABL)
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-08  jkm  Y2K date window
 *  2000-05  kpo  remove dead code
 *  2016-04  tlw  audit fields
 *  2013-03  mab  Y2K date window
 *  2015-09  ssp  add lock retry
 */

/* WarehouseBE.cls : business entity for Warehouse (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS WH.WarehouseBE:

  DEFINE PUBLIC PROPERTY WarehouseNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY WarehouseName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Country AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Phone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC WarehouseBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pWarehouseNum AS INTEGER):
    FIND FIRST Warehouse NO-LOCK WHERE Warehouse.WarehouseNum = pWarehouseNum NO-ERROR.
    IF NOT AVAILABLE Warehouse THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:WarehouseNum = Warehouse.WarehouseNum
           THIS-OBJECT:WarehouseName = Warehouse.WarehouseName
           THIS-OBJECT:Country = Warehouse.Country
           THIS-OBJECT:Address = Warehouse.Address
           THIS-OBJECT:Address2 = Warehouse.Address2
           THIS-OBJECT:City = Warehouse.City
           THIS-OBJECT:State = Warehouse.State
           THIS-OBJECT:PostalCode = Warehouse.PostalCode
           THIS-OBJECT:Phone = Warehouse.Phone
           rRow = ROWID(Warehouse) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:WarehouseNum = 0 THEN cErr = cErr + "Warehouse Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Warehouse.
      ELSE FIND Warehouse WHERE ROWID(Warehouse) = rRow EXCLUSIVE-LOCK.
      ASSIGN Warehouse.WarehouseNum = THIS-OBJECT:WarehouseNum
             Warehouse.WarehouseName = THIS-OBJECT:WarehouseName
             Warehouse.Country = THIS-OBJECT:Country
             Warehouse.Address = THIS-OBJECT:Address
             Warehouse.Address2 = THIS-OBJECT:Address2
             Warehouse.City = THIS-OBJECT:City
             Warehouse.State = THIS-OBJECT:State
             Warehouse.PostalCode = THIS-OBJECT:PostalCode
             Warehouse.Phone = THIS-OBJECT:Phone.
      rRow = ROWID(Warehouse).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Warehouse WHERE ROWID(Warehouse) = rRow EXCLUSIVE-LOCK.
      DELETE Warehouse.
    END.
  END METHOD.

END CLASS.

