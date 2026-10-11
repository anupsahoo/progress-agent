/*------------------------------------------------------------------------
    File        : employee_batch.p
    Purpose     : Nightly Employee housekeeping
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-10  ssp  performance: use index
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "employee_batch.log") APPEND.
PUT UNFORMATTED "Employee batch started " STRING(NOW) SKIP.

FOR EACH Employee EXCLUSIVE-LOCK
    WHERE Employee.Birthdate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Employee.VacationDaysLeft < 0 THEN DO:
        PUT UNFORMATTED "Negative Vacation Days Left on " STRING(Employee.EmpNum) SKIP.
        ASSIGN Employee.VacationDaysLeft = 0 iChanged = iChanged + 1.
    END.
    IF Employee.LastName <> TRIM(Employee.LastName) THEN
        ASSIGN Employee.LastName = TRIM(Employee.LastName) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Employee batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

