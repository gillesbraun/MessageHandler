/*----------------------------------------------------------------------------
| Routine : sp_addMessage
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Adds a new message to the DB.
|
| Parameters :
| ------------
|  IN  : dtDescription : Description of the new message
|        fiMessageType : The Type of the message as defined in MessageType
|        fiUser        : The Username of the creator
|
|  OUT : o_id          : ID of the new Message
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_id
|   stdReturnValuesUsed : Integer of the new message
|
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_addMessage(
  IN  i_desc          VARCHAR(255),
  IN  i_idMessageType CHAR(1),
  IN  i_idUser        VARCHAR(32),
  OUT o_id          INT UNSIGNED,
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

    START TRANSACTION;

    INSERT INTO tblMessage (dtDescription, fiMessageType, fiUser)
    VALUES (i_desc, i_idMessageType, i_idUser);

    SELECT idMessage
    FROM tblMessage
    WHERE dtDescription = i_desc
    INTO o_id;

    COMMIT;

  END ??
