/*------------------------------------------------------------------------
    File        : dateutil.i
    Purpose     : date helpers
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  1999-03  rdh  performance: use index
 *  2009-05  kpo  credit hold rule
 *  2011-03  mab  add lock retry
 */

/* dateutil.i : date helpers */

FUNCTION fnMonthEnd RETURNS DATE (INPUT pt AS DATE):
  RETURN DATE(MONTH(pt) MOD 12 + 1, 1, YEAR(pt) + (IF MONTH(pt) = 12 THEN 1 ELSE 0)) - 1.
END FUNCTION.

FUNCTION fnAgeDays RETURNS INTEGER (INPUT pt AS DATE):
  RETURN TODAY - pt.
END FUNCTION.

