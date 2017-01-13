/*----------------------------------------------------------------------------
| Routine : sp_getLanguages
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all stored languages (ID, Name, LocalizedName)
|
| Parameters :
| ------------
|  OUT : o_out : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MessageHandler'@'localhost'
PROCEDURE sp_getLanguages(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idLanguage, dtName, dtLocalizedName, dtCreatedTS, IFNULL(dtUpdatedTS, ''))
        SEPARATOR '^')
    FROM tblLanguage
    INTO o_out;
  END ??