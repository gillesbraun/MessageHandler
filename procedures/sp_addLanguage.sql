/*----------------------------------------------------------------------------
| Routine : sp_addLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a language into the database.
|
| Parameters :
| ------------
|  IN  : idLanguage   : ISO 639-1 code of the language
|        dtName       : Name of language in English
|        dtLocalName  : Name of language in that language
|
|  OUT : o_code       : Statuscode of the procedure
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_code
|   stdReturnValuesUsed : 1062 : This code is set when the id of
|                                the language already exists in the DB
|   stdReturnValuesUsed : 1213 : This code is set when a deadlock occurred
|                                and failed after 3 attempts.
|
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_addLanguage(
  IN  i_idLanguage  CHAR(2),
  IN  i_dtName      VARCHAR(100),
  IN  i_dtLocalName VARCHAR(100),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE deadlockOccured INT DEFAULT 0;
    DECLARE nbrOfAttempts INT DEFAULT 0;

    DECLARE dup_key CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR dup_key
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg);
      SET o_message = @msg;
    END;
    SET o_code = 0;
    SET o_message = "";

    -- Start a loop to try the transaction 3 times
    tra_loop: WHILE (nbrOfAttempts < 3) DO
      BEGIN
        -- Define an exit handler when deadlock occurs.
        DECLARE deadlock CONDITION FOR 1213;
        DECLARE EXIT HANDLER FOR deadlock
          BEGIN
            SET deadlockOccured = 1;
            ROLLBACK;
          END;


        START TRANSACTION;
        -- Do the action

        INSERT INTO tblLanguage (idLanguage, dtName, dtLocalizedName) VALUES
          (i_idLanguage, i_dtName, i_dtLocalName);

        COMMIT;

      END;
      -- End of the block where deadlocks can occur

      IF deadlockOccured = 0 THEN
        -- Leave when no deadlock occured
        LEAVE tra_loop;
      ELSE
        -- Try again if deadlock occured
        SET nbrOfAttempts = nbrOfAttempts + 1;
      END IF;
    END WHILE tra_loop;

    IF deadlockOccured = 1 THEN
      CALL sp_getMsg(1, 'en', '3', @msg);
      SET o_message = @msg;
      SET o_code = 1213;
    END IF;

  END ??
