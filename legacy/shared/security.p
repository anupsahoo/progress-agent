/*------------------------------------------------------------------------
    File        : security.p
    Purpose     : program level authorisation
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-09  ssp  new report column
 *  2007-07  rdh  performance: use index
 *  2004-01  tlw  new report column
 *  2005-08  tlw  appserver split
 *  2013-04  rdh  credit hold rule
 */

/* security.p : program level authorisation */

DEFINE INPUT  PARAMETER pcProgram AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER plAllowed AS LOGICAL   NO-UNDO.
{shared/sysdefs.i}

plAllowed = CAN-DO("*", gUserId).
IF NOT plAllowed THEN
  MESSAGE "You are not authorised to run " pcProgram VIEW-AS ALERT-BOX ERROR.

