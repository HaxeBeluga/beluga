
package beluga.module.account.exception;

import beluga.core.BelugaException;

class LoginAlreadyExistException extends BelugaException
{

	public var login(default, null) : String;

	public function new(login : String) {
		super("The login " + login + " already exist");
		this.login = login;
	}

}