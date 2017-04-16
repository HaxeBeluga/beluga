Survey module's doc
===================

The __survey__ module allows you to create and handle surveys easily. It depends on the __account__ module provided by Beluga so you won't be able to use the __survey__ module without it.

This module offers a few numbers of methods to easily integrate it inside your project.

Here are the methods provided by this module :

```Haxe
public function canVote(survey_id : Int) : Bool
public function create(args : {
    title : String,
    description : String,
    choices : Array<String>
}) : Void
public function vote(args : {
    survey_id : Int,
    option : Int
}) : Void
public function getSurvey(survey_id: Int) : SurveyModel
public function getSurveysList() : Array<SurveyData>
public function redirect() : Void
public function delete(survey_id : Int) : Void
public function getChoices(survey_id : Int) : Array<Choice>
public function getResults(survey_id : Int) : Array<Dynamic>
public function print(survey_id : Int): Void
public function getActualSurveyId() : Int
```

##Triggers

This module can send back the following triggers :

 * redirect
 * deleteFail
 * deleteSuccess
 * printSurvey
 * createFail
 * createSuccess
 * voteFail
 * voteSuccess
 * answerNotify
 * defaultSurvey

##Errors

In case of failure, just check the error code to know what's wrong. Here is the full errors list for the survey module :

 * __MissingLogin__ : You need to be logged in.
 * __NotAllowed__ : You can't do this action.
 * __MissingDescription__ : The description of the survey is missing.
 * __MissingTitle__ : The title of the survey is missing.
 * __MissingChoices__ : Two choices minimum are needed.
 * __NotFound__ : The requested survey doesn't exist.
 * __AlreadyVoted__ : You have already voted for this survey.
 * __None__ : No error occured.

##Methods description

For example, the vote method sends back the `voteSuccess` trigger or the `voteSuccess` trigger. Then you just have to handle them and display according to the one you will receive.

```Haxe
public function canVote(survey_id : Int) : Bool
```

The can vote method returns false if there is no logged user or if the current logged user already has voted for the given survey.

```Haxe
public function create(args : {
    title : String,
    description : String,
    choices : Array<String>
}) : Void
```

This method creates a new survey by taking its title, its description and its choices. Depending on its success, it will throw the `createFail` trigger or the `createSuccess` trigger.

```Haxe
public function vote(args : {
	survey_id : Int,
	option : Int
}) : Void
```

The vote method takes the survey id and the choice id in parameter and throws back the `voteSuccess` trigger or the `voteFail` trigger depending on its success.

```Haxe
public function getSurvey(survey_id: Int) : SurveyModel
```

Returns the Survey corresponding to the id given in parameters. Returns null if the survey doesn't exist.

```Haxe
public function getSurveysList() : Array<SurveyData>
```

Returns all the surveys created by the current logged user.

```Haxe
public function redirect() : Void
```

Sends back the `redirect` trigger.

```Haxe
public function delete(args : {survey_id : Int}) : Void
```

The delete method remove the given survey from the database and all the data linked to it. It takes a survey id in parameter. It throws back the `deleteFail` trigger or the `deleteSuccess` trigger depending on its success.

```Haxe
public function getChoices(args : {survey_id : Int}) : Array<Choice>
```

This method returns the choices' list for the specified survey. If the returned array is empty, you should check if your survey does exist.

```Haxe
public function getResults(args : {survey_id : Int}) : Array<Dynamic>
```

This method returns an array containing stats of the specified survey.

```Haxe
public function print(survey_id : Int): Void
public function getActualSurveyId() : Int
```

These two methods are called internally by the survey module.
