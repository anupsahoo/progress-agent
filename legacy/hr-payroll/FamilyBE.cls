/*------------------------------------------------------------------------
    File        : FamilyBE.cls
    Purpose     : business entity for Family (OpenEdge 11 OO ABL)
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-12  rdh  appserver split
 */

/* FamilyBE.cls : business entity for Family (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS HR.FamilyBE:

  DEFINE PUBLIC PROPERTY EmpNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY RelativeName AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Relation AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Birthdate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CoveredOnBenefits AS LOGICAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY BenefitDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC FamilyBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pEmpNum AS INTEGER, INPUT pRelativeName AS CHARACTER):
    FIND FIRST Family NO-LOCK WHERE Family.EmpNum = pEmpNum AND Family.RelativeName = pRelativeName NO-ERROR.
    IF NOT AVAILABLE Family THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:EmpNum = Family.EmpNum
           THIS-OBJECT:RelativeName = Family.RelativeName
           THIS-OBJECT:Relation = Family.Relation
           THIS-OBJECT:Birthdate = Family.Birthdate
           THIS-OBJECT:CoveredOnBenefits = Family.CoveredOnBenefits
           THIS-OBJECT:BenefitDate = Family.BenefitDate
           rRow = ROWID(Family) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:EmpNum = 0 THEN cErr = cErr + "Emp No is required.~n".
    IF THIS-OBJECT:RelativeName = "" THEN cErr = cErr + "Relative Name is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Family.
      ELSE FIND Family WHERE ROWID(Family) = rRow EXCLUSIVE-LOCK.
      ASSIGN Family.EmpNum = THIS-OBJECT:EmpNum
             Family.RelativeName = THIS-OBJECT:RelativeName
             Family.Relation = THIS-OBJECT:Relation
             Family.Birthdate = THIS-OBJECT:Birthdate
             Family.CoveredOnBenefits = THIS-OBJECT:CoveredOnBenefits
             Family.BenefitDate = THIS-OBJECT:BenefitDate.
      rRow = ROWID(Family).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Family WHERE ROWID(Family) = rRow EXCLUSIVE-LOCK.
      DELETE Family.
    END.
  END METHOD.

END CLASS.

