/*------------------------------------------------------------------------
    File        : ItemBE.cls
    Purpose     : business entity for Item (OpenEdge 11 OO ABL)
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-08  rdh  new report column
 *  2016-12  ssp  Y2K date window
 *  2010-05  kpo  new report column
 */

/* ItemBE.cls : business entity for Item (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS IN.ItemBE:

  DEFINE PUBLIC PROPERTY Itemnum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ItemName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Price AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Onhand AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Allocated AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ReOrder AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OnOrder AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CatPage AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CatDescription AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Category1 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Category2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Special AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Weight AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Minqty AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC ItemBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pItemnum AS INTEGER):
    FIND FIRST Item NO-LOCK WHERE Item.Itemnum = pItemnum NO-ERROR.
    IF NOT AVAILABLE Item THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Itemnum = Item.Itemnum
           THIS-OBJECT:ItemName = Item.ItemName
           THIS-OBJECT:Price = Item.Price
           THIS-OBJECT:Onhand = Item.Onhand
           THIS-OBJECT:Allocated = Item.Allocated
           THIS-OBJECT:ReOrder = Item.ReOrder
           THIS-OBJECT:OnOrder = Item.OnOrder
           THIS-OBJECT:CatPage = Item.CatPage
           THIS-OBJECT:CatDescription = Item.CatDescription
           THIS-OBJECT:Category1 = Item.Category1
           THIS-OBJECT:Category2 = Item.Category2
           THIS-OBJECT:Special = Item.Special
           THIS-OBJECT:Weight = Item.Weight
           THIS-OBJECT:Minqty = Item.Minqty
           rRow = ROWID(Item) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:Itemnum = 0 THEN cErr = cErr + "Item Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Item.
      ELSE FIND Item WHERE ROWID(Item) = rRow EXCLUSIVE-LOCK.
      ASSIGN Item.Itemnum = THIS-OBJECT:Itemnum
             Item.ItemName = THIS-OBJECT:ItemName
             Item.Price = THIS-OBJECT:Price
             Item.Onhand = THIS-OBJECT:Onhand
             Item.Allocated = THIS-OBJECT:Allocated
             Item.ReOrder = THIS-OBJECT:ReOrder
             Item.OnOrder = THIS-OBJECT:OnOrder
             Item.CatPage = THIS-OBJECT:CatPage
             Item.CatDescription = THIS-OBJECT:CatDescription
             Item.Category1 = THIS-OBJECT:Category1
             Item.Category2 = THIS-OBJECT:Category2
             Item.Special = THIS-OBJECT:Special
             Item.Weight = THIS-OBJECT:Weight
             Item.Minqty = THIS-OBJECT:Minqty.
      rRow = ROWID(Item).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Item WHERE ROWID(Item) = rRow EXCLUSIVE-LOCK.
      DELETE Item.
    END.
  END METHOD.

END CLASS.

