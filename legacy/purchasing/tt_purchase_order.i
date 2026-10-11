/*------------------------------------------------------------------------
    File        : tt_purchase_order.i
    Purpose     : temp-table and dataset for PurchaseOrder (AppServer transport)
    Module      : Purchasing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-06  jkm  credit hold rule
 *  2002-06  rdh  new report column
 *  2009-02  mab  new report column
 *  2013-06  ssp  performance: use index
 *  2005-08  jkm  new report column
 */

/* tt_purchase_order.i : temp-table and dataset for PurchaseOrder (AppServer transport) */

DEFINE TEMP-TABLE ttPurchaseOrder NO-UNDO BEFORE-TABLE btPurchaseOrder
    FIELD PONum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "PO Num"
    FIELD DateEntered AS DATE FORMAT "99/99/9999" LABEL "Date Entered"
    FIELD SupplierIDNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Supplier ID"
    FIELD ReceiveDate AS DATE FORMAT "99/99/9999" LABEL "Date Received"
    FIELD POStatus AS CHARACTER FORMAT "x(20)" LABEL "PO Status"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX PONum IS PRIMARY UNIQUE PONum
    .

DEFINE TEMP-TABLE ttPurchaseOrderErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE TEMP-TABLE ttPOLineRef NO-UNDO LIKE POLine.

DEFINE DATASET dsPurchaseOrder FOR ttPurchaseOrder, ttPOLineRef
    DATA-RELATION rPurchaseOrderPOLine FOR ttPurchaseOrder, ttPOLineRef
        RELATION-FIELDS (PONum, PONum) NESTED.

