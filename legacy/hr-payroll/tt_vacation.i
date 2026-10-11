/*------------------------------------------------------------------------
    File        : tt_vacation.i
    Purpose     : temp-table and dataset for Vacation (AppServer transport)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-12  jkm  add lock retry
 *  2001-05  tlw  appserver split
 *  2016-07  mab  new report column
 *  2001-06  rdh  Y2K date window
 *  2013-04  mab  new report column
 */

/* tt_vacation.i : temp-table and dataset for Vacation (AppServer transport) */

DEFINE TEMP-TABLE ttVacation NO-UNDO BEFORE-TABLE btVacation
    FIELD EmpNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Emp No"
    FIELD StartDate AS DATE FORMAT "99/99/9999" LABEL "Start Date"
    FIELD EndDate AS DATE FORMAT "99/99/9999" LABEL "End Date"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX EmpNoStartDate IS PRIMARY UNIQUE EmpNum StartDate
    .

DEFINE TEMP-TABLE ttVacationErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsVacation FOR ttVacation.

