package beluga.core.form;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;

class ValidateMacro
{
  private static function concatExpr(beg_expr : Expr, end_expr : Expr) : Expr
  {
    return ((beg_expr != null) ? macro {${beg_expr} ${end_expr}} : macro $end_expr);
  }

  private static function generateCondition(form_variable : Field, rule : MetadataEntry) : Expr
  {
    var condition_name = "check" + rule.name;
    var condition_arg = [macro $i{form_variable.name}].concat(rule.params);

    // Verify the existence of the rule
    if (Reflect.isFunction(Reflect.field(beluga.core.form.RuleChecker,condition_name)) == false)
    {
      Context.error("The rule '" + rule.name + "' is invalid in '"
                    + Context.getLocalClass() + "' object. Stop.",
                    Context.currentPos());
    }

    // Resolve the "if" statement
    var condition_expr = macro
    {
      if (beluga.core.form.RuleChecker.$condition_name($a{condition_arg}) == false)
      {
        this.error[$v{form_variable.name}].push($v{rule.name});
      }
    }

    return (condition_expr);
  }

  private static function generateDataChecker(form_variable : Field) : Expr
  {
    var checker_expr = null;

    // Concat all conditions
    for (rule in form_variable.meta)
    {
      var condition = generateCondition(form_variable, rule);
      if (condition != null)
      {
        checker_expr = concatExpr(checker_expr, condition);
      }
    }
    return (checker_expr);
  }

  private static function generateValidationBody(fields : Array<Field>) : Expr
  {
    var body_proto : Expr;
   
    // Create the condition statement which analyze the form data
    for (field in fields)
    {
      var data_checker = generateDataChecker(field);
      if (data_checker != null)
      {
        body_proto = concatExpr(body_proto, data_checker);
      }
    }

    // Add the return statement. False if there are errors, true otherwise.
    body_proto = concatExpr(body_proto, macro return (!this.error.iterator().hasNext()));

    return (body_proto);
  }

  private static function createValidationFunction(fields : Array<Field>) : Field
  {
    // Define the return type of the validation function
    var ret_proto = TPath({
      name   : "Bool",
      pack   : [],
      params : []
    });

    // Build the validation function
    var funct_proto = FFun({
      ret    : ret_proto,
      params : [],
      expr   : generateValidationBody(fields),
      args   : []
    });

    // Parametrization of the validation function
    var validation_func = {
      name   : "validate",
      kind   : funct_proto,
      access : [APublic, AOverride],
      meta   : [],
      doc    : null,
      pos    : Context.currentPos()
    }

    return (validation_func);
  }

  macro public static function build() : Array<Field>
  {
    // Get fields of the "Form" object
    var fields = Context.getBuildFields();

    // Create the validation function
    var validation_function = createValidationFunction(fields);

    // Add validation function
    fields.push(validation_function);

    return (fields);
  }
}