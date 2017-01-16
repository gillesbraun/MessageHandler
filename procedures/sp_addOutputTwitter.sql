/*----------------------------------------------------------------------------
| Routine : sp_addOutputTwitter
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-12-21
|
| Description : Creates a new Twitter Output and attaches it to a given output
|
| Parameters :
| ------------
|  IN  : i_consumerKey : Twitter Consumer Key
|        i_consumerSecret   : Twitter Consumer Secret
|        i_accessToken   : Twitter Access Token
|        i_accessTokenSecret   : Twitter Access Token Secret
|        i_output   : Path for the logfile
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_addOutputTwitter(
  IN i_output INT UNSIGNED,
  IN i_consumerKey CHAR(25),
  IN i_consumerSecret CHAR(50),
  IN i_accessToken CHAR(50),
  IN i_accessTokenSecret CHAR(45),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN

    SET o_code = 0;
    SET o_message = "OK";

    INSERT INTO tblOutputTwitter(dtConsumerKey, dtConsumerSecret, dtAccessToken, dtAccessTokenSecret, fiOutput) VALUE
      (i_consumerKey, i_consumerSecret, i_accessToken, i_accessTokenSecret, i_output);
  END ??