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
    DECLARE t_deadlock_timeout INT DEFAULT 0;
    DECLARE t_attempts INT DEFAULT 0;

    -- Foreign key exception
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
      SET o_code = 1452;
      CALL sp_getMsg(3, 'en', '', @m);
      SET o_message = @m;
    END;

    SET o_code = 0;
    SET o_message = "OK";

    -- Deadlock retry loop
    tra_loop:WHILE (t_attempts < 3) DO
      BEGIN
        DECLARE deadlock_detected CONDITION FOR 1213;
        DECLARE timeout_detected CONDITION FOR 1205;
        DECLARE EXIT HANDLER FOR deadlock_detected, timeout_detected
        BEGIN
          ROLLBACK;
          SET t_deadlock_timeout=1;
        END;
        SET t_deadlock_timeout=0;

        START TRANSACTION;

        INSERT INTO tblOutputTwitter(dtConsumerKey, dtConsumerSecret, dtAccessToken, dtAccessTokenSecret, fiOutput) VALUE
          (i_consumerKey, i_consumerSecret, i_accessToken, i_accessTokenSecret, i_output);
        COMMIT;

      END;
      IF t_deadlock_timeout = 0 THEN -- No deadlock or timeout, exit loop
        LEAVE tra_loop;
      ELSE
        SET t_attempts = t_attempts + 1;
      END IF;
    END WHILE tra_loop;

    IF t_deadlock_timeout = 1 THEN -- attempt resulted in deadlock
      SET o_code = 1;
      CALL sp_getMsg(1, 'en', t_attempts, o_message);
    END IF;

  END ??
