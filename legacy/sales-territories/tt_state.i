/*------------------------------------------------------------------------
    File        : tt_state.i
    Purpose     : temp-table and dataset for State (AppServer transport)
    Module      : Sales & Territories
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 11/02/2001
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2010-09  tlw  Y2K date window
 */

/* tt_state.i : temp-table and dataset for State (AppServer transport) */

DEFINE TEMP-TABLE ttState NO-UNDO BEFORE-TABLE btState
    FIELD State AS CHARACTER FORMAT "x(20)" LABEL "State"
    FIELD StateName AS CHARACTER FORMAT "x(20)" LABEL "State Name"
    FIELD Region AS CHARACTER FORMAT "x(8)" LABEL "Region"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX State IS PRIMARY UNIQUE State
    .

DEFINE TEMP-TABLE ttStateErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsState FOR ttState.

