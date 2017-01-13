CREATE TABLE tblLanguage (
  idLanguage      CHAR(2) PRIMARY KEY,
  dtName          VARCHAR(100) NOT NULL,
  dtLocalizedName VARCHAR(100) NOT NULL,
  dtCreatedTS     DATETIME DEFAULT CURRENT_TIMESTAMP,
  dtUpdatedTS     DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

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
CREATE TRIGGER tblMessageType_bu BEFORE UPDATE ON tblMessageType FOR EACH ROW
  SET NEW.dtUpdatedTS = CURRENT_TIMESTAMP;

CREATE TABLE tblUser (
  idUser         VARCHAR(32) PRIMARY KEY,
  dtPassword     CHAR(64) NOT NULL,
  dtSalt         CHAR(64) NOT NULL,
  dtIsAdmin      BOOLEAN   DEFAULT FALSE,
  dtRegisteredTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TABLE tblEmail (
  idEmail     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fiOutput    INT UNSIGNED NOT NULL,
  dtSubject   VARCHAR(100) NOT NULL,
  dtRecipient VARCHAR(50)  NOT NULL,

  CONSTRAINT fk_tblEmail_tblOutput
  FOREIGN KEY (fiOutput)
  REFERENCES tblOutput (idOutput)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE tblPendingEmail (
  idPendingLog INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  fiEmail INT UNSIGNED NOT NULL,
  dtBody TEXT NOT NULL
);

CREATE TABLE tblLogfile (
  idLogfile INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fiOutput  INT UNSIGNED NOT NULL,
  dtPath    VARCHAR(255) NOT NULL,

  CONSTRAINT fk_tblLogfile_tblOutput
  FOREIGN KEY (fiOutput)
  REFERENCES tblOutput (idOutput)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE tblPendingLog (
  idPendingLog INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  dtMsg TEXT NOT NULL,
  fiLogfile INT UNSIGNED NOT NULL,

  CONSTRAINT fk_tblPendingLog_tblLogfile
  FOREIGN KEY (fiLogfile)
  REFERENCES tblLogfile (idLogfile)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

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
CREATE TRIGGER tblMessageInLanguage_bu BEFORE UPDATE ON tblMessageInLanguage FOR EACH ROW
  BEGIN
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '^', '');
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '~', '');
  END//

CREATE TRIGGER tblMessageInLanguage_bi BEFORE INSERT ON tblMessageInLanguage FOR EACH ROW
  BEGIN
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '^', '');
    SET NEW.dtMessageInLanguage = REPLACE(NEW.dtMessageInLanguage, '~', '');
  END//
DELIMITER ;

-- routines:
