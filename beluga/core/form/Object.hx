package beluga.core.form;

@:autoBuild(beluga.core.form.ValidateMacro.build())
class Object {
	public var error : Map<String, Array<String>>;

    public function new() : Void {
        this.error = new Map<String, Array<String>>();
    }

    public function validate() : Bool {
        return (!this.error.iterator().hasNext());
    }
}