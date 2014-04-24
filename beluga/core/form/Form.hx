package form;

@:autoBuild(form.TranslateMacro.build())
@:autoBuild(form.ValidateMacro.build())
class Form
{
  public var error : Map<String, Array<String>>;

  public function new() : Void
  {
    this.error = new Map<String, Array<String>>();
  }

  public function validate() : Bool
  {
    return (!this.error.iterator().hasNext());
  }

}