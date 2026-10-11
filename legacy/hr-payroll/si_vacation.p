/*------------------------------------------------------------------------
    File        : si_vacation.p
    Purpose     : AppServer service interface for Vacation
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{hr-payroll/tt_vacation.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsVacation.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcVacation FOR Vacation.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttVacation:ATTACH-DATA-SOURCE(DATA-SOURCE srcVacation:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcVacation:FILL-WHERE-STRING = pcWhere.
    DATASET dsVacation:FILL().
    BUFFER ttVacation:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttVacation:ATTACH-DATA-SOURCE(DATA-SOURCE srcVacation:HANDLE).
    FOR EACH btVacation:
      BUFFER btVacation:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btVacation:ERROR THEN pcError = pcError + BUFFER btVacation:ERROR-STRING + "~n".
    END.
    BUFFER ttVacation:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttVacation:
      FIND FIRST Vacation EXCLUSIVE-LOCK WHERE Vacation.EmpNum = ttVacation.EmpNum AND Vacation.StartDate = ttVacation.StartDate NO-WAIT NO-ERROR.
      IF LOCKED Vacation THEN DO:
        pcError = pcError + "Vacation is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Vacation THEN DELETE Vacation.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Vacation:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Vacation NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_vacation " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

