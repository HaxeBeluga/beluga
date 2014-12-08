package beluga.widget;

import haxe.Template;
import beluga.resource.ResourceManager;
import haxe.macro.Expr;

class Layout {
    public var parent : Layout;
    public var tpl : Template;

    macro public static function newFromPath(tpl_path : ExprOf<String>, ?parent : Expr) {
        var tpl_id = ResourceManager.register(tpl_path);
        return switch (parent) {
            case null: macro new Layout(beluga.resource.ResourceManager.dynGetTplFromId($v{tpl_id}));
            default : macro new Layout(beluga.resource.ResourceManager.dynGetTplFromId($v{tpl_id}), ${parent});
        }
    }

    public function new(tpl : Template, ?parent : Layout) {
        this.tpl = tpl;
        this.parent = parent;
    }

    macro public function wrap(ethis : Expr, tpl_path : ExprOf<String>) {
        var tpl_id = ResourceManager.register(tpl_path);
        return macro new Layout(beluga.resource.ResourceManager.dynGetTplFromId($v{tpl_id}), ${ethis});
    }

    public function execute(ctx : Dynamic, m : Dynamic) : String {
        var render = ctx.__content__ = tpl.execute(ctx, m);
        if (parent != null) {
            render = parent.execute(ctx, m);
        }
        return render;
    }

}