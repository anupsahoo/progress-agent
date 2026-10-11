/*------------------------------------------------------------------------
    File        : si_item.p
    Purpose     : AppServer service interface for Item
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

{inventory/tt_item.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsItem.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcItem FOR Item.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttItem:ATTACH-DATA-SOURCE(DATA-SOURCE srcItem:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcItem:FILL-WHERE-STRING = pcWhere.
    DATASET dsItem:FILL().
    BUFFER ttItem:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttItem:ATTACH-DATA-SOURCE(DATA-SOURCE srcItem:HANDLE).
    FOR EACH btItem:
      BUFFER btItem:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btItem:ERROR THEN pcError = pcError + BUFFER btItem:ERROR-STRING + "~n".
    END.
    BUFFER ttItem:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttItem:
      FIND FIRST Item EXCLUSIVE-LOCK WHERE Item.Itemnum = ttItem.Itemnum NO-WAIT NO-ERROR.
      IF LOCKED Item THEN DO:
        pcError = pcError + "Item is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE Item THEN DELETE Item.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER Item:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH Item NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_item " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

