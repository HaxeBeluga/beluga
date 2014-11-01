// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.faq.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.faq.model.CategoryModel;

@:table("beluga_faq_faq")
@:id(id)
@:build(beluga.Database.registerModel())
class FaqModel extends Object {
    public var id : SId;
    public var question : STinyText;
    public var answer : SText;
    public var category_id: SInt;
    @:relation(category_id) public var category : CategoryModel;
}