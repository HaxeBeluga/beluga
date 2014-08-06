<?php

class haxe_macro_Binop extends Enum {
	public static $OpAdd;
	public static $OpAnd;
	public static $OpArrow;
	public static $OpAssign;
	public static function OpAssignOp($op) { return new haxe_macro_Binop("OpAssignOp", 20, array($op)); }
	public static $OpBoolAnd;
	public static $OpBoolOr;
	public static $OpDiv;
	public static $OpEq;
	public static $OpGt;
	public static $OpGte;
	public static $OpInterval;
	public static $OpLt;
	public static $OpLte;
	public static $OpMod;
	public static $OpMult;
	public static $OpNotEq;
	public static $OpOr;
	public static $OpShl;
	public static $OpShr;
	public static $OpSub;
	public static $OpUShr;
	public static $OpXor;
	public static $__constructors = array(0 => 'OpAdd', 11 => 'OpAnd', 22 => 'OpArrow', 4 => 'OpAssign', 20 => 'OpAssignOp', 14 => 'OpBoolAnd', 15 => 'OpBoolOr', 2 => 'OpDiv', 5 => 'OpEq', 7 => 'OpGt', 8 => 'OpGte', 21 => 'OpInterval', 9 => 'OpLt', 10 => 'OpLte', 19 => 'OpMod', 1 => 'OpMult', 6 => 'OpNotEq', 12 => 'OpOr', 16 => 'OpShl', 17 => 'OpShr', 3 => 'OpSub', 18 => 'OpUShr', 13 => 'OpXor');
	}
haxe_macro_Binop::$OpAdd = new haxe_macro_Binop("OpAdd", 0);
haxe_macro_Binop::$OpAnd = new haxe_macro_Binop("OpAnd", 11);
haxe_macro_Binop::$OpArrow = new haxe_macro_Binop("OpArrow", 22);
haxe_macro_Binop::$OpAssign = new haxe_macro_Binop("OpAssign", 4);
haxe_macro_Binop::$OpBoolAnd = new haxe_macro_Binop("OpBoolAnd", 14);
haxe_macro_Binop::$OpBoolOr = new haxe_macro_Binop("OpBoolOr", 15);
haxe_macro_Binop::$OpDiv = new haxe_macro_Binop("OpDiv", 2);
haxe_macro_Binop::$OpEq = new haxe_macro_Binop("OpEq", 5);
haxe_macro_Binop::$OpGt = new haxe_macro_Binop("OpGt", 7);
haxe_macro_Binop::$OpGte = new haxe_macro_Binop("OpGte", 8);
haxe_macro_Binop::$OpInterval = new haxe_macro_Binop("OpInterval", 21);
haxe_macro_Binop::$OpLt = new haxe_macro_Binop("OpLt", 9);
haxe_macro_Binop::$OpLte = new haxe_macro_Binop("OpLte", 10);
haxe_macro_Binop::$OpMod = new haxe_macro_Binop("OpMod", 19);
haxe_macro_Binop::$OpMult = new haxe_macro_Binop("OpMult", 1);
haxe_macro_Binop::$OpNotEq = new haxe_macro_Binop("OpNotEq", 6);
haxe_macro_Binop::$OpOr = new haxe_macro_Binop("OpOr", 12);
haxe_macro_Binop::$OpShl = new haxe_macro_Binop("OpShl", 16);
haxe_macro_Binop::$OpShr = new haxe_macro_Binop("OpShr", 17);
haxe_macro_Binop::$OpSub = new haxe_macro_Binop("OpSub", 3);
haxe_macro_Binop::$OpUShr = new haxe_macro_Binop("OpUShr", 18);
haxe_macro_Binop::$OpXor = new haxe_macro_Binop("OpXor", 13);
