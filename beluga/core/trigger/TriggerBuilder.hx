package beluga.core.trigger;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * ...
 * @author Masadow
 */
class TriggerBuilder
{
    macro public static function build() : Array<Field> {
		var fields = Context.getBuildFields();
		
		var typeParameter = Context.getLocalClass().get().params[0].t;
		
		trace(Context.getLocalClass().get().params[0].t);
		
		switch (typeParameter)
		{
			case TInst(t, params):
				trace(t.get());
			case _:
				trace("Hello");
		}
		
		return fields;
	}
}