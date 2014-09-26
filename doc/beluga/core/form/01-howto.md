# Beluga's Form

Beluga's form system allows developers to automatically analyze the GET/POST
data they receive.

# Implementation

## Basic form

Imagine a simple form asking for a **name**, an **age** and an optional
**gender**. Let's wrap it inside a Haxe object:

```Haxe
class MyFrom
{
  public var name : String;
  public var age : Int;
  public var genre : Null<String>;
}
```

###### Notes

The following basic types are recognized :
* Int
* Float
* String
* Bool

You can make one or several parameters optional by specifying that its type is
`Null<T>`.

## Set requirements

Now we have our form, we have to define the requirements (or rules) that our
data need to validate. In order to achieve it, our form should inherit from
`beluga.form.Object`. and then, we can prefixe each variables with metadata.

```Haxe
class MyFrom extends beluga.form.Object
{
  @MinLength(4)
  @MaxLength(32)
  public var name : String;

  @RangeValue(0, 120)
  @Match(Pattern.Number)
  public var age : Int;

  @Match(Pattern.Alpha)
  public var genre : Null<String>;
}
```

###### List of requirements

* MinValue(x): The field value must be above or equal to x
* MaxValue(x): The field value must be below or equal to x
* RangeValue(x, y): Shortcut for MinValue(x) and MaxValue(y)
* EqualValue(value): The field must be equal to the given value
* MinLength(x): The field must be at least x characters length
* MaxLength(x): The field must be at most x characters length
* RangeLength(x, y): Shortcut for MinLength(x) and MaxLength(y)
* EqualLength(x): The field must be exactly x characters length
* Match(pattern): The field value must match the given pattern
* EqualTo(field): The field must be equal to another field
* Database(table, field): The field must match at least one value in database
considered given table and field. *Under development*
* Alter(function): The field will be altered by given function. The original
value will be lost! This rule always return true.

###### List of predefined pattern *(Under development)*

* Number: Match number.
* Alpha: Match alphabetic characters.
* AlphaNumeric: Match alpha-numeric character. Combinaison of Number and Alpha.
* Email: Match e-mail address.
* Date: Match date format.
* Time: Match time format.
* DateTime: Match date and time format. Cominaison of Date andTime.
* Month: Match month format.
* Week: Match week format.
* Phone: Match phone format.
* Color: Match color format.
* URL: Match URL format.
* Expr(expr): Custom pattern.

## Validation process

At this point, we define our form and its requirements so, now, it's time to
talk about its validation. Actually, this is really simple. Firstly, you have
to create your form object by passing the anonymous structure as a parameter. It avoids
to manually assign the content of the structure albeit possible. Once it's done,
you just have to call the function `validate`. If an error occurred, then you can access
it by the public variable `error`; which is a `Map` with the data name as key and the
requirement name as value.

```Haxe
class MyFrom extends beluga.form.Object
{
  @MinLength(4)
  @MaxLength(32)
  public var name : String;

  @RangeValue(0, 120)
  @Match(Pattern.Number)
  public var age : Int;

  @Match(Pattern.Alpha)
  public var genre : Null<String>;
}

// ...

public function doSomething(args : {name : String, age : Int, genre : Null<String>})
{
  // Init the form object with form data
  var my_form = new MyForm(args);

  // Check correctness of data
  var is_correct = my_form.validate();
  if (is_correct == true)
  {
    // No error! Yippee-Ki Yay \o/
  }
  else
  {
    trace(my_form.error);
  }
}
```

## Limitations

We miss a system that can automatically bind the Beluga error system to the validate process. We still need to check
by ourselves creating huge `if/else` statements. It MUST change.
