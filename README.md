# MessageHandler

[![build status](https://gitlab.com/gillesbraun/MessageHandler/badges/master/build.svg)](https://gitlab.com/gillesbraun/MessageHandler/commits/master)
[Download latest build](https://gitlab.com/gillesbraun/MessageHandler/builds/artifacts/master/download?job=build)

## 1. Introduction

MessageHandler is a database application, which can be used to save different kinds of messages. They can each be translated in any language you want. This can be used as internationalization for another project. Some basics you have to understand before you can get started:

- You can define which languages are available for translation
- It is possible to translate each message in each language
- Have placeholders in the message translations, which can be replaced when the message is requested and displayed.
  - For example: In the database, the following message translation is stored: &quot;Welcome back, #!&quot;. When the message is requested from the database, you can define which text should be replacing the &quot;#!&quot; in the message. So when you call the _getMsg_ procedure from your application, you can specify the username to be put in the welcome message. You can also define in which language the message should be translated.
- Outputs are a method of sending messages to other services. There are several types of outputs: Log file, Twitter and E-mail. It is possible to attach messages to an output. So when a message is requested, that message is automatically outputted through the attached outputs. For example: a certain error message should always be saved to a log file.
- User management: keeps track of who created which messages

## 2. Changes to previous version

### New in version 2 (27/01/2017)

- The project is now completely transaction-safe
- Added install script, to guide through installation
- Added Twitter output possibility
- Added triggers to disallow certain characters in data
- Added backup script

## 3. Getting started

## Requirements

To use this project, you need a _MySQL Server 5.7_ with root permissions. To use the web interface, you also need a web server with _PHP_ and _MySQLi_ Support.

PHP should be in your path variable. This means you should be able to execute the command &quot;php&quot; anywhere.

To use the outputs, you need one of the following:

- A Unix system with _cronjobs_
- Windows system with _Task Scheduler_

## Installing MessageHandler

## Using the provided installation script

Extract the zip file containing the compiled version of MessageHandler. Navigate to the &quot;build&quot; folder using a terminal and execute the following command inside that folder:
```
$ php install.php
```
You will be prompted to enter a administrative account for the MySQL server to install the script. Typically this is root. Then you will be prompted for the password of that user account. If that user has no password, just press enter.

If the install was ok, it will ask you if you would like to change the defautl MessageHandler user account password. It is highly recommended to do this as the default password is unsecure.

## Install Cronjob

To use the outputs, you need to get the composer dependencies first. To get these dependencies, you need to download Composer: [https://getcomposer.org/](https://getcomposer.org/)

Navigate to the _build_ directory using a terminal, which is also going to be the folder where the cron script should be executed from. Run the following command:

$ composer install

This will download all the needed dependencies for the outputs.

### Unix

Open a terminal and run the command crontab –e. This opens an editor window. You now have to enter this line to execute the script every minute each day. You probably need to change the path to your scripts.
```
\* \* \* \* \* php /home/messagehandler/cron.php
```
### Windows

Illustrations for this step are in the chapter 6. Appendix

- Open _Task Scheduler_, and click _Create Task_ in the right siderbar
- Press on the _Triggers_ tab, and click the _New…_ Button at the bottom (illustration 1)
  - Select to begin the task _at startup_
  - Click the checkbox to _repeat the task_, and write _1 minute_ in the dropdown.
  - Select Indefinitely in the duration dropdown. When you are done, click OK
- Press on the _Actions_ tab, and click the _New…_ Button at the bottom (illustration 2)
  - Program/script should be the path to your PHP executable
  - In the arguments text field, put cron.php
  - In the _Start in_ field, enter the path to the _build_ directory, in which the cron.php resides

### Configure backup

To use the backup script, you just need to run the file _backup.php_ in the _build_ folder at the desired time. Have a look at the two examples above (Unix and Windows), but replace _cron.php_ by _backup.php_.

It is recommended to run the backup script at least once per week, but it is entirely up to you.

## Start using MessageHandler

### Creating the first Message

To start using the project, you need to add a few things first. Enter the following commands in a MySQL prompt.

All the procedures have at least two output parameters. These are @code and @message. They can be used to see if the execution of the procedure was successful. If not, @message contains a more detailed description about what went wrong.

If you want to have more information about the individual procedures, have a look at 4. Procedures explained.

1. Create a user
```
mysql> CALL sp\_addUser(&#39;_username_&#39;, &#39;_password&#39;_, 1, @code, @message);
```
The 3

# rd
 parameter is the admin flag. If 1, the user is going to be an admin. If 0, a regular user will be created.
1. Add Languages

mysql&gt; CALL sp\_addLanguage(&#39;de&#39;, &#39;German&#39;, &#39;Deutsch&#39;, @code, @message);

This adds a language, with the first parameter being the ID ( [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)), second parameter being the name of the language in english, and the third is the language name in the language itself.

1. Add Message Types

mysql&gt; CALL sp\_addMessageType(&#39;I&#39;, &#39;en&#39;, &#39;Information&#39;, @code, @msg);

If you created multiple languages, you need to run this procedure for each language, replacing each time the language parameter and the translation for that language.

1. Add Messages

mysql&gt; CALL sp\_addMessage(&#39;Description&#39;, &#39;I&#39;, &#39;username&#39;, @id, @code, @message);

This adds a message with a given description, Type of message, and username. @id returns the ID for the created message.

1. Add translations for the message

mysql&gt; CALL sp\_addMessageInLanguage(@id, &#39;en&#39;, &#39;Translation for msg&#39;, @code, @message);

This adds a translation for the message created in step 4. You can reuse the @id param. You should run this command for every language and for every message, so that there is a translation for every message. The translation can contain a placeholder, which can be replaced when the message is requested. Placeholder text is **#!** And can be used multiple times.

After you executed these steps, you can already get a message translation using this simple command:

mysql&gt; CALL sp\_getMsg(@id, &#39;en&#39;, NULL, @translation, @code, @message);

This requests the translation of the message in the language and writes it in the variable @ translation. The 3

# rd
 parameter is skipped using _NULL_, because this parameter is used for replacing placeholders that are saved in the message translation. When this replace string is given and the translation contains a placeholder, this string replaces the placeholder. If multiple placeholders are set and you want to replace them, separate your replace string using the same delimiter as in the placeholder: **#!**

As you can see, the output parameter @id can be reused for other procedure calls, if they are within the same connection. If you reconnect, your user variables will be removed. Watch out for this when including MessageHandler in your project.

Have a look at this example:

mysql&gt; CALL sp\_addMessageInLanguage(2, &#39;en&#39;, &#39;Dear #!, welcome to #!.&#39;, @code, @message);

mysql&gt; CALL sp\_getMsg(2, &#39;en&#39;, &#39;User#!This Site&#39;, @translation , @code, @message);

@translation now contains the following string: &#39;Dear User, welcome to This Site.&#39;.

### Create an Output

To create an output, you must issue the command CALL sp\_addOutput in the mysql prompt. It has 3 input parameters: fiUser, fiLanguage, dtName. Assigning a user is optional, but is recommended. Its purpose is to keep track of who created which output. The language parameter however is mandatory and defines a language in which every language should be translated into before getting output. Also, you have to give it a name. This will make it easier to find it once you have several different outputs.

In this case, I want to have a log file which logs several messages. But first, a normal output needs to be created. So I&#39;ll give it a name which says that it writes to a logfile.

sp\_addOutput(&#39;username&#39;, &#39;en&#39;, Default logfile output to home.&#39;, @id, @code, @message);

Now I create a logfile output and attach it to the created output.

sp\_addOutputLogfile(@id, &#39;/home/messagehandler/default.log&#39;, @code, @message);

This has now created an output that redirects the messages into log files. The next step is to assign the messages that should be logged.

sp\_assignMessageToOutput(1, @id, @code, @message);

The return value of the procedure can also be viewed in order to see if this command worked. But as this is the first message we assigned, there shouldn&#39;t be any issues.

Every time the message with id 2 is requested, it is redirected to the output we just created.

## 4. Procedures explained

This chapter will cover the usage of all the procedures that are available to use. Some of them are used primarily for display purposes of the web interface. The procedures are listed in alphabetical order.

All the procedures have at least two output parameters. These are @statusCode and @statusMessage. They can be used to see if the execution of the procedure was successful. If not, @message contains a more detailed description about what went wrong.

### sp\_addLanguage

This procedure adds a language to the DB. A language has a 2-character long ID, which is the ISO 639‑1 code of the language. A language also has a name in English and a name in the same language as the language itself.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idLanguage | CHAR(2) | The ID of the language you want to add. This ID is the ISO 639-1 code of the language |
| IN | dtName | VARCHAR(100) | The name of the language in English |
| IN | dtLocalizedName | VARCHAR(100) | The name of the language their own language |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
- 1062: ID already exists
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addMessage

This procedure adds a message to the DB. A message is defined only by its description. It is the general description of the message. Every message can later be translated into every language. So the description defines what the language should contain.

A message also has a message type. This defines what type the message is. For example, you could add an _Information_ Type with the identifier &#39;I&#39;

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | dtDescription | VARCHAR(255) | The description for the message |
| IN | idMessageType | CHAR(1) | The type of the message |
| IN | idUser | VARCHAR(32) | The username of the creator |
| OUT | idMessage | INT UNSIGNED | The new ID for the created message |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout

- 1062: Description already exists

- 1452: Foreign key error
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addMessageInLanguage

This procedure adds a message in a language (translation), for a given message and for a given language. The message field can contain placeholders (#!), which can be replaced when the message is requested. So you may insert a translation with as many placeholders as you like. It is strongly recommended that you configure your messages in such a ways that for every translation, the number of placeholders is the same.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The id of the message |
| IN | idLanguage | CHAR(2) | The ISO 639‑1 code of the language |
| IN | dtMessage | VARCHAR(500) | The translation with the placeholders |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout

- 1062: Translation already exists

- 1452: language or message not found
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

###  sp\_addMessageType

This procedure creates a new message type. There should be a translation for each message type in each language. This translation is the prefix for the message translation. Each type should should be translated in each language. The ID of the message type is a single character.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessageType | CHAR(1) | The ID for the message type |
| IN | language | CHAR(2) | The ID of the language |
| IN | name | VARCHAR(50) | The Name of the type in the language |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
- 1062: ID already exists
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addOutput

This procedure creates a new output. An output is relatively abstract, as you do not see any difference when you assign a message to it. But you can assign as many different sub-outputs (e.g Logfile or email) of any kind to this output. So every time the message is called, it is automatically sent to all the outputs that it is assigned to.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | username | VARCHAR(32) | The username of the owner |
| IN | language | CHAR(2) | The ID of the language |
| IN | name | VARCHAR(255) | Name of the output |
| OUT | idOutput | INT UNSIGNED | The ID of the newly created output |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
- 1062: Name already used
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addOutputEmail

Adds an email sub-output. It can be assigned to a normal output. So every time the normal output is called, every sub-output that is assigned to that normal output is also called. The information of the recipient is saved when the output is created.

**NB** : You need to have the cronjobs installed in order to use this output.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idOutput | INT UNSIGNED | The ID of the parent output |
| IN | dtSubject | VARCHAR(100) | The subject of the email |
| IN | dtRecipient | VARCHAR(50) | The email address of the recipient |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error

- 1: Deadlock/Timeout

- 1452: Foreign key error
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addOutputLogfile

This procedure adds a log file sub-output. Each time a message that is assigned to this output will be saved in a log file which you can define in this procedure.

**NB** : You need to have the cronjobs installed in order to use this output.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idOutput | INT UNSIGNED | The ID of the parent output |
| IN | dtPath | VARCHAR(255) | The path to the logfile. The filename needs to be included. |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error

- 1: Deadlock/Timeout

- 1452: Foreign key error
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addOutputTwitter

This procedure adds a new Twitter sub-output. Used for sending messages to a Twitter account.

**NB** : You need to have the cronjobs installed in order to use this output.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idOutput | INT UNSIGNED | The ID of the parent output |
| IN | dtPath | VARCHAR(255) | The path to the logfile. The filename needs to be included. |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
- 1452: Foreign key error
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_addUser

This procedure adds a new user to the MessageHandler. The password is saved encrypted and salted. These tasks done by this procedure. A user can also be defined as an admin. These users are needed for the web interface login. You do not need to create a user as the columns where the user is referenced can be NULL. But it is a nice convenience nonetheless to see who created a message for example. The username must be unique.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idUsername | VARCHAR(32) | The new username for the user |
| IN | dtPassword | VARCHAR(64) | The new password for the user in cleartext. |
| IN | dtIsAdmin | BOOLEAN | Whether the user is an admin or not |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout

- 1062: ID already exists
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_assignMessageToOutput

This procedure allows you to assign a message to an output. When the message is then requested, it is also sent to the outputs it is assigned to. You can only assign messages to parent outputs, not to
sub-outputs directly.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| IN | idOutput | INT UNSIGNED | The ID of the output |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error

- 1: Deadlock/Timeout
- 1062: Message already assigned

- 1452: Message or output doesn&#39;t exist
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_checkUserCredentials

This procedure allows you to check if the username and password combination matches one in the database.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idUsername | VARCHAR(32) | The new username for the user |
| IN | dtPassword | VARCHAR(64) | The new password for the user in cleartext. |
| OUT | result | BOOLEAN | True when username and password are right |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_deleteLanguage

This deletes a language. When a language is deleted, all message translations, message types and outputs will also be deleted, as they are dependant of the language.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idLanguage | CHAR(2) | The ID of the language |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_deleteMessage

This deletes a message. When a message is deleted, all translations of that message are also removed.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_deleteMessageInLanguage

This deletes the translation of a message.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| IN | idLanguage | CHAR(2) | The ID of the language |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_deleteMessageType

This deletes a message type. All messages of that type are also removed.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessageType | CHAR(1) | The ID for the message type |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_deleteOutput

This procedure is used to delete an Output. All sub-outputs (Twitter, Log file, E-mail) are also deleted because they don&#39;t have a parent any more.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idOutput | INT UNSIGNED | The ID of the output |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_deleteOutputEmail,
sp\_deleteOutputLogfile,
sp\_deleteOutputTwitter

This deletes a sub-output. As the syntax is the same for the three procedures, the parameters below work for all three.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idSuboutput | INT UNSIGNED | The ID of the output |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_removeMessageFromOutput

This procedure removes the assignment from a message to an output, meaning that the message will no longer be handled by the given output when the message is requested.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| IN | idOutput | INT UNSIGNED | The ID of the output |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
- 1062: ID already exists
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_updateMessageDescription

Updates the description of a message. The description is limited to 255 characters.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| IN | Description | VARCHAR(255) | The new description for the message |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_updateMessageTranslation

Updates a translation for a message in a language.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| IN | idLanguage | CHAR(2) | The Language of the message |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_updateMessageType

Updates the message type of a messge.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idMessage | INT UNSIGNED | The ID of the message |
| IN | idMessageType | CHAR(1) | The ID of the message type |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_updateUserIsAdmin

Updates the user setting admin permissions. isAdmin is a BOOLEAN.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idUsername | VARCHAR(32) | The username to update |
| IN | isAdmin | BOOLEAN | Defines if the user should be admin or not |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |

### sp\_updateUserPassword

Updates a users&#39; password. Hashes it and adds a salt for extra security.

| Type | Name | Datatype | Description |
| --- | --- | --- | --- |
| IN | idUsername | VARCHAR(32) | The username to update |
| IN | Password | VARCHAR(32) | The new password to be saved |
| OUT | statusCode | SMALLINT | Return code of the procedure:
- 0: No error
- 1: Deadlock/Timeout
 |
| OUT | statusMessage | VARCHAR(100) | Status message from the procedure |



## Get Procedures

All procedures that start with sp\_get are special. As it is not possible save multiple rows of data in a variable, all get methods use the same way of saving the data in a variable. A CSV String is formed, but with special characters delimiting rows and columns. Rows are delimited by ^ and values by ~.

For example: sp\_getLanguages returns _idLanguage_, _dtName_, _dtLocalizedName._ If there is a single row, the following string will be built: en~English~English. If there are multiple rows, a result might look like this: en~English~English^de~German~Deutsch^fr~French~Francais.

### sp\_getMsg

This is the primary procedure used for getting translations, which also sends them to their outputs. You can specify the replacement strings, which are used to replace the placeholders in the message.

sp\_getMsg(idMessage, idLanguage, replace, @translation, @code, @message);

Here is an example to further illustrate the placeholders. Suppose you have a message translation for the idMessage: 4 and the idLanguage: en. The translation looks like this: &quot;_Dear_ **#!** _, your last login was on_ **#!** _._&quot;.

If you wanted to get this message with two replacement strings, for example _Jack_ and _2016-06-16_, the call for the message would look like this:

sp\_getMessageInLanguage(4, &#39;en&#39;, &#39;Jack#!2016-06-16&#39;, @translation, @code, @message);

### sp\_getLanguageOfOutput

This procedure returns the language of an output:

sp\_getLanguageOfOutput(idOutput, @language, @code, @message);

### sp\_getLanguages

This procedure returns all languages:

sp\_getLanguages(@languages, @code, @message);

### sp\_getLanguagesNotUsedInMessage

This procedure returns all the languages for a message which don&#39;t have a translation yet:

sp\_getLanguagesNotUsedInMessage(idMessage, @languages, @code, @message);

### sp\_getMessageLanguages

This returns all languages that have been translated for a message.

sp\_getMessageLanguages(idMessage, @languages, @code, @message);

### sp\_getMessages

This returns all languages that have been translated for a message.

sp\_getMessages(@messages, @code, @message);

### sp\_getMessageTypeInLanguage

This returns the translation of the message type for the language.

sp\_getMessageTypeInLanguage(idMessageType, idLanguage, @type, @code, @message);

### sp\_getMessageTypeOfMessage

This returns the type of message for a given message.

sp\_getMessageTypeOfMessage(idMessage, @msgtype, @code, @message);

### sp\_getMessageTypes

This returns all message types from the db.

sp\_getMessageTypes(@types, @code, @message);

### sp\_getMessageTypesInLanguage

This returns all languages that have been translated for a message.

sp\_getMessageTypesInLanguage(idLanguage, @msgtypes, @code, @message);

### sp\_getPendingLog, sp\_getPendingEmail, sp\_getPendingTwitter

Returns the log and email outputs that need to be handled through the cronjob script. It returns the messages, along with the information they need to be sent.

sp\_getPendingLog(@types, @code, @message);

sp\_getMessageTypes(@types, @code, @message);

sp\_getMessageTypes(@types, @code, @message);

## 6. Appendix


 ![](data:image/*;base64,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)

Illustation 1

 ![](data:image/*;base64,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)

Illustation 2