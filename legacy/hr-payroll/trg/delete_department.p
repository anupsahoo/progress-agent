/*------------------------------------------------------------------------
    File        : delete_department.p
    Purpose     : schema DELETE trigger for Department, referential integrity
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-11  tlw  performance: use index
 *  2008-11  jkm  add lock retry
 *  2007-08  jkm  add lock retry
 *  2014-09  jkm  remove dead code
 */

/* trg/delete_department.p : schema DELETE trigger for Department, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Department.

{shared/sysdefs.i}

IF CAN-FIND(FIRST Employee WHERE Employee.DeptCode = Department.DeptCode) THEN DO:
  MESSAGE "Cannot delete Department: Employee records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/department_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Department.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Department by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/department.q") APPEND.
EXPORT "Department" "D" STRING(NOW) Department.DeptCode.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Department", INPUT STRING(ROWID(Department)), INPUT "DELETE").

