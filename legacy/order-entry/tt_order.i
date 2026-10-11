/*------------------------------------------------------------------------
    File        : tt_order.i
    Purpose     : temp-table and dataset for Order (AppServer transport)
    Module      : Order Entry
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-04  kpo  audit fields
 *  2008-11  mab  credit hold rule
 *  2017-01  kpo  add lock retry
 */

/* tt_order.i : temp-table and dataset for Order (AppServer transport) */

DEFINE TEMP-TABLE ttOrder NO-UNDO BEFORE-TABLE btOrder
    FIELD Ordernum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Order Num"
    FIELD CustNum AS INTEGER FORMAT ">>>>9" LABEL "Cust Num"
    FIELD OrderDate AS DATE FORMAT "99/99/99" LABEL "Ordered"
    FIELD ShipDate AS DATE FORMAT "99/99/9999" LABEL "Shipped"
    FIELD PromiseDate AS DATE FORMAT "99/99/99" LABEL "Promised"
    FIELD Carrier AS CHARACTER FORMAT "x(25)" LABEL "Carrier"
    FIELD Instructions AS CHARACTER FORMAT "x(50)" LABEL "Instructions"
    FIELD PO AS CHARACTER FORMAT "x(20)" LABEL "PO"
    FIELD Terms AS CHARACTER FORMAT "x(20)" LABEL "Terms"
    FIELD SalesRep AS CHARACTER FORMAT "x(4)" LABEL "Sales Rep"
    FIELD BillToID AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Bill To ID"
    FIELD ShipToID AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Ship To ID"
    FIELD OrderStatus AS CHARACTER FORMAT "x(20)" LABEL "Order Status"
    FIELD WarehouseNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Warehouse Num"
    FIELD Creditcard AS CHARACTER FORMAT "x(20)" LABEL "Credit Card"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX OrderNum IS PRIMARY UNIQUE Ordernum
    INDEX CustOrder UNIQUE CustNum Ordernum
    INDEX OrderDate OrderDate
    INDEX OrderStatus OrderStatus
    INDEX SalesRep SalesRep
    .

DEFINE TEMP-TABLE ttOrderErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE TEMP-TABLE ttOrderLineRef NO-UNDO LIKE OrderLine.

DEFINE DATASET dsOrder FOR ttOrder, ttOrderLineRef
    DATA-RELATION rOrderOrderLine FOR ttOrder, ttOrderLineRef
        RELATION-FIELDS (Ordernum, Ordernum) NESTED.

