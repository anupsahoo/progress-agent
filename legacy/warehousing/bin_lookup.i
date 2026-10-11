/*------------------------------------------------------------------------
    File        : bin_lookup.i
    Purpose     : Bin lookup helpers. {&NO-BIN-FUNCS} suppresses the functions.
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-11  rdh  Y2K date window
 *  2002-04  ssp  credit hold rule
 *  1999-07  ssp  Y2K date window
 */

/* bin_lookup.i : Bin lookup helpers. {&NO-BIN-FUNCS} suppresses the functions. */

&IF DEFINED(BIN_LOOKUP_I) = 0 &THEN
&GLOBAL-DEFINE BIN_LOOKUP_I YES

DEFINE BUFFER bLkBin FOR Bin.

FUNCTION BinExists RETURNS LOGICAL (INPUT pBinNum AS INTEGER):
  RETURN CAN-FIND(FIRST bLkBin WHERE bLkBin.BinNum = pBinNum).
END FUNCTION.

FUNCTION BinDesc RETURNS CHARACTER (INPUT pBinNum AS INTEGER):
  FIND FIRST bLkBin NO-LOCK WHERE bLkBin.BinNum = pBinNum NO-ERROR.
  RETURN (IF AVAILABLE bLkBin THEN bLkBin.BinName ELSE "** unknown **").
END FUNCTION.

PROCEDURE find-bin :
  DEFINE INPUT  PARAMETER pBinNum AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER pRowid AS ROWID NO-UNDO.
  FIND FIRST bLkBin NO-LOCK WHERE bLkBin.BinNum = pBinNum NO-ERROR.
  pRowid = IF AVAILABLE bLkBin THEN ROWID(bLkBin) ELSE ?.
END PROCEDURE.

&ENDIF

