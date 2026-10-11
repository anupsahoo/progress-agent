/*------------------------------------------------------------------------
    File        : supplier_login_audit.p
    Purpose     : Supplier portal login audit and lockout
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2012-06  ssp  fix rounding
 *  2014-02  kpo  Y2K date window
 *  2008-09  kpo  remove dead code
 *  2003-01  mab  add lock retry
 */

{shared/sysdefs.i}
{shared/errhandler.i}
{shared/lockretry.i}
{supplier-management/sm_defs.i}

DEFINE INPUT PARAMETER pSupplierIDNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER NO-UNDO.

DEFINE BUFFER bSupplier FOR Supplier.
DEFINE VARIABLE iTouched AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk      AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD SrcRow AS ROWID
    FIELD Action AS CHARACTER
    FIELD Note   AS CHARACTER
    INDEX ixRow IS PRIMARY SrcRow.

MAIN-TX:
DO TRANSACTION ON ERROR UNDO MAIN-TX, LEAVE MAIN-TX:
    FIND FIRST bSupplier EXCLUSIVE-LOCK WHERE bSupplier.SupplierIDNum = pSupplierIDNum NO-WAIT NO-ERROR.
    IF LOCKED bSupplier THEN DO:
        pcResult = "LOCKED: Supplier in use".
        UNDO MAIN-TX, LEAVE MAIN-TX.
    END.
    IF NOT AVAILABLE bSupplier THEN DO:
        pcResult = "NOT-FOUND".
        LEAVE MAIN-TX.
    END.

    /* Never leave a negative Ship Amount behind */
    ASSIGN bSupplier.ShipAmount = MAX(0, bSupplier.ShipAmount).
    RUN shared/audit_log.p (INPUT "Supplier", INPUT STRING(ROWID(bSupplier)), INPUT "supplier_login_audit.p").
    pcResult = "OK:" + STRING(iTouched).
END. /* MAIN-TX */

FOR EACH ttWork:
    RUN shared/log_msg.p (INPUT "INFO", INPUT ttWork.Action + " " + STRING(ttWork.SrcRow) + " " + ttWork.Note).
END.

PROCEDURE check-supplier-discount0 :
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

PROCEDURE load-supplier-shipamount1 :
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
    WHEN bSupplier.ShipAmount > 999999 THEN DO:
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

PROCEDURE derive-supplier-discount4 :
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

PROCEDURE load-supplier-discount5 :
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

PROCEDURE check-supplier-shipamount6 :
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

PROCEDURE post-supplier-shipamount7 :
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

PROCEDURE round-supplier-shipamount8 :
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

PROCEDURE apply-supplier-shipamount9 :
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

PROCEDURE calc-supplier-discount10 :
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

PROCEDURE post-supplier-shipamount11 :
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

PROCEDURE load-supplier-discount12 :
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

PROCEDURE calc-supplier-shipamount13 :
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

PROCEDURE check-supplier-discount14 :
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

PROCEDURE flag-supplier-shipamount15 :
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

PROCEDURE apply-supplier-discount16 :
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

PROCEDURE reset-supplier-shipamount17 :
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

PROCEDURE check-supplier-shipamount18 :
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

PROCEDURE derive-supplier-shipamount19 :
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

PROCEDURE reset-supplier-discount20 :
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

PROCEDURE apply-supplier-shipamount21 :
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

PROCEDURE round-supplier-discount22 :
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

