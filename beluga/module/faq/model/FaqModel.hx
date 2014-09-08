package beluga.module.faq.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.faq.model.CategoryModel;

@:table("beluga_faq_faq")
@:id(id)
class FaqModel extends Object {
    public var id : SId;
    public var question : STinyText;
    public var answer : SText;
    public var category_id: SInt;
    @:relation(category_id) public var category : CategoryModel;
}