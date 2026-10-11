/*------------------------------------------------------------------------
    File        : delete_bin.p
    Purpose     : schema DELETE trigger for Bin, referential integrity
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-05  mab  new report column
 *  2008-10  tlw  audit fields
 *  2002-08  kpo  fix rounding
 *  2014-03  kpo  audit fields
 */

/* trg/delete_bin.p : schema DELETE trigger for Bin, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Bin.

{shared/sysdefs.i}

IF CAN-FIND(FIRST InventoryTrans WHERE InventoryTrans.BinNum = Bin.BinNum) THEN DO:
  MESSAGE "Cannot delete Bin: InventoryTrans records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/bin_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Bin.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Bin by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/bin.q") APPEND.
EXPORT "Bin" "D" STRING(NOW) Bin.BinNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Bin", INPUT STRING(ROWID(Bin)), INPUT "DELETE").

