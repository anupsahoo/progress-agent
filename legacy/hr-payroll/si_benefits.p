/*------------------------------------------------------------------------
    File        : si_benefits.p
    Purpose     : AppServer service interface for Benefits
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

{hr-payroll/tt_benefits.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsBenefits.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcBenefits FOR Benefits.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttBenefits:ATTACH-DATA-SOURCE(DATA-SOURCE srcBenefits:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcBenefits:FILL-WHERE-STRING = pcWhere.
    DATASET dsBenefits:FILL().
    BUFFER ttBenefits:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttBenefits:ATTACH-DATA-SOURCE(DATA-SOURCE srcBenefits:HANDLE).
    FOR EACH btBenefits:
      BUFFER btBenefits:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btBenefits:ERROR THEN pcError = pcError + BUFFER btBenefits:ERROR-STRING + "~n".
    END.
    BUFFER ttBenefits:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttBenefits:
      FIND FIRST Benefits EXCLUSIVE-LOCK WHERE Benefits.EmpNum = ttBenefits.EmpNum NO-WAIT NO-ERROR.
      IF LOCKED Benefits THEN DO:
        pcError = pcError + "Benefits is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Benefits THEN DELETE Benefits.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Benefits:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Benefits NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_benefits " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

