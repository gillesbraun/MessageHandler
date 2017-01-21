
DELIMITER ;
CALL sp_addUser('admin', '13371337', 1, @c, @msg);
CALL sp_addUser('Angus', '1337', 0, @c, @msg);


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
  ('Deadlock occurred.', 'F', 'admin'),
  ('Duplicate key', 'A', 'admin'),
  ('Foreign key failed.', 'F', 'admin');

INSERT INTO tblMessageInLanguage (fiMessage, fiLanguage, dtMessageInLanguage) VALUES
  (1, 'en', 'Failed with deadlock after #! attempts.'),
  (1, 'de', 'Fehlgeschlagen wegen Deadlock nach #! Versuchen.'),
  (1, 'fr', 'Échec à cause de deadlock après #! essais.'),
  (2, 'en', 'Duplicate key error encountered.'),
  (2, 'de', 'Doppelter Primärschlüssel gefunden.'),
  (2, 'fr', 'Clé primaire double.'),
  (3, 'en', 'Foreign key not found.'),
  (3, 'de', 'Fremdschlüssel nicht gefunden.'),
  (3, 'fr', 'Clé étrangère pas trouvé.');

CALL sp_addOutput('admin', 'de', 'Admin Output to Logfile', @output, @c, @msg);
CALL sp_addOutputLogfile(@output, '/tmp/adminmsghandler.log', @c, @msg);
CALL sp_assignMessageToOutput(1, @output, @c, @m);

CALL sp_addOutput('Angus', 'en', 'Default Logfile and email', @output, @c, @msg);
CALL sp_addOutputLogfile(@output, '/tmp/msghandler.log', @c, @msg);
CALL sp_addOutputEmail(@output, 'Log from MsgHandler', 'braun.gillo@gmail.com', @c, @msg);
CALL sp_addOutputTwitter(@output, 'jLftnT7NI5p2iiwhvnQeKgDoZ', 'dnncZLjUQEtOSeCzZk0Rh7EJy2fY94zhhV6rvP0WW5NrtVorID',
'88227924-upe2jQES0eIK7EyxK7qNcS1NGFj6B72GthFeKeFTy', 'kpPAziveUVy67F7PGyAoP87PcpeG9hIdUOwCjPqfNY5U8', @c, @msg);
CALL sp_assignMessageToOutput(2, @output, @c, @m);
