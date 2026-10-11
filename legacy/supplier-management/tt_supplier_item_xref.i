/*------------------------------------------------------------------------
    File        : tt_supplier_item_xref.i
    Purpose     : temp-table and dataset for SupplierItemXref (AppServer transport)
    Module      : Supplier Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-11  jkm  appserver split
 *  2015-03  kpo  Y2K date window
 *  2015-07  jkm  appserver split
 *  1999-02  jkm  credit hold rule
 *  2004-10  mab  remove dead code
 */

/* tt_supplier_item_xref.i : temp-table and dataset for SupplierItemXref (AppServer transport) */

DEFINE TEMP-TABLE ttSupplierItemXref NO-UNDO BEFORE-TABLE btSupplierItemXref
    FIELD SupplierIDNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Supplier ID"
    FIELD Itemnum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Item #"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX SupplieridItemNum IS PRIMARY UNIQUE SupplierIDNum Itemnum
    INDEX ItemNumSupplierID UNIQUE Itemnum SupplierIDNum
    .

DEFINE TEMP-TABLE ttSupplierItemXrefErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsSupplierItemXref FOR ttSupplierItemXref.

