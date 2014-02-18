package form;

import haxe.macro.Expr;
import haxe.macro.Context;

import haxe.macro.ExprTools;

class ValidateMacro
{
  private static function concatExpr(beg_expr : Expr, end_expr : Expr) :Expr
  {
    var final_expr : Expr = macro {${beg_expr}}

    final_expr = (final_expr != null) ? macro {${end_expr}} : macro {${final_expr} ${end_expr}};
    return (final_expr);
  }

  private static function generateVariableChecker(form_variable : Field) : Expr
  {
    var field_name = form_variable.name;
    var cond_chain : Expr = null;

    for (rule in form_variable.meta)
    {
      var checker_func = "check" + rule.name;
      var condition = macro {
        if (RuleChecker.$checker_func(this.$field_name) == false)
        {
          this.error["user"].push("user is required.");
        }
      }

      cond_chain = concatExpr(cond_chain, condition);
    }
    return (cond_chain);
  }

  private static function createValidationFunction(fields : Array<Field>) : Field
  {
    var body_proto : Expr;

    // Define prototype
    for (field in fields)
    {
      body_proto = generateVariableChecker(field);
      trace(ExprTools.toString(body_proto));
    }
    body_proto = concatExpr(body_proto, macro return (true));
    
    //trace(ExprTools.toString(body_proto));

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

    return ({pos : Context.currentPos(), name : "validate", meta : [], kind : funct_proto, doc : null, access : [APublic, AOverride]});
  }

  macro public static function build() : Array<Field>
  {
    // Create the validation function
    var fields = Context.getBuildFields();
    var validation_function = createValidationFunction(fields);
    fields.push(validation_function);

    // TODO : Remove before push
    //Context.warning(fields.toString(), Context.currentPos());

    return fields;
  }
}