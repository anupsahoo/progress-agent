/*------------------------------------------------------------------------
    File        : credit_bureau_if.p
    Purpose     : Credit bureau score import
    Module      : Credit Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-02  jkm  fix rounding
 *  2009-09  tlw  appserver split
 *  2003-03  mab  credit hold rule
 *  2005-05  mab  new report column
 *  1999-06  ssp  appserver split
 */

{shared/sysdefs.i}
{customer-management/tt_customer.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/credit_bureau_if_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH Customer NO-LOCK:
    CREATE ttCustomer.
    BUFFER-COPY Customer TO ttCustomer.
    iRecs = iRecs + 1.
END.

DATASET dsCustomer:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=Customer" SKIP "FIELDS=CustNum,Country,Name,Address,Address2,City,State,PostalCode,Contact,Phone,SalesRep,CreditLimit,Balance,Terms,Discount,Comments,Fax,EmailAddress" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "credit_bureau_if.p: " + STRING(iRecs) + " records written").

PROCEDURE map-customer-balance0 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bCustomer FOR Customer.
  FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bCustomer THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bCustomer.Balance < 0 THEN plOk = NO.
    WHEN bCustomer.Balance > 999999 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Customer.Balance above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

