// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.repository;

// beluga core
import beluga.module.SpodRepository;

// beluga mods
import beluga.module.account.model.User;
import haxe.ds.Option;

//haxe
import sys.db.Object;
import sys.db.Types;

class UserRepository extends SpodRepository<User> {

    public function new() {
        super();
    }

    public function getUserByName(login : String) : Option<User> {
        var user = User.manager.search($login == login).first();
        return (user != null ? Some(user) : None);
    }
}