Notification module's doc
=========================

The __notification__ module allows you to create and handle notifications easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __notification__ module without it.

This module offers a few numbers of methods to easily integrate it inside your project.

Here are the methods provided by this module :

```Haxe
public function print(args : {id : Int}) : Void
public function create(args : {
    title : String,
    text : String,
    user_id : Int
}) : Void
public function delete(args : {id : Int}) : Void
public function getNotifications() : Array<NotificationModel>
public function getNotification(notif_id: Int, user_id: Int) : NotificationModel
public function canPrint(notif_id: Int) : Bool
```

##Triggers

This module can send back the following triggers :

* defaultNotification
* createSuccess
* createFail
* deleteSuccess
* deleteFail
* print

##Errors

In case of failure, just check the error code to know what's wrong. Here is the full errors list for the notification module :

 * __MissingLogin__ : You need to be logged in.
 * __MissingTitle__ : The title is missing.
 * __MissingMessage__ : The message is missing.
 * __IdNotFound__ : The given id doesn't exist.
 * __None__ : No error occured.

##Methods description

For example, the `vote` method sends back the `deleteSuccess` trigger or the `deleteFail` trigger. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function print(args : {id : Int}) : Void
```

This method takes the notification's id in paramater. Calling it throws this trigger `print`. Then you just have to call the Print widget.

```Haxe
public function create(args : {
		title : String,
		text : String,
		user_id : Int
	}) : Void
```

This method creates a new notification by taking its title, a text to describe it and an user id. Depending on its success, it will throw the `createSuccess` trigger or the `createFail` trigger.

```Haxe
public function delete(args : {id : Int}) : Void
```

The delete method takes the notification's id and throw back the trigger `deleteSuccess` or `deleteFail` if it succeeds or fails.

```Haxe
public function getNotifications() : Array<NotificationModel>
```

This method returns the notifications list for the current user (if there is no current user, it returns an empty list).

```Haxe
public function getNotification(notif_id: Int, user_id: Int) : NotificationModel
```

Returns the given notification if it belongs to the given user. Otherwise, it returns null.

```Haxe
public function canPrint(notif_id: Int) : Bool
```

This methods returns true or false, depending if the given notification belongs to the logged user.
