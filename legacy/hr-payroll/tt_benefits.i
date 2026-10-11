/*------------------------------------------------------------------------
    File        : tt_benefits.i
    Purpose     : temp-table and dataset for Benefits (AppServer transport)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-08  mab  appserver split
 *  2005-11  ssp  add lock retry
 */

/* tt_benefits.i : temp-table and dataset for Benefits (AppServer transport) */

DEFINE TEMP-TABLE ttBenefits NO-UNDO BEFORE-TABLE btBenefits
    FIELD EmpNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Emp No"
    FIELD HealthCare AS CHARACTER FORMAT "x(8)" LABEL "Health Care"
    FIELD LifeInsurance AS INTEGER FORMAT "$>>,>>>,>>>" LABEL "Life Insurance"
    FIELD Pension401K AS INTEGER FORMAT ">>,>>9" LABEL "Pension401K"
    FIELD StockPurchase AS INTEGER FORMAT ">>,>>9" LABEL "Stock Purchase"
    FIELD MedicalSpending AS INTEGER FORMAT ">>,>>9" LABEL "Medical Spending"
    FIELD DependentCare AS INTEGER FORMAT ">>,>>9" LABEL "Dependent Care"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX EmpNo IS PRIMARY UNIQUE EmpNum
    .

DEFINE TEMP-TABLE ttBenefitsErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE TEMP-TABLE ttFamilyRef NO-UNDO LIKE Family.

DEFINE DATASET dsBenefits FOR ttBenefits, ttFamilyRef
    DATA-RELATION rBenefitsFamily FOR ttBenefits, ttFamilyRef
        RELATION-FIELDS (EmpNum, EmpNum) NESTED.

