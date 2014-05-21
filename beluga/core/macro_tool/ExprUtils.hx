package beluga.core.macro_tool;

import haxe.macro.Expr;

class ExprUtils
{
  public static function concat(beg_expr : Expr, end_expr : Expr) : Expr
  {
    return ((beg_expr != null) ? macro {${beg_expr} ${end_expr}} : macro $end_expr);
  }
}