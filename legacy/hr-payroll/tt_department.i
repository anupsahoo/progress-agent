/*------------------------------------------------------------------------
    File        : tt_department.i
    Purpose     : temp-table and dataset for Department (AppServer transport)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-05  rdh  credit hold rule
 *  2011-05  tlw  appserver split
 */

/* tt_department.i : temp-table and dataset for Department (AppServer transport) */

DEFINE TEMP-TABLE ttDepartment NO-UNDO BEFORE-TABLE btDepartment
    FIELD DeptCode AS CHARACTER FORMAT "x(3)" LABEL "Dept Code"
    FIELD DeptName AS CHARACTER FORMAT "x(15)" LABEL "Dept Name"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX DeptCode IS PRIMARY UNIQUE DeptCode
    .

DEFINE TEMP-TABLE ttDepartmentErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsDepartment FOR ttDepartment.

