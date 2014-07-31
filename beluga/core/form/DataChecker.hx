package beluga.core.form;

// TODO Implement the checkDatabase function.

// To create a new rule to check, we just have to concatenate "check" + rule name
// For example: "MinValue" become "check" + "MinValue" == "checkMinValue"

class DataChecker {
    @generic
    public static function checkMinValue<FormDataType : (Int, Float)>(form_value : FormDataType, min_value : FormDataType) : Bool {
        return (form_value < min_value);
    }

    @generic
    public static function checkMaxValue<FormDataType : (Int, Float)>(form_value : FormDataType, max_value : FormDataType) : Bool {
        return (form_value > max_value);
    }

    @generic
    public static function checkRangeValue<FormDataType: (Int, Float)>(form_value : FormDataType, min_value : FormDataType, max_value : FormDataType) : Bool {
        return (checkMinValue(form_value, min_value) == true && checkMaxValue(form_value, max_value) == true);
    }

    @generic
    public static function checkEqualValue<FormDataType>(form_value : FormDataType, value : FormDataType) : Bool {
        return (form_value == value);
    }

    public static function checkMinLength(form_value : String, min_length : Int) : Bool {
	return (form_value.length >= min_length) || isBlanckOrNull(form_value);
    }

    public static function checkMaxLength(form_value : String, max_length : Int) : Bool {
        return (form_value.length <= max_length) || isBlanckOrNull(form_value);
    }

    public static function checkRangeLength(form_value : String, min_length : Int, max_length : Int) : Bool {
        return (checkMinLength(form_value, min_length) == true && checkMaxLength(form_value, max_length) == true) || isBlanckOrNull(form_value);
    }

    public static function checkEqualLength(form_value : String, length : Int) : Bool {
        return (form_value.length == length) || isBlanckOrNull(form_value);
    }

    public static function checkMatch(form_value : String, pattern : EReg) : Bool {
        return (pattern.match(form_value)) || isBlanckOrNull(form_value);
    }

    @generic
    public static function checkEqualTo<FormDataType>(field : FormDataType, field_bis : FormDataType) : Bool {
        return (field == field_bis) || isBlanckOrNull(field);
    }

    @generic
    public static function checkAlter<FormDataType>(field : FormDataType, alter_func : FormDataType -> Bool) : Bool {
        return (alter_func(field))|| isBlanckOrNull(field);
    }

	public static function isNotBlanckOrNull(o : Dynamic) {
		if (Std.is(o, String)) {
			return o != null && o.length != 0;
		}
		return o != null;
	}
	
	public static function isBlanckOrNull(o : Dynamic) {
		return !isNotBlanckOrNull(o);
	}

}