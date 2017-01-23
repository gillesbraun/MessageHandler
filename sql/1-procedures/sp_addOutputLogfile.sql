/*----------------------------------------------------------------------------
| Routine : sp_addOutputLogfile
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Creates a new Logfile and attaches it to a given output
|
| Parameters :
| ------------
|  IN  : fiOutput : ID of the output you want to attach this one to
|        dtPath   : Path for the logfile
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_addOutputLogfile(
  IN i_idOutput INT UNSIGNED,
  IN i_dtPath   VARCHAR(255),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN

    -- Foreign key exception
    DECLARE EXIT HANDLER FOR 1452
      BEGIN
        SET o_code = 1452;
        CALL sp_getMsg(3, 'en', '', @m);
        SET o_message = @m;
      END;

    SET o_code = 0;
    SET o_message = "OK";

    INSERT INTO tblOutputLogfile (fiOutput, dtPath) VALUES
      (i_idOutput, i_dtPath);
  END ??