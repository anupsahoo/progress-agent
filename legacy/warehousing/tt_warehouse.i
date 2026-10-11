/*------------------------------------------------------------------------
    File        : tt_warehouse.i
    Purpose     : temp-table and dataset for Warehouse (AppServer transport)
    Module      : Warehousing
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 02/17/2012
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2003-09  jkm  Y2K date window
 *  2011-07  jkm  add lock retry
 *  2014-09  rdh  performance: use index
 *  2008-07  mab  new report column
 *  2001-01  jkm  new report column
 */

/* tt_warehouse.i : temp-table and dataset for Warehouse (AppServer transport) */

DEFINE TEMP-TABLE ttWarehouse NO-UNDO BEFORE-TABLE btWarehouse
    FIELD WarehouseNum AS INTEGER FORMAT "zzzzzzzzz9" LABEL "Warehouse Num"
    FIELD WarehouseName AS CHARACTER FORMAT "x(30)" LABEL "Warehouse Name"
    FIELD Country AS CHARACTER FORMAT "x(20)" LABEL "Country"
    FIELD Address AS CHARACTER FORMAT "x(35)" LABEL "Address"
    FIELD Address2 AS CHARACTER FORMAT "x(35)" LABEL "Address2"
    FIELD City AS CHARACTER FORMAT "x(25)" LABEL "City"
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD PostalCode AS CHARACTER FORMAT "x(10)" LABEL "Postal Code"
    FIELD Phone AS CHARACTER FORMAT "x(20)" LABEL "Phone"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX warehousenum IS PRIMARY UNIQUE WarehouseNum
    INDEX warehousename WarehouseName
    .

DEFINE TEMP-TABLE ttWarehouseErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsWarehouse FOR ttWarehouse.

