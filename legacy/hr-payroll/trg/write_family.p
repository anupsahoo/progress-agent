/*------------------------------------------------------------------------
    File        : write_family.p
    Purpose     : schema WRITE trigger for Family, field-level audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-01  mab  fix rounding
 *  2013-11  tlw  fix rounding
 *  2004-12  mab  Y2K date window
 */

/* trg/write_family.p : schema WRITE trigger for Family, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Family OLD BUFFER oldFamily.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN hr-payroll/family_val.p (INPUT ROWID(Family), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Family write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Family.EmpNum <> oldFamily.EmpNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Family.EmpNum", INPUT STRING(oldFamily.EmpNum), INPUT STRING(Family.EmpNum)).
END.
IF Family.RelativeName <> oldFamily.RelativeName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Family.RelativeName", INPUT STRING(oldFamily.RelativeName), INPUT STRING(Family.RelativeName)).
END.
IF Family.Relation <> oldFamily.Relation THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Family.Relation", INPUT STRING(oldFamily.Relation), INPUT STRING(Family.Relation)).
END.
IF Family.Birthdate <> oldFamily.Birthdate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Family.Birthdate", INPUT STRING(oldFamily.Birthdate), INPUT STRING(Family.Birthdate)).
END.
IF Family.CoveredOnBenefits <> oldFamily.CoveredOnBenefits THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Family.CoveredOnBenefits", INPUT STRING(oldFamily.CoveredOnBenefits), INPUT STRING(Family.CoveredOnBenefits)).
END.
IF Family.BenefitDate <> oldFamily.BenefitDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Family.BenefitDate", INPUT STRING(oldFamily.BenefitDate), INPUT STRING(Family.BenefitDate)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/family.q") APPEND.
  EXPORT "Family" "W" STRING(NOW) Family.EmpNum Family.RelativeName.
  OUTPUT CLOSE.
END.

