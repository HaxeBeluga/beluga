package beluga.core.validation;

/**
 * ...
 * @author Alexis Brissard
 */
class SimpleValidator extends Validator
{

	public var validationList = new Map <String, (Void -> Bool)>();

	public function new(?parent : Validator, ?validationList : Map <String, (Void -> Bool)>) 
	{
		super(parent);
		if (validationList == null) {
			this.validationList = new Map < String, (Void -> Bool) > ();
		} else {
			this.validationList = validationList;
		}
	}

	override public function validate() : Array<String> {
		var errorList = new Array<String>();
		errorList = errorList.concat(super.validate());
		errorList = errorList.concat(validateNoChild());		
		return errorList;
	}
	
	public function validateNoChild() : Array<String> {
		var errorList = new Array<String>();
		for (validationkey in validationList.keys()) {
			if (!validationList.get(validationkey)()) {
				errorList.push(validationkey);
			}
		}
		
		return errorList;
	}

}