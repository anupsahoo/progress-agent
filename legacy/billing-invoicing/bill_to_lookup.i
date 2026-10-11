/*------------------------------------------------------------------------
    File        : bill_to_lookup.i
    Purpose     : BillTo lookup helpers. {&NO-BILLTO-FUNCS} suppresses the functions.
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-12  rdh  add lock retry
 *  1999-08  kpo  appserver split
 *  2004-01  rdh  appserver split
 *  1999-04  kpo  new report column
 *  2015-10  rdh  new report column
 */

/* bill_to_lookup.i : BillTo lookup helpers. {&NO-BILLTO-FUNCS} suppresses the functions. */

&IF DEFINED(BILL_TO_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE BILL_TO_LOOKUP_I YES

DEFINE BUFFER bLkBillTo FOR BillTo.

FUNCTION BillToExists RETURNS LOGICAL (INPUT pCustNum AS INTEGER, INPUT pBillToID AS INTEGER):
  RETURN CAN-FIND(FIRST bLkBillTo WHERE bLkBillTo.CustNum = pCustNum AND bLkBillTo.BillToID = pBillToID).
END FUNCTION.

FUNCTION BillToDesc RETURNS CHARACTER (INPUT pCustNum AS INTEGER, INPUT pBillToID AS INTEGER):
  FIND FIRST bLkBillTo NO-LOCK WHERE bLkBillTo.CustNum = pCustNum AND bLkBillTo.BillToID = pBillToID NO-ERROR.
  RETURN (IF AVAILABLE bLkBillTo THEN bLkBillTo.Name ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-bill_to :
  DEFINE INPUT  PARAMETER pCustNum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pBillToID AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkBillTo NO-LOCK WHERE bLkBillTo.CustNum = pCustNum AND bLkBillTo.BillToID = pBillToID NO-ERROR.
  pRowid = IF AVAILABLE bLkBillTo THEN ROWID(bLkBillTo) ELSE ?.
END PROCEDURE.

&ENDIF

