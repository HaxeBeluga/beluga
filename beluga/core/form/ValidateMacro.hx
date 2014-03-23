package form;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;

// TODO Remove when PUSH
// import haxe.macro.ExprTools;

class ValidateMacro
{
  private static function generateCondition(field_name : String, rule : MetadataEntry) : Expr
  {
    var condition_name = "check" + rule.name;
    var condition_arg = [macro $i{field_name}].concat(rule.params);

    // Verify the existence of the rule
    if (Reflect.isFunction(Reflect.field(form.RuleChecker,condition_name)) == false)
    {
      Context.error("The rule '" + rule.name + "' is invalid in '"
                    + Context.getLocalClass() + "' object. Stop.",
                    Context.currentPos());
    }

    // Resolve the "if" statement
    var condition_expr = macro
    {
      if (form.RuleChecker.$condition_name($a{condition_arg}) == false)
      {
        this.error[$v{field_name}].push($v{rule.name});
      }
    }

    return (condition_expr);
  }

  private static function generateDataChecker(field : Field) : Expr
  {
    var checker_expr = null;

    // Concat all conditions
    for (rule in field.meta)
    {
      var condition = generateCondition(field.name, rule);
      if (condition != null)
      {
        checker_expr = MacroTools.concatExpr(checker_expr, condition);
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
        body_proto = MacroTools.concatExpr(body_proto, data_checker);
      }
    }

    // Add the return statement. False if there are errors, true otherwise.
    body_proto = MacroTools.concatExpr(body_proto, macro return (!this.error.iterator().hasNext()));

    // TODO Remove when PUSH
    // trace(ExprTools.toString(body_proto));

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