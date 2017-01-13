/*----------------------------------------------------------------------------
| Routine : sp_addOutputEmail
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Creates a new EmailOutput and attaches it to an Output.
|
| Parameters :
| ------------
|  IN  : fiOutput    : ID of the output you want to attach this one to
|        dtSubject   : Subject of the email
|        dtRecipient : email address of the one who receives the email
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_addOutputEmail(
  IN i_idOutput    INT UNSIGNED,
  IN i_dtSubject   VARCHAR(100),
  IN i_dtRecipient VARCHAR(50),
  OUT o_code        SMALLINT UNSIGNED,
  OUT o_message     VARCHAR(100))
  SQL SECURITY DEFINER
  BEGIN

    SET o_code = 0;
    SET o_message = "OK";

    INSERT INTO tblEmail (fiOutput, dtSubject, dtRecipient) VALUES
      (i_idOutput, i_dtSubject, i_dtRecipient);
  END ??
