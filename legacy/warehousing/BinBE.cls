/*------------------------------------------------------------------------
    File        : BinBE.cls
    Purpose     : business entity for Bin (OpenEdge 11 OO ABL)
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-05  ssp  fix rounding
 *  2002-05  tlw  audit fields
 *  2004-03  rdh  fix rounding
 *  2017-03  ssp  add lock retry
 *  2014-12  jkm  performance: use index
 */

/* BinBE.cls : business entity for Bin (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS WH.BinBE:

  DEFINE PUBLIC PROPERTY WarehouseNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Itemnum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Qty AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY BinNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY BinName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC BinBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pBinNum AS INTEGER):
    FIND FIRST Bin NO-LOCK WHERE Bin.BinNum = pBinNum NO-ERROR.
    IF NOT AVAILABLE Bin THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:WarehouseNum = Bin.WarehouseNum
           THIS-OBJECT:Itemnum = Bin.Itemnum
           THIS-OBJECT:Qty = Bin.Qty
           THIS-OBJECT:BinNum = Bin.BinNum
           THIS-OBJECT:BinName = Bin.BinName
           rRow = ROWID(Bin) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:BinNum = 0 THEN cErr = cErr + "Bin Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Bin.
      ELSE FIND Bin WHERE ROWID(Bin) = rRow EXCLUSIVE-LOCK.
      ASSIGN Bin.WarehouseNum = THIS-OBJECT:WarehouseNum
             Bin.Itemnum = THIS-OBJECT:Itemnum
             Bin.Qty = THIS-OBJECT:Qty
             Bin.BinNum = THIS-OBJECT:BinNum
             Bin.BinName = THIS-OBJECT:BinName.
      rRow = ROWID(Bin).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Bin WHERE ROWID(Bin) = rRow EXCLUSIVE-LOCK.
      DELETE Bin.
    END.
  END METHOD.

END CLASS.

