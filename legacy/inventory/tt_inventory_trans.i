/*------------------------------------------------------------------------
    File        : tt_inventory_trans.i
    Purpose     : temp-table and dataset for InventoryTrans (AppServer transport)
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-01  jkm  fix rounding
 *  2015-05  jkm  performance: use index
 */

/* tt_inventory_trans.i : temp-table and dataset for InventoryTrans (AppServer transport) */

DEFINE TEMP-TABLE ttInventoryTrans NO-UNDO BEFORE-TABLE btInventoryTrans
    FIELD InvTransNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Inventory Trans Num"
    FIELD WarehouseNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Warehouse Num"
    FIELD BinNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Bin Num"
    FIELD Qty AS INTEGER FORMAT "->>>>9" LABEL "Qty"
    FIELD Itemnum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Item Num"
    FIELD TransDate AS DATE FORMAT "99/99/9999" LABEL "Trans Date"
    FIELD InvType AS CHARACTER FORMAT "X(12)" LABEL "Type"
    FIELD PONum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "PO Num"
    FIELD Ordernum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Order Num"
    FIELD Transtime AS CHARACTER FORMAT "X(5)" LABEL "Trans Time"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    .

DEFINE TEMP-TABLE ttInventoryTransErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsInventoryTrans FOR ttInventoryTrans.

