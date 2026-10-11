/*------------------------------------------------------------------------
    File        : tt_ship_to.i
    Purpose     : temp-table and dataset for ShipTo (AppServer transport)
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-04  mab  remove dead code
 *  2005-08  tlw  credit hold rule
 *  2003-03  mab  Y2K date window
 */

/* tt_ship_to.i : temp-table and dataset for ShipTo (AppServer transport) */

DEFINE TEMP-TABLE ttShipTo NO-UNDO BEFORE-TABLE btShipTo
    FIELD CustNum AS INTEGER FORMAT ">>>>9" LABEL "Cust Num"
    FIELD ShipToID AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Ship To ID"
    FIELD Contact AS CHARACTER FORMAT "x(30)" LABEL "Contact"
    FIELD Address AS CHARACTER FORMAT "x(35)" LABEL "Address"
    FIELD Address2 AS CHARACTER FORMAT "x(35)" LABEL "Address2"
    FIELD City AS CHARACTER FORMAT "x(25)" LABEL "City"
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD PostalCode AS CHARACTER FORMAT "x(10)" LABEL "Postal Code"
    FIELD Phone AS CHARACTER FORMAT "x(20)" LABEL "Phone"
    FIELD Comments AS CHARACTER FORMAT "x(80)" LABEL "Comments"
    FIELD Name AS CHARACTER FORMAT "x(30)" LABEL "Name"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX custnumshipto IS PRIMARY UNIQUE CustNum ShipToID
    .

DEFINE TEMP-TABLE ttShipToErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsShipTo FOR ttShipTo.

