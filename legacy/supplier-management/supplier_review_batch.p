/*------------------------------------------------------------------------
    File        : supplier_review_batch.p
    Purpose     : Quarterly supplier review extraction
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : batch_runner.p, period end
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-06  mab  new report column
 *  2014-12  ssp  add lock retry
 *  2012-05  ssp  fix rounding
 *  2007-04  tlw  audit fields
 *  2010-09  jkm  fix rounding
 */

{shared/sysdefs.i}
{shared/dateutil.i}

DEFINE INPUT PARAMETER ptPeriodEnd AS DATE NO-UNDO.

DEFINE TEMP-TABLE ttSum NO-UNDO
    FIELD GroupKey AS CHARACTER
    FIELD Cnt      AS INTEGER
    FIELD Amount   AS DECIMAL
    INDEX ixKey IS PRIMARY UNIQUE GroupKey.

DEFINE VARIABLE cKey AS CHARACTER NO-UNDO.

FOR EACH Supplier NO-LOCK
    WHERE Supplier.LoginDate <= ptPeriodEnd:
    cKey = "Supplier|" + STRING(Supplier.Name).
    FIND ttSum WHERE ttSum.GroupKey = cKey NO-ERROR.
    IF NOT AVAILABLE ttSum THEN DO:
        CREATE ttSum.
        ttSum.GroupKey = cKey.
    END.
    ASSIGN ttSum.Cnt = ttSum.Cnt + 1
           ttSum.Amount = ttSum.Amount + Supplier.ShipAmount.
END.

OUTPUT TO VALUE(gLogDir + "supplier_review_batch_" + STRING(ptPeriodEnd, "99999999") + ".log").
FOR EACH ttSum BY ttSum.GroupKey:
    PUT UNFORMATTED ttSum.GroupKey "~t" ttSum.Cnt "~t" ttSum.Amount SKIP.
END.
OUTPUT CLOSE.

PROCEDURE post-supplier-shipamount0 :
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

PROCEDURE reset-supplier-discount1 :
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

PROCEDURE check-supplier-shipamount2 :
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

PROCEDURE calc-supplier-shipamount3 :
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

PROCEDURE post-supplier-discount4 :
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

PROCEDURE map-supplier-shipamount5 :
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

PROCEDURE apply-supplier-discount6 :
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

PROCEDURE reset-supplier-shipamount7 :
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

PROCEDURE derive-supplier-discount8 :
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
    WHEN bSupplier.Discount > 50000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Supplier.Discount above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

PROCEDURE calc-supplier-shipamount10 :
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

PROCEDURE reset-supplier-shipamount11 :
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

