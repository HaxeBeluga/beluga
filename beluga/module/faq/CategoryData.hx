package beluga.module.faq;

import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;

class CategoryData {
    public var categories: Array<CategoryModel>;
    public var faqs: Array<FaqModel>;

    public function new(f: Array<FaqModel>, c: Array<CategoryModel>) {
        categories = c;
        faqs = f;
    }
}