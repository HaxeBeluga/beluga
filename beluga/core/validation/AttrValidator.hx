package beluga.core.validation;

/**
 * ...
 * @author Alexis Brissard
 */
class AttrValidator<T> extends Validator
{
	private var value : T;
	
	public var validationList : Map <String, (T -> Bool)>;

	public function new(?parent : Validator, value : T, ?validationList : Map <String, (T -> Bool)>) 
	{
		super(parent);
		this.value = value;
		if (validationList == null) {
			this.validationList = new Map < String, (T -> Bool) > ();
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
	
	public function validateNoChild() {
		var errorList = new Array<String>();
		for (validationkey in validationList.keys()) {
			if (!validationList.get(validationkey)(value)) {
				errorList.push(validationkey);
			}
		}
		
		return errorList;	
	}

}
