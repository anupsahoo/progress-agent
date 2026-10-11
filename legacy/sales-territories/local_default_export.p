/*------------------------------------------------------------------------
    File        : local_default_export.p
    Purpose     : Export LocalDefault to CSV
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-03  rdh  credit hold rule
 *  2012-08  jkm  credit hold rule
 *  2013-11  mab  remove dead code
 *  2003-09  kpo  appserver split
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRows  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart AS INTEGER NO-UNDO.

iStart = ETIME(YES).
IF pcFile = "" OR pcFile = ? THEN
  pcFile = gReportDir + "local_default_" + STRING(TODAY, "99999999") + ".csv".

OUTPUT TO VALUE(pcFile).
PUT UNFORMATTED "Country,Region1 Label,Region2 Label,Postal Label,Postal Format,Tel Format,Currency Symbol,Date Format,Local Default Num" SKIP.
FOR EACH LocalDefault NO-LOCK
    BY LocalDefault.LocalDefNum:
    EXPORT DELIMITER "," LocalDefault.Country LocalDefault.Region1Label LocalDefault.Region2Label LocalDefault.PostalLabel LocalDefault.PostalFormat LocalDefault.TelFormat LocalDefault.CurrencySymbol LocalDefault.DateFormat LocalDefault.LocalDefNum.
    iRows = iRows + 1.
END.
OUTPUT CLOSE.

/* Control file for the downstream loader */
OUTPUT TO VALUE(pcFile + ".ctl").
PUT UNFORMATTED "TABLE=LocalDefault" SKIP "ROWS=" iRows SKIP "CREATED=" STRING(NOW) SKIP "BY=" gUserId SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "LocalDefault export: " + STRING(iRows) + " rows in " + STRING(ETIME / 1000) + "s").

