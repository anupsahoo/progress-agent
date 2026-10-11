/*------------------------------------------------------------------------
    File        : tt_order_line.i
    Purpose     : temp-table and dataset for OrderLine (AppServer transport)
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-10  rdh  new report column
 *  2014-06  kpo  Y2K date window
 */

/* tt_order_line.i : temp-table and dataset for OrderLine (AppServer transport) */

DEFINE TEMP-TABLE ttOrderLine NO-UNDO BEFORE-TABLE btOrderLine
    FIELD Ordernum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Order Num"
    FIELD Linenum AS INTEGER FORMAT ">>9" LABEL "Line Num"
    FIELD Itemnum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Item Num"
    FIELD Price AS DECIMAL FORMAT "->,>>>,>>9.99" LABEL "Price" DECIMALS 2
    FIELD Qty AS INTEGER FORMAT "->>>>9" LABEL "Qty"
    FIELD Discount AS INTEGER FORMAT ">>9%" LABEL "Discount"
    FIELD ExtendedPrice AS DECIMAL FORMAT "->>>,>>9.99" LABEL "Extended Price" DECIMALS 2
    FIELD OrderLineStatus AS CHARACTER FORMAT "x(20)" LABEL "Order Line Status"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX orderline IS PRIMARY UNIQUE Ordernum Linenum
    INDEX itemnum Itemnum
    INDEX OrderLineStatus OrderLineStatus
    .

DEFINE TEMP-TABLE ttOrderLineErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsOrderLine FOR ttOrderLine.

