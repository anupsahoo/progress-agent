/*------------------------------------------------------------------------
    File        : delete_salesrep.p
    Purpose     : schema DELETE trigger for Salesrep, referential integrity
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-01  kpo  new report column
 *  2013-03  ssp  Y2K date window
 */

/* trg/delete_salesrep.p : schema DELETE trigger for Salesrep, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Salesrep.

{shared/sysdefs.i}

IF CAN-FIND(FIRST Customer WHERE Customer.SalesRep = Salesrep.SalesRep) THEN DO:
  MESSAGE "Cannot delete Salesrep: Customer records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Order WHERE Order.SalesRep = Salesrep.SalesRep) THEN DO:
  MESSAGE "Cannot delete Salesrep: Order records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST RefCall WHERE RefCall.SalesRep = Salesrep.SalesRep) THEN DO:
  MESSAGE "Cannot delete Salesrep: RefCall records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Table VALEXP: NOT CAN-FIND(FIRST Customer Of Salesrep) */

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/salesrep_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Salesrep.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Salesrep by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/salesrep.q") APPEND.
EXPORT "Salesrep" "D" STRING(NOW) Salesrep.SalesRep.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Salesrep", INPUT STRING(ROWID(Salesrep)), INPUT "DELETE").

