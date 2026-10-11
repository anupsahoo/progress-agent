/*------------------------------------------------------------------------
    File        : si_department.p
    Purpose     : AppServer service interface for Department
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{hr-payroll/tt_department.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsDepartment.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcDepartment FOR Department.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttDepartment:ATTACH-DATA-SOURCE(DATA-SOURCE srcDepartment:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcDepartment:FILL-WHERE-STRING = pcWhere.
    DATASET dsDepartment:FILL().
    BUFFER ttDepartment:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttDepartment:ATTACH-DATA-SOURCE(DATA-SOURCE srcDepartment:HANDLE).
    FOR EACH btDepartment:
      BUFFER btDepartment:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btDepartment:ERROR THEN pcError = pcError + BUFFER btDepartment:ERROR-STRING + "~n".
    END.
    BUFFER ttDepartment:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttDepartment:
      FIND FIRST Department EXCLUSIVE-LOCK WHERE Department.DeptCode = ttDepartment.DeptCode NO-WAIT NO-ERROR.
      IF LOCKED Department THEN DO:
        pcError = pcError + "Department is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Department THEN DELETE Department.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Department:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Department NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_department " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

