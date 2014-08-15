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
import beluga.module.account.exception.LoginAlreadyExistException;
import beluga.module.account.ESubscribeFailCause;
import beluga.core.macro.MetadataReader;

class AccountImpl extends ModuleImpl implements AccountInternal implements MetadataReader {

    private static inline var SESSION_USER = "session_user";

    public function new() {
        super();
    }

    override public function loadConfig(data : Fast) {}

    public static function _logout() {
        Beluga.getInstance().getModuleInstance(Account).logout();
    }

    public function logout() {
		Session.remove(SESSION_USER);
        beluga.triggerDispatcher.dispatch("beluga_account_logout", []);
    }

    @bTrigger("beluga_account_login")
    public static function _login(args : {
        login : String,
        password : String
    }) {
        Beluga.getInstance().getModuleInstance(Account).login(args);
    }

    public function login(args : {
        login : String,
        password : String
    }) {
        var user : List<User> = User.manager.dynamicSearch({login : args.login});

        if (user.length > 1) {
            //Somethings wrong in database
            beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Something's wrong in database"}]);
        } else if (user.length == 0) {
            //login wrong
            beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Unknown user"}]);
        } else {
            var tmp = user.first();
            if (tmp.hashPassword != haxe.crypto.Md5.encode(args.password)) {
                beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Invalid login and / or password"}]);
            } else {
                // you cannot compare like this : tmp.isBan == true, it will always return false !
                if (tmp.isBan) {
                    beluga.triggerDispatcher.dispatch("beluga_account_login_fail", [{err: "Your account as been bannished"}]);
                } else {
                    setLoggedUser(tmp);
                    beluga.triggerDispatcher.dispatch("beluga_account_login_success", [
                        tmp
                    ]);
                }
            }
        }
    }
	
    private function subscribeCheckArgs(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) : String {

        if (args.login == "") {
            return "invalid login";
        }
        if (args.password == "" || args.password_conf == "") {
            return "missing password";
        }
        if (args.password != args.password_conf) {
            return "passwords don't match";
        }

        for (tmp in User.manager.dynamicSearch( {login : args.login} )) {
            return "login already used";
        }
        //TODO: place user form validation here
        //Also validate that the user is unique with something like this
        //User.manager.dynamicSearch({login : args.login, hashPassword: ahaxe.crypto.Md5.encode(args.password).first() != null;

        return "";
    }

