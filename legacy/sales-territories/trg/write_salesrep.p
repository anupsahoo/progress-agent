/*------------------------------------------------------------------------
    File        : write_salesrep.p
    Purpose     : schema WRITE trigger for Salesrep, field-level audit
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-05  kpo  remove dead code
 *  2010-04  mab  Y2K date window
 *  2009-04  tlw  audit fields
 *  2001-06  jkm  add lock retry
 *  2008-07  kpo  add lock retry
 */

/* trg/write_salesrep.p : schema WRITE trigger for Salesrep, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Salesrep OLD BUFFER oldSalesrep.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN sales-territories/salesrep_val.p (INPUT ROWID(Salesrep), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Salesrep write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Salesrep.SalesRep <> oldSalesrep.SalesRep THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Salesrep.SalesRep", INPUT STRING(oldSalesrep.SalesRep), INPUT STRING(Salesrep.SalesRep)).
END.
IF Salesrep.RepName <> oldSalesrep.RepName THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Salesrep.RepName", INPUT STRING(oldSalesrep.RepName), INPUT STRING(Salesrep.RepName)).
END.
IF Salesrep.Region <> oldSalesrep.Region THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Salesrep.Region", INPUT STRING(oldSalesrep.Region), INPUT STRING(Salesrep.Region)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/salesrep.q") APPEND.
  EXPORT "Salesrep" "W" STRING(NOW) Salesrep.SalesRep.
  OUTPUT CLOSE.
END.

