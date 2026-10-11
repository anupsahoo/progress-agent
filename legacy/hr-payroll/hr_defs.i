/*------------------------------------------------------------------------
    File        : hr_defs.i
    Purpose     : HR & Payroll shared definitions
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-04  jkm  audit fields
 *  2009-04  mab  appserver split
 *  2006-12  mab  Y2K date window
 */

/* hr_defs.i : HR & Payroll shared definitions */

&GLOBAL-DEFINE MODULE-ID hr-payroll
&GLOBAL-DEFINE MODULE-NAME "HR & Payroll"

DEFINE NEW GLOBAL SHARED VARIABLE gHRPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gHRSite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE EMPLOYEE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE DEPARTMENT-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE BENEFITS-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE FAMILY-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE TIMESHEET-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE VACATION-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE EMPLOYEE-KEY EmpNum
&GLOBAL-DEFINE EMPLOYEE-FIELDS EmpNum LastName FirstName Address Address2 City State PostalCode HomePhone WorkPhone DeptCode Position Birthdate StartDate VacationDaysLeft SickDaysLeft
&GLOBAL-DEFINE DEPARTMENT-KEY DeptCode
&GLOBAL-DEFINE DEPARTMENT-FIELDS DeptCode DeptName
&GLOBAL-DEFINE BENEFITS-KEY EmpNum
&GLOBAL-DEFINE BENEFITS-FIELDS EmpNum HealthCare LifeInsurance Pension401K StockPurchase MedicalSpending DependentCare
&GLOBAL-DEFINE FAMILY-KEY EmpNum RelativeName
&GLOBAL-DEFINE FAMILY-FIELDS EmpNum RelativeName Relation Birthdate CoveredOnBenefits BenefitDate
&GLOBAL-DEFINE TIMESHEET-KEY EmpNum DayRecorded
&GLOBAL-DEFINE TIMESHEET-FIELDS EmpNum DayRecorded TypeRecorded AMTimeIn AMTimeOut PMTimeIn PMTimeOut RegularHours OvertimeHours
&GLOBAL-DEFINE VACATION-KEY EmpNum StartDate
&GLOBAL-DEFINE VACATION-FIELDS EmpNum StartDate EndDate

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

