#Mail module

The __mail__ module allows you to create and handle mails easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __mail__ module without it.

This module offers a few number of methods to easily integrate it inside your project.

Here are the methods provided by this module :

```Haxe
public function createDefaultContext() : Void
public function setActualMail(mail_id : Int) : Void
public function getActualMail() : MailModel
public function canPrint() : Bool
public function getSentMails() : Array<MailModel>
public function getMail(id : Int) : MailModel
public function getDraftMails() : Array<MailModel>
public function sendMail(args : {receiver : String, subject : String, message : String}) : Void
```

##Triggers

This module can send back the following triggers :
 * sendFail
 * sendSuccess

##Errors

In case of failure, just check the error code to know what's wrong. Here is the full errors list for the __mail__ module :
 * __MissingLogin__ : You need to be logged in.
 * __MailNotSent__ : An error occured when trying to send the mail.
 * __OnlyPHP__ : The only language supported by the mail module is currently PHP, any other will fail and throw back this error.
 * __MissingReceiver__ : The receiver is missing.
 * __MissingSubject__ : The subject is missing.
 * __MissingMessage__ : The message is missing.
 * __UnknownId__ : The given id doesn't exist in the database.
 * __None__ : No error detected.

## Methods description

```Haxe
public function sendMail(args : {receiver : String, subject : String, message : String}) : Void;
```

This method takes the receiver's address, the mail's subject and the the mail's message. It throws back `sendSuccess` or `sendFail`, depending on the result of the method execution. Please refer to the described errors [above](#errors).

```Haxe
public function getSentMails() : Array<MailModel>;
```

This method returns the list of the mails sned by the current logged user (which can be empty of course).

```Haxe
public function getMail(id : Int) : MailModel;
```

This methods returns the Mail referred by the `id` or `null` if it cannot be found. If it fails, `error_id` is set to the appropriate error.

```Haxe
public function getDraftMails() : Array<MailModel>;
```

This methods returns the draft mails list of the current logged user (which can be empty of course).

```Haxe
public function createDefaultContext() : Void
public function setActualMail(mail_id : Int) : Void
public function getActualMail() : MailModel
public function canPrint() : Bool
```

These four methods are only used inside the mail module. Using one of them can create undefined behavior.
nside the mail module. Using one of them can create undefined behavior.
