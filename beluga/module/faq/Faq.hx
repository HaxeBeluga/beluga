package beluga.module.faq;

import beluga.core.module.Module;

import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;

interface Faq extends Module {
    public var triggers: FaqTrigger;

    public function createFAQ(args : {
        question : String,
        answer : String,
        category_id : Int
    }) : Void;
    public function createCategory(args : {name : String, parent: Int}) : Void;
    public function deleteFAQ(args : {question_id : Int, category_id : Int}) : Void;
    public function deleteCategory(args : {category_id : Int, parent_id: Int}) : Void;
    public function editCategory(args : {category_id: Int, name : String}) : Void;
    public function editFAQ(args : {faq_id: Int, question : String, answer : String}) : Void;
    public function getAllFromCategory(category_id: Int) : CategoryData;
    public function getAllCategories() : Array<CategoryModel>;
    public function getCategory(category_id : Int) : CategoryModel;
    public function getFAQ(faq_id : Int) : FaqModel;
}