Survey module's doc
===================

The __survey__ module allows you to create and handle surveys easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __survey__ module without it.

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

* beluga_survey_vote_success
* beluga_survey_vote_fail
* beluga_survey_create_success
* beluga_survey_create_fail
* beluga_survey_printx
* beluga_survey_votex
* beluga_survey_redirect
* beluga_survey_delete_success
* beluga_survey_delete_fail
* beluga_survey_default

which suggest to the developer what widget to display.

For example, the vote method sends back the `beluga_survey_vote_success` trigger or the `beluga_survey_vote_fail` trigger. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function print(args : {id : Int}) : Void
```

This method take the survey's id in paramater. Calling it can throw two different triggers : `beluga_survey_printx` and `beluga_survey_votex` depending on the fact that the user has voted or not in this survey.

```Haxe
public function create(args : {
    title : String,
		choices : String,
		choices2 : String
	}) : Void
```

This method creates a new survey by taking its title and its choices. Depending on its success, it will throw the `beluga_survey_create_fail` trigger or `beluga_survey_create_success`.

```Haxe
public function vote(args : {
		id : Int,
		option : Int
	}) : Void
```

The vote method takes the survey id and the choice id in parameter and throw back the trigger `beluga_survey_vote_success` or `beluga_survey_vote_fail` if it succeeds or fails.

```Haxe
public function delete(args : {id : Int}) : Void
```

The delete method takes a survey id in parameter. One more, it throws back the `beluga_survey_delete_fail` trigger or `beluga_survey_delete_success` if it fails or succeeds.
