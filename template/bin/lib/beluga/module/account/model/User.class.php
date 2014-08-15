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
	public $isAdmin;
	public $isBan;
	public $sponsor_id;
	public $email;
	public function setPassword($password) {
		$this->hashPassword = haxe_crypto_Md5::encode($password);
	}
	public function get_sponsor() {
		return beluga_module_account_model_User::$manager->h__get($this, "sponsor", "sponsor_id", false);
	}
	public function set_sponsor($_v) {
		return beluga_module_account_model_User::$manager->h__set($this, "sponsor", "sponsor_id", $_v);
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
	static $__properties__ = array("set_sponsor" => "set_sponsor","get_sponsor" => "get_sponsor");
	function __toString() { return 'beluga.module.account.model.User'; }
}
beluga_module_account_model_User::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => (new _hx_array(array("oy4:namey15:beluga_acc_usery7:indexesaoy4:keysay5:loginhy6:uniquetghy9:relationsaoy4:lockfy4:propy7:sponsory4:typey32:beluga.module.account.model.Usery7:cascadefy6:isNullfy3:keyy10:sponsor_idghy7:hfieldsby2:idoR0R17R13fy1:tjy17:sys.db.RecordType:0:0gR15oR0R15R13fR18jR19:1:0gy12:hashPasswordoR0R20R13fR18jR19:9:1i32gR4oR0R4R13fR18jR19:9:1i32gy13:emailVerifiedoR0R21R13fR18jR19:8:0gy5:emailoR0R22R13fR18jR19:9:1i128gy17:subscribeDateTimeoR0R23R13fR18jR19:11:0gy5:isBanoR0R24R13fR18r16gy7:isAdminoR0R25R13fR18r16ghR14aR17hy6:fieldsar7r13r11r19r15r22r21r9r17hg")))))));
beluga_module_account_model_User::$manager = new sys_db_Manager(_hx_qtype("beluga.module.account.model.User"));
