/*------------------------------------------------------------------------
    File        : numutil.i
    Purpose     : numeric helpers
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2017-04  jkm  appserver split
 */

/* numutil.i : numeric helpers */

FUNCTION fnRound2 RETURNS DECIMAL (INPUT pd AS DECIMAL):
  RETURN ROUND(pd, 2).
END FUNCTION.

FUNCTION fnPct RETURNS DECIMAL (INPUT pdPart AS DECIMAL, INPUT pdWhole AS DECIMAL):
  IF pdWhole = 0 THEN RETURN 0.
  RETURN ROUND(pdPart / pdWhole * 100, 2).
END FUNCTION.

