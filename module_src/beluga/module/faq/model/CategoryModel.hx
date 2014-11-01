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

@:table("beluga_faq_category")
@:id(id)
@:build(beluga.Database.registerModel())
class CategoryModel extends Object {
    public var id : SId;
    public var name : STinyText;
    public var parent_id: SInt;
    @:relation(parent_id) public var parent : CategoryModel;
}