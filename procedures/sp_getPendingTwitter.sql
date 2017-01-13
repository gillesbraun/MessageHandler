/*----------------------------------------------------------------------------
| Routine : sp_getPendingTwitter
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all pending twitter entries and deletes them from the database.
|               This is used by a cronjob to periodically send twitter updates
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
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getPendingTwitter(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', dtConsumerKey, dtConsumerSecret, dtAccessToken, dtAccessTokenSecret, dtMessage)
        SEPARATOR '^')
    FROM tblPendingTwitter, tblOutputTwitter
    WHERE idOutputTwitter = fiOutputTwitter
    INTO o_out;

    DELETE FROM tblPendingTwitter;
  END ??
