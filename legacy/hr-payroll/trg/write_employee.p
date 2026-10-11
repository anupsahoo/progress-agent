/*------------------------------------------------------------------------
    File        : write_employee.p
    Purpose     : schema WRITE trigger for Employee, field-level audit
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-11  mab  appserver split
 *  2008-04  tlw  performance: use index
 *  2001-04  jkm  appserver split
 *  2005-08  tlw  new report column
 *  2001-03  jkm  fix rounding
 */

/* trg/write_employee.p : schema WRITE trigger for Employee, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Employee OLD BUFFER oldEmployee.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN hr-payroll/employee_val.p (INPUT ROWID(Employee), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Employee write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Employee.EmpNum <> oldEmployee.EmpNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.EmpNum", INPUT STRING(oldEmployee.EmpNum), INPUT STRING(Employee.EmpNum)).
END.
IF Employee.LastName <> oldEmployee.LastName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.LastName", INPUT STRING(oldEmployee.LastName), INPUT STRING(Employee.LastName)).
END.
IF Employee.FirstName <> oldEmployee.FirstName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.FirstName", INPUT STRING(oldEmployee.FirstName), INPUT STRING(Employee.FirstName)).
END.
IF Employee.Address <> oldEmployee.Address THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.Address", INPUT STRING(oldEmployee.Address), INPUT STRING(Employee.Address)).
END.
IF Employee.Address2 <> oldEmployee.Address2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.Address2", INPUT STRING(oldEmployee.Address2), INPUT STRING(Employee.Address2)).
END.
IF Employee.City <> oldEmployee.City THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.City", INPUT STRING(oldEmployee.City), INPUT STRING(Employee.City)).
END.
IF Employee.State <> oldEmployee.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.State", INPUT STRING(oldEmployee.State), INPUT STRING(Employee.State)).
END.
IF Employee.PostalCode <> oldEmployee.PostalCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.PostalCode", INPUT STRING(oldEmployee.PostalCode), INPUT STRING(Employee.PostalCode)).
END.
IF Employee.HomePhone <> oldEmployee.HomePhone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.HomePhone", INPUT STRING(oldEmployee.HomePhone), INPUT STRING(Employee.HomePhone)).
END.
IF Employee.WorkPhone <> oldEmployee.WorkPhone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.WorkPhone", INPUT STRING(oldEmployee.WorkPhone), INPUT STRING(Employee.WorkPhone)).
END.
IF Employee.DeptCode <> oldEmployee.DeptCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.DeptCode", INPUT STRING(oldEmployee.DeptCode), INPUT STRING(Employee.DeptCode)).
END.
IF Employee.Position <> oldEmployee.Position THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.Position", INPUT STRING(oldEmployee.Position), INPUT STRING(Employee.Position)).
END.
IF Employee.Birthdate <> oldEmployee.Birthdate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.Birthdate", INPUT STRING(oldEmployee.Birthdate), INPUT STRING(Employee.Birthdate)).
END.
IF Employee.StartDate <> oldEmployee.StartDate THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.StartDate", INPUT STRING(oldEmployee.StartDate), INPUT STRING(Employee.StartDate)).
END.
IF Employee.VacationDaysLeft <> oldEmployee.VacationDaysLeft THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.VacationDaysLeft", INPUT STRING(oldEmployee.VacationDaysLeft), INPUT STRING(Employee.VacationDaysLeft)).
END.
IF Employee.SickDaysLeft <> oldEmployee.SickDaysLeft THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Employee.SickDaysLeft", INPUT STRING(oldEmployee.SickDaysLeft), INPUT STRING(Employee.SickDaysLeft)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/employee.q") APPEND.
  EXPORT "Employee" "W" STRING(NOW) Employee.EmpNum.
  OUTPUT CLOSE.
END.

