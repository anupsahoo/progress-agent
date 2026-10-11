/*------------------------------------------------------------------------
    File        : si_supplier.p
    Purpose     : AppServer service interface for Supplier
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

{supplier-management/tt_supplier.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsSupplier.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcSupplier FOR Supplier.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttSupplier:ATTACH-DATA-SOURCE(DATA-SOURCE srcSupplier:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcSupplier:FILL-WHERE-STRING = pcWhere.
    DATASET dsSupplier:FILL().
    BUFFER ttSupplier:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttSupplier:ATTACH-DATA-SOURCE(DATA-SOURCE srcSupplier:HANDLE).
    FOR EACH btSupplier:
      BUFFER btSupplier:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btSupplier:ERROR THEN pcError = pcError + BUFFER btSupplier:ERROR-STRING + "~n".
    END.
    BUFFER ttSupplier:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttSupplier:
      FIND FIRST Supplier EXCLUSIVE-LOCK WHERE Supplier.SupplierIDNum = ttSupplier.SupplierIDNum NO-WAIT NO-ERROR.
      IF LOCKED Supplier THEN DO:
        pcError = pcError + "Supplier is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Supplier THEN DELETE Supplier.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Supplier:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Supplier NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_supplier " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

