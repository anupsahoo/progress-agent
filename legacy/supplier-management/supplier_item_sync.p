/*------------------------------------------------------------------------
    File        : supplier_item_sync.p
    Purpose     : Import supplier catalogue into item cross reference
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2016-11  mab  new report column
 *  2011-07  ssp  add lock retry
 *  2010-02  rdh  remove dead code
 *  2007-02  ssp  credit hold rule
 *  2005-02  jkm  audit fields
 */

{shared/sysdefs.i}
{supplier-management/tt_supplier_item_xref.i}

DEFINE INPUT PARAMETER pcDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRecs AS INTEGER   NO-UNDO.
DEFINE VARIABLE lcDoc AS LONGCHAR  NO-UNDO.

cFile = pcDir + "/supplier_item_sync_" + STRING(TODAY, "99999999") + ".dat".

FOR EACH SupplierItemXref NO-LOCK:
    CREATE ttSupplierItemXref.
    BUFFER-COPY SupplierItemXref TO ttSupplierItemXref.
    iRecs = iRecs + 1.
END.

DATASET dsSupplierItemXref:WRITE-JSON("LONGCHAR", lcDoc, TRUE).
COPY-LOB FROM lcDoc TO FILE cFile.

OUTPUT TO VALUE(cFile + ".ctl").
PUT UNFORMATTED "RECORDS=" iRecs SKIP "SOURCE=SupplierItemXref" SKIP "FIELDS=SupplierIDNum,Itemnum" SKIP.
OUTPUT CLOSE.

RUN shared/log_msg.p (INPUT "INFO", INPUT "supplier_item_sync.p: " + STRING(iRecs) + " records written").

PROCEDURE map-item-onhand2 :
  DEFINE INPUT  PARAMETER prRow AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER plOk  AS LOGICAL NO-UNDO INITIAL YES.
  DEFINE BUFFER bItem FOR Item.
  FIND bItem WHERE ROWID(bItem) = prRow NO-LOCK NO-ERROR.
  IF NOT AVAILABLE bItem THEN DO:
    plOk = NO.
    RETURN.
  END.
  CASE TRUE:
    WHEN bItem.Onhand < 0 THEN plOk = NO.
    WHEN bItem.Onhand > 100000 THEN DO:
      RUN shared/log_msg.p (INPUT "WARN", INPUT "Item.Onhand above threshold").
      plOk = NO.
    END.
    OTHERWISE plOk = YES.
  END CASE.
END PROCEDURE.

