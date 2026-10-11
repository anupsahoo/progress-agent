/*------------------------------------------------------------------------
    File        : shipto_validate.p
    Purpose     : Ship-to address validation
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-08  jkm  add lock retry
 *  2004-11  jkm  remove dead code
 *  2014-10  mab  Y2K date window
 *  2008-04  ssp  add lock retry
 *  2016-11  jkm  audit fields
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bShipTo FOR ShipTo.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bShipTo THEN RETURN ERROR "ShipTo not found".

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE derive-ship-to-state0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.State = "" OR bShipTo.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-ship-to-state1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.State = "" OR bShipTo.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ship-to-city2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.City = "" OR bShipTo.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ship-to-name3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Name = "" OR bShipTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-ship-to-city4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.City = "" OR bShipTo.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE reset-ship-to-state5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.State = "" OR bShipTo.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-ship-to-name6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Name = "" OR bShipTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-ship-to-name7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Name = "" OR bShipTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ship-to-comments8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Comments = "" OR bShipTo.Comments = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Comments is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Comments) > 80 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ship-to-name9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Name = "" OR bShipTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-ship-to-address10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Address = "" OR bShipTo.Address = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Address is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Address) > 35 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-ship-to-city11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.City = "" OR bShipTo.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ship-to-postalcode12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.PostalCode = "" OR bShipTo.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

PROCEDURE post-ship-to-contact13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Contact = "" OR bShipTo.Contact = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Contact is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Contact) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-ship-to-name14 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Name = "" OR bShipTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ship-to-address215 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Address2 = "" OR bShipTo.Address2 = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Address2 is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Address2) > 35 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-ship-to-comments16 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Comments = "" OR bShipTo.Comments = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Comments is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Comments) > 80 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-ship-to-city17 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.City = "" OR bShipTo.City = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.City is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.City) > 25 THEN plOk = NO.
END PROCEDURE.

PROCEDURE round-ship-to-contact18 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Contact = "" OR bShipTo.Contact = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Contact is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Contact) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ship-to-comments19 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Comments = "" OR bShipTo.Comments = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Comments is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Comments) > 80 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-ship-to-phone20 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Phone = "" OR bShipTo.Phone = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Phone is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Phone) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE apply-ship-to-name21 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Name = "" OR bShipTo.Name = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Name is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Name) > 30 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-ship-to-postalcode22 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.PostalCode = "" OR bShipTo.PostalCode = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.PostalCode is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.PostalCode) > 10 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-ship-to-address223 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Address2 = "" OR bShipTo.Address2 = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Address2 is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Address2) > 35 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-ship-to-address24 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bShipTo FOR ShipTo.
  FIND bShipTo WHERE ROWID(bShipTo) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bShipTo THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bShipTo.Address = "" OR bShipTo.Address = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "ShipTo.Address is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bShipTo.Address) > 35 THEN plOk = NO.
END PROCEDURE.

