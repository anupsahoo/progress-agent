/*------------------------------------------------------------------------
    File        : sysdefs.i
    Purpose     : global session variables for every Sports2000 program
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-02  jkm  fix rounding
 *  2013-03  jkm  Y2K date window
 */

/* sysdefs.i : global session variables for every Sports2000 program */

&IF DEFINED(SYSDEFS_I) = 0 &THEN
&GLOBAL-DEFINE SYSDEFS_I YES
DEFINE NEW GLOBAL SHARED VARIABLE gCompanyName   AS CHARACTER NO-UNDO INITIAL "Sports2000 Inc.".
DEFINE NEW GLOBAL SHARED VARIABLE gUserId        AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gReportDir     AS CHARACTER NO-UNDO INITIAL "/apps/s2k/reports/".
DEFINE NEW GLOBAL SHARED VARIABLE gLogDir        AS CHARACTER NO-UNDO INITIAL "/apps/s2k/logs/".
DEFINE NEW GLOBAL SHARED VARIABLE gMaxLockRetry  AS INTEGER   NO-UNDO INITIAL 3.
DEFINE NEW GLOBAL SHARED VARIABLE gUserCanDelete AS LOGICAL   NO-UNDO.
&ENDIF

