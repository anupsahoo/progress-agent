/*------------------------------------------------------------------------
    File        : tt_invoice.i
    Purpose     : temp-table and dataset for Invoice (AppServer transport)
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-01  mab  Y2K date window
 *  2008-07  jkm  add lock retry
 *  2014-07  rdh  remove dead code
 *  2007-11  kpo  credit hold rule
 */

/* tt_invoice.i : temp-table and dataset for Invoice (AppServer transport) */

DEFINE TEMP-TABLE ttInvoice NO-UNDO BEFORE-TABLE btInvoice
    FIELD Invoicenum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Invoice Num"
    FIELD CustNum AS INTEGER FORMAT ">>>>9" LABEL "Cust Num"
    FIELD InvoiceDate AS DATE FORMAT "99/99/9999" LABEL "Invoice Date"
    FIELD Amount AS DECIMAL FORMAT "->>,>>9.99" LABEL "Amount" DECIMALS 2
    FIELD TotalPaid AS DECIMAL FORMAT "->>,>>9.99" LABEL "Total Paid" DECIMALS 2
    FIELD Adjustment AS DECIMAL FORMAT "->>,>>9.99" LABEL "Adjustment" DECIMALS 2
    FIELD OrderNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Order Num"
    FIELD ShipCharge AS DECIMAL FORMAT "->>,>>9.99" LABEL "Ship Charge" DECIMALS 2
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX InvoiceNum IS PRIMARY UNIQUE Invoicenum
    INDEX CustNum CustNum
    INDEX InvoiceDate InvoiceDate
    INDEX OrderNum OrderNum
    .

DEFINE TEMP-TABLE ttInvoiceErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsInvoice FOR ttInvoice.

