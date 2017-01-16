/*----------------------------------------------------------------------------
| Routine : sp_handleTwitter
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-12-21
|
| Description : Handles each Twitter output for a given parent output.
|
| Parameters :
| ------------
|   IN : idOutput : The ID of the output
|        body     : The text to send
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_handleTwitter(
  IN i_idOutput INT UNSIGNED,
  IN i_msg      TEXT)
  SQL SECURITY DEFINER
  BEGIN
    DECLARE l_notfound TINYINT DEFAULT FALSE;
    DECLARE l_output INT UNSIGNED;

    DECLARE cur CURSOR FOR SELECT idOutputTwitter FROM tblOutputTwitter WHERE fiOutput = i_idOutput;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_notfound = 1;

    OPEN cur;
    cur_loop: LOOP
      FETCH cur INTO l_output;
      IF l_notfound THEN
        LEAVE cur_loop;
      END IF;

      INSERT INTO tblPendingTwitter (dtMessage, fiOutputTwitter) VALUE (i_msg, l_output);

    END LOOP;
    CLOSE cur;

  END ??