/*----------------------------------------------------------------------------
| Routine : sp_assignMessageToOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Assigns a message to an output. So every time the message
|               is generated, it is also sent to these outputs
|
| Parameters :
| ------------
|  IN  : idMessage    : The ID of the message you want to assign
|        idOutput     : The ID of the output you want to send the message to
|
|  OUT : o_code       : Statuscode of the procedure
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : o_exitCode
|   stdReturnValuesUsed : 0 : No error occurred
|   stdReturnValuesUsed : 1062 : When the message is already assigned to the output
|
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_assignMessageToOutput(
  IN i_message INT UNSIGNED,
  IN i_output  INT UNSIGNED,
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
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

    INSERT INTO tblMessageOutput (fiMessage, fiOutput) VALUES
    (i_message, i_output);
  END ??
