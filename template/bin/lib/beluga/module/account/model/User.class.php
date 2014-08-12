<?php

class beluga_module_account_model_User extends sys_db_Object {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public $id;
	public $login;
	public $hashPassword;
	public $subscribeDateTime;
	public $emailVerified;
	public $email;
	public function setPassword($password) {
		$this->hashPassword = haxe_crypto_Md5::encode($password);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	static function __meta__() { $args = func_get_args(); return call_user_func_array(self::$__meta__, $args); }
	static $__meta__;
	static $manager;
	function __toString() { return 'beluga.module.account.model.User'; }
}
beluga_module_account_model_User::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => (new _hx_array(array("oy4:namey15:beluga_acc_usery7:indexesaoy4:keysay5:loginhy6:uniquetghy9:relationsahy7:hfieldsby2:idoR0R8y6:isNullfy1:tjy17:sys.db.RecordType:0:0gy12:hashPasswordoR0R12R9fR10jR11:9:1i32gR4oR0R4R9fR10jR11:9:1i32gy13:emailVerifiedoR0R13R9fR10jR11:8:0gy5:emailoR0R14R9fR10jR11:9:1i128gy17:subscribeDateTimeoR0R15R9fR10jR11:11:0ghy3:keyaR8hy6:fieldsar6r10r8r16r12r14hg")))))));
beluga_module_account_model_User::$manager = new sys_db_Manager(_hx_qtype("beluga.module.account.model.User"));
