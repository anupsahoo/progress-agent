/*------------------------------------------------------------------------
    File        : bi_defs.i
    Purpose     : Billing & Invoicing shared definitions
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-09  tlw  credit hold rule
 *  2000-01  ssp  Y2K date window
 *  2004-02  tlw  add lock retry
 *  2009-06  ssp  appserver split
 */

/* bi_defs.i : Billing & Invoicing shared definitions */

&GLOBAL-DEFINE MODULE-ID billing-invoicing
&GLOBAL-DEFINE MODULE-NAME "Billing & Invoicing"

DEFINE NEW GLOBAL SHARED VARIABLE gBIPeriod AS DATE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gBISite   AS CHARACTER NO-UNDO INITIAL "HQ".

&GLOBAL-DEFINE INVOICE-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE BILLTO-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE CUSTOMER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDER-LOCK EXCLUSIVE-LOCK
&GLOBAL-DEFINE ORDERLINE-LOCK EXCLUSIVE-LOCK

&GLOBAL-DEFINE INVOICE-KEY Invoicenum
&GLOBAL-DEFINE INVOICE-FIELDS Invoicenum CustNum InvoiceDate Amount TotalPaid Adjustment OrderNum ShipCharge
&GLOBAL-DEFINE BILLTO-KEY CustNum BillToID
&GLOBAL-DEFINE BILLTO-FIELDS CustNum BillToID Name Address Address2 City State PostalCode Contact Phone

DEFINE NEW GLOBAL SHARED TEMP-TABLE ttModuleCtx NO-UNDO
    FIELD CtxKey   AS CHARACTER
    FIELD CtxValue AS CHARACTER
    INDEX ixKey IS PRIMARY UNIQUE CtxKey.

FUNCTION fnCtx RETURNS CHARACTER (INPUT pcKey AS CHARACTER):
  FIND ttModuleCtx WHERE ttModuleCtx.CtxKey = pcKey NO-ERROR.
  RETURN (IF AVAILABLE ttModuleCtx THEN ttModuleCtx.CtxValue ELSE "").
END FUNCTION.

