package beluga.module.faq.model;

import sys.db.Object;
import sys.db.Types;

@:table("beluga_faq_category")
@:id(id)
class CategoryModel extends Object {
    public var id : SId;
    public var name : STinyText;
    public var parent_id: SInt;
    @:relation(parent_id) public var parent : CategoryModel;
}