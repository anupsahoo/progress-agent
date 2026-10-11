/*------------------------------------------------------------------------
    File        : write_bin.p
    Purpose     : schema WRITE trigger for Bin, field-level audit
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-02  rdh  add lock retry
 *  2001-07  tlw  audit fields
 *  2011-08  rdh  credit hold rule
 *  2017-02  ssp  new report column
 *  2010-11  rdh  add lock retry
 */

/* trg/write_bin.p : schema WRITE trigger for Bin, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Bin OLD BUFFER oldBin.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN warehousing/bin_val.p (INPUT ROWID(Bin), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Bin write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Bin.WarehouseNum <> oldBin.WarehouseNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Bin.WarehouseNum", INPUT STRING(oldBin.WarehouseNum), INPUT STRING(Bin.WarehouseNum)).
END.
IF Bin.Itemnum <> oldBin.Itemnum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Bin.Itemnum", INPUT STRING(oldBin.Itemnum), INPUT STRING(Bin.Itemnum)).
END.
IF Bin.Qty <> oldBin.Qty THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Bin.Qty", INPUT STRING(oldBin.Qty), INPUT STRING(Bin.Qty)).
END.
IF Bin.BinNum <> oldBin.BinNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Bin.BinNum", INPUT STRING(oldBin.BinNum), INPUT STRING(Bin.BinNum)).
END.
IF Bin.BinName <> oldBin.BinName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Bin.BinName", INPUT STRING(oldBin.BinName), INPUT STRING(Bin.BinName)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/bin.q") APPEND.
  EXPORT "Bin" "W" STRING(NOW) Bin.BinNum.
  OUTPUT CLOSE.
END.

