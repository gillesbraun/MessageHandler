/*----------------------------------------------------------------------------
| Routine : sp_addMessageInLanguage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a translation for a given message for a language.
|
| Parameters :
| ------------
|  IN  : idMessage  : ID of the message to be translated
|        idLanguage : Language the translation is in. Language ID format: ISO 639-1
|        dtMessage  : The translation including the placeholders with the format #!.
|                     The placeholders can be replaced when the message is output.
|
|  OUT : o_code       : Statuscode of the procedure
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_code
|   stdReturnValuesUsed : 1062 : This code is set when the id of
|                                the language already exists in the DB
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_addMessageInLanguage(
  IN i_idMessage  INT UNSIGNED,
  IN i_idLanguage CHAR(2),
  IN i_message    VARCHAR(500),
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
    SET o_message = "OK";

    INSERT INTO tblMessageInLanguage (fiMessage, fiLanguage, dtMessageInLanguage)
    VALUES (i_idMessage, i_idLanguage, i_message);

  END ??
