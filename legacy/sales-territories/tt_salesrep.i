/*------------------------------------------------------------------------
    File        : tt_salesrep.i
    Purpose     : temp-table and dataset for Salesrep (AppServer transport)
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-11  ssp  add lock retry
 *  2012-06  ssp  credit hold rule
 *  2001-06  kpo  appserver split
 */

/* tt_salesrep.i : temp-table and dataset for Salesrep (AppServer transport) */

DEFINE TEMP-TABLE ttSalesrep NO-UNDO BEFORE-TABLE btSalesrep
    FIELD SalesRep AS CHARACTER FORMAT "x(4)" LABEL "Sales Rep"
    FIELD RepName AS CHARACTER FORMAT "x(30)" LABEL "Rep Name"
    FIELD Region AS CHARACTER FORMAT "x(8)" LABEL "Region"
    FIELD MonthQuota AS INTEGER EXTENT 12 FORMAT "->,>>>,>>9" LABEL "Month Quota"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX SalesRep IS PRIMARY UNIQUE SalesRep
    .

DEFINE TEMP-TABLE ttSalesrepErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsSalesrep FOR ttSalesrep.

