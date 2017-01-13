/*----------------------------------------------------------------------------
| Routine : sp_getOutputsLogfile
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all Logfile outputs for a given Parent Output ID.
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
PROCEDURE sp_getOutputsLogfile(
  IN  i_idOutput INT UNSIGNED,
  OUT o_out TEXT
)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idLogfile, dtPath)
        SEPARATOR '^')
    FROM tblLogfile
    WHERE fiOutput = i_idOutput
    INTO o_out;
  END ??
