/*----------------------------------------------------------------------------
| Routine : sp_updateMessageDescription
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Updates a messages' description.
|
| Parameters :
| ------------
|  IN  : idMessage     : The ID of the message you want to remove
|        dtDescription : The new description
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_updateMessageDescription(
  IN i_idMessage   INT UNSIGNED,
  IN i_desc VARCHAR(255))
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblMessage
    SET dtDescription = i_desc
    WHERE idMessage = i_idMessage;
  END ??
