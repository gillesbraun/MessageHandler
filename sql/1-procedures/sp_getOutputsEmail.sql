/*----------------------------------------------------------------------------
| Routine : sp_getOutputsEmail
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2017-01-24
|
| Description : Returns all Email outputs for a given Parent Output ID.
|
| Parameters :
| ------------
|  OUT : o_out      : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getOutputsEmail(
  IN  i_idOutput INT UNSIGNED,
  OUT o_out TEXT
)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idOutputEmail, dtSubject, dtRecipient)
        SEPARATOR '^')
    FROM tblOutputEmail
    WHERE fiOutput = i_idOutput
    INTO o_out;
  END ??
