GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addLanguage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addMessage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addMessageInLanguage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addMessageType TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addOutput TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addOutputEmail TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addOutputLogfile TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addOutputTwitter TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_addUser TO MessageHandler@localhost;

GRANT EXECUTE ON PROCEDURE MessageHandler.sp_checkUserCredentials TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_assignMessageToOutput TO MessageHandler@localhost;

GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteLanguage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteMessage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteMessageInLanguage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteMessageType TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteOutput TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteOutputEmail TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteOutputLogfile TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteOutputTwitter TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_deleteUser TO MessageHandler@localhost;


GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getLanguageOfOutput TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getLanguages TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getLanguagesNotUsedInMessage TO MessageHandler@localhost;
-- sp_getMessageInLanguage
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMessageTranslations TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMessages TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMessageTypeInLanguage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMessageTypeOfMessage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMessageTypes TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMessageTypesInLanguage TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getMsg TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getOutputs TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getOutputsEmail TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getOutputsTwitter TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getOutputsLogfile TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getPendingEmail TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getPendingLogfile TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getPendingTwitter TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_getUsers TO MessageHandler@localhost;
-- sp_handleOutput
-- sp_handleEmail
-- sp_handleLogfile
-- sp_handleTwitter
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_removeMessageFromOutput TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateLanguageLocalizedName TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateLanguageName TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateMessageDescription TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateMessageTranslation TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateMessageType TO MessageHandler@localhost;

GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateUserIsAdmin TO MessageHandler@localhost;
GRANT EXECUTE ON PROCEDURE MessageHandler.sp_updateUserPassword TO MessageHandler@localhost;
