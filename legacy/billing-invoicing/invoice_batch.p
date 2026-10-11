/*------------------------------------------------------------------------
    File        : invoice_batch.p
    Purpose     : Nightly Invoice housekeeping
    Module      : Billing & Invoicing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-03  tlw  add lock retry
 *  2002-10  mab  new report column
 *  2014-06  rdh  audit fields
 *  2016-01  ssp  appserver split
 *  2008-12  mab  new report column
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "invoice_batch.log") APPEND.
PUT UNFORMATTED "Invoice batch started " STRING(NOW) SKIP.

FOR EACH Invoice EXCLUSIVE-LOCK
    WHERE Invoice.InvoiceDate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Invoice.Amount < 0 THEN DO:
        PUT UNFORMATTED "Negative Amount on " STRING(Invoice.Invoicenum) SKIP.
        ASSIGN Invoice.Amount = 0 iChanged = iChanged + 1.
    END.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Invoice batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

