/*----------------------------------------------------------------------------
| Routine : sp_getMessageInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets a message translation from the DB and replaces the placeholders
|               with the given placeholder parameters.
|               No transaction here because it is called by procedures that already
|               have open transactions.
|
| Parameters :
| ------------
|   IN : idMessage  : The ID of the message
|        idLanguage : The ID of the language
|        replace    : The replacement for the placeholders. To replace multiple
|                     placeholders, separate them using #!
|
|  OUT : o_out      : The finished message
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_getMsg, sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getMessageInLanguage(
  IN  i_idMessage  INT UNSIGNED,
  IN  i_idLanguage CHAR(2),
  IN  i_replace    TEXT,
  OUT o_out        VARCHAR(500))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE l_positionM, l_positionR INT;
    DECLARE l_message VARCHAR(500);
    DECLARE l_rep VARCHAR(500);

    SELECT dtMessageInLanguage
    FROM tblMessageInLanguage
    WHERE fiMessage = i_idMessage AND fiLanguage = i_idLanguage
    INTO l_message
    LOCK IN SHARE MODE;

    IF ( l_message IS NULL ) THEN
      SET o_out = CONCAT('FATAL ERROR: Message has no translation for language ', i_idLanguage, '!');
    ELSE
      search_loop: LOOP
        IF i_replace IS NULL THEN
          LEAVE search_loop;
        END IF;
        SET l_positionM = LOCATE('#!', l_message); -- searches for the first occurence of delimiter in msg
        SET l_positionR = LOCATE('#!', i_replace); -- searches for first occurence of delimiter in replace string
        IF (l_positionM = 0) -- When there is no placeholder in message left
        THEN
          LEAVE search_loop;
        END IF;
        IF (l_positionR = 0) -- When replace string is only one word, so no delimiter
        THEN
          SET l_rep = i_replace; -- uses whole string as first replace string
        ELSE
          SET l_rep = LEFT(i_replace, l_positionR - 1); -- uses first replacement from the string
        END IF;

        SET l_message = CONCAT(LEFT(l_message, l_positionM - 1), -- get everything left of the placeholder
                               l_rep, -- insert replacement
                               SUBSTR(l_message, l_positionM + 2)); -- append rest of message
        SET i_replace = RIGHT(i_replace, CHAR_LENGTH(i_replace) - l_positionR -
                                         1); -- removes the used replacement from replace string

      END LOOP;
      CALL sp_getMessageTypeOfMessage(i_idMessage, @type, @result_code, @result_message);
      CALL sp_getMessageTypeInLanguage(@type, i_idLanguage, @typelang, @result_code, @result_message);
      SET o_out = CONCAT(IFNULL(CONCAT(@typelang, ': '), ''),l_message);
    END IF;
  END ??
