/*------------------------------------------------------------------------
    File        : BillToBE.cls
    Purpose     : business entity for BillTo (OpenEdge 11 OO ABL)
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2015-01  jkm  add lock retry
 *  1999-01  tlw  appserver split
 *  2005-06  jkm  remove dead code
 *  2015-10  tlw  credit hold rule
 *  2016-01  jkm  appserver split
 */

/* BillToBE.cls : business entity for BillTo (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS BI.BillToBE:

  DEFINE PUBLIC PROPERTY CustNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY BillToID AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Name AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Contact AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Phone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC BillToBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pCustNum AS INTEGER, INPUT pBillToID AS INTEGER):
    FIND FIRST BillTo NO-LOCK WHERE BillTo.CustNum = pCustNum AND BillTo.BillToID = pBillToID NO-ERROR.
    IF NOT AVAILABLE BillTo THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:CustNum = BillTo.CustNum
           THIS-OBJECT:BillToID = BillTo.BillToID
           THIS-OBJECT:Name = BillTo.Name
           THIS-OBJECT:Address = BillTo.Address
           THIS-OBJECT:Address2 = BillTo.Address2
           THIS-OBJECT:City = BillTo.City
           THIS-OBJECT:State = BillTo.State
           THIS-OBJECT:PostalCode = BillTo.PostalCode
           THIS-OBJECT:Contact = BillTo.Contact
           THIS-OBJECT:Phone = BillTo.Phone
           rRow = ROWID(BillTo) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:CustNum = 0 THEN cErr = cErr + "Cust Num is required.~n".
    IF THIS-OBJECT:BillToID = 0 THEN cErr = cErr + "BillToID is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE BillTo.
      ELSE FIND BillTo WHERE ROWID(BillTo) = rRow EXCLUSIVE-LOCK.
      ASSIGN BillTo.CustNum = THIS-OBJECT:CustNum
             BillTo.BillToID = THIS-OBJECT:BillToID
             BillTo.Name = THIS-OBJECT:Name
             BillTo.Address = THIS-OBJECT:Address
             BillTo.Address2 = THIS-OBJECT:Address2
             BillTo.City = THIS-OBJECT:City
             BillTo.State = THIS-OBJECT:State
             BillTo.PostalCode = THIS-OBJECT:PostalCode
             BillTo.Contact = THIS-OBJECT:Contact
             BillTo.Phone = THIS-OBJECT:Phone.
      rRow = ROWID(BillTo).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND BillTo WHERE ROWID(BillTo) = rRow EXCLUSIVE-LOCK.
      DELETE BillTo.
    END.
  END METHOD.

END CLASS.

