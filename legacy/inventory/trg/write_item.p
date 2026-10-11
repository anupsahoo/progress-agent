/*------------------------------------------------------------------------
    File        : write_item.p
    Purpose     : schema WRITE trigger for Item, field-level audit
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-06  rdh  audit fields
 */

/* trg/write_item.p : schema WRITE trigger for Item, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Item OLD BUFFER oldItem.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN inventory/item_val.p (INPUT ROWID(Item), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Item write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Item.Itemnum <> oldItem.Itemnum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Itemnum", INPUT STRING(oldItem.Itemnum), INPUT STRING(Item.Itemnum)).
END.
IF Item.ItemName <> oldItem.ItemName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.ItemName", INPUT STRING(oldItem.ItemName), INPUT STRING(Item.ItemName)).
END.
IF Item.Price <> oldItem.Price THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Price", INPUT STRING(oldItem.Price), INPUT STRING(Item.Price)).
END.
IF Item.Onhand <> oldItem.Onhand THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Onhand", INPUT STRING(oldItem.Onhand), INPUT STRING(Item.Onhand)).
END.
IF Item.Allocated <> oldItem.Allocated THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Allocated", INPUT STRING(oldItem.Allocated), INPUT STRING(Item.Allocated)).
END.
IF Item.ReOrder <> oldItem.ReOrder THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.ReOrder", INPUT STRING(oldItem.ReOrder), INPUT STRING(Item.ReOrder)).
END.
IF Item.OnOrder <> oldItem.OnOrder THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.OnOrder", INPUT STRING(oldItem.OnOrder), INPUT STRING(Item.OnOrder)).
END.
IF Item.CatPage <> oldItem.CatPage THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.CatPage", INPUT STRING(oldItem.CatPage), INPUT STRING(Item.CatPage)).
END.
IF Item.CatDescription <> oldItem.CatDescription THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.CatDescription", INPUT STRING(oldItem.CatDescription), INPUT STRING(Item.CatDescription)).
END.
IF Item.Category1 <> oldItem.Category1 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Category1", INPUT STRING(oldItem.Category1), INPUT STRING(Item.Category1)).
END.
IF Item.Category2 <> oldItem.Category2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Category2", INPUT STRING(oldItem.Category2), INPUT STRING(Item.Category2)).
END.
IF Item.Special <> oldItem.Special THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Special", INPUT STRING(oldItem.Special), INPUT STRING(Item.Special)).
END.
IF Item.Weight <> oldItem.Weight THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Weight", INPUT STRING(oldItem.Weight), INPUT STRING(Item.Weight)).
END.
IF Item.Minqty <> oldItem.Minqty THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Item.Minqty", INPUT STRING(oldItem.Minqty), INPUT STRING(Item.Minqty)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/item.q") APPEND.
  EXPORT "Item" "W" STRING(NOW) Item.Itemnum.
  OUTPUT CLOSE.
END.

