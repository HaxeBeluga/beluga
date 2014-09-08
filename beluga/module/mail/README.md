Mail module's doc
=================

The __mail__ module allows you to create and handle mails easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __mail__ module without it.

This module offers a few numbers of method to easily integrate this module inside your project.

Here is the method provided by this module :

```Haxe
public function getSentMails() : Array<MailModel>
public function getMail(id : Int) : MailModel
public function getDraftMails() : Array<MailModel>
public function sendMail(args : {receiver : String, subject : String, message : String}) : Void
```

Those functions are handled by the Beluga webdispatcher and throw these triggers :

* beluga_mail_send_success
* beluga_mail_send_fail

which suggest to the developer what widget to display.

```Haxe
public function sendMail(args : {receiver : String, subject : String, message : String}) : Void
```

This method takes the receiver's email, the mail's subject and the the mail's message. It throws back `beluga_mail_send_success` or `beluga_mail_send_fail`, depending on the result of the method's execution.

```Haxe
public function getSentMails() : Array<MailModel>;
```

This method returns the list of the sent mails (which can be empty of course).

```Haxe
public function getMail(id : Int) : MailModel;
```

This methods returns the Mail referred by the id or null if it cannot be found.

```Haxe
public function getDraftMails() : Array<MailModel>;
```

This methods returns the draft mails list (which can be empty of course).