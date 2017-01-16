/*----------------------------------------------------------------------------
| Routine : sp_handleEmail
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Handles each email output for a given parent output.
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
PROCEDURE sp_handleEmail(
  IN i_idOutput INT UNSIGNED,
  IN i_body     TEXT)
  SQL SECURITY DEFINER
  BEGIN
    DECLARE l_emailID INT UNSIGNED;
    DECLARE l_notfound TINYINT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT
                             idOutputEmail
                           FROM tblOutputEmail
                           WHERE fiOutput = i_idOutput;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_notfound = TRUE;

    OPEN cur;
    cur_loop: LOOP
      FETCH cur INTO l_emailID;

      IF (l_notfound = 1) THEN
        LEAVE cur_loop;
      END IF;

      IF (l_emailID IS NOT NULL)
      THEN
        INSERT INTO tblPendingEmail(fiOutputEmail, dtBody) VALUES (l_emailID, i_body);
      END IF;
    END LOOP;

    CLOSE cur;
  END ??
