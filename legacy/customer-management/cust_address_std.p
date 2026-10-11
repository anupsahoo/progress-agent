/*------------------------------------------------------------------------
    File        : cust_address_std.p
    Purpose     : Standardise addresses using state and postal rules
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-08  rdh  add lock retry
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bCustomer FOR Customer.
DEFINE BUFFER bState FOR State.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bCustomer THEN RETURN ERROR "Customer not found".

dBase = dBase + bCustomer.CreditLimit.
dBase = dBase + 0.75 * bCustomer.Balance.
dBase = dBase + 1.00 * bCustomer.Discount.

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE post-state-statename0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.StateName = "" OR bState.StateName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.StateName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.StateName) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE derive-customer-creditlimit1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.CreditLimit < 0 THEN plOk = NO.
    WHEN bCustomer.CreditLimit > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.CreditLimit above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-state-region2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.Region = "" OR bState.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.Region) > 8 THEN plOk = NO.
END PROCEDURE.

PROCEDURE check-state-statename3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.StateName = "" OR bState.StateName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.StateName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.StateName) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE calc-state-statename4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.StateName = "" OR bState.StateName = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.StateName is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.StateName) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE map-state-state5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.State = "" OR bState.State = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.State is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.State) > 20 THEN plOk = NO.
END PROCEDURE.

PROCEDURE flag-state-region6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.Region = "" OR bState.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.Region) > 8 THEN plOk = NO.
END PROCEDURE.

PROCEDURE load-customer-discount7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Discount < 0 THEN plOk = NO.
    WHEN bCustomer.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-state-region8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bState FOR State.
  FIND bState WHERE ROWID(bState) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bState THEN DO:
    plOk = NO.
    RETURN.
  END.
  IF bState.Region = "" OR bState.Region = ? THEN DO:
    RUN shared/log_msg.p (INPUT "WARN", INPUT "State.Region is blank").
    plOk = NO.
  END.
  ELSE IF LENGTH(bState.Region) > 8 THEN plOk = NO.
END PROCEDURE.

