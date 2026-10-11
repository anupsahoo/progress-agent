/*------------------------------------------------------------------------
    File        : w2_extract.p
    Purpose     : Year-end tax extract
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-11  ssp  audit fields
 */

{shared/sysdefs.i}
{hr-payroll/tt_employee.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/w2_extract_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH Employee NO-LOCK:
    CREATE ttEmployee.
    BUFFER-COPY Employee TO ttEmployee.
    iRecs = iRecs + 1.
END.

DATASET dsEmployee:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=Employee" SKIP "FIELDS=EmpNum,LastName,FirstName,Address,Address2,City,State,PostalCode,HomePhone,WorkPhone,DeptCode,Position,Birthdate,StartDate,VacationDaysLeft,SickDaysLeft" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "w2_extract.p: " + STRING(iRecs) + " records written").

PROCEDURE map-employee-sickdaysleft0 :
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
    WHEN bEmployee.SickDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-employee-sickdaysleft1 :
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
    WHEN bEmployee.SickDaysLeft > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Employee.SickDaysLeft above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-employee-vacationdaysleft2 :
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

PROCEDURE reset-employee-vacationdaysleft3 :
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

