/*------------------------------------------------------------------------
    File        : ShipToBE.cls
    Purpose     : business entity for ShipTo (OpenEdge 11 OO ABL)
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-02  kpo  credit hold rule
 *  2006-05  tlw  new report column
 *  2008-01  rdh  credit hold rule
 *  2001-09  kpo  add lock retry
 */

/* ShipToBE.cls : business entity for ShipTo (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS OF.ShipToBE:

  DEFINE PUBLIC PROPERTY CustNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ShipToID AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Contact AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Address2 AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY City AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY State AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY PostalCode AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Phone AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Comments AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Name AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC ShipToBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pCustNum AS INTEGER, INPUT pShipToID AS INTEGER):
    FIND FIRST ShipTo NO-LOCK WHERE ShipTo.CustNum = pCustNum AND ShipTo.ShipToID = pShipToID NO-ERROR.
    IF NOT AVAILABLE ShipTo THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:CustNum = ShipTo.CustNum
           THIS-OBJECT:ShipToID = ShipTo.ShipToID
           THIS-OBJECT:Contact = ShipTo.Contact
           THIS-OBJECT:Address = ShipTo.Address
           THIS-OBJECT:Address2 = ShipTo.Address2
           THIS-OBJECT:City = ShipTo.City
           THIS-OBJECT:State = ShipTo.State
           THIS-OBJECT:PostalCode = ShipTo.PostalCode
           THIS-OBJECT:Phone = ShipTo.Phone
           THIS-OBJECT:Comments = ShipTo.Comments
           THIS-OBJECT:Name = ShipTo.Name
           rRow = ROWID(ShipTo) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:CustNum = 0 THEN cErr = cErr + "Cust Num is required.~n".
    IF THIS-OBJECT:ShipToID = 0 THEN cErr = cErr + "Ship To ID is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE ShipTo.
      ELSE FIND ShipTo WHERE ROWID(ShipTo) = rRow EXCLUSIVE-LOCK.
      ASSIGN ShipTo.CustNum = THIS-OBJECT:CustNum
             ShipTo.ShipToID = THIS-OBJECT:ShipToID
             ShipTo.Contact = THIS-OBJECT:Contact
             ShipTo.Address = THIS-OBJECT:Address
             ShipTo.Address2 = THIS-OBJECT:Address2
             ShipTo.City = THIS-OBJECT:City
             ShipTo.State = THIS-OBJECT:State
             ShipTo.PostalCode = THIS-OBJECT:PostalCode
             ShipTo.Phone = THIS-OBJECT:Phone
             ShipTo.Comments = THIS-OBJECT:Comments
             ShipTo.Name = THIS-OBJECT:Name.
      rRow = ROWID(ShipTo).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND ShipTo WHERE ROWID(ShipTo) = rRow EXCLUSIVE-LOCK.
      DELETE ShipTo.
    END.
  END METHOD.

END CLASS.

