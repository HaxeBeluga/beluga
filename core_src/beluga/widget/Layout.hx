package beluga.widget;

import haxe.Template;
import beluga.resource.ResourceManager;
import haxe.macro.Expr;

/**
 * ...
 * @author Alexis Brissard
 */
class Layout
{
    
    public var parent : Layout;
    public var tpl : Template;
    
    macro public static function newFromPath(tpl_path : ExprOf<String>, ?parent : Expr) {
        var tpl_id = ResourceManager.register(tpl_path);
        return switch (parent) {
            case null: macro new Layout(ResourceManager.dynGetTplFromId($v{tpl_id}));
            case _ : macro new Layout(ResourceManager.dynGetTplFromId($v{tpl_id}), ${parent});
        }
    }

    public function new(tpl : Template, ?parent : Layout) {
        this.tpl = tpl;
        this.parent = parent;
    }

    macro public function bind(ethis : Expr, tpl_path : ExprOf<String>) {
        var tpl_id = ResourceManager.register(tpl_path);
        return macro new Layout(ResourceManager.dynGetTplFromId($v{tpl_id}), ${ethis});
    }

    public function execute(ctx : Dynamic, m : Dynamic) : String {
        ctx.__content__ = tpl.execute(ctx, m);
        return switch(parent) {
            case null: ctx.__content__;
            case _: parent.execute(ctx, m);
        }
    }

    #if exemple_code
        var base = Layout.newFromPath("base.mtt");
        var bootstrap = Layout.newFromPath("bootstrap.mtt", base);
        var bootstrap = base.bind("bootstrap.mtt");
    #end

}