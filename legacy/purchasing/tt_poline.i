/*------------------------------------------------------------------------
    File        : tt_poline.i
    Purpose     : temp-table and dataset for POLine (AppServer transport)
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-06  mab  appserver split
 *  1999-12  ssp  new report column
 *  2004-02  rdh  add lock retry
 */

/* tt_poline.i : temp-table and dataset for POLine (AppServer transport) */

DEFINE TEMP-TABLE ttPOLine NO-UNDO BEFORE-TABLE btPOLine
    FIELD Linenum AS INTEGER FORMAT ">>9" LABEL "Line Num"
    FIELD Itemnum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Item Num"
    FIELD Price AS DECIMAL FORMAT "->,>>>,>>9.99" LABEL "Price" DECIMALS 2
    FIELD Qty AS INTEGER FORMAT "->>>>9" LABEL "Qty"
    FIELD Discount AS INTEGER FORMAT ">>9%" LABEL "Discount"
    FIELD ExtendedPrice AS DECIMAL FORMAT "->>,>>9.99" LABEL "Extended Price" DECIMALS 2
    FIELD PONum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Order Num"
    FIELD POLineStatus AS CHARACTER FORMAT "x(20)" LABEL "PO Line Status"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX PONumLinenum IS PRIMARY UNIQUE PONum Linenum
    .

DEFINE TEMP-TABLE ttPOLineErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsPOLine FOR ttPOLine.

