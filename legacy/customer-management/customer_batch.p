/*------------------------------------------------------------------------
    File        : customer_batch.p
    Purpose     : Nightly Customer housekeeping
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2007-04  kpo  fix rounding
 *  2008-12  tlw  audit fields
 *  2013-11  tlw  appserver split
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "customer_batch.log") APPEND.
PUT UNFORMATTED "Customer batch started " STRING(NOW) SKIP.

FOR EACH Customer EXCLUSIVE-LOCK
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Customer.CreditLimit < 0 THEN DO:
        PUT UNFORMATTED "Negative Credit Limit on " STRING(Customer.CustNum) SKIP.
        ASSIGN Customer.CreditLimit = 0 iChanged = iChanged + 1.
    END.
    IF Customer.Country <> TRIM(Customer.Country) THEN
        ASSIGN Customer.Country = TRIM(Customer.Country) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Customer batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

