package beluga.core.form;

/**
 * ...
 * @author Alexis Brissard
 */
class Validator
{

     /*
    * Browse an object recursivly to check that each bool is true; 
    */
    public static function validate(validations : Dynamic) : Bool {
        if (Std.is(validations, Bool)) {
            var isValid : Bool = cast validations;
            if (!isValid) return false;
        } else if (Reflect.isObject(validations)) {
            var fields = Reflect.fields(validations);
            for (fieldName in fields) {
                var field = Reflect.field(validations, fieldName);
                if(!validate(field)) return false;
            }   
        } else {
            //Warning field not bool can't be tested
        }
        return true;
    }

    /*
    * Return a string corresponding to each error
    * ex:   {
    *           login: {
    *               sizeBetween: false
    *           }
    *       }
    *  return ["login_sizeBetween"]
    */ 
    public static function getErrorKeys(validations : Dynamic, ?prefix : String) : Array<String> {
        var errorKeys = new Array<String>();
        if (Std.is(validations, Bool)) {
            if (!validate(validations)) {
                errorKeys.push(prefix);
            }
        } else if (Reflect.isObject(validations)) {
            var fields = Reflect.fields(validations);
            for (fieldName in fields) {
                var field = Reflect.field(validations, fieldName);
                if (prefix != null) {
                    errorKeys = errorKeys.concat(getErrorKeys(field, prefix + "_" + fieldName));
                } else {
                    errorKeys = errorKeys.concat(getErrorKeys(field, fieldName));
                }
            }
        } else {
            //Warning field not bool can't be tested
        }
        return errorKeys;
    }
    
    @generic
    public static function minValue<FormDataType : (Int, Float)>(form_value : FormDataType, min_value : FormDataType) : Bool {
        return (form_value < min_value);
    }

    @generic
    public static function maxValue<FormDataType : (Int, Float)>(form_value : FormDataType, max_value : FormDataType) : Bool {
        return (form_value > max_value);
    }

    @generic
    public static function rangeValue<FormDataType: (Int, Float)>(form_value : FormDataType, min_value : FormDataType, max_value : FormDataType) : Bool {
        return (minValue(form_value, min_value) == true && maxValue(form_value, max_value) == true);
    }

    @generic
    public static function equalValue<FormDataType>(form_value : FormDataType, value : FormDataType) : Bool {
        return (form_value == value);
    }

    public static function minLength(form_value : String, min_length : Int) : Bool {
	return (form_value.length >= min_length) || blanckOrNull(form_value);
    }

    public static function maxLength(form_value : String, max_length : Int) : Bool {
        return (form_value.length <= max_length) || blanckOrNull(form_value);
    }

    public static function rangeLength(form_value : String, min_length : Int, max_length : Int) : Bool {
        return (minLength(form_value, min_length) == true && maxLength(form_value, max_length) == true) || blanckOrNull(form_value);
    }

    public static function equalLength(form_value : String, length : Int) : Bool {
        return (form_value.length == length) || blanckOrNull(form_value);
    }

    public static function match(form_value : String, pattern : EReg) : Bool {
        return (pattern.match(form_value)) || blanckOrNull(form_value);
    }

    @generic
    public static function equalTo<FormDataType>(field : FormDataType, field_bis : FormDataType) : Bool {
        return (field == field_bis) || blanckOrNull(field);
    }

    public static function notBlanckOrNull(o : Dynamic) {
        if (Std.is(o, String)) {
            return o != null && o.length != 0;
        }
        return o != null;
    }

    public static function blanckOrNull(o : Dynamic) {
        return !notBlanckOrNull(o);
    }

}