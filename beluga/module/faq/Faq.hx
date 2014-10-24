// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.faq;

import beluga.core.module.IModule;

import beluga.module.faq.model.FaqModel;
import beluga.module.faq.model.CategoryModel;
import beluga.module.faq.CategoryData;

import haxe.ds.Option;

interface Faq extends IModule {
    public var triggers: FaqTrigger;
    public var faq_id : Option<Int>;
    public var category_id : Option<Int>;
    public var widgets : FaqWidget;

    public function redirectEditFAQ() : Bool;
    public function getCurrentCategory() : CategoryModel;

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
    private function getAllFromCategory(category_id: Int) : CategoryData;
    public function getAllCategories() : Array<CategoryModel>;
    private function getCategory(category_id : Int) : CategoryModel;
    private function getFAQ(faq_id : Int) : FaqModel;
}