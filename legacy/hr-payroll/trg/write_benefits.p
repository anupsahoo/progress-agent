/*------------------------------------------------------------------------
    File        : write_benefits.p
    Purpose     : schema WRITE trigger for Benefits, field-level audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-01  kpo  new report column
 *  1999-04  kpo  new report column
 */

/* trg/write_benefits.p : schema WRITE trigger for Benefits, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Benefits OLD BUFFER oldBenefits.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN hr-payroll/benefits_val.p (INPUT ROWID(Benefits), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Benefits write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Benefits.EmpNum <> oldBenefits.EmpNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.EmpNum", INPUT STRING(oldBenefits.EmpNum), INPUT STRING(Benefits.EmpNum)).
END.
IF Benefits.HealthCare <> oldBenefits.HealthCare THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.HealthCare", INPUT STRING(oldBenefits.HealthCare), INPUT STRING(Benefits.HealthCare)).
END.
IF Benefits.LifeInsurance <> oldBenefits.LifeInsurance THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.LifeInsurance", INPUT STRING(oldBenefits.LifeInsurance), INPUT STRING(Benefits.LifeInsurance)).
END.
IF Benefits.Pension401K <> oldBenefits.Pension401K THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.Pension401K", INPUT STRING(oldBenefits.Pension401K), INPUT STRING(Benefits.Pension401K)).
END.
IF Benefits.StockPurchase <> oldBenefits.StockPurchase THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.StockPurchase", INPUT STRING(oldBenefits.StockPurchase), INPUT STRING(Benefits.StockPurchase)).
END.
IF Benefits.MedicalSpending <> oldBenefits.MedicalSpending THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.MedicalSpending", INPUT STRING(oldBenefits.MedicalSpending), INPUT STRING(Benefits.MedicalSpending)).
END.
IF Benefits.DependentCare <> oldBenefits.DependentCare THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Benefits.DependentCare", INPUT STRING(oldBenefits.DependentCare), INPUT STRING(Benefits.DependentCare)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/benefits.q") APPEND.
  EXPORT "Benefits" "W" STRING(NOW) Benefits.EmpNum.
  OUTPUT CLOSE.
END.

