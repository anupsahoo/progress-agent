/*------------------------------------------------------------------------
    File        : tt_employee.i
    Purpose     : temp-table and dataset for Employee (AppServer transport)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-07  rdh  performance: use index
 *  2002-11  rdh  audit fields
 *  2004-10  rdh  appserver split
 *  2016-09  tlw  new report column
 */

/* tt_employee.i : temp-table and dataset for Employee (AppServer transport) */

DEFINE TEMP-TABLE ttEmployee NO-UNDO BEFORE-TABLE btEmployee
    FIELD EmpNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Emp No"
    FIELD LastName AS CHARACTER FORMAT "x(25)" LABEL "Last Name"
    FIELD FirstName AS CHARACTER FORMAT "x(15)" LABEL "First Name"
    FIELD Address AS CHARACTER FORMAT "x(35)" LABEL "Address"
    FIELD Address2 AS CHARACTER FORMAT "x(35)" LABEL "Address2"
    FIELD City AS CHARACTER FORMAT "x(25)" LABEL "City"
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD PostalCode AS CHARACTER FORMAT "x(10)" LABEL "Postal Code"
    FIELD HomePhone AS CHARACTER FORMAT "x(20)" LABEL "Home Phone"
    FIELD WorkPhone AS CHARACTER FORMAT "x(20)" LABEL "Work Phone"
    FIELD DeptCode AS CHARACTER FORMAT "x(3)" LABEL "Dept Code"
    FIELD Position AS CHARACTER FORMAT "x(20)" LABEL "Position"
    FIELD Birthdate AS DATE FORMAT "99/99/9999" LABEL "Birthdate"
    FIELD StartDate AS DATE FORMAT "99/99/9999" LABEL "Start Date"
    FIELD VacationDaysLeft AS INTEGER FORMAT ">>9" LABEL "Vacation Days Left"
    FIELD SickDaysLeft AS INTEGER FORMAT ">>9" LABEL "Sick Days Left"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX EmpNo IS PRIMARY UNIQUE EmpNum
    INDEX DeptCode DeptCode
    INDEX Name UNIQUE LastName FirstName
    .

DEFINE TEMP-TABLE ttEmployeeErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE TEMP-TABLE ttFamilyRef NO-UNDO LIKE Family.

DEFINE DATASET dsEmployee FOR ttEmployee, ttFamilyRef
    DATA-RELATION rEmployeeFamily FOR ttEmployee, ttFamilyRef
        RELATION-FIELDS (EmpNum, EmpNum) NESTED.

