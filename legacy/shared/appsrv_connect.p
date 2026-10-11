/*------------------------------------------------------------------------
    File        : appsrv_connect.p
    Purpose     : connect to the Sports2000 AppServer
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2002-03  rdh  Y2K date window
 *  1999-10  mab  Y2K date window
 *  2001-12  jkm  credit hold rule
 */

/* appsrv_connect.p : connect to the Sports2000 AppServer */

DEFINE OUTPUT PARAMETER phServer AS HANDLE NO-UNDO.
CREATE SERVER phServer.
phServer:CONNECT("-AppService s2kbroker -H appsrv01 -S 5162") NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  RUN shared/log_msg.p (INPUT "ERROR", INPUT "AppServer connect failed").

