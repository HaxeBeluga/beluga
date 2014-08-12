<?php

class haxe_Template {
	public function __construct($str) {
		if(!php_Boot::$skip_constructor) {
		$tokens = $this->parseTokens($str);
		$this->expr = $this->parseBlock($tokens);
		if(!$tokens->isEmpty()) {
			throw new HException("Unexpected '" . Std::string($tokens->first()->s) . "'");
		}
	}}
	public $expr;
	public $context;
	public $macros;
	public $stack;
	public $buf;
	public function execute($context, $macros = null) {
		if($macros === null) {
			$this->macros = _hx_anonymous(array());
		} else {
			$this->macros = $macros;
		}
		$this->context = $context;
		$this->stack = new HList();
		$this->buf = new StringBuf();
		$this->run($this->expr);
		return $this->buf->b;
	}
	public function resolve($v) {
		if(_hx_has_field($this->context, $v)) {
			return Reflect::field($this->context, $v);
		}
		if(null == $this->stack) throw new HException('null iterable');
		$__hx__it = $this->stack->iterator();
		while($__hx__it->hasNext()) {
			$ctx = $__hx__it->next();
			if(_hx_has_field($ctx, $v)) {
				return Reflect::field($ctx, $v);
			}
		}
		if($v === "__current__") {
			return $this->context;
		}
		return Reflect::field(haxe_Template::$globals, $v);
	}
	public function parseTokens($data) {
		$tokens = new HList();
		while(haxe_Template::$splitter->match($data)) {
			$p = haxe_Template::$splitter->matchedPos();
			if($p->pos > 0) {
				$tokens->add(_hx_anonymous(array("p" => _hx_substr($data, 0, $p->pos), "s" => true, "l" => null)));
			}
			if(_hx_char_code_at($data, $p->pos) === 58) {
				$tokens->add(_hx_anonymous(array("p" => _hx_substr($data, $p->pos + 2, $p->len - 4), "s" => false, "l" => null)));
				$data = haxe_Template::$splitter->matchedRight();
				continue;
			}
			$parp = $p->pos + $p->len;
			$npar = 1;
			$params = (new _hx_array(array()));
			$part = "";
			while(true) {
				$c = _hx_char_code_at($data, $parp);
				$parp++;
				if($c === 40) {
					$npar++;
				} else {
					if($c === 41) {
						$npar--;
						if($npar <= 0) {
							break;
						}
					} else {
						if($c === null) {
							throw new HException("Unclosed macro parenthesis");
						}
					}
				}
				if($c === 44 && $npar === 1) {
					$params->push($part);
					$part = "";
				} else {
					$part .= _hx_string_or_null(chr($c));
				}
				unset($c);
			}
			$params->push($part);
			$tokens->add(_hx_anonymous(array("p" => haxe_Template::$splitter->matched(2), "s" => false, "l" => $params)));
			$data = _hx_substr($data, $parp, strlen($data) - $parp);
			unset($part,$parp,$params,$p,$npar);
		}
		if(strlen($data) > 0) {
			$tokens->add(_hx_anonymous(array("p" => $data, "s" => true, "l" => null)));
		}
		return $tokens;
	}
	public function parseBlock($tokens) {
		$l = new HList();
		while(true) {
			$t = $tokens->first();
			if($t === null) {
				break;
			}
			if(!$t->s && ($t->p === "end" || $t->p === "else" || _hx_substr($t->p, 0, 7) === "elseif ")) {
				break;
			}
			$l->add($this->parse($tokens));
			unset($t);
		}
		if($l->length === 1) {
			return $l->first();
		}
		return haxe__Template_TemplateExpr::OpBlock($l);
	}
	public function parse($tokens) {
		$t = $tokens->pop();
		$p = $t->p;
		if($t->s) {
			return haxe__Template_TemplateExpr::OpStr($p);
		}
		if($t->l !== null) {
			$pe = new HList();
			{
				$_g = 0;
				$_g1 = $t->l;
				while($_g < $_g1->length) {
					$p1 = $_g1[$_g];
					++$_g;
					$pe->add($this->parseBlock($this->parseTokens($p1)));
					unset($p1);
				}
			}
			return haxe__Template_TemplateExpr::OpMacro($p, $pe);
		}
		if(_hx_substr($p, 0, 3) === "if ") {
			$p = _hx_substr($p, 3, strlen($p) - 3);
			$e = $this->parseExpr($p);
			$eif = $this->parseBlock($tokens);
			$t1 = $tokens->first();
			$eelse = null;
			if($t1 === null) {
				throw new HException("Unclosed 'if'");
			}
			if($t1->p === "end") {
				$tokens->pop();
				$eelse = null;
			} else {
				if($t1->p === "else") {
					$tokens->pop();
					$eelse = $this->parseBlock($tokens);
					$t1 = $tokens->pop();
					if($t1 === null || $t1->p !== "end") {
						throw new HException("Unclosed 'else'");
					}
				} else {
					$t1->p = _hx_substr($t1->p, 4, strlen($t1->p) - 4);
					$eelse = $this->parse($tokens);
				}
			}
			return haxe__Template_TemplateExpr::OpIf($e, $eif, $eelse);
		}
		if(_hx_substr($p, 0, 8) === "foreach ") {
			$p = _hx_substr($p, 8, strlen($p) - 8);
			$e1 = $this->parseExpr($p);
			$efor = $this->parseBlock($tokens);
			$t2 = $tokens->pop();
			if($t2 === null || $t2->p !== "end") {
				throw new HException("Unclosed 'foreach'");
			}
			return haxe__Template_TemplateExpr::OpForeach($e1, $efor);
		}
		if(haxe_Template::$expr_splitter->match($p)) {
			return haxe__Template_TemplateExpr::OpExpr($this->parseExpr($p));
		}
		return haxe__Template_TemplateExpr::OpVar($p);
	}
	public function parseExpr($data) {
		$l = new HList();
		$expr = $data;
		while(haxe_Template::$expr_splitter->match($data)) {
			$p = haxe_Template::$expr_splitter->matchedPos();
			$k = $p->pos + $p->len;
			if($p->pos !== 0) {
				$l->add(_hx_anonymous(array("p" => _hx_substr($data, 0, $p->pos), "s" => true)));
			}
			$p1 = haxe_Template::$expr_splitter->matched(0);
			$l->add(_hx_anonymous(array("p" => $p1, "s" => _hx_index_of($p1, "\"", null) >= 0)));
			$data = haxe_Template::$expr_splitter->matchedRight();
			unset($p1,$p,$k);
		}
		if(strlen($data) !== 0) {
			$l->add(_hx_anonymous(array("p" => $data, "s" => true)));
		}
		$e = null;
		try {
			$e = $this->makeExpr($l);
			if(!$l->isEmpty()) {
				throw new HException($l->first()->p);
			}
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			if(is_string($s = $_ex_)){
				throw new HException("Unexpected '" . _hx_string_or_null($s) . "' in " . _hx_string_or_null($expr));
			} else throw $__hx__e;;
		}
		return array(new _hx_lambda(array(&$data, &$e, &$expr, &$l, &$s), "haxe_Template_0"), 'execute');
	}
	public function makeConst($v) {
		haxe_Template::$expr_trim->match($v);
		$v = haxe_Template::$expr_trim->matched(1);
		if(_hx_char_code_at($v, 0) === 34) {
			$str = _hx_substr($v, 1, strlen($v) - 2);
			return array(new _hx_lambda(array(&$str, &$v), "haxe_Template_1"), 'execute');
		}
		if(haxe_Template::$expr_int->match($v)) {
			$i = Std::parseInt($v);
			return array(new _hx_lambda(array(&$i, &$v), "haxe_Template_2"), 'execute');
		}
		if(haxe_Template::$expr_float->match($v)) {
			$f = Std::parseFloat($v);
			return array(new _hx_lambda(array(&$f, &$v), "haxe_Template_3"), 'execute');
		}
		$me = $this;
		return array(new _hx_lambda(array(&$me, &$v), "haxe_Template_4"), 'execute');
	}
	public function makePath($e, $l) {
		$p = $l->first();
		if($p === null || $p->p !== ".") {
			return $e;
		}
		$l->pop();
		$field = $l->pop();
		if($field === null || !$field->s) {
			throw new HException($field->p);
		}
		$f = $field->p;
		haxe_Template::$expr_trim->match($f);
		$f = haxe_Template::$expr_trim->matched(1);
		return $this->makePath(array(new _hx_lambda(array(&$e, &$f, &$field, &$l, &$p), "haxe_Template_5"), 'execute'), $l);
	}
	public function makeExpr($l) {
		return $this->makePath($this->makeExpr2($l), $l);
	}
	public function makeExpr2($l) {
		$p = $l->pop();
		if($p === null) {
			throw new HException("<eof>");
		}
		if($p->s) {
			return $this->makeConst($p->p);
		}
		{
			$_g = $p->p;
			switch($_g) {
			case "(":{
				$e1 = $this->makeExpr($l);
				$p1 = $l->pop();
				if($p1 === null || $p1->s) {
					throw new HException($p1->p);
				}
				if($p1->p === ")") {
					return $e1;
				}
				$e2 = $this->makeExpr($l);
				$p2 = $l->pop();
				if($p2 === null || $p2->p !== ")") {
					throw new HException($p2->p);
				}
				{
					$_g1 = $p1->p;
					switch($_g1) {
					case "+":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_6"), 'execute');
					}break;
					case "-":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_7"), 'execute');
					}break;
					case "*":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_8"), 'execute');
					}break;
					case "/":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_9"), 'execute');
					}break;
					case ">":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_10"), 'execute');
					}break;
					case "<":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_11"), 'execute');
					}break;
					case ">=":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_12"), 'execute');
					}break;
					case "<=":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_13"), 'execute');
					}break;
					case "==":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_14"), 'execute');
					}break;
					case "!=":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_15"), 'execute');
					}break;
					case "&&":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_16"), 'execute');
					}break;
					case "||":{
						return array(new _hx_lambda(array(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2), "haxe_Template_17"), 'execute');
					}break;
					default:{
						throw new HException("Unknown operation " . _hx_string_or_null($p1->p));
					}break;
					}
				}
			}break;
			case "!":{
				$e = $this->makeExpr($l);
				return array(new _hx_lambda(array(&$_g, &$e, &$l, &$p), "haxe_Template_18"), 'execute');
			}break;
			case "-":{
				$e3 = $this->makeExpr($l);
				return array(new _hx_lambda(array(&$_g, &$e3, &$l, &$p), "haxe_Template_19"), 'execute');
			}break;
			}
		}
		throw new HException($p->p);
	}
	public function run($e) {
		switch($e->index) {
		case 0:{
			$v = $e->params[0];
			$this->buf->add(Std::string($this->resolve($v)));
		}break;
		case 1:{
			$e1 = $e->params[0];
			$this->buf->add(Std::string(call_user_func($e1)));
		}break;
		case 2:{
			$eelse = $e->params[2];
			$eif = $e->params[1];
			$e2 = $e->params[0];
			{
				$v1 = call_user_func($e2);
				if($v1 === null || _hx_equal($v1, false)) {
					if($eelse !== null) {
						$this->run($eelse);
					}
				} else {
					$this->run($eif);
				}
			}
		}break;
		case 3:{
			$str = $e->params[0];
			$this->buf->add($str);
		}break;
		case 4:{
			$l = $e->params[0];
			if(null == $l) throw new HException('null iterable');
			$__hx__it = $l->iterator();
			while($__hx__it->hasNext()) {
				$e3 = $__hx__it->next();
				$this->run($e3);
			}
		}break;
		case 5:{
			$loop = $e->params[1];
			$e4 = $e->params[0];
			{
				$v2 = call_user_func($e4);
				try {
					$x = $v2->iterator();
					if(_hx_field($x, "hasNext") === null) {
						throw new HException(null);
					}
					$v2 = $x;
				}catch(Exception $__hx__e) {
					$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
					$e5 = $_ex_;
					{
						try {
							if(_hx_field($v2, "hasNext") === null) {
								throw new HException(null);
							}
						}catch(Exception $__hx__e) {
							$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
							$e6 = $_ex_;
							{
								throw new HException("Cannot iter on " . Std::string($v2));
							}
						}
					}
				}
				$this->stack->push($this->context);
				$v3 = $v2;
				$__hx__it = $v3;
				while($__hx__it->hasNext()) {
					$ctx = $__hx__it->next();
					$this->context = $ctx;
					$this->run($loop);
				}
				$this->context = $this->stack->pop();
			}
		}break;
		case 6:{
			$params = $e->params[1];
			$m = $e->params[0];
			{
				$v4 = Reflect::field($this->macros, $m);
				$pl = new _hx_array(array());
				$old = $this->buf;
				$pl->push((isset($this->resolve) ? $this->resolve: array($this, "resolve")));
				if(null == $params) throw new HException('null iterable');
				$__hx__it = $params->iterator();
				while($__hx__it->hasNext()) {
					$p = $__hx__it->next();
					switch($p->index) {
					case 0:{
						$v5 = $p->params[0];
						$pl->push($this->resolve($v5));
					}break;
					default:{
						$this->buf = new StringBuf();
						$this->run($p);
						$pl->push($this->buf->b);
					}break;
					}
				}
				$this->buf = $old;
				try {
					$this->buf->add(Std::string(Reflect::callMethod($this->macros, $v4, $pl)));
				}catch(Exception $__hx__e) {
					$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
					$e7 = $_ex_;
					{
						$plstr = null;
						try {
							$plstr = $pl->join(",");
						}catch(Exception $__hx__e) {
							$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
							$e8 = $_ex_;
							{
								$plstr = "???";
							}
						}
						$msg = "Macro call " . _hx_string_or_null($m) . "(" . _hx_string_or_null($plstr) . ") failed (" . Std::string($e7) . ")";
						throw new HException($msg);
					}
				}
			}
		}break;
		}
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
	static $splitter;
	static $expr_splitter;
	static $expr_trim;
	static $expr_int;
	static $expr_float;
	static function globals() { $args = func_get_args(); return call_user_func_array(self::$globals, $args); }
	static $globals;
	function __toString() { return 'haxe.Template'; }
}
haxe_Template::$splitter = new EReg("(::[A-Za-z0-9_ ()&|!+=/><*.\"-]+::|\\\$\\\$([A-Za-z0-9_-]+)\\()", "");
haxe_Template::$expr_splitter = new EReg("(\\(|\\)|[ \x0D\x0A\x09]*\"[^\"]*\"[ \x0D\x0A\x09]*|[!+=/><*.&|-]+)", "");
haxe_Template::$expr_trim = new EReg("^[ ]*([^ ]+)[ ]*\$", "");
haxe_Template::$expr_int = new EReg("^[0-9]+\$", "");
haxe_Template::$expr_float = new EReg("^([+-]?)(?=\\d|,\\d)\\d*(,\\d*)?([Ee]([+-]?\\d+))?\$", "");
haxe_Template::$globals = _hx_anonymous(array());
function haxe_Template_0(&$data, &$e, &$expr, &$l, &$s) {
	{
		try {
			return call_user_func($e);
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			$exc = $_ex_;
			{
				throw new HException("Error : " . Std::string($exc) . " in " . _hx_string_or_null($expr));
			}
		}
	}
}
function haxe_Template_1(&$str, &$v) {
	{
		return $str;
	}
}
function haxe_Template_2(&$i, &$v) {
	{
		return $i;
	}
}
function haxe_Template_3(&$f, &$v) {
	{
		return $f;
	}
}
function haxe_Template_4(&$me, &$v) {
	{
		return $me->resolve($v);
	}
}
function haxe_Template_5(&$e, &$f, &$field, &$l, &$p) {
	{
		return Reflect::field(call_user_func($e), $f);
	}
}
function haxe_Template_6(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return _hx_add(call_user_func($e1), call_user_func($e2));
	}
}
function haxe_Template_7(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) - call_user_func($e2);
	}
}
function haxe_Template_8(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) * call_user_func($e2);
	}
}
function haxe_Template_9(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) / call_user_func($e2);
	}
}
function haxe_Template_10(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) > call_user_func($e2);
	}
}
function haxe_Template_11(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) < call_user_func($e2);
	}
}
function haxe_Template_12(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) >= call_user_func($e2);
	}
}
function haxe_Template_13(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) <= call_user_func($e2);
	}
}
function haxe_Template_14(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return _hx_equal(call_user_func($e1), call_user_func($e2));
	}
}
function haxe_Template_15(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return !_hx_equal(call_user_func($e1), call_user_func($e2));
	}
}
function haxe_Template_16(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) && call_user_func($e2);
	}
}
function haxe_Template_17(&$_g, &$_g1, &$e1, &$e2, &$l, &$p, &$p1, &$p2) {
	{
		return call_user_func($e1) || call_user_func($e2);
	}
}
function haxe_Template_18(&$_g, &$e, &$l, &$p) {
	{
		$v = call_user_func($e);
		return $v === null || _hx_equal($v, false);
	}
}
function haxe_Template_19(&$_g, &$e3, &$l, &$p) {
	{
		return -call_user_func($e3);
	}
}
