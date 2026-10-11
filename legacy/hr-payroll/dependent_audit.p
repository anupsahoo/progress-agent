/*------------------------------------------------------------------------
    File        : dependent_audit.p
    Purpose     : Dependent eligibility audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-02  jkm  add lock retry
 *  2009-08  mab  add lock retry
 *  1999-12  rdh  Y2K date window
 *  2004-07  kpo  new report column
 *  2003-09  mab  new report column
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{hr-payroll/hr_defs.i}

DEFINE INPUT PARAMETER pEmpNum AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pRelativeName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bFamily FOR Family.
DEFINE BUFFER bBenefits FOR Benefits.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bFamily EXCLUSIVE-LOCK WHERE bFamily.EmpNum = pEmpNum AND bFamily.RelativeName = pRelativeName NO-WAIT NO-ERROR.
    IF LOCKED bFamily THEN DO:
        pcResult = "LOCKED: Family in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bFamily THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bBenefits EXCLUSIVE-LOCK
        WHERE bBenefits.EmpNum = bFamily.EmpNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bBenefits)
               ttWork.Action = "UPDATE".
        IF bBenefits.LifeInsurance < 0 THEN DO:
            ttWork.Note = "negative Life Insurance".
            bBenefits.LifeInsurance = 0.
        END.
    END.

    RUN shared/audit_log.p (INPUT "Family", INPUT STRING(ROWID(bFamily)), INPUT "dependent_audit.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE apply-family-relation0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.Relation = "" OR bFamily.Relation = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.Relation is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.Relation) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-family-relativename1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.RelativeName = "" OR bFamily.RelativeName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.RelativeName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.RelativeName) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-benefits-dependentcare2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBenefits FOR Benefits.
  FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBenefits THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBenefits.DependentCare < 0 THEN plOk = NO.
    WHEN bBenefits.DependentCare > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Benefits.DependentCare above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-benefits-medicalspending3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBenefits FOR Benefits.
  FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBenefits THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBenefits.MedicalSpending < 0 THEN plOk = NO.
    WHEN bBenefits.MedicalSpending > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Benefits.MedicalSpending above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-benefits-lifeinsurance4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBenefits FOR Benefits.
  FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBenefits THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBenefits.LifeInsurance < 0 THEN plOk = NO.
    WHEN bBenefits.LifeInsurance > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Benefits.LifeInsurance above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-benefits-stockpurchase5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBenefits FOR Benefits.
  FIND bBenefits WHERE ROWID(bBenefits) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBenefits THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBenefits.StockPurchase < 0 THEN plOk = NO.
    WHEN bBenefits.StockPurchase > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Benefits.StockPurchase above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-family-relation6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.Relation = "" OR bFamily.Relation = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.Relation is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.Relation) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-family-relation7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.Relation = "" OR bFamily.Relation = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.Relation is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.Relation) > 15 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-family-relativename8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bFamily FOR Family.
  FIND bFamily WHERE ROWID(bFamily) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bFamily THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bFamily.RelativeName = "" OR bFamily.RelativeName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Family.RelativeName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bFamily.RelativeName) > 15 THEN plOk = NO.
END PROCEDURE.

