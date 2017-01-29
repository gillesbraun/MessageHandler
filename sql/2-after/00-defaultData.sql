
DELIMITER ;

CALL sp_addUser('admin', 'q1w2e3!', 1, @c, @m);
-- Default Values
INSERT INTO tblLanguage (idLanguage, dtName, dtLocalizedName) VALUES
  ('en', 'English', 'English'),
  ('de', 'German', 'Deutsch'),
  ('fr', 'French', 'Français');
INSERT INTO tblMessageType (fiLanguage, idMessageType, dtName) VALUES
  ('en', 'I', 'Information'),
  ('en', 'W', 'Warning'),
  ('en', 'A', 'Alert'),
  ('en', 'F', 'Fatal error'),
  ('de', 'I', 'Information'),
  ('de', 'W', 'Warnung'),
  ('de', 'A', 'Aufpassen'),
  ('de', 'F', 'Fataler Fehler'),
  ('fr', 'I', 'Information'),
  ('fr', 'W', 'Attention'),
  ('fr', 'A', 'Alerte'),
  ('fr', 'F', 'Erreur fatale');

INSERT INTO tblMessage (dtDescription, fiMessageType, fiUser) VALUES
  ('Execution failed.', 'A', 'admin'),
  ('Duplicate key', 'A', 'admin'),
  ('Foreign key failed.', 'F', 'admin');

INSERT INTO tblMessageInLanguage (fiMessage, fiLanguage, dtMessageInLanguage) VALUES
  (1, 'en', 'The execution failed after #! attempts.'),
  (1, 'de', 'Fehlgeschlagen nach #! Versuchen.'),
  (1, 'fr', 'Échec après #! essais.'),
  (2, 'en', 'Duplicate key error encountered.'),
  (2, 'de', 'Doppelter Primärschlüssel gefunden.'),
  (2, 'fr', 'Clé primaire double.'),
  (3, 'en', 'Foreign key not found.'),
  (3, 'de', 'Fremdschlüssel nicht gefunden.'),
  (3, 'fr', 'Clé étrangère pas trouvé.');

