/*------------------------------------------------------------------------
    File        : msgbox.i
    Purpose     : message helpers
    Module      : Shared services
    Syntax      :
    Description : Sports2000 Enterprise back office (sample estate)
    Author(s)   : Sports2000 IS
    Created     : 06/21/2004
  ----------------------------------------------------------------------*/

/* Change log
 * --------
 *  2011-08  rdh  new report column
 */

/* msgbox.i : message helpers */

&GLOBAL-DEFINE MSG-INFO VIEW-AS ALERT-BOX INFORMATION TITLE "Sports2000"
&GLOBAL-DEFINE MSG-ERROR VIEW-AS ALERT-BOX ERROR TITLE "Sports2000"
&GLOBAL-DEFINE MSG-WARN VIEW-AS ALERT-BOX WARNING TITLE "Sports2000"

FUNCTION fnConfirm RETURNS LOGICAL (INPUT pcText AS CHARACTER):
  DEFINE VARIABLE lYes AS LOGICAL NO-UNDO.
  IF SESSION:BATCH-MODE THEN RETURN YES.
  MESSAGE pcText VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lYes.
  RETURN lYes.
END FUNCTION.

PROCEDURE show-info :
  DEFINE INPUT PARAMETER pcText AS CHARACTER NO-UNDO.
  IF SESSION:BATCH-MODE THEN RUN shared/log_msg.p (INPUT "INFO", INPUT pcText).
  ELSE MESSAGE pcText {&MSG-INFO}.
END PROCEDURE.

