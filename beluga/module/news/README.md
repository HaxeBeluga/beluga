News module's doc
=================

The __news__ module allows you to create and handle news easily. If you want to post / edit / delete an article or a comment, then you will need the __account__ module provided by Beluga.

This module offers a few numbers of method to easily integrate this module inside your project.

Here is the methods list :

```Haxe
public function print(args : {news_id : Int}) : Void
public function create(args : {title : String, text : String}) : Void
public function edit(args : {news_id : Int, title : String, text : String}) : Void
public function addComment(args : {news_id : Int, text : String}) : Void
public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void
public function delete(args : {news_id : Int}) : Void
public function getAllNews() : Array<NewsModel>;
public function getNews(args : {user_id : Int}) : Array<NewsModel>;
public function getComments(args : {news_id : Int}) : Array<CommentModel>;
```

These functions are handled by the Beluga webdispatcher and throw respectively these triggers :

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

For example, the `create` method sends back the `beluga_news_create_success` trigger or the `beluga_news_create_fail` trigger depending on the fact that the creation has succeed or not. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function print(args : {news_id : Int}) : Void
```

This method takes the news' id in parameter. Calling it throw back the `beluga_news_print` trigger.

```Haxe
public function create(args : {title : String, text : String}) : Void
```

This method takes the article's title and text in paramater. Calling it can throw two different triggers : `beluga_news_create_success` and `beluga_news_create_fail` depending on the result of the creation process.

```Haxe
public function edit(args : {news_id : Int, title : String, text : String}) : Void
```

The edit method takes 3 parameters : the news id you want to edit, the new title and the new text. If you want to keep the old title or description, just send the current one. It throws back `beluga_news_edit_success` or `beluga_news_edit_fail`.

```Haxe
public function addComment(args : {news_id : Int, text : String}) : Void
```

The addComment method takes 2 parameters : the news id on which you want to add this comment and the text of the comment. It throws back `beluga_news_addComment_success` or `beluga_news_addComment_fail`.

```Haxe
public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void
```

The deleteComment takes 2 parameters : the news id on which you want to delete the comment (used to know if you can delete a comment on this article if it's not one of yours) and the comment id. It throws back `beluga_news_deleteComment_success` or `beluga_news_deleteComment_fail`.

```Haxe
public function delete(args : {news_id : Int}) : Void
```

The delete method takes a news id in parameter. It throws back the `beluga_news_delete_fail` trigger or `beluga_news_delete_success` if it fails or succeeds.

```Haxe
public function getAllNews() : Array<NewsModel>;
```

This method returns the list of all the created news (which can be empty of course).

```Haxe
public function getNews(args : {user_id : Int}) : Array<NewsModel>;
```

This method returns the list of the news (which can be empty) created by the user referred by the id.

```Haxe
public function getComments(args : {news_id : Int}) : Array<CommentModel>;
```

This method returns the list of the comments (which can be empty) of the specified news referred by its id.