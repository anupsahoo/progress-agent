/*------------------------------------------------------------------------
    File        : item_export.p
    Purpose     : Export Item to CSV
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-03  jkm  Y2K date window
 *  2011-01  mab  audit fields
 *  1999-05  jkm  appserver split
 *  2008-04  rdh  performance: use index
 *  2005-08  rdh  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "item_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Item Num,Item Name,Price,On Hand,Allocated,Re Order,On Order,Cat Page,Cat-Description,Category1,Category2,Special,Weight,Min Qty" SKIP.
FOR EACH Item NO-LOCK
    BY Item.Itemnum:
    EXPORT DELIMITER "," Item.Itemnum Item.ItemName Item.Price Item.Onhand Item.Allocated Item.ReOrder Item.OnOrder Item.CatPage Item.CatDescription Item.Category1 Item.Category2 Item.Special Item.Weight Item.Minqty.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=Item" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "Item export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

