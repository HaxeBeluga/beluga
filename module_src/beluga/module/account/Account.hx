// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.account;

import beluga.metadata.SessionFlashData;
import beluga.module.account.api.AccountApi;
import haxe.xml.Fast;
import sys.db.Types.SId;
import sys.db.Types;
import sys.db.Manager;

import beluga.Beluga;
import beluga.module.Module;
import beluga.module.account.model.User;
import beluga.module.account.model.Friend;
import beluga.module.account.model.BlackList;
import beluga.module.account.AccountErrorKind;
import beluga.I18n;
import beluga.module.account.Account;
import beluga.api.form.Validator;
import beluga.FlashData;
import haxe.Session;
import beluga.api.BelugaApi;

import beluga.module.account.js.Javascript;

@:Css("/beluga/module/account/view/css/")
class Account extends Module {

    public var triggers = new AccountTrigger();
    public var widgets : AccountWidget;

    @:FlashData
    public var lastLoginError(get, set) : Null<LoginFailCause>;

    @:Session
    public var loggedUser(get, set) : User;

    public var isLogged(get, never) : Bool;

    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/account/locale/");

    @:FlashData
    public var lastSubscribeError(get, set) : Dynamic;
    @:FlashData
    public var lastSubscribeValue(get, set) : Dynamic;

    public var error_id : String;
    public var success_msg : String;

    var config : Dynamic;

    public function new() {
        super();
        config = AccountConfig.get();
    }

    override public function initialize(beluga : Beluga) {
        this.widgets = new AccountWidget();
        beluga.db.initTable(User);
        beluga.api.register("account", new AccountApi(beluga, this));
    }

    public function getLoggedUser() : User {
        return this.loggedUser;
    }

    public function logout() : Void {
        this.loggedUser = null;
        success_msg = "disconnect_success";
        triggers.afterLogout.dispatch();
    }

    public function login(args : {
        login : String,
        password : String
    }) {

        var user : List<User> = User.manager.dynamicSearch({login : args.login});
        if (user.length > 1) {
            //Somethings wrong in database
            lastLoginError = LoginInternalError;
            triggers.loginFail.dispatch({err: lastLoginError});
        } else if (user.length == 0) {
            //login wrong
            lastLoginError = UnknownUser;
            triggers.loginFail.dispatch({err: lastLoginError});
        } else {
            var tmp = user.first();
            if (tmp.hashPassword != haxe.crypto.Md5.encode(args.password)) {
                lastLoginError = WrongPassword;
                triggers.loginFail.dispatch({err: lastLoginError});
            } else {
                // you cannot compare like this : tmp.isBan == true, it will always return false !
                if (tmp.isBan) {
                    lastLoginError = UserBanned;
                    error_id = UserBannished;
                    triggers.loginFail.dispatch({err: lastLoginError});
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
                mandatory: Validator.notEmpty(args.login),
                maxLength: Validator.maxLength(args.login, 255),
                unique: loginUnique(args.login)
            },
            password: {
                mandatory: Validator.notEmpty(args.password),
                confirm: Validator.equalTo(args.password, args.password_conf),
                minLength: Validator.minLength(args.password, 6),
                maxLength: Validator.maxLength(args.password, 255)
            },
            email: {
                mandatory: Validator.notEmpty(args.email),
                isemail: Validator.match(args.email, ~/.+@.+/i),
                maxLength: Validator.maxLength(args.password, 255)
            }
        }

        lastSubscribeValue = args;
        if (Validator.validate(validations)) {
            //Save user in db
            var user = new User();
            user.login = args.login;
            user.setPassword(args.password);
            user.emailVerified = true;//TODO AB Change when activation mail sent.
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
    // I don't understand the meaning of the function getUsers so i wrote this
    // one for the moment as i just want all the list of the user in the website.
    public function getUsers2(): List<User> {
        return User.manager.dynamicSearch({});
    }

    public function getUsersExcept(except: User): Array<User> {
        var users = new Array<User>();
        var id = except == null ? -1 : except.id;

        for (user in User.manager.dynamicSearch({})) {
            if (user.id != id)
                users.push(user);
        }
        return users;
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

    public function get_isLogged() : Bool {
        return this.loggedUser != null;
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
            error_id = MissingLogin;
            triggers.deleteFail.dispatch({err : error_id});
        } else if (user.id != args.id && user.isAdmin == false) {
            error_id = NotAllowed;
            triggers.deleteFail.dispatch({err : error_id});
        } else {
            for (tmp in User.manager.dynamicSearch({id : args.id })) {
                tmp.delete();
                logout();
                success_msg = "delete_success";
                triggers.deleteSuccess.dispatch();
                return;
            }
            error_id = UnknownUser;
            triggers.deleteFail.dispatch({err : error_id});
        }
    }

    public function edit(user_id: Int, email : String) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.editFail.dispatch({err : error_id});
        } else {
            if (user.id != user_id && user.isAdmin == false) {
                error_id = NotAllowed;
                triggers.editFail.dispatch({err : error_id});
            } else {
                user.email = email;
                user.update();
                success_msg = "edit_success";
                triggers.editSuccess.dispatch();
            }
        }
    }

    public function ban(user_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.banFail.dispatch({err : error_id});
        } else {
            if (!user.isAdmin) {
                error_id = NeedAdmin;
                triggers.banFail.dispatch({err : error_id});
            } else if (user_id == user.id) {
                error_id = BanYourself;
                triggers.banFail.dispatch({err : error_id});
            } else {
                for (tmp in User.manager.dynamicSearch({id : user_id })) {
                    if (tmp.isBan == true) {
                        error_id = AlreadyBannished;
                        triggers.banFail.dispatch({err : error_id});
                        return;
                    }
                    tmp.isBan = true;
                    tmp.update();
                    success_msg = "ban_success";
                    triggers.banSuccess.dispatch();
                    return;
                }
                error_id = UnknownUser;
                triggers.banFail.dispatch({err : error_id});
            }
        }
    }

