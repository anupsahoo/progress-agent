/*------------------------------------------------------------------------
    File        : feedback_report.p
    Purpose     : Feedback listing with control-break totals
    Module      : Customer Management
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 03/14/1999
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2014-04  rdh  remove dead code
 *  2010-12  kpo  new report column
 *  2012-04  mab  performance: use index
 *  2005-10  rdh  new report column
 *  1999-04  rdh  remove dead code
 */

{shared/sysdefs.i}

DEFINE INPUT PARAMETER pcDest AS CHARACTER NO-UNDO.

DEFINE STREAM sRpt.
DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotRating AS DECIMAL NO-UNDO FORMAT "->>>,>>>,>>9.99".

FORM HEADER
    gCompanyName FORMAT "x(40)" AT 1
    "Feedback Report" AT 50
    "Page" AT 110 PAGE-NUMBER(sRpt) FORMAT ">>>9"
    SKIP "Run" TODAY STRING(TIME, "HH:MM") SKIP(1)
    WITH FRAME fHdr PAGE-TOP NO-BOX WIDTH 132 STREAM-IO.

IF pcDest = "PRINTER" THEN OUTPUT STREAM sRpt TO PRINTER PAGED PAGE-SIZE 60.
ELSE OUTPUT STREAM sRpt TO VALUE(gReportDir + "feedback_" + STRING(TODAY, "99999999") + ".txt") PAGED PAGE-SIZE 60.

VIEW STREAM sRpt FRAME fHdr.

FOR EACH Feedback NO-LOCK
    BREAK BY Feedback.Contact:
    iCount = iCount + 1.
    ACCUMULATE Feedback.Rating (TOTAL SUB-TOTAL BY Feedback.Contact).
    IF FIRST-OF(Feedback.Contact) THEN
        PUT STREAM sRpt UNFORMATTED SKIP(1) "Contact Name: " Feedback.Contact SKIP.
    DISPLAY STREAM sRpt Feedback.Contact Feedback.Company Feedback.EmailAddress Feedback.Phone Feedback.Fax Feedback.Comments Feedback.Department
        WITH FRAME fDet DOWN WIDTH 132 NO-BOX STREAM-IO.
    IF LAST-OF(Feedback.Contact) THEN DO:
        PUT STREAM sRpt UNFORMATTED "  Subtotal Rating: " STRING(ACCUM SUB-TOTAL BY Feedback.Contact Feedback.Rating, "->>>,>>>,>>9.99") SKIP.
    END.
END.

dTotRating = ACCUM TOTAL Feedback.Rating.
PUT STREAM sRpt UNFORMATTED SKIP(2) "Records: " iCount SKIP.
PUT STREAM sRpt UNFORMATTED "Total Rating: " STRING(dTotRating, "->>>,>>>,>>9.99") SKIP.
OUTPUT STREAM sRpt CLOSE.

