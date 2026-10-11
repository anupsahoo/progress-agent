/*------------------------------------------------------------------------
    File        : supplier_shipcost.p
    Purpose     : Freight cost estimate per supplier
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-07  ssp  Y2K date window
 *  2015-08  kpo  Y2K date window
 *  2002-07  ssp  credit hold rule
 *  2017-01  jkm  audit fields
 */

{shared/sysdefs.i}
{shared/numutil.i}

DEFINE INPUT  PARAMETER prRow    AS ROWID   NO-UNDO.
DEFINE OUTPUT PARAMETER pdResult AS DECIMAL NO-UNDO.

DEFINE BUFFER bSupplier FOR Supplier.

DEFINE VARIABLE dBase   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFactor AS DECIMAL NO-UNDO INITIAL 1.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

FUNCTION fnTier RETURNS DECIMAL (INPUT pdAmt AS DECIMAL):
  IF pdAmt >= 100000 THEN RETURN 0.15.
  IF pdAmt >= 50000  THEN RETURN 0.10.
  IF pdAmt >= 10000  THEN RETURN 0.05.
  RETURN 0.
END FUNCTION.

FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bSupplier THEN RETURN ERROR "Supplier not found".

dBase = dBase + bSupplier.ShipAmount.
dBase = dBase + 0.75 * bSupplier.Discount.

pdResult = ROUND(dBase * dFactor * (1 - fnTier(dBase)), 2).
IF pdResult < 0 THEN pdResult = 0.

PROCEDURE derive-supplier-discount0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-supplier-discount1 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE reset-supplier-shipamount2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE derive-supplier-discount3 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-supplier-shipamount4 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-supplier-shipamount5 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-supplier-discount6 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-supplier-shipamount7 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-supplier-shipamount8 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE apply-supplier-discount9 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-supplier-shipamount10 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-supplier-shipamount11 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 9999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE round-supplier-discount12 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE map-supplier-discount13 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-supplier-shipamount14 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-supplier-discount15 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-supplier-discount16 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE check-supplier-discount17 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE flag-supplier-discount18 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.Discount < 0 THEN plOk = NO.
    WHEN bSupplier.Discount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE load-supplier-shipamount19 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE post-supplier-shipamount20 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bSupplier FOR Supplier.
  FIND bSupplier WHERE ROWID(bSupplier) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bSupplier THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bSupplier.ShipAmount < 0 THEN plOk = NO.
    WHEN bSupplier.ShipAmount > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.ShipAmount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

