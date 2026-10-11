/*------------------------------------------------------------------------
    File        : delete_item.p
    Purpose     : schema DELETE trigger for Item, referential integrity
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-07  ssp  appserver split
 *  2000-09  rdh  new report column
 */

/* trg/delete_item.p : schema DELETE trigger for Item, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Item.

{shared/sysdefs.i}

IF CAN-FIND(FIRST Bin WHERE Bin.Itemnum = Item.Itemnum) THEN DO:
  MESSAGE "Cannot delete Item: Bin records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST InventoryTrans WHERE InventoryTrans.Itemnum = Item.Itemnum) THEN DO:
  MESSAGE "Cannot delete Item: InventoryTrans records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST OrderLine WHERE OrderLine.Itemnum = Item.Itemnum) THEN DO:
  MESSAGE "Cannot delete Item: OrderLine records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST POLine WHERE POLine.Itemnum = Item.Itemnum) THEN DO:
  MESSAGE "Cannot delete Item: POLine records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST SupplierItemXref WHERE SupplierItemXref.Itemnum = Item.Itemnum) THEN DO:
  MESSAGE "Cannot delete Item: SupplierItemXref records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Table VALEXP: NOT (CAN-FIND(FIRST orderline OF item)) */

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/item_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Item.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Item by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/item.q") APPEND.
EXPORT "Item" "D" STRING(NOW) Item.Itemnum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Item", INPUT STRING(ROWID(Item)), INPUT "DELETE").

