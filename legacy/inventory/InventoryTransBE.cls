/*------------------------------------------------------------------------
    File        : InventoryTransBE.cls
    Purpose     : business entity for InventoryTrans (OpenEdge 11 OO ABL)
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-02  rdh  remove dead code
 *  1999-01  ssp  add lock retry
 *  2015-11  mab  audit fields
 *  2000-10  mab  Y2K date window
 */

/* InventoryTransBE.cls : business entity for InventoryTrans (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS IN.InventoryTransBE:

  DEFINE PUBLIC PROPERTY InvTransNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY WarehouseNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY BinNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Qty AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Itemnum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY TransDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY InvType AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PONum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Ordernum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Transtime AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC InventoryTransBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pInvTransNum AS INTEGER):
    FIND FIRST InventoryTrans NO-LOCK WHERE InventoryTrans.InvTransNum = pInvTransNum NO-ERROR.
    IF NOT AVAILABLE InventoryTrans THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:InvTransNum = InventoryTrans.InvTransNum
           THIS-OBJECT:WarehouseNum = InventoryTrans.WarehouseNum
           THIS-OBJECT:BinNum = InventoryTrans.BinNum
           THIS-OBJECT:Qty = InventoryTrans.Qty
           THIS-OBJECT:Itemnum = InventoryTrans.Itemnum
           THIS-OBJECT:TransDate = InventoryTrans.TransDate
           THIS-OBJECT:InvType = InventoryTrans.InvType
           THIS-OBJECT:PONum = InventoryTrans.PONum
           THIS-OBJECT:Ordernum = InventoryTrans.Ordernum
           THIS-OBJECT:Transtime = InventoryTrans.Transtime
           rRow = ROWID(InventoryTrans) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:InvTransNum = 0 THEN cErr = cErr + "Inventory Trans Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE InventoryTrans.
      ELSE FIND InventoryTrans WHERE ROWID(InventoryTrans) = rRow EXCLUSIVE-LOCK.
      ASSIGN InventoryTrans.InvTransNum = THIS-OBJECT:InvTransNum
             InventoryTrans.WarehouseNum = THIS-OBJECT:WarehouseNum
             InventoryTrans.BinNum = THIS-OBJECT:BinNum
             InventoryTrans.Qty = THIS-OBJECT:Qty
             InventoryTrans.Itemnum = THIS-OBJECT:Itemnum
             InventoryTrans.TransDate = THIS-OBJECT:TransDate
             InventoryTrans.InvType = THIS-OBJECT:InvType
             InventoryTrans.PONum = THIS-OBJECT:PONum
             InventoryTrans.Ordernum = THIS-OBJECT:Ordernum
             InventoryTrans.Transtime = THIS-OBJECT:Transtime.
      rRow = ROWID(InventoryTrans).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND InventoryTrans WHERE ROWID(InventoryTrans) = rRow EXCLUSIVE-LOCK.
      DELETE InventoryTrans.
    END.
  END METHOD.

END CLASS.

