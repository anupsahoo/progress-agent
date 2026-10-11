/*------------------------------------------------------------------------
    File        : si_ship_to.p
    Purpose     : AppServer service interface for ShipTo
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

{order-fulfilment/tt_ship_to.i}

DEFINE INPUT        PARAMETER pcAction AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcWhere  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsShipTo.
DEFINE OUTPUT       PARAMETER pcError  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQ AS HANDLE NO-UNDO.
DEFINE DATA-SOURCE srcShipTo FOR ShipTo.

CASE pcAction:
  WHEN "fetch" THEN DO:
    BUFFER ttShipTo:ATTACH-DATA-SOURCE(DATA-SOURCE srcShipTo:HANDLE).
    IF pcWhere > "" THEN DATA-SOURCE srcShipTo:FILL-WHERE-STRING = pcWhere.
    DATASET dsShipTo:FILL().
    BUFFER ttShipTo:DETACH-DATA-SOURCE().
  END.
  WHEN "save" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    BUFFER ttShipTo:ATTACH-DATA-SOURCE(DATA-SOURCE srcShipTo:HANDLE).
    FOR EACH btShipTo:
      BUFFER btShipTo:SAVE-ROW-CHANGES() NO-ERROR.
      IF BUFFER btShipTo:ERROR THEN pcError = pcError + BUFFER btShipTo:ERROR-STRING + "~n".
    END.
    BUFFER ttShipTo:DETACH-DATA-SOURCE().
  END.
  WHEN "delete" THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ttShipTo:
      FIND FIRST ShipTo EXCLUSIVE-LOCK WHERE ShipTo.CustNum = ttShipTo.CustNum AND ShipTo.ShipToID = ttShipTo.ShipToID NO-WAIT NO-ERROR.
      IF LOCKED ShipTo THEN DO:
        pcError = pcError + "ShipTo is locked by another user~n".
        UNDO, LEAVE.
      END.
      IF AVAILABLE ShipTo THEN DELETE ShipTo.
    END.
  END.
  WHEN "count" THEN DO:
    CREATE QUERY hQ.
    hQ:SET-BUFFERS(BUFFER ShipTo:HANDLE).
    hQ:QUERY-PREPARE("PRESELECT EACH ShipTo NO-LOCK " + pcWhere).
    hQ:QUERY-OPEN().
    pcError = "COUNT=" + STRING(hQ:NUM-RESULTS).
    hQ:QUERY-CLOSE().
    DELETE OBJECT hQ.
  END.
  OTHERWISE pcError = "Unknown action " + pcAction.
END CASE.

RUN shared/log_msg.p (INPUT "DEBUG", INPUT "si_ship_to " + pcAction + " " + pcWhere + (IF pcError > "" THEN " ERR " + pcError ELSE "")).

