/*------------------------------------------------------------------------
    File        : tt_family.i
    Purpose     : temp-table and dataset for Family (AppServer transport)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-01  ssp  fix rounding
 *  2008-01  rdh  appserver split
 */

/* tt_family.i : temp-table and dataset for Family (AppServer transport) */

DEFINE TEMP-TABLE ttFamily NO-UNDO BEFORE-TABLE btFamily
    FIELD EmpNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Emp No"
    FIELD RelativeName AS CHARACTER FORMAT "x(15)" LABEL "Relative Name"
    FIELD Relation AS CHARACTER FORMAT "x(15)" LABEL "Relation"
    FIELD Birthdate AS DATE FORMAT "99/99/9999" LABEL "Birthdate"
    FIELD CoveredOnBenefits AS LOGICAL FORMAT "yes/no" LABEL "Covered On Benefits"
    FIELD BenefitDate AS DATE FORMAT "99/99/9999" LABEL "Benefit Date"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX EmpNoRelativeName IS PRIMARY UNIQUE EmpNum RelativeName
    .

DEFINE TEMP-TABLE ttFamilyErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsFamily FOR ttFamily.

