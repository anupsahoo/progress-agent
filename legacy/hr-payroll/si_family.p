/*------------------------------------------------------------------------
    File        : si_family.p
    Purpose     : AppServer service interface for Family
    Module      : HR & Payroll
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

{hr-payroll/tt_family.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsFamily.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcFamily FOR Family.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttFamily:ATTACH-DATA-SOURCE(DATA-SOURCE srcFamily:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcFamily:FILL-WHERE-STRING = pcWhere.
    DATASET dsFamily:FILL().
    BUFFER ttFamily:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttFamily:ATTACH-DATA-SOURCE(DATA-SOURCE srcFamily:HANDLE).
    FOR EACH btFamily:
      BUFFER btFamily:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btFamily:ERROR THEN pcError = pcError + BUFFER btFamily:ERROR-STRING + "~n".
    END.
    BUFFER ttFamily:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttFamily:
      FIND FIRST Family EXCLUSIVE-LOCK WHERE Family.EmpNum = ttFamily.EmpNum AND Family.RelativeName = ttFamily.RelativeName NO-WAIT NO-ERROR.
      IF LOCKED Family THEN DO:
        pcError = pcError + "Family is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Family THEN DELETE Family.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Family:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Family NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_family " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

