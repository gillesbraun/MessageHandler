/*----------------------------------------------------------------------------
| Routine : sp_getOutputsTwitter
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2017-01-24
|
| Description : Returns all Twitter outputs for a given Parent Output ID.
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
PROCEDURE sp_getOutputsTwitter(
  IN  i_idOutput INT UNSIGNED,
  OUT o_out TEXT
)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idOutputTwitter, dtConsumerKey, dtConsumerSecret, dtAccessToken, dtConsumerSecret)
        SEPARATOR '^')
    FROM tblOutputTwitter
    WHERE fiOutput = i_idOutput
    INTO o_out;
  END ??
