/*------------------------------------------------------------------------
    File        : invoice_val.p
    Purpose     : Business validation for Invoice
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER prRow AS ROWID     NO-UNDO.
DEFINE OUTPUT PARAMETER plOk  AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE OUTPUT PARAMETER pcMsg AS CHARACTER NO-UNDO.

DEFINE BUFFER bInvoice FOR Invoice.

FIND bInvoice WHERE ROWID(bInvoice) = prRow NO-LOCK NO-ERROR.
IF NOT AVAILABLE bInvoice THEN DO:
  ASSIGN plOk = NO pcMsg = "Invoice record not found.".
  RETURN.
END.

/* Invoicenum: invoicenum > 0 */
IF NOT (bInvoice.Invoicenum > 0) THEN
  RUN add-error ("Invoice number cannot be zero").

/* CustNum: CAN-FIND(customer OF invoice) */
IF NOT CAN-FIND(FIRST Customer WHERE Customer.CustNum = bInvoice.CustNum) THEN
  RUN add-error ("The Customer number entered must be a valid one.").

IF bInvoice.InvoiceDate <> ? AND YEAR(bInvoice.InvoiceDate) < 1950 THEN
  RUN add-error ("Invoice Date is before the 1950 date window.").

PROCEDURE add-error :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  ASSIGN plOk  = NO
         pcMsg = pcMsg + (IF pcMsg = "" THEN "" ELSE CHR(10)) + pcText.
END PROCEDURE.

