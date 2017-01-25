CREATE TABLE tblLanguage (
  idLanguage      CHAR(2) PRIMARY KEY,
  dtName          VARCHAR(100) NOT NULL,
  dtLocalizedName VARCHAR(100) NOT NULL,
  dtCreatedTS     DATETIME DEFAULT CURRENT_TIMESTAMP,
  dtUpdatedTS     DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER tr_tblLanguage_bu BEFORE UPDATE ON tblLanguage FOR EACH ROW
  BEGIN
    SET NEW.dtName = REPLACE(NEW.dtName, '^', '');
    SET NEW.dtName = REPLACE(NEW.dtName, '~', '');
    SET NEW.dtLocalizedName = REPLACE(NEW.dtLocalizedName, '^', '');
    SET NEW.dtLocalizedName = REPLACE(NEW.dtLocalizedName, '~', '');
  END//

CREATE TRIGGER tr_tblLanguage_bi BEFORE INSERT ON tblLanguage FOR EACH ROW
  BEGIN
    SET NEW.dtName = REPLACE(NEW.dtName, '^', '');
    SET NEW.dtName = REPLACE(NEW.dtName, '~', '');
    SET NEW.dtLocalizedName = REPLACE(NEW.dtLocalizedName, '^', '');
    SET NEW.dtLocalizedName = REPLACE(NEW.dtLocalizedName, '~', '');
  END//
DELIMITER ;


CREATE TABLE tblMessageType (
  idMessageType CHAR(1),
  fiLanguage    CHAR(2),
  dtName        VARCHAR(50) NOT NULL,
  dtCreatedTS   DATETIME DEFAULT CURRENT_TIMESTAMP,
  dtUpdatedTS   DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (idMessageType, fiLanguage),

  CONSTRAINT fk_tblMessageType_tblLanguage
  FOREIGN KEY (fiLanguage)
  REFERENCES tblLanguage (idLanguage)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER tr_tblMessageType_bu BEFORE UPDATE ON tblMessageType FOR EACH ROW
  BEGIN
    SET NEW.dtName = REPLACE(NEW.dtName, '^', '');
    SET NEW.dtName = REPLACE(NEW.dtName, '~', '');
  END//

CREATE TRIGGER tr_tblMessageType_bi BEFORE INSERT ON tblMessageType FOR EACH ROW
  BEGIN
    SET NEW.dtName = REPLACE(NEW.dtName, '^', '');
    SET NEW.dtName = REPLACE(NEW.dtName, '~', '');
  END//
DELIMITER ;


CREATE TABLE tblUser (
  idUser         VARCHAR(32) PRIMARY KEY,
  dtPassword     CHAR(64) NOT NULL,
  dtSalt         CHAR(64) NOT NULL,
  dtIsAdmin      BOOLEAN   DEFAULT FALSE,
  dtRegisteredTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER tr_tblUser_bu BEFORE UPDATE ON tblUser FOR EACH ROW
  BEGIN
    SET NEW.idUser = REPLACE(NEW.idUser, '^', '');
    SET NEW.idUser = REPLACE(NEW.idUser, '~', '');
  END//

CREATE TRIGGER tr_tblUser_bi BEFORE INSERT ON tblUser FOR EACH ROW
  BEGIN
    SET NEW.idUser = REPLACE(NEW.idUser, '^', '');
    SET NEW.idUser = REPLACE(NEW.idUser, '~', '');
  END//
DELIMITER ;

CREATE TABLE tblOutput (
  idOutput    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dtName      VARCHAR(255) UNIQUE NOT NULL,
  fiUser      VARCHAR(32),
  fiLanguage  CHAR(2)             NOT NULL,
  dtCreatedTS TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  dtUpdatedTS DATETIME     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_tblOutput_tblUser
  FOREIGN KEY (fiUser)
  REFERENCES tblUser (idUser)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

  CONSTRAINT fk_tblOutput_tblLanguage
  FOREIGN KEY (fiLanguage)
  REFERENCES tblLanguage (idLanguage)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER tr_tblOutput_bu BEFORE UPDATE ON tblOutput FOR EACH ROW
  BEGIN
    SET NEW.dtName = REPLACE(NEW.dtName, '^', '');
    SET NEW.dtName = REPLACE(NEW.dtName, '~', '');
  END//

CREATE TRIGGER tr_tblOutput_bi BEFORE INSERT ON tblOutput FOR EACH ROW
  BEGIN
    SET NEW.dtName = REPLACE(NEW.dtName, '^', '');
    SET NEW.dtName = REPLACE(NEW.dtName, '~', '');
  END//
DELIMITER ;


CREATE TABLE tblOutputEmail (
  idOutputEmail     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fiOutput    INT UNSIGNED NOT NULL,
  dtSubject   VARCHAR(100) NOT NULL,
  dtRecipient VARCHAR(50)  NOT NULL,

  CONSTRAINT fk_tblOutputEmail_tblOutput
  FOREIGN KEY (fiOutput)
  REFERENCES tblOutput (idOutput)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER tr_tblOutputEmail_bu BEFORE UPDATE ON tblOutputEmail FOR EACH ROW
  BEGIN
    SET NEW.dtSubject = REPLACE(NEW.dtSubject, '^', '');
    SET NEW.dtSubject = REPLACE(NEW.dtSubject, '~', '');
    SET NEW.dtRecipient = REPLACE(NEW.dtRecipient, '^', '');
    SET NEW.dtRecipient = REPLACE(NEW.dtRecipient, '~', '');
  END//

CREATE TRIGGER tr_tblOutputEmail_bi BEFORE INSERT ON tblOutputEmail FOR EACH ROW
  BEGIN
    SET NEW.dtSubject = REPLACE(NEW.dtSubject, '^', '');
    SET NEW.dtSubject = REPLACE(NEW.dtSubject, '~', '');
    SET NEW.dtRecipient = REPLACE(NEW.dtRecipient, '^', '');
    SET NEW.dtRecipient = REPLACE(NEW.dtRecipient, '~', '');
  END//
DELIMITER ;


CREATE TABLE tblPendingEmail (
  idPendingLog INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  fiOutputEmail INT UNSIGNED NOT NULL,
  dtBody TEXT NOT NULL,

  CONSTRAINT fk_tblPendingEmail_tblOutputEmail
  FOREIGN KEY (fiOutputEmail)
  REFERENCES tblOutputEmail (idOutputEmail)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
DELIMITER //
CREATE TRIGGER tr_tblPendingEmail_bu BEFORE UPDATE ON tblPendingEmail FOR EACH ROW
  BEGIN
    SET NEW.dtBody = REPLACE(NEW.dtBody, '^', '');
    SET NEW.dtBody = REPLACE(NEW.dtBody, '~', '');
  END//

CREATE TRIGGER tr_tblPendingEmail_bi BEFORE INSERT ON tblPendingEmail FOR EACH ROW
  BEGIN
    SET NEW.dtBody = REPLACE(NEW.dtBody, '^', '');
    SET NEW.dtBody = REPLACE(NEW.dtBody, '~', '');
  END//
DELIMITER ;

CREATE TABLE tblOutputLogfile (
  idOutputLogfile INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fiOutput  INT UNSIGNED NOT NULL,
  dtPath    VARCHAR(255) NOT NULL,

  CONSTRAINT fk_tblOutputLogfile_tblOutput
  FOREIGN KEY (fiOutput)
  REFERENCES tblOutput (idOutput)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER tr_tblOutputLogfile_bu BEFORE UPDATE ON tblOutputLogfile FOR EACH ROW
  BEGIN
    SET NEW.dtPath = REPLACE(NEW.dtPath, '^', '');
    SET NEW.dtPath = REPLACE(NEW.dtPath, '~', '');
  END//

CREATE TRIGGER tr_tblOutputLogfile_bi BEFORE INSERT ON tblOutputLogfile FOR EACH ROW
  BEGIN
    SET NEW.dtPath = REPLACE(NEW.dtPath, '^', '');
    SET NEW.dtPath = REPLACE(NEW.dtPath, '~', '');
  END//
DELIMITER ;


CREATE TABLE tblPendingLog (
  idPendingLog INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  dtMsg TEXT NOT NULL,
  fiOutputLogfile INT UNSIGNED NOT NULL,

  CONSTRAINT fk_tblPendingLog_tblOutputLogfile
  FOREIGN KEY (fiOutputLogfile)
  REFERENCES tblOutputLogfile (idOutputLogfile)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER tr_tblPendingLog_bu BEFORE UPDATE ON tblPendingLog FOR EACH ROW
  BEGIN
    SET NEW.dtMsg = REPLACE(NEW.dtMsg, '^', '');
    SET NEW.dtMsg = REPLACE(NEW.dtMsg, '~', '');
  END//

CREATE TRIGGER tr_tblPendingLog_bi BEFORE INSERT ON tblPendingLog FOR EACH ROW
  BEGIN
    SET NEW.dtMsg = REPLACE(NEW.dtMsg, '^', '');
    SET NEW.dtMsg = REPLACE(NEW.dtMsg, '~', '');
  END//
DELIMITER ;


CREATE TABLE tblOutputTwitter(
  idOutputTwitter INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  dtConsumerKey CHAR(25) NOT NULL,
  dtConsumerSecret CHAR(50) NOT NULL,
  dtAccessToken CHAR(50) NOT NULL,
  dtAccessTokenSecret CHAR(45) NOT NULL,
  fiOutput INT UNSIGNED NOT NULL,

  CONSTRAINT fk_tblOutputTwitter_tblOutput
  FOREIGN KEY (fiOutput)
  REFERENCES tblOutput (idOutput)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE tblPendingTwitter(
  idPendingTwitter INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  dtMessage VARCHAR(500) NOT NULL,
  fiOutputTwitter INT UNSIGNED NOT NULL,

  CONSTRAINT fk_tblPendingTwitter_tblOutputTwitter
  FOREIGN KEY (fiOutputTwitter)
  REFERENCES tblOutputTwitter (idOutputTwitter)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE tblMessage (
  idMessage     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dtDescription VARCHAR(255) NOT NULL UNIQUE,
  fiMessageType CHAR(1)      NOT NULL,
  fiUser        VARCHAR(32),
  dtCreatedTS   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP(),
  dtUpdatedTS   DATETIME     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_tblMessage_tblMessageType
  FOREIGN KEY (fiMessageType)
  REFERENCES tblMessageType (idMessageType)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_tblMessage_tblUser
  FOREIGN KEY (fiUser)
  REFERENCES tblUser (idUser)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

DELIMITER //
CREATE TRIGGER tr_tblMessage_bu BEFORE UPDATE ON tblMessage FOR EACH ROW
  BEGIN
    SET NEW.dtDescription = REPLACE(NEW.dtDescription, '^', '');
    SET NEW.dtDescription = REPLACE(NEW.dtDescription, '~', '');
  END//

CREATE TRIGGER tr_tblMessage_bi BEFORE INSERT ON tblMessage FOR EACH ROW
  BEGIN
    SET NEW.dtDescription = REPLACE(NEW.dtDescription, '^', '');
    SET NEW.dtDescription = REPLACE(NEW.dtDescription, '~', '');
  END//
DELIMITER ;

CREATE TABLE tblMessageOutput (
  fiMessage INT UNSIGNED,
  fiOutput  INT UNSIGNED,
  PRIMARY KEY (fiMessage, fiOutput),

  CONSTRAINT fk_tblMessageOutput_tblOutput
  FOREIGN KEY (fiOutput)
  REFERENCES tblOutput (idOutput)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_MessageOutput_tblMessage
  FOREIGN KEY (fiMessage)
  REFERENCES tblMessage (idMessage)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE tblMessageInLanguage (
  fiMessage           INT UNSIGNED NOT NULL,
  fiLanguage          CHAR(2)      NOT NULL,
  dtMessageInLanguage VARCHAR(500) NOT NULL,
  dtCreateTS          DATETIME DEFAULT CURRENT_TIMESTAMP(),
  dtUpdatedTS         DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (fiMessage, fiLanguage),

  CONSTRAINT fk_tblMessageInLanguage_tblMessage
  FOREIGN KEY (fiMessage)
  REFERENCES tblMessage (idMessage)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_tblMessageInLanguage_tblLanguage
  FOREIGN KEY (fiLanguage)
  REFERENCES tblLanguage (idLanguage)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER tr_tblMessageInLanguage_bu BEFORE UPDATE ON tblMessageInLanguage FOR EACH ROW
  BEGIN
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '^', '');
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '~', '');
  END//

CREATE TRIGGER tr_tblMessageInLanguage_bi BEFORE INSERT ON tblMessageInLanguage FOR EACH ROW
  BEGIN
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '^', '');
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '~', '');
  END//
DELIMITER ;

-- routines:
