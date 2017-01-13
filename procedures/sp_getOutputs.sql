/*----------------------------------------------------------------------------
| Routine : sp_getOutputs
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all outputs.
|
| Parameters :
| ------------
|  OUT : o_out      : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getOutputs(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idOutput, dtName, fiUser, fiLanguage, dtCreatedTS, IFNULL(dtUpdatedTS, ''))
        SEPARATOR '^')
    FROM tblOutput
    INTO o_out;
  END ??
