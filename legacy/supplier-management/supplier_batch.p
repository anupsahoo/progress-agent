/*------------------------------------------------------------------------
    File        : supplier_batch.p
    Purpose     : Nightly Supplier housekeeping
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
    Schedule     : cron 02:15 via shared/batch_runner.p
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2009-02  jkm  performance: use index
 *  2016-10  jkm  new report column
 *  2012-06  jkm  remove dead code
 */

{shared/sysdefs.i}
{shared/lockretry.i}

DEFINE VARIABLE iRead    AS INTEGER NO-UNDO.
DEFINE VARIABLE iChanged AS INTEGER NO-UNDO.
DEFINE VARIABLE iErrors  AS INTEGER NO-UNDO.
DEFINE VARIABLE iStart   AS INTEGER NO-UNDO.

iStart = ETIME(YES).
OUTPUT TO VALUE(gLogDir + "supplier_batch.log") APPEND.
PUT UNFORMATTED "Supplier batch started " STRING(NOW) SKIP.

FOR EACH Supplier EXCLUSIVE-LOCK
    WHERE Supplier.LoginDate <> ?
    ON ERROR UNDO, NEXT:
    iRead = iRead + 1.
    IF Supplier.ShipAmount < 0 THEN DO:
        PUT UNFORMATTED "Negative Ship Amount on " STRING(Supplier.SupplierIDNum) SKIP.
        ASSIGN Supplier.ShipAmount = 0 iChanged = iChanged + 1.
    END.
    IF Supplier.Name <> TRIM(Supplier.Name) THEN
        ASSIGN Supplier.Name = TRIM(Supplier.Name) iChanged = iChanged + 1.
    IF iRead MOD 500 = 0 THEN
        PUT UNFORMATTED "  progress " iRead " read" SKIP.
END.

PUT UNFORMATTED "Supplier batch finished: " iRead " read, " iChanged " changed, " iErrors " errors in " ETIME / 1000 "s" SKIP.
OUTPUT CLOSE.
RETURN STRING(iErrors).

