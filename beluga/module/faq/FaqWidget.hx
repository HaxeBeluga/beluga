package beluga.module.faq;

import beluga.module.faq.widget.CreateCategory;
import beluga.module.faq.widget.Create;
import beluga.module.faq.widget.EditCategory;
import beluga.module.faq.widget.EditFaq;
import beluga.module.faq.widget.Print;

class FaqWidget {
    public var create_category = new CreateCategory();
    public var create = new Create();
    public var edit_category = new EditCategory();
    public var edit_faq = new EditFaq();
    public var print = new Print();

    public function new() {}
}