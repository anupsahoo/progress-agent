/*------------------------------------------------------------------------
    File        : tt_supplier.i
    Purpose     : temp-table and dataset for Supplier (AppServer transport)
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-05  tlw  fix rounding
 *  2005-08  jkm  credit hold rule
 *  2000-01  jkm  Y2K date window
 *  2011-05  kpo  audit fields
 *  2009-11  mab  credit hold rule
 */

/* tt_supplier.i : temp-table and dataset for Supplier (AppServer transport) */

DEFINE TEMP-TABLE ttSupplier NO-UNDO BEFORE-TABLE btSupplier
    FIELD SupplierIDNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Supplier ID"
    FIELD Name AS CHARACTER FORMAT "x(30)" LABEL "Name"
    FIELD Address AS CHARACTER FORMAT "x(35)" LABEL "Address"
    FIELD Address2 AS CHARACTER FORMAT "x(35)" LABEL "Address2"
    FIELD City AS CHARACTER FORMAT "x(25)" LABEL "City"
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD PostalCode AS CHARACTER FORMAT "x(10)" LABEL "ZipCode"
    FIELD Country AS CHARACTER FORMAT "x(20)" LABEL "Country"
    FIELD Phone AS CHARACTER FORMAT "x(20)" LABEL "Phone"
    FIELD Comments AS CHARACTER FORMAT "x(80)" LABEL "Comments"
    FIELD Password AS CHARACTER FORMAT "x(8)" LABEL "Password"
    FIELD LoginDate AS DATE FORMAT "99/99/9999" LABEL "Login Date"
    FIELD ShipAmount AS INTEGER FORMAT ">>>>9" LABEL "Ship Amount"
    FIELD Discount AS INTEGER FORMAT ">>9%" LABEL "Discount"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX SupplierID IS PRIMARY UNIQUE SupplierIDNum
    .

DEFINE TEMP-TABLE ttSupplierErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE TEMP-TABLE ttSupplierItemXrefRef NO-UNDO LIKE SupplierItemXref.

DEFINE DATASET dsSupplier FOR ttSupplier, ttSupplierItemXrefRef
    DATA-RELATION rSupplierSupplierItemXref FOR ttSupplier, ttSupplierItemXrefRef
        RELATION-FIELDS (SupplierIDNum, SupplierIDNum) NESTED.

