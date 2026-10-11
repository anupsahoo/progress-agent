/*------------------------------------------------------------------------
    File        : customer_val.p
    Purpose     : Business validation for Customer
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bCustomer FOR Customer.

FIND bCustomer WHERE ROWID(bCustomer) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bCustomer THEN DO:
  ASSIGN plOk = NO pcMsg = "Customer record not found.".
  RETURN.
END.

/* CustNum: custnum > 0 */
IF NOT (bCustomer.CustNum > 0) THEN
  RUN add-error ("Customer number must be greater than zero").

/* SalesRep: CAN-FIND(Salesrep OF Customer) */
IF NOT CAN-FIND(FIRST Salesrep WHERE Salesrep.SalesRep = bCustomer.SalesRep) THEN
  RUN add-error ("The Sales Rep's name you've entered must exist in the Salesrep table.").

/* CreditLimit: CreditLimit >= 0 AND CreditLimit <= 9999999 */
IF NOT (bCustomer.CreditLimit >= 0 AND bCustomer.CreditLimit <= 9999999) THEN
  RUN add-error ("Credit Limit must be >= 0 and <= 9,999,999").

/* Discount: Discount >= 0 */
IF NOT (bCustomer.Discount >= 0) THEN
  RUN add-error ("Discount must be greater or equal to 0").

IF bCustomer.EmailAddress > "" AND INDEX(bCustomer.EmailAddress, "@") = 0 THEN
  RUN add-error ("Email must be a valid e-mail address.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

