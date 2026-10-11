/*------------------------------------------------------------------------
    File        : ship_to_lookup.i
    Purpose     : ShipTo lookup helpers. {&NO-SHIPTO-FUNCS} suppresses the functions.
    Module      : Order Fulfilment
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-06  tlw  fix rounding
 */

/* ship_to_lookup.i : ShipTo lookup helpers. {&NO-SHIPTO-FUNCS} suppresses the functions. */

&IF DEFINED(SHIP_TO_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE SHIP_TO_LOOKUP_I YES

DEFINE BUFFER bLkShipTo FOR ShipTo.

FUNCTION ShipToExists RETURNS LOGICAL (INPUT pCustNum AS INTEGER, INPUT pShipToID AS INTEGER):
  RETURN CAN-FIND(FIRST bLkShipTo WHERE bLkShipTo.CustNum = pCustNum AND bLkShipTo.ShipToID = pShipToID).
END FUNCTION.

FUNCTION ShipToDesc RETURNS CHARACTER (INPUT pCustNum AS INTEGER, INPUT pShipToID AS INTEGER):
  FIND FIRST bLkShipTo NO-LOCK WHERE bLkShipTo.CustNum = pCustNum AND bLkShipTo.ShipToID = pShipToID NO-ERROR.
  RETURN (IF AVAILABLE bLkShipTo THEN bLkShipTo.Name ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-ship_to :
  DEFINE INPUT  PARAMETER pCustNum AS INTEGER NO-UNDO.
  DEFINE INPUT  PARAMETER pShipToID AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkShipTo NO-LOCK WHERE bLkShipTo.CustNum = pCustNum AND bLkShipTo.ShipToID = pShipToID NO-ERROR.
  pRowid = IF AVAILABLE bLkShipTo THEN ROWID(bLkShipTo) ELSE ?.
END PROCEDURE.

&ENDIF

