// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account;

import haxe.xml.Fast;
import haxe.Session;
import sys.db.Types.SId;
import sys.db.Types;
import sys.db.Manager;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.account.model.User;
import beluga.module.account.model.Friend;
import beluga.module.account.model.BlackList;
import beluga.core.BelugaI18n;
import beluga.module.account.Account;
import beluga.core.form.Validator;

class AccountImpl extends ModuleImpl implements AccountInternal {

    private static inline var SESSION_USER = "session_user";

    public var triggers = new AccountTrigger();
    public var widgets : AccountWidget;

    public var loggedUser(get, set) : User;

    public var isLogged(get, never) : Bool;

    public var i18n = BelugaI18n.loadI18nFolder("/module/account/local/");

    public var lastLoginError : LoginFailCause;
    public var lastSubscribeError : Dynamic;
    public var lastSubscribeValue : Dynamic;

    public function new() {
        super();
    }

    override public function initialize(beluga : Beluga) {
        this.widgets = new AccountWidget();
    }

    public function getLoggedUser() : User {
        return this.loggedUser;
    }

    public function logout() : Void {
        Session.remove(SESSION_USER);
        triggers.afterLogout.dispatch();
    }

    public function login(args : {
        login : String,
        password : String
    }) {

        var user : List<User> = User.manager.dynamicSearch({login : args.login});
        if (user.length > 1) {
            //Somethings wrong in database
            lastLoginError = InternalError;
            triggers.loginFail.dispatch({err: InternalError});
        } else if (user.length == 0) {
            //login wrong
            lastLoginError = UnknowUser;
            triggers.loginFail.dispatch({err: UnknowUser});
        } else {
            var tmp = user.first();
            if (tmp.hashPassword != haxe.crypto.Md5.encode(args.password)) {
                lastLoginError = WrongPassword;
                triggers.loginFail.dispatch({err: WrongPassword});
            } else {
                // you cannot compare like this : tmp.isBan == true, it will always return false !
                if (tmp.isBan) {
                    lastLoginError = UserBanned;
                    triggers.loginFail.dispatch({err: UserBanned});
                } else {
                    loggedUser = tmp;
                    triggers.loginSuccess.dispatch();
                }
            }
        }
    }

    public function loginUnique(login : String) {
        var user : List<User> = User.manager.dynamicSearch( { login: login } );
        return user.length == 0;
    }

    public function subscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
        var validations = {
            login: {
                mandatory: Validator.notBlanckOrNull(args.login),
                maxLength: Validator.maxLength(args.login, 255),
                unique: loginUnique(args.login)
            },
            password: {
                mandatory: Validator.notBlanckOrNull(args.password),
                confirm: Validator.equalTo(args.password, args.password_conf),
                minLength: Validator.minLength(args.password, 6),
                maxLength: Validator.maxLength(args.password, 255)
            },
            email: {
                mandatory: Validator.notBlanckOrNull(args.email),
                isemail: Validator.match(args.email, ~/[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z][A-Z][A-Z]?/i),
                maxLength: Validator.maxLength(args.password, 255)
            }
        }
        
