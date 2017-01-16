/*----------------------------------------------------------------------------
| Routine : sp_getUsers
| Author(s)  : (c) BTSi Braun Gilles
| CreateDate : 2016-06-09
|
| Description : Returns all users with their information.
|
| Parameters :
| ------------
|  OUT : o_out    : CSV string. Rows separated by ^ and Values by ~
|
| List of callers : (this routine is called by the following routines)
| -----------------
|
|---------------------------------------------------------------------------*/
DELIMITER ??
CREATE DEFINER = 'MsgHandler'@'localhost'
PROCEDURE sp_getUsers(OUT o_out TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(
        CONCAT_WS('~', idUser, dtIsAdmin, dtRegisteredTS)
        SEPARATOR '^')
    FROM tblUser
    INTO o_out;
  END ??
