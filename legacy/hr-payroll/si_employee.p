/*------------------------------------------------------------------------
    File        : si_employee.p
    Purpose     : AppServer service interface for Employee
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{hr-payroll/tt_employee.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsEmployee.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcEmployee FOR Employee.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttEmployee:ATTACH-DATA-SOURCE(DATA-SOURCE srcEmployee:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcEmployee:FILL-WHERE-STRING = pcWhere.
    DATASET dsEmployee:FILL().
    BUFFER ttEmployee:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttEmployee:ATTACH-DATA-SOURCE(DATA-SOURCE srcEmployee:HANDLE).
    FOR EACH btEmployee:
      BUFFER btEmployee:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btEmployee:ERROR THEN pcError = pcError + BUFFER btEmployee:ERROR-STRING + "~n".
    END.
    BUFFER ttEmployee:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttEmployee:
      FIND FIRST Employee EXCLUSIVE-LOCK WHERE Employee.EmpNum = ttEmployee.EmpNum NO-WAIT NO-ERROR.
      IF LOCKED Employee THEN DO:
        pcError = pcError + "Employee is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Employee THEN DELETE Employee.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Employee:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Employee NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_employee " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

