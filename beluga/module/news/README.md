News module's doc
=================

The __news__ module allows you to create and handle surveys easily. If you want to post / edit / delete an article or a comment, then you will need the __account__ module provided by Beluga.

This module offers a few numbers of method to easily integrate the widget inside your project.

Here is the methods list:

```Haxe
public function print(args : {id : Int}) : Void
public function create(args : {
    title : String,
		choices : String,
		choices2 : String
	}) : Void
public function vote(args : {
		id : Int,
		option : Int
	}) : Void
public function delete(args : {id : Int}) : Void
```

These functions are handle by the Beluga webdispatcher, and throw respectively these triggers :

* beluga_news_edit_success
* beluga_news_edit_fail
* beluga_news_addComment_success
* beluga_news_addComment_fail
* beluga_news_deleteComment_success
* beluga_news_deleteComment_fail
* beluga_news_print
* beluga_news_delete_success
* beluga_news_delete_fail
* beluga_news_create_success
* beluga_news_create_fail

which suggest to the developer what widget to display.

For example, the create method sends back the `beluga_news_create_success` trigger or the `beluga_news_create_fail` trigger. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function print(args : {news_id : Int}) : Void
```

This method take the survey's id in paramater. Calling it throw back the `beluga_news_print` trigger.

```Haxe
public function create(args : {title : String, text : String}) : Void
```

This method takes the article's title and text in paramater. Calling it can throw two different triggers : `beluga_news_create_success` and `beluga_news_create_fail` depending on the result of the creation process.

```Haxe
public function edit(args : {news_id : Int, title : String, text : String}) : Void
```

The edit method takes 3 parameters : the news id you want to edit, the new title, the new text. If you want to keep the old title or description, just send the current one.

```Haxe
public function delete(args : {news_id : Int}) : Void
```

The delete method takes a news id in parameter. It throws back the `beluga_news_delete_fail` trigger or `beluga_news_delete_success` if it fails or succeeds.
