// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload.model;

// beluga mods
import beluga.module.account.model.User;

// haxe
import sys.db.Object;
import sys.db.Types;

@:id(id)
@:table("beluga_fil_file")
@:build(beluga.core.Database.registerModel())
class File extends Object {
    public var id: SId;
    public var owner_id: SInt;
    public var name: SString<32>;
    public var path: SString<32>;
    public var size: SInt;
    @:relation(owner_id)
    public var user: User;
}
