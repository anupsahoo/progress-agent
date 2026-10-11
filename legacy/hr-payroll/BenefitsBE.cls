/*------------------------------------------------------------------------
    File        : BenefitsBE.cls
    Purpose     : business entity for Benefits (OpenEdge 11 OO ABL)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2001-04  tlw  remove dead code
 *  2014-11  tlw  credit hold rule
 *  2002-03  tlw  fix rounding
 *  2017-03  jkm  remove dead code
 */

/* BenefitsBE.cls : business entity for Benefits (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS HR.BenefitsBE:

  DEFINE PUBLIC PROPERTY EmpNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY HealthCare AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY LifeInsurance AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Pension401K AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY StockPurchase AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY MedicalSpending AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY DependentCare AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC BenefitsBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pEmpNum AS INTEGER):
    FIND FIRST Benefits NO-LOCK WHERE Benefits.EmpNum = pEmpNum NO-ERROR.
    IF NOT AVAILABLE Benefits THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:EmpNum = Benefits.EmpNum
           THIS-OBJECT:HealthCare = Benefits.HealthCare
           THIS-OBJECT:LifeInsurance = Benefits.LifeInsurance
           THIS-OBJECT:Pension401K = Benefits.Pension401K
           THIS-OBJECT:StockPurchase = Benefits.StockPurchase
           THIS-OBJECT:MedicalSpending = Benefits.MedicalSpending
           THIS-OBJECT:DependentCare = Benefits.DependentCare
           rRow = ROWID(Benefits) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:EmpNum = 0 THEN cErr = cErr + "Emp No is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Benefits.
      ELSE FIND Benefits WHERE ROWID(Benefits) = rRow EXCLUSIVE-LOCK.
      ASSIGN Benefits.EmpNum = THIS-OBJECT:EmpNum
             Benefits.HealthCare = THIS-OBJECT:HealthCare
             Benefits.LifeInsurance = THIS-OBJECT:LifeInsurance
             Benefits.Pension401K = THIS-OBJECT:Pension401K
             Benefits.StockPurchase = THIS-OBJECT:StockPurchase
             Benefits.MedicalSpending = THIS-OBJECT:MedicalSpending
             Benefits.DependentCare = THIS-OBJECT:DependentCare.
      rRow = ROWID(Benefits).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Benefits WHERE ROWID(Benefits) = rRow EXCLUSIVE-LOCK.
      DELETE Benefits.
    END.
  END METHOD.

END CLASS.

