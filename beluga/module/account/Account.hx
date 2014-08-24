package beluga.module.account;

import beluga.core.module.Module;
import beluga.module.account.model.User;
import sys.db.Types.SId;

interface Account extends Module {
	
	public var triggers : AccountTrigger;
	
	public var widgets : AccountWidget;

	public var loggedUser(get, set) : User;
	
	public var isLogged(get, never) : Bool;	
	
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

	public function getUser(userId : SId) : User;

    public function logout() : Void;

    public function editEmail(user : User, email : String) : Void;
}
