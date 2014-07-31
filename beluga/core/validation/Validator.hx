package beluga.core.validation;

/**
 * ...
 * @author Alexis Brissard
 */
class Validator
{

	private var childList = new Array<Validator>();
	
	public function new (?parent : Validator) {
		if (parent != null) {
			parent.childList.push(this);
		}
	}
	
	public function removeChild(child : Validator) {
		childList.remove(child);
	}
	
	public function validate() : Array<String> {
		var errorList = new Array<String>();
		for (i in childList) {
			errorList = errorList.concat(i.validate());
		}
		return errorList;
	}
	
}