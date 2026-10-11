/*------------------------------------------------------------------------
    File        : tt_customer.i
    Purpose     : temp-table and dataset for Customer (AppServer transport)
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-08  tlw  performance: use index
 *  2009-12  kpo  Y2K date window
 */

/* tt_customer.i : temp-table and dataset for Customer (AppServer transport) */

DEFINE TEMP-TABLE ttCustomer NO-UNDO BEFORE-TABLE btCustomer
    FIELD CustNum AS INTEGER FORMAT ">>>>9" LABEL "Cust Num"
    FIELD Country AS CHARACTER FORMAT "x(20)" LABEL "Country"
    FIELD Name AS CHARACTER FORMAT "x(30)" LABEL "Name"
    FIELD Address AS CHARACTER FORMAT "x(35)" LABEL "Address"
    FIELD Address2 AS CHARACTER FORMAT "x(35)" LABEL "Address2"
    FIELD City AS CHARACTER FORMAT "x(25)" LABEL "City"
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD PostalCode AS CHARACTER FORMAT "x(10)" LABEL "Postal Code"
    FIELD Contact AS CHARACTER FORMAT "x(30)" LABEL "Contact"
    FIELD Phone AS CHARACTER FORMAT "x(20)" LABEL "Phone"
    FIELD SalesRep AS CHARACTER FORMAT "x(4)" LABEL "Sales Rep"
    FIELD CreditLimit AS DECIMAL FORMAT "->,>>>,>>9" LABEL "Credit Limit" DECIMALS 2
    FIELD Balance AS DECIMAL FORMAT "->,>>>,>>9.99" LABEL "Balance" DECIMALS 2
    FIELD Terms AS CHARACTER FORMAT "x(20)" LABEL "Terms"
    FIELD Discount AS INTEGER FORMAT ">>9%" LABEL "Discount"
    FIELD Comments AS CHARACTER FORMAT "x(80)" LABEL "Comments"
    FIELD Fax AS CHARACTER FORMAT "x(20)" LABEL "Fax"
    FIELD EmailAddress AS CHARACTER FORMAT "x(50)" LABEL "Email"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX CustNum IS PRIMARY UNIQUE CustNum
    INDEX CountryPost Country PostalCode
    INDEX Name Name
    INDEX SalesRep SalesRep
    .

DEFINE TEMP-TABLE ttCustomerErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsCustomer FOR ttCustomer.

