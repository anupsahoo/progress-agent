/*------------------------------------------------------------------------
    File        : inventory_trans_report.p
    Purpose     : InventoryTrans listing with control-break totals
    Module      : Inventory
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 09/09/2008
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2008-03  kpo  appserver split
 *  2004-11  tlw  credit hold rule
 *  2003-01  jkm  performance: use index
 *  2001-05  mab  add lock retry
 *  2016-05  ssp  new report column
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotQty AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "InventoryTrans Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "inventory_trans_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH InventoryTrans NO-LOCK
    BREAK BY InventoryTrans.InvType:
    iCount = iCount + 1.
    ACCUMULATE InventoryTrans.Qty (TOTAL SUB-TOTAL BY InventoryTrans.InvType).
    IF FIRST-OF(InventoryTrans.InvType) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Type: " InventoryTrans.InvType SKIP.
    DISPLAY STREAM sRpt InventoryTrans.InvTransNum InventoryTrans.WarehouseNum InventoryTrans.BinNum InventoryTrans.Qty InventoryTrans.Itemnum InventoryTrans.TransDate InventoryTrans.InvType
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(InventoryTrans.InvType) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Qty: " STRING(ACCUM SUB-TOTAL BY InventoryTrans.InvType InventoryTrans.Qty, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotQty = ACCUM TOTAL InventoryTrans.Qty.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Qty: " STRING(dTotQty, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

