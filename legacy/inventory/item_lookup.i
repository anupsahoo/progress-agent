/*------------------------------------------------------------------------
    File        : item_lookup.i
    Purpose     : Item lookup helpers. {&NO-ITEM-FUNCS} suppresses the functions.
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2000-02  mab  add lock retry
 *  2004-06  jkm  audit fields
 *  2000-09  kpo  appserver split
 *  2011-11  ssp  performance: use index
 */

/* item_lookup.i : Item lookup helpers. {&NO-ITEM-FUNCS} suppresses the functions. */

&IF DEFINED(ITEM_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE ITEM_LOOKUP_I YES

DEFINE BUFFER bLkItem FOR Item.

FUNCTION ItemExists RETURNS LOGICAL (INPUT pItemnum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkItem WHERE bLkItem.Itemnum = pItemnum).
END FUNCTION.

FUNCTION ItemDesc RETURNS CHARACTER (INPUT pItemnum AS INTEGER):
  FIND FIRST bLkItem NO-LOCK WHERE bLkItem.Itemnum = pItemnum NO-ERROR.
  RETURN (IF AVAILABLE bLkItem THEN bLkItem.ItemName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-item :
  DEFINE INPUT  PARAMETER pItemnum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkItem NO-LOCK WHERE bLkItem.Itemnum = pItemnum NO-ERROR.
  pRowid = IF AVAILABLE bLkItem THEN ROWID(bLkItem) ELSE ?.
END PROCEDURE.

&ENDIF

