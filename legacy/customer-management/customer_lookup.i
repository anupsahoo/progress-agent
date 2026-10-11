/*------------------------------------------------------------------------
    File        : customer_lookup.i
    Purpose     : Customer lookup helpers. {&NO-CUSTOMER-FUNCS} suppresses the functions.
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-01  kpo  performance: use index
 */

/* customer_lookup.i : Customer lookup helpers. {&NO-CUSTOMER-FUNCS} suppresses the functions. */

&IF DEFINED(CUSTOMER_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE CUSTOMER_LOOKUP_I YES

DEFINE BUFFER bLkCustomer FOR Customer.

FUNCTION CustomerExists RETURNS LOGICAL (INPUT pCustNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkCustomer WHERE bLkCustomer.CustNum = pCustNum).
END FUNCTION.

FUNCTION CustomerDesc RETURNS CHARACTER (INPUT pCustNum AS INTEGER):
  FIND FIRST bLkCustomer NO-LOCK WHERE bLkCustomer.CustNum = pCustNum NO-ERROR.
  RETURN (IF AVAILABLE bLkCustomer THEN bLkCustomer.Name ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-customer :
  DEFINE INPUT  PARAMETER pCustNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkCustomer NO-LOCK WHERE bLkCustomer.CustNum = pCustNum NO-ERROR.
  pRowid = IF AVAILABLE bLkCustomer THEN ROWID(bLkCustomer) ELSE ?.
END PROCEDURE.

&ENDIF

