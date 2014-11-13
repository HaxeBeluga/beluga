// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum;

import beluga.module.forum.model.Topic;
import beluga.module.forum.model.CategoryModel;

class CategoryData {
    public var categories: Array<CategoryModel>;
    public var topics: Array<Topic>;

    public function new(_topics: Array<Topic>, _categories: Array<CategoryModel>) {
        categories = _categories;
        topics = _topics;
    }
}