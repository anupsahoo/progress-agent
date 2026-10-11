/*------------------------------------------------------------------------
    File        : InvoiceBE.cls
    Purpose     : business entity for Invoice (OpenEdge 11 OO ABL)
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-06  ssp  performance: use index
 *  2001-12  ssp  fix rounding
 *  2014-07  rdh  add lock retry
 *  1999-09  tlw  credit hold rule
 *  2011-09  mab  Y2K date window
 */

/* InvoiceBE.cls : business entity for Invoice (OpenEdge 11 OO ABL) */

USING Progress.Lang.*.

CLASS BI.InvoiceBE:

  DEFINE PUBLIC PROPERTY Invoicenum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY CustNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY InvoiceDate AS DATE NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Amount AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY TotalPaid AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY Adjustment AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OrderNum AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ShipCharge AS DECIMAL NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY IsNew AS LOGICAL NO-UNDO GET. PRIVATE SET.
  DEFINE PRIVATE VARIABLE rRow AS ROWID NO-UNDO.

  CONSTRUCTOR PUBLIC InvoiceBE ():
    IsNew = YES.
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL Fetch (INPUT pInvoicenum AS INTEGER):
    FIND FIRST Invoice NO-LOCK WHERE Invoice.Invoicenum = pInvoicenum NO-ERROR.
    IF NOT AVAILABLE Invoice THEN RETURN FALSE.
    ASSIGN THIS-OBJECT:Invoicenum = Invoice.Invoicenum
           THIS-OBJECT:CustNum = Invoice.CustNum
           THIS-OBJECT:InvoiceDate = Invoice.InvoiceDate
           THIS-OBJECT:Amount = Invoice.Amount
           THIS-OBJECT:TotalPaid = Invoice.TotalPaid
           THIS-OBJECT:Adjustment = Invoice.Adjustment
           THIS-OBJECT:OrderNum = Invoice.OrderNum
           THIS-OBJECT:ShipCharge = Invoice.ShipCharge
           rRow = ROWID(Invoice) IsNew = NO.
    RETURN TRUE.
  END METHOD.

  METHOD PUBLIC CHARACTER Validate ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    IF THIS-OBJECT:Invoicenum = 0 THEN cErr = cErr + "Invoice Num is required.~n".
    RETURN cErr.
  END METHOD.

  METHOD PUBLIC VOID Save ():
    DEFINE VARIABLE cErr AS CHARACTER NO-UNDO.
    cErr = Validate().
    IF cErr > "" THEN UNDO, THROW NEW AppError(cErr, 1).
    DO TRANSACTION:
      IF IsNew THEN CREATE Invoice.
      ELSE FIND Invoice WHERE ROWID(Invoice) = rRow EXCLUSIVE-LOCK.
      ASSIGN Invoice.Invoicenum = THIS-OBJECT:Invoicenum
             Invoice.CustNum = THIS-OBJECT:CustNum
             Invoice.InvoiceDate = THIS-OBJECT:InvoiceDate
             Invoice.Amount = THIS-OBJECT:Amount
             Invoice.TotalPaid = THIS-OBJECT:TotalPaid
             Invoice.Adjustment = THIS-OBJECT:Adjustment
             Invoice.OrderNum = THIS-OBJECT:OrderNum
             Invoice.ShipCharge = THIS-OBJECT:ShipCharge.
      rRow = ROWID(Invoice).
    END.
    IsNew = NO.
  END METHOD.

  METHOD PUBLIC VOID Remove ():
    DO TRANSACTION:
      FIND Invoice WHERE ROWID(Invoice) = rRow EXCLUSIVE-LOCK.
      DELETE Invoice.
    END.
  END METHOD.

END CLASS.

