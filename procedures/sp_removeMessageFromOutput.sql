/*----------------------------------------------------------------------------
| Routine : sp_removeMessageFromOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Removes a given message from being put out to the given output
|
| Parameters :
| ------------
|   IN : idOutput : The ID of the message
|        text     : The ID of the output
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_removeMessageFromOutput(
  IN  i_idMessage INT UNSIGNED,
  IN  i_idOutput  INT UNSIGNED)
  SQL SECURITY DEFINER
  BEGIN
    DELETE FROM tblMessageOutput WHERE fiMessage = i_idMessage AND fiOutput = i_idOutput;
  END ??
