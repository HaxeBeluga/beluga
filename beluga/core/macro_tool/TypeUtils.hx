package beluga.core.macro_tool;

import haxe.macro.Expr;

class TypeUtils {
  public static function getVarType(field : Field) : Null<TypePath> {
    var type : Null<TypePath>;

    switch (field.kind) {
        case FVar(type_def, _): {
            switch (type_def) {
                case TPath(type_data): type = type_data;
                default: type = null;
            }
        }
        default: type = null;
    }

    return type;
  }

  public static function isTypeParameter(type : TypePath) : Bool {
      if (Lambda.empty(type.params) == true) {
          return false;
      }

      return true;
  }

  public static function getTypeParameter(type : TypePath) : Array<TypePath> {
      var inner_types = new Array<TypePath>();

      for (param in type.params) {
          switch (param) {
              case TPType(param_type): {
                  switch (param_type) {
                      case TPath(inner_type): inner_types.push(inner_type);
                      default: // Nothing to do
                  }
              }
              default: // Nothing to do
          }
      }

      return inner_types;
    }
}