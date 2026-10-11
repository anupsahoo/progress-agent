/*------------------------------------------------------------------------
    File        : write_department.p
    Purpose     : schema WRITE trigger for Department, field-level audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-05  jkm  performance: use index
 *  2009-10  jkm  fix rounding
 *  2010-06  tlw  audit fields
 *  2000-01  kpo  performance: use index
 */

/* trg/write_department.p : schema WRITE trigger for Department, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Department OLD BUFFER oldDepartment.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN hr-payroll/department_val.p (INPUT ROWID(Department), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Department write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Department.DeptCode <> oldDepartment.DeptCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Department.DeptCode", INPUT STRING(oldDepartment.DeptCode), INPUT STRING(Department.DeptCode)).
END.
IF Department.DeptName <> oldDepartment.DeptName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Department.DeptName", INPUT STRING(oldDepartment.DeptName), INPUT STRING(Department.DeptName)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/department.q") APPEND.
  EXPORT "Department" "W" STRING(NOW) Department.DeptCode.
  OUTPUT CLOSE.
END.

