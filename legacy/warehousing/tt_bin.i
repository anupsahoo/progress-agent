/*------------------------------------------------------------------------
    File        : tt_bin.i
    Purpose     : temp-table and dataset for Bin (AppServer transport)
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-05  tlw  remove dead code
 *  2009-10  rdh  performance: use index
 */

/* tt_bin.i : temp-table and dataset for Bin (AppServer transport) */

DEFINE TEMP-TABLE ttBin NO-UNDO BEFORE-TABLE btBin
    FIELD WarehouseNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Warehouse Num"
    FIELD Itemnum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Item Num"
    FIELD Qty AS INTEGER FORMAT "->>>>9" LABEL "Qty"
    FIELD BinNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Bin Num"
    FIELD BinName AS CHARACTER FORMAT "x(30)" LABEL "Bin Name"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX BinNum IS PRIMARY UNIQUE BinNum
    INDEX ItemNum Itemnum
    INDEX WarehouseNumItemNum WarehouseNum Itemnum
    .

DEFINE TEMP-TABLE ttBinErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsBin FOR ttBin.

