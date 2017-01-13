/*----------------------------------------------------------------------------
| Routine : sp_handleOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Handles every child output
|
| Parameters :
| ------------
|   IN : idMessage : The ID of the message
|        replace   : The text to write to the logfile
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_getMessageInLanguage
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_handleOutput(
  IN i_idMessage INT UNSIGNED,
  IN i_replace   TEXT
)
  BEGIN
    DECLARE l_idOutput TEXT;
    DECLARE l_stop TINYINT DEFAULT FALSE;
    DECLARE l_num_emails INT UNSIGNED;
    DECLARE l_num_logs INT UNSIGNED;
    DECLARE l_num_twitters INT UNSIGNED;

    DECLARE cur CURSOR FOR SELECT fiOutput
                           FROM tblMessageOutput
                           WHERE fiMessage = i_idMessage;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_stop = TRUE;

    OPEN cur;
    output_loop: LOOP
      FETCH cur
      INTO l_idOutput;
      IF l_stop
      THEN
        LEAVE output_loop;
      END IF;

      CALL sp_getLanguageOfOutput(l_idOutput, @lang);
      CALL sp_getMessageInLanguage(i_idMessage, @lang, i_replace, @msg);

      SELECT COUNT(*) FROM tblEmail WHERE fiOutput = l_idOutput INTO l_num_emails;
      IF l_num_emails > 0 THEN
        CALL sp_handleLogfile(l_idOutput, @msg);
      END IF;

      SELECT COUNT(*) FROM tblLogfile WHERE fiOutput = l_idOutput INTO l_num_logs;
      IF l_num_logs > 0 THEN
        CALL sp_handleEmail(l_idOutput, @msg);
      END IF;

      SELECT COUNT(*) FROM tblOutputTwitter WHERE fiOutput = l_idOutput INTO l_num_twitters;
      IF l_num_twitters > 0 THEN
        CALL sp_handleTwitter(l_idOutput, @msg);
      END IF;

    END LOOP;
    CLOSE cur;
  END ??
