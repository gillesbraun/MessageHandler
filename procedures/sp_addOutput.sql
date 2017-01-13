
/*----------------------------------------------------------------------------
| Routine : sp_addOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds an Output in a given language. One Output always has a language.
|               After adding the Output, you can attach other Outputs to this output, like logfile.
|               It is possible to add different messages that will always be put out using this output.
|
| Parameters :
| ------------
|  IN  : fiUser       : The owner's username of the output
|        fiLanguage   : ISO 639-1 code of the language
|        dtName       : Name for the output
|
|  OUT : o_code       : ID of the newly created output
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_addOutput(
  IN  i_idUser     VARCHAR(32),
  IN  i_idLanguage CHAR(2),
  IN  i_dtName     VARCHAR(255),
  OUT o_outputID   INT UNSIGNED,
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN
    DECLARE dup CONDITION FOR 1062;
    DECLARE CONTINUE HANDLER FOR dup
    BEGIN
      SET o_code = 1062;
      CALL sp_getMsg(2, 'en', '', @msg);
      SET o_message = @msg;
    END;

    SET o_code = 0;
    SET o_message = "";

    INSERT INTO tblOutput (fiUser, fiLanguage, dtName) VALUES
      (i_idUser, i_idLanguage, i_dtName);

    SELECT idOutput
    FROM tblOutput
    WHERE dtName = i_dtName
    INTO o_outputID;
  END ??
