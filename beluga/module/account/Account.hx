// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account;

import beluga.core.module.Module;
import beluga.module.account.model.User;
import sys.db.Types.SId;

enum LoginFailCause {
	InternalError;
	UnknowUser;
	WrongPassword;
	UserBanned;
}

interface Account extends Module {

    public var triggers : AccountTrigger;

    public var widgets : AccountWidget;

    public var loggedUser(get, set) : User;

    public var isLogged(get, never) : Bool;
	
	public var lastLoginError : LoginFailCause;

    public function subscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) : Void;

    public function login(args : {
        login : String,
        password : String
    }) : Void;

    public function deleteUser(args : {id : Int}) : Void;

    public function getUser(userId : SId) : User;

    public function getSponsor(userId : SId) : User;

    public function getDisconnectedUsers() : Array<User>;
    // FIXME(Someone who wrote getUsers)
    // see the implementation
    public function getUsers2(): List<User>;

    public function getFriends(user_id: Int) : Array<User>;

    public function getNotFriends(user_id: Int) : Array<User>;

    public function getBlackListed(user_id: Int) : Array<User>;

    public function showUser(args: { id: Int}): Void;

    public function logout() : Void;

    //public function setLoggedUser(user : User) : User;

    public function getLoggedUser() : User;

    //public function isLogged() : Bool;

    public function edit(user_id: Int, email : String) : Void;

    public function ban(user_id: Int) : Void;

    public function unban(user_id: Int) : Void;

    public function friend(user_id: Int, friend_id: Int) : Void;

    public function unfriend(user_id: Int, friend_id: Int) : Void;

    public function blacklist(user_id: Int, friend_id: Int) : Void;

    public function unblacklist(user_id: Int, friend_id: Int) : Void;
}
