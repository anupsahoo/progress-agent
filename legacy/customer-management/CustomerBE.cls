/*------------------------------------------------------------------------
    File        : CustomerBE.cls
    Purpose     : business entity for Customer (OpenEdge 11 OO ABL)
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2013-07  ssp  new report column
 *  2015-05  ssp  credit hold rule
 *  2002-07  kpo  remove dead code
 */

/* CustomerBE.cls : business entity for Customer (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS CM.CustomerBE:

  DEFINE PUBLIC PROPERTY CustNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Country AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Name AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Contact AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Phone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY SalesRep AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CreditLimit AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Balance AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Terms AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Discount AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Comments AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Fax AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY EmailAddress AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC CustomerBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pCustNum AS INTEGER):
    FIND FIRST Customer NO-LOCK WHERE Customer.CustNum = pCustNum NO-ERROR.
    IF NOT AVAILABLE Customer THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:CustNum = Customer.CustNum
           THIS-OBJECT:Country = Customer.Country
           THIS-OBJECT:Name = Customer.Name
           THIS-OBJECT:Address = Customer.Address
           THIS-OBJECT:Address2 = Customer.Address2
           THIS-OBJECT:City = Customer.City
           THIS-OBJECT:State = Customer.State
           THIS-OBJECT:PostalCode = Customer.PostalCode
           THIS-OBJECT:Contact = Customer.Contact
           THIS-OBJECT:Phone = Customer.Phone
           THIS-OBJECT:SalesRep = Customer.SalesRep
           THIS-OBJECT:CreditLimit = Customer.CreditLimit
           THIS-OBJECT:Balance = Customer.Balance
           THIS-OBJECT:Terms = Customer.Terms
           THIS-OBJECT:Discount = Customer.Discount
           THIS-OBJECT:Comments = Customer.Comments
           THIS-OBJECT:Fax = Customer.Fax
           THIS-OBJECT:EmailAddress = Customer.EmailAddress
           rRow = ROWID(Customer) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:CustNum = 0 THEN cErr = cErr + "Cust Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Customer.
      ELSE FIND Customer WHERE ROWID(Customer) = rRow EXCLUSIVE-LOCK.
      ASSIGN Customer.CustNum = THIS-OBJECT:CustNum
             Customer.Country = THIS-OBJECT:Country
             Customer.Name = THIS-OBJECT:Name
             Customer.Address = THIS-OBJECT:Address
             Customer.Address2 = THIS-OBJECT:Address2
             Customer.City = THIS-OBJECT:City
             Customer.State = THIS-OBJECT:State
             Customer.PostalCode = THIS-OBJECT:PostalCode
             Customer.Contact = THIS-OBJECT:Contact
             Customer.Phone = THIS-OBJECT:Phone
             Customer.SalesRep = THIS-OBJECT:SalesRep
             Customer.CreditLimit = THIS-OBJECT:CreditLimit
             Customer.Balance = THIS-OBJECT:Balance
             Customer.Terms = THIS-OBJECT:Terms
             Customer.Discount = THIS-OBJECT:Discount
             Customer.Comments = THIS-OBJECT:Comments
             Customer.Fax = THIS-OBJECT:Fax
             Customer.EmailAddress = THIS-OBJECT:EmailAddress.
      rRow = ROWID(Customer).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Customer WHERE ROWID(Customer) = rRow EXCLUSIVE-LOCK.
      DELETE Customer.
    END.
  END METHOD.

END CLASS.

