/*------------------------------------------------------------------------
    File        : tt_time_sheet.i
    Purpose     : temp-table and dataset for TimeSheet (AppServer transport)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-07  rdh  appserver split
 *  2014-08  kpo  audit fields
 *  2015-12  ssp  new report column
 *  2004-10  rdh  remove dead code
 */

/* tt_time_sheet.i : temp-table and dataset for TimeSheet (AppServer transport) */

DEFINE TEMP-TABLE ttTimeSheet NO-UNDO BEFORE-TABLE btTimeSheet
    FIELD EmpNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Emp No"
    FIELD DayRecorded AS DATE FORMAT "99/99/9999" LABEL "Day Recorded"
    FIELD TypeRecorded AS CHARACTER FORMAT "x(8)" LABEL "Type Recorded"
    FIELD AMTimeIn AS CHARACTER FORMAT "xx:xx" LABEL "AM Time In"
    FIELD AMTimeOut AS CHARACTER FORMAT "xx:xx" LABEL "AM Time Out"
    FIELD PMTimeIn AS CHARACTER FORMAT "xx:xx" LABEL "PM Time In"
    FIELD PMTimeOut AS CHARACTER FORMAT "xx:xx" LABEL "PM Time Out"
    FIELD RegularHours AS DECIMAL FORMAT ">>9.<<" LABEL "Regular Hours" DECIMALS 2
    FIELD OvertimeHours AS DECIMAL FORMAT ">>9.<<" LABEL "Overtime Hours" DECIMALS 2
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX EmpNoDayRecorded IS PRIMARY UNIQUE EmpNum DayRecorded
    .

DEFINE TEMP-TABLE ttTimeSheetErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsTimeSheet FOR ttTimeSheet.

