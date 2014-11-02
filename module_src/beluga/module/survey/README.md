Survey module's doc
===================

The __survey__ module allows you to create and handle surveys easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __survey__ module without it.

This module offers a few numbers of method to easily integrate this module inside your project.

Here is the methods list:

```Haxe
public function print(args : {survey_id : Int}) : Void
public function create(args : {
    title : String,
		choices : String,
		choices2 : String
	}) : Void
public function vote(args : {
		survey_id : Int,
		option : Int
	}) : Void
public function delete(args : {survey_id : Int}) : Void
public function canVote(args : {survey_id : Int}) : Bool
public function getChoices(args : {survey_id : Int}) : Array<Choice>
public function getResults(args : {survey_id : Int}) : Array<Dynamic>
```

These functions are handled by the Beluga webdispatcher and throw respectively these triggers :

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
public function print(args : {survey_id : Int}) : Void
```

This method takes the survey's id in paramater. Calling it throw back the `beluga_survey_printx` trigger or nothing if the the survey was not found.

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
		survey_id : Int,
		option : Int
	}) : Void
```

The vote method takes the survey id and the choice id in parameter and throw back the trigger `beluga_survey_vote_success` or `beluga_survey_vote_fail` if it succeeds or fails.

```Haxe
public function delete(args : {survey_id : Int}) : Void
```

The delete method takes a survey id in parameter. It throws back the `beluga_survey_delete_fail` trigger or `beluga_survey_delete_success` if it fails or succeeds.

```Haxe
public function canVote(args : {survey_id : Int}) : Bool
```

This method returns true or false, depending on the fact that the current user has already vote in this survey or not.

```Haxe
public function getChoices(args : {survey_id : Int}) : Array<Choice>
```

This method returns the choices' list for the specified survey by its id.

```Haxe
public function getResults(args : {survey_id : Int}) : Array<Dynamic>
```

This method returns the results for the referred survey by its id.