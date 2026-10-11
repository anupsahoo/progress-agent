/*------------------------------------------------------------------------
    File        : wh_capacity_rpt.p
    Purpose     : Warehouse capacity and utilisation
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-03  ssp  fix rounding
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.
DEFINE STREAM sOut.
DEFINE VARIABLE dLine AS DECIMAL NO-UNDO.
DEFINE VARIABLE dGrand AS DECIMAL NO-UNDO.

OUTPUT STREAM sOut TO VALUE(pcDest) PAGED PAGE-SIZE 66.
PUT STREAM sOut UNFORMATTED gCompanyName SKIP "Warehouse capacity and utilisation" SKIP(1).

FOR EACH Warehouse NO-LOCK
    BREAK BY Warehouse.City:
    dLine = 0.
    FOR EACH Bin NO-LOCK WHERE Bin.WarehouseNum = Warehouse.WarehouseNum:
        dLine = dLine + Bin.Qty.
    END.
    dGrand = dGrand + dLine.
    ACCUMULATE dLine (TOTAL SUB-TOTAL BY Warehouse.City).
    DISPLAY STREAM sOut Warehouse.WarehouseNum Warehouse.WarehouseName Warehouse.Country Warehouse.Address dLine LABEL "Amount" FORMAT "->>>,>>>,>>9.99"
        WITH FRAME fLine DOWN WIDTH 132 STREAM-IO.
    IF LAST-OF(Warehouse.City) THEN
        PUT STREAM sOut UNFORMATTED SKIP "  City total: " ACCUM SUB-TOTAL BY Warehouse.City dLine SKIP(1).
END.
PUT STREAM sOut UNFORMATTED SKIP(1) "Grand total: " dGrand SKIP.
OUTPUT STREAM sOut CLOSE.

PROCEDURE check-warehouse-country0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.Country = "" OR bWarehouse.Country = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.Country is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.Country) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-warehouse-state1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.State = "" OR bWarehouse.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-bin-qty2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-warehouse-city3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.City = "" OR bWarehouse.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-bin-qty4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-warehouse-postalcode5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bWarehouse FOR Warehouse.
  FIND bWarehouse WHERE ROWID(bWarehouse) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bWarehouse THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bWarehouse.PostalCode = "" OR bWarehouse.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "Warehouse.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bWarehouse.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-bin-qty6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bBin FOR Bin.
  FIND bBin WHERE ROWID(bBin) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bBin THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bBin.Qty < 0 THEN plOk = NO.
    WHEN bBin.Qty > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Bin.Qty above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

