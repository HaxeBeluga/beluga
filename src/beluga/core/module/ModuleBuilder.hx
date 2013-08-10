package beluga.core.module;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * ...
 * @author Masadow
 */
class ModuleBuilder
{
	macro public static function build() : Array<Field>
	{
		var pos = haxe.macro.Context.currentPos();
		var fields = haxe.macro.Context.getBuildFields();

		var clazz = Context.getLocalClass().get();

		var clazzTypePath = { sub: null, params: [], pack : [] , name : clazz.name };
		var clazzComplexType = TPath( clazzTypePath );

		//Generate instance static field
		fields.push( { name : "instance", doc : null, meta : [], access : [APrivate, AStatic], kind : FVar(clazzComplexType, null), pos : pos } );

		//Generate getInstance method for modules
		var nul = Context.makeExpr(null, pos);
		var inst = { pos:pos, expr: EConst(CIdent("instance")) };
		var initInst = { pos:pos, expr: EBinop(OpAssign, inst, { pos:pos, expr: ENew(clazzTypePath, []) }) };
		var fun : Function = {
			ret : clazzComplexType,
			params : [],
			expr : { pos: pos, expr: EBlock([ //getInstance body
										{pos:pos , expr: EIf({pos:pos, expr: EBinop(OpEq, inst, nul)}, initInst, null) },
										{pos:pos , expr: EReturn(inst)}
										])
			}, //End of getInstance body
			args : []
		};
        fields.push({ name : "getInstance", doc : null, meta : [], access : [APublic, AStatic], kind : FFun(fun), pos : pos });

        return fields;
	}
}