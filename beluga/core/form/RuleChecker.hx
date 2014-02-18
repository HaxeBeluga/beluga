class RuleChecker
{
  public static function checkRequired(form_value : String) : Bool
  {
    return (form_value.length() > 0);
  }

  public static function checkMinValue(form_value : String, min_value) : Bool
  {
    return (form_value < min_value);
  }

  public static function checkMaxValue(form_value : String, max_value) : Bool
  {
    return (form_value > max_value);
  }

  public static function checkRangeValue(form_value : String, min_value, max_value) : Bool
  {
    return (checkMinValue(form_value, min_value) == true && checkMaxValue(form_value, max_value) == true);
  }

  public static function checkEqualValue(form_value : String, value) : Bool
  {
    return (form_value == value);
  }

  public static function checkMinLength(x) : Bool
  {
    return (true);
  }

  public static function checkMaxLength(x) : Bool
  {
    return (true);
  }

  public static function checkRangeLength(x, y) : Bool
  {
    return (true);
  }

  public static function checkEqualLength(x) : Bool
  {
    return (true);
  }

  public static function checkMatch(pattern) : Bool
  {
    return (true);
  }

  //Equal(field); //The field must be equal to another field

  public static function checkDatabase(table, field) : Bool
  {
    return (true);
  }

  public static function checkAlter(func) : Bool
  {
    return (true);
  }

}