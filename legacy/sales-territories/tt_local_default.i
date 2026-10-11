/*------------------------------------------------------------------------
    File        : tt_local_default.i
    Purpose     : temp-table and dataset for LocalDefault (AppServer transport)
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-05  kpo  audit fields
 *  2012-05  kpo  audit fields
 *  2008-06  kpo  new report column
 *  2004-02  ssp  add lock retry
 *  2012-04  rdh  credit hold rule
 */

/* tt_local_default.i : temp-table and dataset for LocalDefault (AppServer transport) */

DEFINE TEMP-TABLE ttLocalDefault NO-UNDO BEFORE-TABLE btLocalDefault
    FIELD Country AS CHARACTER FORMAT "x(20)" LABEL "Country"
    FIELD Region1Label AS CHARACTER FORMAT "x(15)" LABEL "Region1 Label"
    FIELD Region2Label AS CHARACTER FORMAT "x(15)" LABEL "Region2 Label"
    FIELD PostalLabel AS CHARACTER FORMAT "x(15)" LABEL "Postal Label"
    FIELD PostalFormat AS CHARACTER FORMAT "x(15)" LABEL "Postal Format"
    FIELD TelFormat AS CHARACTER FORMAT "x(15)" LABEL "Tel Format"
    FIELD CurrencySymbol AS CHARACTER FORMAT "x(6)" LABEL "Currency Symbol"
    FIELD DateFormat AS CHARACTER FORMAT "x(8)" LABEL "Date Format"
    FIELD LocalDefNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Local Default Num"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX localdefnum IS PRIMARY UNIQUE LocalDefNum
    .

DEFINE TEMP-TABLE ttLocalDefaultErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsLocalDefault FOR ttLocalDefault.

