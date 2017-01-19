/*----------------------------------------------------------------------------
| Routine : sp_getLanguageOfOutput
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Gets the language ID for the given output ID.
|
| Parameters :
| ------------
|  IN  : idOutput : The ID of the output you want to get the language from
|
|  OUT : o_lang   : The ID of the language the output has. 
|                   NULL if output does not exist.
|
| List of callers : (this routine is called by the following routines)
| -----------------
| sp_handleOutput
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getLanguageOfOutput(
  IN  i_idOutput INT UNSIGNED,
  OUT o_lang     CHAR(2))
  SQL SECURITY DEFINER
  BEGIN
    SELECT fiLanguage
    FROM tblOutput
    WHERE idOutput = i_idOutput
    INTO o_lang;
  END ??
