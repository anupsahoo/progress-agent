/*------------------------------------------------------------------------
    File        : vacation_accrue.p
    Purpose     : Vacation and sick day accrual
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2004-03  kpo  new report column
 *  2010-08  ssp  Y2K date window
 *  2003-07  kpo  remove dead code
 *  2005-12  mab  fix rounding
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{hr-payroll/hr_defs.i}

DEFINE INPUT PARAMETER pEmpNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bEmployee FOR Employee.
DEFINE BUFFER bVacation FOR Vacation.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bEmployee EXCLUSIVE-LOCK WHERE bEmployee.EmpNum = pEmpNum NO-WAIT NO-ERROR.
    IF LOCKED bEmployee THEN DO:
        pcResult = "LOCKED: Employee in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bEmployee THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    FOR EACH bVacation EXCLUSIVE-LOCK
        WHERE bVacation.EmpNum = bEmployee.EmpNum:
        iTouched = iTouched + 1.
        CREATE ttWork.
        ASSIGN ttWork.SrcRow = ROWID(bVacation)
               ttWork.Action = "UPDATE".
    END.

    /* Never leave a negative Vacation Days Left behind */
    ASSIGN bEmployee.VacationDaysLeft = MAX(0, bEmployee.VacationDaysLeft).
    RUN shared/audit_log.p (INPUT "Employee", INPUT STRING(ROWID(bEmployee)), INPUT "vacation_accrue.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE map-employee-vacationdaysleft0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.VacationDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.VacationDaysLeft > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.VacationDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-employee-sickdaysleft3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bEmployee FOR Employee.
  FIND bEmployee WHERE ROWID(bEmployee) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bEmployee THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bEmployee.SickDaysLeft < 0 THEN plOk = NO.
    WHEN bEmployee.SickDaysLeft > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

