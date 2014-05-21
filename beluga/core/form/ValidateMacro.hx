package beluga.core.form;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;

import beluga.core.macro_tool.ExprUtils;
import beluga.core.macro_tool.TypeUtils;

class ValidateMacro
{
  private static function generateCondition(field_name : String, rule : MetadataEntry) : Expr
  {
    var condition_name = "check" + rule.name;
    var condition_arg = [macro $i{field_name}].concat(rule.params);

    // Verify existence of the rule
    if (Reflect.isFunction(Reflect.field(form.DataChecker, condition_name)) == false)
    {
      Context.error("The rule '" + rule.name + "' is invalid in '"
                    + Context.getLocalClass() + "' object.",
                    Context.currentPos());
    }

    // Resolve "if" statement
    var condition_expr = macro
    {
      if (form.DataChecker.$condition_name($a{condition_arg}) == false)
      {
        this.error[$v{field_name}].push($v{rule.name});
      }
    }

    return (condition_expr);
  }

  private static function generateDataChecker(field : Field) : Array<Expr>
  {
    var checker_expr = new Array<Expr>();

    // Concatenate all conditions
    for (rule in field.meta)
    {
      var condition = generateCondition(field.name, rule);
      if (condition != null)
      {
        checker_expr.push(condition);
      }
    }
    return (checker_expr);
  }

  private static function checkTypeParameter(type : TypePath) : Void
  {
    // Supported type parameter
    var supp_type_parameter = [
      "Null"  => ["Int","Float","String","Bool"]
    ];

    // Check type parameter
    if (supp_type_parameter.exists(type.name) == false)
    {
      Context.error("Unsupported '" + type.name + "<>' type in '"
      + Context.getLocalClass() + "' object.",
      Context.currentPos());
    }

    // Check type inside type parameter
    var inner_types = TypeUtils.getTypeParameter(type);
    if (Lambda.empty(inner_types) == false)
    {
      for (inner_type in inner_types)
      {
        if (Lambda.has(supp_type_parameter.get(type.name), inner_type.name) == false)
        {
          Context.error("Unsupported '" + inner_type.name + "' type inside '"
          + type.name + "<>' in '" + Context.getLocalClass() + "' object.",
          Context.currentPos());
        }
      }
    }
  }

  private static function checkBasicType(type : TypePath) : Void
  {
    // Supported basic type
    var supp_raw_type = ["Int", "Float", "String", "Bool"];

    // Check if supported type
    if (Lambda.has(supp_raw_type, type.name) == false)
    {
      Context.error("Unsupported '" + type.name + "' type in '"
      + Context.getLocalClass() + "' object.",
      Context.currentPos());
    }
  }

  private static function checkSupportedFVarType(field : Field) : Void
  {
    // Check if field is FVar expr and valid
    var type = TypeUtils.getVarType(field);
    if (type == null)
    {
      Context.error("Field is not 'FVar' type in '"
      + Context.getLocalClass() + "' object.",
      Context.currentPos());
    }

    // Check if supported type
    if (TypeUtils.isTypeParameter(type) == true)
    {
      checkTypeParameter(type);
    }
    else
    {
      checkBasicType(type);
    }    
  }

  private static function isNotRequired(field : Field) : Bool
  {
    // Check if it is Null<T>
    var type = TypeUtils.getVarType(field);
    if (TypeUtils.isTypeParameter(type) == false || type.name != "Null")
    {
      return false;
    }
    return true;
  }

  private static function generateNullConditionChecker(field : Field) : Expr
  {
    // Resolve "if" checking if data exists or not
    var var_name = field.name; 
    var null_condition_expr = macro
    {
      if (this.$var_name != null)
      {
        // Will insert generateDataChecker here!
      }
    }
    return null_condition_expr;
  }

  private static function addNullCond(field : Field, data_checker : Expr) : Expr
  {
    var final_if : Expr;
    var not_req_condition = generateNullConditionChecker(field);
          
    switch (not_req_condition.expr)
    {
      case EBlock(exprs):
      {
        switch (exprs[0].expr)
        {
          case EIf(if_cond, if_scope, else_scope):
          {
            final_if = {
              expr : EIf(if_cond, data_checker, else_scope),
              pos  : Context.currentPos()};
          }
          default:
            // Nothing to do
        }
      }
      default:
        //Nothing to do
    }
    return { expr : EBlock([final_if]), pos : Context.currentPos() };
  }

  private static function generateValidationBody(fields : Array<Field>) : Expr
  {
    var body_proto = new Array<Expr>();
   
    // Create condition statement which analyze form data
    for (field in fields)
    {
      if (field.kind.getName() == "FVar")
      {
        // Verify if types in form is valid and supported 
        checkSupportedFVarType(field);

        // Generate condition checking the data
        var data_checker = generateDataChecker(field);
        if (Lambda.empty(data_checker) == false)
        {
          var checker_expr = { expr : EBlock(data_checker), pos  : Context.currentPos() };
          
          // Determine if the field is required or not
          if (isNotRequired(field) == true)
          {
            body_proto.push(addNullCond(field, checker_expr));
          }
          else
          {
            body_proto.push(checker_expr);
          }
        }
      }
    }

    // Add return statement: false if there are errors, true otherwise.
    var return_statement = macro return (!this.error.iterator().hasNext());
    body_proto.push(return_statement);

    return ({ expr : EBlock(body_proto), pos : Context.currentPos() });
  }

  private static function createValidationFunction(fields : Array<Field>) : Field
  {
    // Define return type of validation function
    var ret_proto = TPath({
      name   : "Bool",
      pack   : [],
      params : []
    });

    // Build validation function
    var funct_proto = FFun({
      ret    : ret_proto,
      params : [],
      expr   : generateValidationBody(fields),
      args   : []
    });

    // Parametrization of validation function
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
    // Get fields of form object
    var fields = Context.getBuildFields();

    // Create the validation function
    var validation_function = createValidationFunction(fields);

    // Add validation function to form object
    fields.push(validation_function);

    return (fields);
  }
}