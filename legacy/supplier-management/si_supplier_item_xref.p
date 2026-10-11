/*------------------------------------------------------------------------
    File        : si_supplier_item_xref.p
    Purpose     : AppServer service interface for SupplierItemXref
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{supplier-management/tt_supplier_item_xref.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsSupplierItemXref.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcSupplierItemXref FOR SupplierItemXref.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttSupplierItemXref:ATTACH-DATA-SOURCE(DATA-SOURCE srcSupplierItemXref:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcSupplierItemXref:FILL-WHERE-STRING = pcWhere.
    DATASET dsSupplierItemXref:FILL().
    BUFFER ttSupplierItemXref:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttSupplierItemXref:ATTACH-DATA-SOURCE(DATA-SOURCE srcSupplierItemXref:HANDLE).
    FOR EACH btSupplierItemXref:
      BUFFER btSupplierItemXref:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btSupplierItemXref:ERROR THEN pcError = pcError + BUFFER btSupplierItemXref:ERROR-STRING + "~n".
    END.
    BUFFER ttSupplierItemXref:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttSupplierItemXref:
      FIND FIRST SupplierItemXref EXCLUSIVE-LOCK WHERE SupplierItemXref.SupplierIDNum = ttSupplierItemXref.SupplierIDNum AND SupplierItemXref.Itemnum = ttSupplierItemXref.Itemnum NO-WAIT NO-ERROR.
      IF LOCKED SupplierItemXref THEN DO:
        pcError = pcError + "SupplierItemXref is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE SupplierItemXref THEN DELETE SupplierItemXref.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER SupplierItemXref:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH SupplierItemXref NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_supplier_item_xref " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

