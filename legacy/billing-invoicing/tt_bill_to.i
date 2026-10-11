/*------------------------------------------------------------------------
    File        : tt_bill_to.i
    Purpose     : temp-table and dataset for BillTo (AppServer transport)
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-10  tlw  performance: use index
 *  2009-06  mab  add lock retry
 *  1999-11  ssp  add lock retry
 *  2005-11  ssp  Y2K date window
 */

/* tt_bill_to.i : temp-table and dataset for BillTo (AppServer transport) */

DEFINE TEMP-TABLE ttBillTo NO-UNDO BEFORE-TABLE btBillTo
    FIELD CustNum AS INTEGER FORMAT ">>>>9" LABEL "Cust Num"
    FIELD BillToID AS INTEGER FORMAT "zzzzzzzzz9" LABEL "BillToID"
    FIELD Name AS CHARACTER FORMAT "x(30)" LABEL "Name"
    FIELD Address AS CHARACTER FORMAT "x(35)" LABEL "Address"
    FIELD Address2 AS CHARACTER FORMAT "x(35)" LABEL "Address2"
    FIELD City AS CHARACTER FORMAT "x(25)" LABEL "City"
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD PostalCode AS CHARACTER FORMAT "x(10)" LABEL "Postal Code"
    FIELD Contact AS CHARACTER FORMAT "x(30)" LABEL "Contact"
    FIELD Phone AS CHARACTER FORMAT "x(20)" LABEL "Phone"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX custnumbillto IS PRIMARY UNIQUE CustNum BillToID
    .

DEFINE TEMP-TABLE ttBillToErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsBillTo FOR ttBillTo.

