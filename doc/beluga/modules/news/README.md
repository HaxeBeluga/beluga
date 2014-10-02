News module's doc
=================

The __news__ module allows you to create and handle news easily. If you want to post / edit / delete an article or a comment, then you will need the __account__ module provided by Beluga.

This module offers a few numbers of method to easily integrate it inside your project.

Here are the methods provided by this module :

```Haxe
public function create(args : {title : String, text : String}) : Void
public function delete(args : {news_id : Int}) : Void
public function edit(args : {news_id : Int, title : String, text : String}) : Void
public function addComment(args : {news_id : Int, text : String}) : Void
public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void
public function canEdit(news_id: Int, user_id: Int) : Bool
public function canPrint(news_id: Int) : Bool
public function getAllNews() : Array<NewsModel>
public function getNewsFromUser(user_id : Int) : Array<NewsModel>
public function getComments(news_id : Int) : Array<CommentModel>
```

##Triggers

This module can send back the following triggers :

* redirect
* redirectEdit
* defaultNews
* print
* editFail
* editSuccess
* addCommentFail
* addCommentSuccess
* deleteCommentFail
* deleteCommentSuccess
* deleteFail
* deleteSuccess
* createFail
* createSuccess

##Errors

In case of failure, just check the error code to know what's wrong. Here is the full errors list for the __news__ module :

 * __MissingLogin__ : You need to be logged in.
 * __NewsNotFound__ : The given news doesn't exist in the database.
 * __CommentNotFound__ : The given comment doesn't exist in the database.
 * __NotAllowed__ : You can't do this action.
 * __MissingMessage__ : The message is missing.
 * __MissingTitle__ : The title is missing.
 * __None__ : No error occured.


##Methods description

For example, the `create` method sends back the `createSucces` trigger or the `createFail` trigger depending on the fact that the creation has succeed or not. Then you just have to handle them and display according to the one you will receive. Don't forget to check what the error is with the given error code.

```Haxe
public function create(args : {title : String, text : String}) : Void
```

The create method allows to create a news. It takes the article's title and text in paramater. Calling it can throw two different triggers : `createSuccess` and `createFail` depending on the result of the creation process. You need to be logged in order to use this method.

```Haxe
public function edit(args : {news_id : Int, title : String, text : String}) : Void
```

The edit method allows to change the data of a news. It takes 3 parameters : the news id you want to edit, the new title and the new text. If you want to keep the old title or the old description, just send the current one. It throws back `editSuccess` or `editFail`. You need to be logged in order to use this method.

```Haxe
public function addComment(args : {news_id : Int, text : String}) : Void
```

The addComment method add a comment on the given news. It takes 2 parameters : the news id on which you want to add this comment and the text of the comment. It throws back `addCommentSuccess` or `addCommentFail`. You need to be logged in order to use this method.

```Haxe
public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void
```

The deleteComment method remove the given comment. It takes 2 parameters : the news id on which you want to delete the comment and the comment id. It throws back `deleteCommentSuccess` or `deleteCommentFail`. To use this method, you have to be logged and the news creator, the comment creator or a root user.

```Haxe
public function delete(args : {news_id : Int}) : Void
```

The delete method remove the given news. It takes a news id in parameter. It throws back the `deleteFail` trigger or `deleteSuccess`. You need to be logged and the creator of the news or a root user.

```Haxe
public function getAllNews() : Array<NewsModel>;
```

This method returns the list of all the created news (which can be empty of course).

```Haxe
public function getNewsFromUser(args : {user_id : Int}) : Array<NewsModel>;
```

This method returns the list of the news (which can be empty) created by the user referenced by the id.

```Haxe
public function getComments(args : {news_id : Int}) : Array<CommentModel>;
```

This method returns the list of the comments (which can be empty) of the specified news referenced by its id.

```Haxe
public function canEdit(news_id: Int, user_id: Int) : Bool
```

The canEdit method returns true if the given user can edit the given news. So if the given user is the news creator or a root user, it will return true.

```Haxe
public function canPrint(news_id: Int) : Bool
```

The canPrint method returns true if the news exist.
