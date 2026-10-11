/*------------------------------------------------------------------------
    File        : tt_ref_call.i
    Purpose     : temp-table and dataset for RefCall (AppServer transport)
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-08  kpo  performance: use index
 *  2014-09  rdh  add lock retry
 */

/* tt_ref_call.i : temp-table and dataset for RefCall (AppServer transport) */

DEFINE TEMP-TABLE ttRefCall NO-UNDO BEFORE-TABLE btRefCall
    FIELD CallNum AS CHARACTER FORMAT "x(6)" LABEL "Call Num"
    FIELD CustNum AS INTEGER FORMAT ">>>>9" LABEL "Cust Num"
    FIELD CallDate AS DATE FORMAT "99/99/9999" LABEL "Call Date"
    FIELD SalesRep AS CHARACTER FORMAT "x(4)" LABEL "Sales Rep"
    FIELD Parent AS CHARACTER FORMAT "x(6)" LABEL "Parent"
    FIELD Txt AS CHARACTER FORMAT "x(300)" LABEL "Txt"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX CallNum IS PRIMARY UNIQUE CallNum
    INDEX CustNum UNIQUE CustNum CallNum
    INDEX Sibling UNIQUE Parent CallNum
    .

DEFINE TEMP-TABLE ttRefCallErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsRefCall FOR ttRefCall.

