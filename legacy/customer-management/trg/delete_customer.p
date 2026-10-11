/*------------------------------------------------------------------------
    File        : delete_customer.p
    Purpose     : schema DELETE trigger for Customer, referential integrity
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-04  ssp  performance: use index
 *  2013-04  rdh  audit fields
 *  2004-04  mab  add lock retry
 *  2011-01  ssp  appserver split
 *  2015-01  kpo  credit hold rule
 */

/* trg/delete_customer.p : schema DELETE trigger for Customer, referential integrity */

TRIGGER PROCEDURE FOR DELETE OF Customer.

{shared/sysdefs.i}

IF CAN-FIND(FIRST BillTo WHERE BillTo.CustNum = Customer.CustNum) THEN DO:
  MESSAGE "Cannot delete Customer: BillTo records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Invoice WHERE Invoice.CustNum = Customer.CustNum) THEN DO:
  MESSAGE "Cannot delete Customer: Invoice records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST Order WHERE Order.CustNum = Customer.CustNum) THEN DO:
  MESSAGE "Cannot delete Customer: Order records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST RefCall WHERE RefCall.CustNum = Customer.CustNum) THEN DO:
  MESSAGE "Cannot delete Customer: RefCall records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

IF CAN-FIND(FIRST ShipTo WHERE ShipTo.CustNum = Customer.CustNum) THEN DO:
  MESSAGE "Cannot delete Customer: ShipTo records still reference it." VIEW-AS ALERT-BOX ERROR.
  RETURN ERROR.
END.

/* Soft archive: keep a copy of every deleted row for seven years (audit requirement). */
OUTPUT TO VALUE(gLogDir + "archive/customer_" + STRING(YEAR(TODAY)) + ".d") APPEND.
EXPORT Customer.
OUTPUT CLOSE.

IF NOT gUserCanDelete THEN DO:
  RUN shared/log_msg.p (INPUT "WARN", INPUT "Delete of Customer by " + gUserId + " without delete right").
  RETURN ERROR "Not authorised to delete".
END.

/* Replication queue for the reporting copy. */
OUTPUT TO VALUE(gLogDir + "repl/customer.q") APPEND.
EXPORT "Customer" "D" STRING(NOW) Customer.CustNum.
OUTPUT CLOSE.

RUN shared/audit_log.p (INPUT "Customer", INPUT STRING(ROWID(Customer)), INPUT "DELETE").

