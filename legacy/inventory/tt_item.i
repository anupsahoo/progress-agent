/*------------------------------------------------------------------------
    File        : tt_item.i
    Purpose     : temp-table and dataset for Item (AppServer transport)
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-02  kpo  credit hold rule
 *  2013-05  tlw  new report column
 */

/* tt_item.i : temp-table and dataset for Item (AppServer transport) */

DEFINE TEMP-TABLE ttItem NO-UNDO BEFORE-TABLE btItem
    FIELD Itemnum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Item Num"
    FIELD ItemName AS CHARACTER FORMAT "x(25)" LABEL "Item Name"
    FIELD Price AS DECIMAL FORMAT "->,>>>,>>9.99" LABEL "Price" DECIMALS 2
    FIELD Onhand AS INTEGER FORMAT "->>>>9" LABEL "On Hand"
    FIELD Allocated AS INTEGER FORMAT "->>>>9" LABEL "Allocated"
    FIELD ReOrder AS INTEGER FORMAT "->>>>9" LABEL "Re Order"
    FIELD OnOrder AS INTEGER FORMAT "->>>>9" LABEL "On Order"
    FIELD CatPage AS INTEGER FORMAT ">>9" LABEL "Cat Page"
    FIELD CatDescription AS CHARACTER FORMAT "X(200)" LABEL "Cat-Description"
    FIELD Category1 AS CHARACTER FORMAT "x(30)" LABEL "Category1"
    FIELD Category2 AS CHARACTER FORMAT "x(30)" LABEL "Category2"
    FIELD Special AS CHARACTER FORMAT "x(8)" LABEL "Special"
    FIELD Weight AS DECIMAL FORMAT "->>,>>9.99" LABEL "Weight" DECIMALS 2
    FIELD Minqty AS INTEGER FORMAT "->>>>9" LABEL "Min Qty"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX ItemNum IS PRIMARY UNIQUE Itemnum
    INDEX Category2ItemName Category2 ItemName
    INDEX CategoryItemName Category1 ItemName
    .

DEFINE TEMP-TABLE ttItemErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsItem FOR ttItem.

