package form;

import haxe.macro.Expr;
import haxe.macro.Context;
//import haxe.macro.Metadata;

import haxe.macro.ExprTools;

class ValidateMacro
{
  private static function concatExpr(beg_expr : Expr, end_expr : Expr) : Expr
  {
    return ((beg_expr != null) ? macro {${beg_expr} ${end_expr}} : macro {${end_expr}});
  }

  private static function generateConditionChecker(form_variable : Field) : Expr
  {
    var total_condition = null;

    for (rule in form_variable.meta)
    {
      // Build the "if" ressources
      var func_name = "check" + rule.name;
      var func_arg = [macro $i{form_variable.name}].concat(rule.params);

      // Resolve the "if" statement
      var new_condition = macro {
        if (RuleChecker.$func_name($a{func_arg}) == false)
        {
          this.error[$v{form_variable.name}].push("insert error message here!");
        }
      }

      // Merge the previous compiled condition with the new one
      total_condition = concatExpr(total_condition, new_condition);
    }
    return (total_condition);
  }

  private static function createValidationFunction(fields : Array<Field>) : Field
  {
    var body_proto : Expr;
   
    // Create the condition statement which analyze the form data
    for (field in fields)
    {
      body_proto = generateConditionChecker(field);
    }

    // Add the return statement. True if there are errors, false otherwise.
    body_proto = concatExpr(body_proto, macro return (!this.error.iterator().hasNext()));

    // Define the return type of the validation function
    var ret_proto = TPath({
      name   : "Bool",
      pack   : [],
      params : []
    });

    // Configure the validation function
    var funct_proto = FFun({
      ret    : ret_proto,
      params : [],
      expr   : body_proto,
      args   : []
    });

    trace(ExprTools.toString(body_proto));

    return ({name : "validate", kind : funct_proto, access : [APublic, AOverride], meta : [], doc : null, pos : Context.currentPos()});
  }

  macro public static function build() : Array<Field>
  {
    // Create the validation function
    var fields = Context.getBuildFields();
    var validation_function = createValidationFunction(fields);
    fields.push(validation_function);

    return (fields);
  }
}