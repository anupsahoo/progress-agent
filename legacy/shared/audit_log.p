/*------------------------------------------------------------------------
    File        : audit_log.p
    Purpose     : append an audit record
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-02  rdh  Y2K date window
 *  2011-10  jkm  fix rounding
 *  2010-09  kpo  remove dead code
 *  2006-09  kpo  credit hold rule
 *  2012-06  tlw  appserver split
 */

/* audit_log.p : append an audit record */

DEFINE INPUT PARAMETER pcWhat AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcOld  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcNew  AS CHARACTER NO-UNDO.
{shared/sysdefs.i}

OUTPUT TO VALUE(gLogDir + "audit.log") APPEND.
PUT UNFORMATTED STRING(NOW) "~t" gUserId "~t" pcWhat "~t" pcOld "~t" pcNew SKIP.
OUTPUT CLOSE.

