Notification module's doc
=========================

The __notification__ module allows you to create and handle notifications easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __notification__ module without it.

This module offers a few numbers of method to easily integrate this module inside your project.

Here is the methods list :

```Haxe
public function print(args : {id : Int}) : Void
public function create(args : {
		title : String,
		text : String,
		user_id : Int
	}) : Void
public function delete(args : {
		id : Int}) : Void
public function getNotifications() : Array<NotificationModel>
```

These functions are handled by the Beluga webdispatcher and throw respectively these triggers :

* beluga_notif_printx
* beluga_notif_delete_success
* beluga_notif_delete_fail
* beluga_notif_create_success
* beluga_notif_create_fail

which suggest to the developer what widget to use.

For example, the vote method sends back the `beluga_notif_delete_success` trigger or the `beluga_notif_delete_fail` trigger. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function print(args : {id : Int}) : Void
```

This method takes the notification's id in paramater. Calling it throws this trigger `beluga_notif_printx` with the the notification in parameter.

```Haxe
public function create(args : {
		title : String,
		text : String,
		user_id : Int
	}) : Void
```

This method creates a new notification by taking its title, a text to describe it and an user id. Depending on its success, it will throw the `beluga_notif_create_success` trigger or `beluga_notif_create_fail`.

```Haxe
public function delete(args : {
		id : Int}) : Void
```

The delete method takes the notification id and throw back the trigger `beluga_notif_delete_success` or `beluga_notif_delete_fail` if it succeeds or fails.

```Haxe
public function getNotifications() : Array<NotificationModel>
```

This method returns the notifications list for the current user (if there is no current user, it returns an empty list).
