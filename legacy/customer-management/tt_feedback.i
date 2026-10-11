/*------------------------------------------------------------------------
    File        : tt_feedback.i
    Purpose     : temp-table and dataset for Feedback (AppServer transport)
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2006-02  rdh  remove dead code
 *  2012-06  jkm  fix rounding
 */

/* tt_feedback.i : temp-table and dataset for Feedback (AppServer transport) */

DEFINE TEMP-TABLE ttFeedback NO-UNDO BEFORE-TABLE btFeedback
    FIELD Contact AS CHARACTER FORMAT "x(30)" LABEL "Contact Name"
    FIELD Company AS CHARACTER FORMAT "x(20)" LABEL "Company"
    FIELD EmailAddress AS CHARACTER FORMAT "x(50)" LABEL "Email"
    FIELD Phone AS CHARACTER FORMAT "x(20)" LABEL "Phone"
    FIELD Fax AS CHARACTER FORMAT "x(20)" LABEL "Fax"
    FIELD Comments AS CHARACTER FORMAT "x(80)" LABEL "Comments"
    FIELD Department AS CHARACTER FORMAT "x(15)" LABEL "Department"
    FIELD Rating AS INTEGER FORMAT "9" LABEL "Rating"
    FIELD RowState AS CHARACTER
    FIELD ErrorMsg AS CHARACTER
    INDEX Department IS PRIMARY Department
    INDEX Rating Rating
    .

DEFINE TEMP-TABLE ttFeedbackErr NO-UNDO
    FIELD RowNum   AS INTEGER
    FIELD FieldName AS CHARACTER
    FIELD ErrorText AS CHARACTER
    INDEX ixRow IS PRIMARY RowNum.

DEFINE DATASET dsFeedback FOR ttFeedback.

