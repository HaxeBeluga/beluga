package beluga.module.survey;

import beluga.core.module.Module;

/**
 * @author Guillaume Gomez
 */

interface Survey extends Module
{
	public function get() : Void;
	public function print(args : {id : Int}) : Void;
	public function create(args : {
		title : String,
		description : String,
		choices : Array<String>
	}) : Void;
	public function vote(args : {
		id : Int,
		option : Int
	}) : Void;
	public function getSurveysList() : Array<SurveyData>;
	public function redirect() : Void;
	public function delete(args : {id : Int}) : Void;
}