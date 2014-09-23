// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

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