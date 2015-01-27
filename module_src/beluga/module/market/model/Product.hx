// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.market.model;

import sys.db.Object;
import sys.db.Types;
import beluga.module.fileupload.model.File;

@:id(id)
@:table("beluga_mar_product")
@:build(beluga.Database.registerModel())
class Product extends Object {
    public var id: SId;
    public var stock: SInt;
    public var name: STinyText;
    public var price: SFloat;
    public var desc : SText;
    public var image_id: Null<SInt>;
    @:relation(image_id) public var image : Null<File>;
}