    public function unban(user_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.unbanFail.dispatch({err : error_id});
        } else {
            if (!user.isAdmin) {
                error_id = NeedAdmin;
                triggers.unbanFail.dispatch({err : error_id});
            } else if (user_id == user.id) {
                error_id = UnbanYourself;
                triggers.unbanFail.dispatch({err : error_id});
            } else {
                for (tmp in User.manager.dynamicSearch({id : user_id })) {
                    if (user.isBan == false) {
                        error_id = NotBannished;
                        triggers.unbanFail.dispatch({err : error_id});
                        return;
                    }
                    tmp.isBan = false;
                    tmp.update();
                    success_msg = "unban_success";
                    triggers.unbanSuccess.dispatch();
                    return;
                }
                error_id = UnknownUser;
                triggers.unbanFail.dispatch({err : error_id});
            }
        }
    }

    public function friend(user_id: Int, friend_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.friendFail.dispatch({err : error_id});
        } else {
            var friend = this.getUser(friend_id);

            if (friend == null) {
                error_id = UnknownUser;
                triggers.friendFail.dispatch({err : error_id});
                return;
            }
            if (user_id == friend_id) {
                error_id = FriendYourself;
                triggers.friendFail.dispatch({err : error_id});
                return;
            }
            for (tmp in Friend.manager.dynamicSearch({user_id : user_id, friend_id: friend_id })) {
                error_id = AlreadyFriend;
                triggers.friendFail.dispatch({err : error_id});
                return;
            }
            var f = new Friend();

            f.user_id = user_id;
            f.friend_id = friend_id;
            f.insert();
            success_msg = "friend_success";
            triggers.friendSuccess.dispatch();
        }
    }

    public function unfriend(user_id: Int, friend_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.unfriendFail.dispatch({err : error_id});
        } else {
            var friend = this.getUser(friend_id);

            if (friend == null) {
                error_id = UnknownUser;
                triggers.unfriendFail.dispatch({err : error_id});
                return;
            }
            if (user_id == friend_id) {
                error_id = FriendYourself;
                triggers.unfriendFail.dispatch({err : error_id});
                return;
            }
            for (tmp in Friend.manager.dynamicSearch({user_id : user_id, friend_id: friend_id })) {
                tmp.delete();
                success_msg = "unfriend_success";
                triggers.unfriendSuccess.dispatch();
                return;
            }
            error_id = NotFriend;
            triggers.unfriendFail.dispatch({err : error_id});
        }
    }

    public function blacklist(user_id: Int, to_blacklist_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.blacklistFail.dispatch({err : error_id});
        } else {
            var to_blacklist = this.getUser(to_blacklist_id);

            if (to_blacklist == null) {
                error_id = UnknwownUser;
                triggers.blacklistFail.dispatch({err : error_id});
                return;
            }
            if (user_id == to_blacklist_id) {
                error_id = BlacklistYourself;
                triggers.blacklistFail.dispatch({err : error_id});
                return;
            }
            for (tmp in BlackList.manager.dynamicSearch({user_id : user_id, blacklisted_id: to_blacklist_id })) {
                error_id = AlreadyBlacklisted;
                triggers.blacklistFail.dispatch({err : error_id});
                return;
            }
            var f = new BlackList();

            f.user_id = user_id;
            f.blacklisted_id = to_blacklist_id;
            f.insert();
            success_msg = "blacklist_success";
            triggers.blacklistSuccess.dispatch();
        }
    }

    public function unblacklist(user_id: Int, to_unblacklist_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            error_id = MissingLogin;
            triggers.unblacklistFail.dispatch({err : error_id});
        } else {
            var to_unblacklist = this.getUser(to_unblacklist_id);

            if (to_unblacklist == null) {
                error_id = UnknownUser;
                triggers.unblacklistFail.dispatch({err : error_id});
                return;
            }
            if (user_id == to_unblacklist_id) {
                error_id = BlacklistYourself;
                triggers.unblacklistFail.dispatch({err : error_id});
                return;
            }
            for (tmp in BlackList.manager.dynamicSearch({user_id : user_id, blacklisted_id: to_unblacklist_id })) {
                tmp.delete();
                success_msg = "unblacklist_success";
                triggers.unblacklistSuccess.dispatch();
                return;
            }
            error_id = NotBlacklisted;
            triggers.unblacklistFail.dispatch({err : error_id});
        }
    }

    public function getErrorString(error: AccountErrorKind) {
        return switch(error) {
            case MissingLogin: BelugaI18n.getKey(this.i18n, "missing_login");
            case NotAllowed: BelugaI18n.getKey(this.i18n, "not_allowed");
            case UnknownUser: BelugaI18n.getKey(this.i18n, "unknown_user");
            case UserBannished: BelugaI18n.getKey(this.i18n, "user_bannished");
            case NeedAdmin: BelugaI18n.getKey(this.i18n, "need_admin_rights");
            case BanYourself: BelugaI18n.getKey(this.i18n, "ban_yourself");
            case UnbanYourself: BelugaI18n.getKey(this.i18n, "unban_yourself");
            case AlreadyBanished: BelugaI18n.getKey(this.i18n, "already_bannished");
            case NotBannished; BelugaI18n.getKey(this.i18n, "not_bannished");
            case FriendYourself: BelugaI18n.getKey(this.i18n, "friend_yourself");
            case AlreadyFriend: BelugaI18n.getKey(this.i18n, "already_friend");
            case NotFriend: BelugaI18n.getKey(this.i18n, "not_friend");
            case BlacklistYourself: BelugaI18n.getKey(this.i18n, "blacklist_yourself");
            case AlreadyBlacklisted: BelugaI18n.getKey(this.i18n, "already_blacklisted");
            case NotBlacklisted; BelugaI18n.getKey(this.i18n, "not_blacklisted");
            case None: "";
        };
    }
}
