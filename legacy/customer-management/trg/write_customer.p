/*------------------------------------------------------------------------
    File        : write_customer.p
    Purpose     : schema WRITE trigger for Customer, field-level audit
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-02  ssp  Y2K date window
 *  2013-07  rdh  performance: use index
 *  2005-11  rdh  performance: use index
 */

/* trg/write_customer.p : schema WRITE trigger for Customer, field-level audit */

TRIGGER PROCEDURE FOR WRITE OF Customer OLD BUFFER oldCustomer.

{shared/sysdefs.i}

DEFINE VARIABLE lOk  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE iChg AS INTEGER   NO-UNDO.

/* Business validation runs on every write, including batch and AppServer updates. */
RUN customer-management/customer_val.p (INPUT ROWID(Customer), OUTPUT lOk, OUTPUT cMsg).
IF NOT lOk THEN DO:
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "Customer write rejected: " + cMsg).
  RETURN ERROR cMsg.
END.

IF Customer.CustNum <> oldCustomer.CustNum THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.CustNum", INPUT STRING(oldCustomer.CustNum), INPUT STRING(Customer.CustNum)).
END.
IF Customer.Country <> oldCustomer.Country THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Country", INPUT STRING(oldCustomer.Country), INPUT STRING(Customer.Country)).
END.
IF Customer.Name <> oldCustomer.Name THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Name", INPUT STRING(oldCustomer.Name), INPUT STRING(Customer.Name)).
END.
IF Customer.Address <> oldCustomer.Address THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Address", INPUT STRING(oldCustomer.Address), INPUT STRING(Customer.Address)).
END.
IF Customer.Address2 <> oldCustomer.Address2 THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Address2", INPUT STRING(oldCustomer.Address2), INPUT STRING(Customer.Address2)).
END.
IF Customer.City <> oldCustomer.City THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.City", INPUT STRING(oldCustomer.City), INPUT STRING(Customer.City)).
END.
IF Customer.State <> oldCustomer.State THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.State", INPUT STRING(oldCustomer.State), INPUT STRING(Customer.State)).
END.
IF Customer.PostalCode <> oldCustomer.PostalCode THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.PostalCode", INPUT STRING(oldCustomer.PostalCode), INPUT STRING(Customer.PostalCode)).
END.
IF Customer.Contact <> oldCustomer.Contact THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Contact", INPUT STRING(oldCustomer.Contact), INPUT STRING(Customer.Contact)).
END.
IF Customer.Phone <> oldCustomer.Phone THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Phone", INPUT STRING(oldCustomer.Phone), INPUT STRING(Customer.Phone)).
END.
IF Customer.SalesRep <> oldCustomer.SalesRep THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.SalesRep", INPUT STRING(oldCustomer.SalesRep), INPUT STRING(Customer.SalesRep)).
END.
IF Customer.CreditLimit <> oldCustomer.CreditLimit THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.CreditLimit", INPUT STRING(oldCustomer.CreditLimit), INPUT STRING(Customer.CreditLimit)).
END.
IF Customer.Balance <> oldCustomer.Balance THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Balance", INPUT STRING(oldCustomer.Balance), INPUT STRING(Customer.Balance)).
END.
IF Customer.Terms <> oldCustomer.Terms THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Terms", INPUT STRING(oldCustomer.Terms), INPUT STRING(Customer.Terms)).
END.
IF Customer.Discount <> oldCustomer.Discount THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Discount", INPUT STRING(oldCustomer.Discount), INPUT STRING(Customer.Discount)).
END.
IF Customer.Comments <> oldCustomer.Comments THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Comments", INPUT STRING(oldCustomer.Comments), INPUT STRING(Customer.Comments)).
END.
IF Customer.Fax <> oldCustomer.Fax THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.Fax", INPUT STRING(oldCustomer.Fax), INPUT STRING(Customer.Fax)).
END.
IF Customer.EmailAddress <> oldCustomer.EmailAddress THEN DO:
  iChg = iChg + 1.
  RUN shared/audit_log.p (INPUT "Customer.EmailAddress", INPUT STRING(oldCustomer.EmailAddress), INPUT STRING(Customer.EmailAddress)).
END.

/* Replication queue for the reporting copy (pre-dates CDC). */
IF iChg > 0 THEN DO:
  OUTPUT TO VALUE(gLogDir + "repl/customer.q") APPEND.
  EXPORT "Customer" "W" STRING(NOW) Customer.CustNum.
  OUTPUT CLOSE.
END.

