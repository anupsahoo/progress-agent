/*------------------------------------------------------------------------
    File        : SupplierItemXrefBE.cls
    Purpose     : business entity for SupplierItemXref (OpenEdge 11 OO ABL)
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-02  rdh  performance: use index
 *  2017-03  tlw  fix rounding
 *  2000-01  kpo  appserver split
 *  2007-09  rdh  new report column
 */

/* SupplierItemXrefBE.cls : business entity for SupplierItemXref (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS SM.SupplierItemXrefBE:

  DEFINE PUBLIC PROPERTY SupplierIDNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Itemnum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC SupplierItemXrefBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pSupplierIDNum AS INTEGER, INPUT pItemnum AS INTEGER):
    FIND FIRST SupplierItemXref NO-LOCK WHERE SupplierItemXref.SupplierIDNum = pSupplierIDNum AND SupplierItemXref.Itemnum = pItemnum NO-ERROR.
    IF NOT AVAILABLE SupplierItemXref THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:SupplierIDNum = SupplierItemXref.SupplierIDNum
           THIS-OBJECT:Itemnum = SupplierItemXref.Itemnum
           rRow = ROWID(SupplierItemXref) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:SupplierIDNum = 0 THEN cErr = cErr + "Supplier ID is required.~n".
    IF THIS-OBJECT:Itemnum = 0 THEN cErr = cErr + "Item # is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE SupplierItemXref.
      ELSE FIND SupplierItemXref WHERE ROWID(SupplierItemXref) = rRow EXCLUSIVE-LOCK.
      ASSIGN SupplierItemXref.SupplierIDNum = THIS-OBJECT:SupplierIDNum
             SupplierItemXref.Itemnum = THIS-OBJECT:Itemnum.
      rRow = ROWID(SupplierItemXref).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND SupplierItemXref WHERE ROWID(SupplierItemXref) = rRow EXCLUSIVE-LOCK.
      DELETE SupplierItemXref.
    END.
  END METHOD.

END CLASS.

