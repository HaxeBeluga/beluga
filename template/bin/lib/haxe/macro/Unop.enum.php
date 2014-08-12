<?php

class haxe_macro_Unop extends Enum {
	public static $OpDecrement;
	public static $OpIncrement;
	public static $OpNeg;
	public static $OpNegBits;
	public static $OpNot;
	public static $__constructors = array(1 => 'OpDecrement', 0 => 'OpIncrement', 3 => 'OpNeg', 4 => 'OpNegBits', 2 => 'OpNot');
	}
haxe_macro_Unop::$OpDecrement = new haxe_macro_Unop("OpDecrement", 1);
haxe_macro_Unop::$OpIncrement = new haxe_macro_Unop("OpIncrement", 0);
haxe_macro_Unop::$OpNeg = new haxe_macro_Unop("OpNeg", 3);
haxe_macro_Unop::$OpNegBits = new haxe_macro_Unop("OpNegBits", 4);
haxe_macro_Unop::$OpNot = new haxe_macro_Unop("OpNot", 2);
