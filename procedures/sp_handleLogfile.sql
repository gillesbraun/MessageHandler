/*----------------------------------------------------------------------------
| Routine : sp_handleLogfile
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Handles each logfile output for a given parent output.
|
| Parameters :
| ------------
|   IN : idOutput : The ID of the output
|        body     : The text to send in the email
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_handleLogfile(
  IN i_idOutput INT UNSIGNED,
  IN i_msg      TEXT)
  SQL SECURITY DEFINER
  BEGIN
    DECLARE l_notfound TINYINT DEFAULT FALSE;
    DECLARE l_output INT UNSIGNED;
    DECLARE cur CURSOR FOR SELECT idOutputLogfile FROM tblOutputLogfile WHERE fiOutput = i_idOutput;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_notfound = 1;

    OPEN cur;
    cur_loop: LOOP
      FETCH cur INTO l_output;
      IF l_notfound THEN
        LEAVE cur_loop;
      END IF;

      INSERT INTO tblPendingLog(fiOutputLogfile, dtMsg) VALUES (l_output, i_msg);

    END LOOP;
    CLOSE cur;

  END ??