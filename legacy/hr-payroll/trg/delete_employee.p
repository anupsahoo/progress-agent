/*------------------------------------------------------------------------
    File        : delete_employee.p
    Purpose     : schema DELETE trigger for Employee, referential integrity
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2005-10  rdh  audit fields
 *  2011-06  tlw  performance: use index
 *  2004-12  ssp  remove dead code
 *  2012-03  tlw  add lock retry
 */

/* trg/delete_employee.p : schema DELETE trigger for Employee, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Employee.

{shared/sysdefs.i}

IF CAN-FIND(FIRST Benefits WHERE Benefits.EmpNum = Employee.EmpNum) THEN DO:
  MESSAGE "Cannot delete Employee: Benefits records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Family WHERE Family.EmpNum = Employee.EmpNum) THEN DO:
  MESSAGE "Cannot delete Employee: Family records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST TimeSheet WHERE TimeSheet.EmpNum = Employee.EmpNum) THEN DO:
  MESSAGE "Cannot delete Employee: TimeSheet records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Vacation WHERE Vacation.EmpNum = Employee.EmpNum) THEN DO:
  MESSAGE "Cannot delete Employee: Vacation records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/employee_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Employee.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Employee by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/employee.q") APPEND.
EXPORT "Employee" "D" STRING(NOW) Employee.EmpNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Employee", INPUT STRING(ROWID(Employee)), INPUT "DELETE").

