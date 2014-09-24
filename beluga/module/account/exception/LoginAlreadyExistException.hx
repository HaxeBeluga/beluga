// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account.exception;

import beluga.core.BelugaException;

class LoginAlreadyExistException extends BelugaException {

    public var login(default, null) : String;

    public function new(login : String) {
        super("The login " + login + " already exist");
        this.login = login;
    }

}