    @bTrigger("beluga_account_subscribe")
    public static function _subscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
        Beluga.getInstance().getModuleInstance(Account).subscribe(args);
    }

    public function subscribe(args : {
        login : String,
        password : String,
        password_conf : String,
        email : String
    }) {
        var error = subscribeCheckArgs(args);
        if (error == "") {
            var user = new User();
            user.login = args.login;
            user.setPassword(args.password);
            //Save user in db
            user.emailVerified = true;//TODO AB Change when activation mail sended.
            user.subscribeDateTime = Date.now();
            user.email = args.email;
            user.isAdmin = false;
            user.isBan = false;
            user.insert();
            //TODO AB Send activation mail
            beluga.triggerDispatcher.dispatch("beluga_account_subscribe_success", [
                user
            ]);
        } else {
            beluga.triggerDispatcher.dispatch("beluga_account_subscribe_fail", [
                error
            ]);
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

    public function getUsers() : Array<User> {
        var user = this.getLoggedUser();
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

    public function setLoggedUser(user : User) : User {
        Session.set(SESSION_USER, user);
        return user;
    }

    public function getLoggedUser() : User {
        return Session.get(SESSION_USER);
    }

    public function isLogged() : Bool {
        return Session.get(SESSION_USER) != null;
    }

    public function _showUser(args: { id: Int}): Void {
        Beluga.getInstance().getModuleInstance(Account).showUser(args);
    }

    public function showUser(args: { id: Int}): Void {
        beluga.triggerDispatcher.dispatch("beluga_account_show_user", [args]);
    }

    public static function _deleteUser(args : {id: Int}) : Void {
        Beluga.getInstance().getModuleInstance(Account).deleteUser(args);
    }

    public function deleteUser(args : {id: Int}) : Void {
        var user = this.getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_delete_fail", [{err: "You have to be logged"}]);
        } else if (user.id != args.id && user.isAdmin == false) {
            beluga.triggerDispatcher.dispatch("beluga_account_delete_fail", [{err: "You can't delete this account"}]);
        } else {
            for (tmp in User.manager.dynamicSearch({id : args.id })) {
                tmp.delete();
                Session.remove(SESSION_USER);
                beluga.triggerDispatcher.dispatch("beluga_account_delete_success", []);
                return;
            }
            beluga.triggerDispatcher.dispatch("beluga_account_delete_fail", [{err: "Unknown user"}]);
        }
    }

    public function edit(user_id: Int, email : String) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_edit_fail", []);
        } else {
            if (user.id != user_id && user.isAdmin == false) {
                beluga.triggerDispatcher.dispatch("beluga_account_edit_fail", []);
            } else {
                user.email = email;
                user.update();
                beluga.triggerDispatcher.dispatch("beluga_account_edit_success", []);
            }
        }
    }

    public function ban(user_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_ban_fail", [{err: "You have to be logged"}]);
        } else {
            if (user_id == user.id)
                beluga.triggerDispatcher.dispatch("beluga_account_ban_fail", [{err: "You can't ban yourself !"}]);
            else if (!user.isAdmin)
                beluga.triggerDispatcher.dispatch("beluga_account_ban_fail", [{err: "You need admin rights to do that"}]);
            else {
                for (tmp in User.manager.dynamicSearch({id : user_id })) {
                    if (tmp.isBan == true) {
                        beluga.triggerDispatcher.dispatch("beluga_account_ban_fail", [{err: "This user is already bannished"}]);
                        return;
                    }
                    tmp.isBan = true;
                    tmp.update();
                    beluga.triggerDispatcher.dispatch("beluga_account_ban_success", []);
                    return;
                }
                beluga.triggerDispatcher.dispatch("beluga_account_ban_fail", [{err: "Unknown user"}]);
            }
        }
    }

    public function unban(user_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_unban_fail", [{err: "You have to be logged"}]);
        } else {
            if (user_id == user.id)
                beluga.triggerDispatcher.dispatch("beluga_account_unban_fail", [{err: "You can't unban yourself !"}]);
            else if (!user.isAdmin)
                beluga.triggerDispatcher.dispatch("beluga_account_unban_fail", [{err: "You need admin rights to do that"}]);
            else {
                for (tmp in User.manager.dynamicSearch({id : user_id })) {
                    if (user.isBan == false) {
                        beluga.triggerDispatcher.dispatch("beluga_account_unban_fail", [{err: "This user is not bannished"}]);
                        return;
                    }
                    tmp.isBan = false;
                    tmp.update();
                    beluga.triggerDispatcher.dispatch("beluga_account_unban_success", []);
                    return;
                }
                beluga.triggerDispatcher.dispatch("beluga_account_unban_fail", [{err: "Unknown user"}]);
            }
        }
    }

    public function friend(user_id: Int, friend_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_friend_fail", [{err: "You have to be logged"}]);
        } else {
            var friend = this.getUser(friend_id);

            if (friend == null) {
                beluga.triggerDispatcher.dispatch("beluga_account_friend_fail", [{err: "Unknown user"}]);
                return;
            }
            if (user_id == friend_id) {
                beluga.triggerDispatcher.dispatch("beluga_account_friend_fail", [{err: "You can't be friend with yourself !"}]);
                return;
            }
            for (tmp in Friend.manager.dynamicSearch({user_id : user_id, friend_id: friend_id })) {
                beluga.triggerDispatcher.dispatch("beluga_account_friend_fail", [{err: "You're already friend with this person"}]);
                return;
            }
            var f = new Friend();

            f.user_id = user_id;
            f.friend_id = friend_id;
            f.insert();
            beluga.triggerDispatcher.dispatch("beluga_account_friend_success", []);
        }
    }

    public function unfriend(user_id: Int, friend_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_unfriend_fail", [{err: "You have to be logged"}]);
        } else {
            var friend = this.getUser(friend_id);

            if (friend == null) {
                beluga.triggerDispatcher.dispatch("beluga_account_unfriend_fail", [{err: "Unknown user"}]);
                return;
            }
            if (user_id == friend_id) {
                beluga.triggerDispatcher.dispatch("beluga_account_unfriend_fail", [{err: "You can't be friend with yourself !"}]);
                return;
            }
            for (tmp in Friend.manager.dynamicSearch({user_id : user_id, friend_id: friend_id })) {
                tmp.delete();
                beluga.triggerDispatcher.dispatch("beluga_account_unfriend_success", []);
                return;
            }
            beluga.triggerDispatcher.dispatch("beluga_account_unfriend_fail", [{err: "You're not friend with this person"}]);
        }
    }

    public function blacklist(user_id: Int, to_blacklist_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_blacklist_fail", [{err: "You have to be logged"}]);
        } else {
            var to_blacklist = this.getUser(to_blacklist_id);

            if (to_blacklist == null) {
                beluga.triggerDispatcher.dispatch("beluga_account_blacklist_fail", [{err: "Unknown user"}]);
                return;
            }
            if (user_id == to_blacklist_id) {
                beluga.triggerDispatcher.dispatch("beluga_account_blacklist_fail", [{err: "You can't blacklist yourself !"}]);
                return;
            }
            for (tmp in BlackList.manager.dynamicSearch({user_id : user_id, blacklisted_id: to_blacklist_id })) {
                beluga.triggerDispatcher.dispatch("beluga_account_blacklist_fail", [{err: "This person is already blacklisted"}]);
                return;
            }
            var f = new BlackList();

            f.user_id = user_id;
            f.blacklisted_id = to_blacklist_id;
            f.insert();
            beluga.triggerDispatcher.dispatch("beluga_account_blacklist_success", []);
        }
    }

    public function unblacklist(user_id: Int, to_unblacklist_id: Int) : Void {
        var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

        if (user == null) {
            beluga.triggerDispatcher.dispatch("beluga_account_unblacklist_fail", [{err: "You have to be logged"}]);
        } else {
            var to_unblacklist = this.getUser(to_unblacklist_id);

            if (to_unblacklist == null) {
                beluga.triggerDispatcher.dispatch("beluga_account_unblacklist_fail", [{err: "Unknown user"}]);
                return;
            }
            if (user_id == to_unblacklist_id) {
                beluga.triggerDispatcher.dispatch("beluga_account_unblacklist_fail", [{err: "You can't blacklist yourself !"}]);
                return;
            }
            for (tmp in BlackList.manager.dynamicSearch({user_id : user_id, blacklisted_id: to_unblacklist_id })) {
                tmp.delete();
                beluga.triggerDispatcher.dispatch("beluga_account_unblacklist_success", []);
                return;
            }
            beluga.triggerDispatcher.dispatch("beluga_account_unblacklist_fail", [{err: "You've not blacklisted this person !"}]);
        }
    }
}
