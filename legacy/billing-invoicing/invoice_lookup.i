/*------------------------------------------------------------------------
    File        : invoice_lookup.i
    Purpose     : Invoice lookup helpers. {&NO-INVOICE-FUNCS} suppresses the functions.
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-02  kpo  add lock retry
 *  2014-03  jkm  fix rounding
 *  2007-07  kpo  credit hold rule
 *  2002-09  kpo  remove dead code
 *  2007-10  mab  audit fields
 */

/* invoice_lookup.i : Invoice lookup helpers. {&NO-INVOICE-FUNCS} suppresses the functions. */

&IF DEFINED(INVOICE_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE INVOICE_LOOKUP_I YES

DEFINE BUFFER bLkInvoice FOR Invoice.

FUNCTION InvoiceExists RETURNS LOGICAL (INPUT pInvoicenum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkInvoice WHERE bLkInvoice.Invoicenum = pInvoicenum).
END FUNCTION.

PROCEDURE find-invoice :
  DEFINE INPUT  PARAMETER pInvoicenum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkInvoice NO-LOCK WHERE bLkInvoice.Invoicenum = pInvoicenum NO-ERROR.
  pRowid = IF AVAILABLE bLkInvoice THEN ROWID(bLkInvoice) ELSE ?.
END PROCEDURE.

&ENDIF