        lastSubscribeValue = args;
        if (Validator.validate(validations)) {
            //Save user in db
            var user = new User();
            user.login = args.login;
            user.setPassword(args.password);
            user.emailVerified = true;//TODO AB Change when activation mail sended.
            user.subscribeDateTime = Date.now();
            user.email = args.email;
            user.isAdmin = false;
            user.isBan = false;
            user.insert();
            //TODO AB Send activation mail
            triggers.subscribeSuccess.dispatch({user: user});
        } else {
            lastSubscribeError = validations;
            triggers.subscribeFail.dispatch({validations : validations});
        }
    }

    public function getUser(userId : SId) : Null<User> {
        try
        {
            return User.manager.get(userId);
        }
        catch (e : Dynamic)
        {
            return null;
        }
    }

    public function getSponsor(userId : SId) : User {
        var user = this.getUser(userId);

        if (user == null)
            return null;
        return user.sponsor;
    }

    public function getDisconnectedUsers() : Array<User> {
        var user = this.loggedUser;
        var list = new Array<User>();

        if (user == null) {
            return list;
        }
        for (tmp in User.manager.dynamicSearch({})) {
            if (tmp.id != user.id) {
                list.push(tmp);
            }
        }
        return list;
    }

    // FIXME(Someone who wrote getUsers)
    // I don't understant the meaning of the function getUsers so i wrote this
    // one for the moment as i just want all the list of the user in the website.
    public function getUsers2(): List<User> {
        return User.manager.dynamicSearch({});
    }

    public function getFriends(user_id: Int) : Array<User> {
        var friends = new Array<User>();

        for (tmp in Friend.manager.dynamicSearch({user_id: user_id})) {
            friends.push(tmp.friend);
        }
        return friends;
    }

    public function getNotFriends(user_id: Int) : Array<User> {
        var not_friends = new Array<User>();

        var row = Manager.cnx.request("select * from beluga_acc_user WHERE id!=" + user_id + " AND id NOT IN (SELECT friend_id from beluga_acc_friend)");
        for (tmp in row) {
            // Need to improve this part of the code
            // A sql query would be far more better
            not_friends.push(tmp);
            // haxe magic
            if (isBlacklistedBy(user_id, tmp.id) || isBlacklistedBy(tmp.id, user_id))
                not_friends.pop();
        }
        return not_friends;
    }

    public function getBlackListed(user_id: Int) : Array<User> {
        var blacklisted = new Array<User>();

        for (tmp in BlackList.manager.dynamicSearch({user_id: user_id})) {
            blacklisted.push(tmp.blacklisted);
        }
        return blacklisted;
    }

    public function isBlacklistedBy(user_id: Int, blacklister_id: Int) : Bool {
        var list = getBlackListed(blacklister_id);

        for (tmp in list) {
            if (tmp.id == user_id)
                return true;
        }
        return false;
    }

    public function activateUser(userId : SId) {
        var user = User.manager.get(userId);

        if (user != null) {
            user.emailVerified = true;
            user.update();
        }
    }

    public function set_loggedUser(user : User) : User {
        Session.set(SESSION_USER, user);
        return user;
    }

    public function get_loggedUser() : User {
        return Session.get(SESSION_USER);
    }

    public function get_isLogged() : Bool {
        return Session.get(SESSION_USER) != null;
    }

    public function showUser(args: { id: Int}): Void {
        this.triggers.showUser.dispatch(args);
    }

    public static function _deleteUser(args : {id: Int}) : Void {
        Beluga.getInstance().getModuleInstance(Account).deleteUser(args);
    }

    public function deleteUser(args : {id: Int}) : Void {
        var user = this.loggedUser;

        if (user == null) {
            triggers.deleteFail.dispatch({err : "You have to be logged"});
        } else if (user.id != args.id && user.isAdmin == false) {
            triggers.deleteFail.dispatch({err : "You can't delete this account"});
        } else {
            for (tmp in User.manager.dynamicSearch({id : args.id })) {
                tmp.delete();
                Session.remove(SESSION_USER);
                triggers.deleteSuccess.dispatch();
                return;
            }
            triggers.deleteFail.dispatch({err : "Unknown user"});
        }
    }

    public function edit(user_id: Int, email : String) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.editFail.dispatch({err : "Please log in"});
        } else {
            if (user.id != user_id && user.isAdmin == false) {
                triggers.editFail.dispatch({err : "You can't do that"});
            } else {
                user.email = email;
                user.update();
                triggers.editSuccess.dispatch();
            }
        }
    }

    public function ban(user_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.banFail.dispatch({err : "You have to be logged"});
        } else {
            if (!user.isAdmin)
                triggers.banFail.dispatch({err : "You need admin rights to do that"});
            else if (user_id == user.id)
                triggers.banFail.dispatch({err : "You can't ban yourself !"});
            else {
                for (tmp in User.manager.dynamicSearch({id : user_id })) {
                    if (tmp.isBan == true) {
                        triggers.banFail.dispatch({err : "This user is already bannished"});
                        return;
                    }
                    tmp.isBan = true;
                    tmp.update();
                    triggers.banSuccess.dispatch();
                    return;
                }
                triggers.banFail.dispatch({err : "Unknown user"});
            }
        }
    }

    public function unban(user_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.unbanFail.dispatch({err : "You have to be logged"});
        } else {
            if (!user.isAdmin)
                triggers.unbanFail.dispatch({err : "You need admin rights to do that"});
            else if (user_id == user.id)
                triggers.unbanFail.dispatch({err : "You can't unban yourself !"});
            else {
                for (tmp in User.manager.dynamicSearch({id : user_id })) {
                    if (user.isBan == false) {
                        triggers.unbanFail.dispatch({err : "This user is not bannished"});
                        return;
                    }
                    tmp.isBan = false;
                    tmp.update();
                    triggers.unbanSuccess.dispatch();
                    return;
                }
                triggers.unbanFail.dispatch({err : "Unknown user"});
            }
        }
    }

    public function friend(user_id: Int, friend_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.friendFail.dispatch({err : "You have to be logged"});
        } else {
            var friend = this.getUser(friend_id);

            if (friend == null) {
                triggers.friendFail.dispatch({err : "Unknown user"});
                return;
            }
            if (user_id == friend_id) {
                triggers.friendFail.dispatch({err : "You can't be friend with yourself !"});
                return;
            }
            for (tmp in Friend.manager.dynamicSearch({user_id : user_id, friend_id: friend_id })) {
                triggers.friendFail.dispatch({err : "You're already friend with this user"});
                return;
            }
            var f = new Friend();

            f.user_id = user_id;
            f.friend_id = friend_id;
            f.insert();
            triggers.friendSuccess.dispatch();
        }
    }

    public function unfriend(user_id: Int, friend_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.unfriendFail.dispatch({err : "You have to be logged"});
        } else {
            var friend = this.getUser(friend_id);

            if (friend == null) {
                triggers.unfriendFail.dispatch({err : "Unknown user"});
                return;
            }
            if (user_id == friend_id) {
                triggers.unfriendFail.dispatch({err : "You can't be friend with yourself !"});
                return;
            }
            for (tmp in Friend.manager.dynamicSearch({user_id : user_id, friend_id: friend_id })) {
                tmp.delete();
                triggers.unfriendSuccess.dispatch();
                return;
            }
            triggers.unfriendFail.dispatch({err : "You're not friend with this person"});
        }
    }

    public function blacklist(user_id: Int, to_blacklist_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.blacklistFail.dispatch({err : "You have to be logged"});
        } else {
            var to_blacklist = this.getUser(to_blacklist_id);

            if (to_blacklist == null) {
                triggers.blacklistFail.dispatch({err : "Unknown user"});
                return;
            }
            if (user_id == to_blacklist_id) {
                triggers.blacklistFail.dispatch({err : "You can't blacklist yourself !"});
                return;
            }
            for (tmp in BlackList.manager.dynamicSearch({user_id : user_id, blacklisted_id: to_blacklist_id })) {
                triggers.blacklistFail.dispatch({err : "This person is already blacklisted"});
                return;
            }
            var f = new BlackList();

            f.user_id = user_id;
            f.blacklisted_id = to_blacklist_id;
            f.insert();
            triggers.blacklistSuccess.dispatch();
        }
    }

    public function unblacklist(user_id: Int, to_unblacklist_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            triggers.unblacklistFail.dispatch({err : "You have to be logged"});
        } else {
            var to_unblacklist = this.getUser(to_unblacklist_id);

            if (to_unblacklist == null) {
            triggers.unblacklistFail.dispatch({err : "Unknown user"});
                return;
            }
            if (user_id == to_unblacklist_id) {
                triggers.unblacklistFail.dispatch({err : "You can't blacklist yourself !"});
                return;
            }
            for (tmp in BlackList.manager.dynamicSearch({user_id : user_id, blacklisted_id: to_unblacklist_id })) {
                tmp.delete();
                triggers.unblacklistSuccess.dispatch();
                return;
            }
            triggers.unblacklistFail.dispatch({err : "You've not blacklisted this person !"});
        }
    }
	
}
