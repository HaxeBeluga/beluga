package beluga.module.account;

import beluga.core.module.Module;
import beluga.module.account.model.User;
import sys.db.Types.SId;

interface Account extends Module {
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

    public function getUsers() : Array<User>;
	
    public function showUser(args: { id: Int}): Void;

    public function logout() : Void;

    public function setLoggedUser(user : User) : User;

    public function getLoggedUser() : User;

    public function isLogged() : Bool;

    public function edit(user_id: Int, email : String) : Void;

    public function ban(user_id: Int) : Void;

    public function unban(user_id: Int) : Void;
}
