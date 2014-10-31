// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.api.form ;

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
        return (form_value.length >= min_length);
    }

    public static function checkMaxLength(form_value : String, max_length : Int) : Bool {
        return (form_value.length <= max_length);
    }

    public static function checkRangeLength(form_value : String, min_length : Int, max_length : Int) : Bool {
        return (checkMinLength(form_value, min_length) == true && checkMaxLength(form_value, max_length) == true);
    }

    public static function checkEqualLength(form_value : String, length : Int) : Bool {
        return (form_value.length == length);
    }

    public static function checkMatch(form_value : String, pattern : EReg) : Bool {
        return (pattern.match(form_value));
    }

    @generic
    public static function checkEqualTo<FormDataType>(field : FormDataType, field_bis : FormDataType) : Bool {
        return (field == field_bis);
    }

    @generic
    public static function checkAlter<FormDataType>(field : FormDataType, alter_func : FormDataType -> Bool) : Bool {
        return (alter_func(field));
    }
}