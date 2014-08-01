<?php

class Xml {
	public function __construct($fromCustomParser = null) {
		if(!php_Boot::$skip_constructor) {
		if($fromCustomParser === null) {
			$fromCustomParser = false;
		}
		$this->_fromCustomParser = $fromCustomParser;
	}}
	public $nodeType;
	public $_nodeName;
	public $_nodeValue;
	public $_attributes;
	public $_children;
	public $_parent;
	public $_fromCustomParser;
	public function get_nodeName() {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t !== Xml::$Element : $_t != Xml::$Element)) {
			throw new HException("bad nodeType");
		}
		return $this->_nodeName;
	}
	public function set_nodeName($n) {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t !== Xml::$Element : $_t != Xml::$Element)) {
			throw new HException("bad nodeType");
		}
		return $this->_nodeName = $n;
	}
	public function get_nodeValue() {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$Element : $_t == Xml::$Element) || (is_object($_t2 = $this->nodeType) && !($_t2 instanceof Enum) ? $_t2 === Xml::$Document : $_t2 == Xml::$Document)) {
			throw new HException("bad nodeType");
		}
		return $this->_nodeValue;
	}
	public function set_nodeValue($v) {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$Element : $_t == Xml::$Element) || (is_object($_t2 = $this->nodeType) && !($_t2 instanceof Enum) ? $_t2 === Xml::$Document : $_t2 == Xml::$Document)) {
			throw new HException("bad nodeType");
		}
		return $this->_nodeValue = $v;
	}
	public function get($att) {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t !== Xml::$Element : $_t != Xml::$Element)) {
			throw new HException("bad nodeType");
		}
		return $this->_attributes->get($att);
	}
	public function set($att, $value) {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t !== Xml::$Element : $_t != Xml::$Element)) {
			throw new HException("bad nodeType");
		}
		$this->_attributes->set($att, Xml::__decodeattr($value));
	}
	public function exists($att) {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t !== Xml::$Element : $_t != Xml::$Element)) {
			throw new HException("bad nodeType");
		}
		return $this->_attributes->exists($att);
	}
	public function iterator() {
		if($this->_children === null) {
			throw new HException("bad nodetype");
		}
		return $this->_children->iterator();
	}
	public function elements() {
		if($this->_children === null) {
			throw new HException("bad nodetype");
		}
		return Lambda::filter($this->_children, array(new _hx_lambda(array(), "Xml_0"), 'execute'))->iterator();
	}
	public function elementsNamed($name) {
		if($this->_children === null) {
			throw new HException("bad nodetype");
		}
		return Lambda::filter($this->_children, array(new _hx_lambda(array(&$name), "Xml_1"), 'execute'))->iterator();
	}
	public function addChild($x) {
		if($this->_children === null) {
			throw new HException("bad nodetype");
		}
		if($x->_parent !== null) {
			$x->_parent->_children->remove($x);
		}
		$x->_parent = $this;
		$this->_children->push($x);
	}
	public function removeChild($x) {
		if($this->_children === null) {
			throw new HException("bad nodetype");
		}
		$b = $this->_children->remove($x);
		if($b) {
			$x->_parent = null;
		}
		return $b;
	}
	public function insertChild($x, $pos) {
		if($this->_children === null) {
			throw new HException("bad nodetype");
		}
		if($x->_parent !== null) {
			$x->_parent->_children->remove($x);
		}
		$x->_parent = $this;
		$this->_children->insert($pos, $x);
	}
	public function toString() {
		if((is_object($_t = $this->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$PCData : $_t == Xml::$PCData)) {
			if($this->_fromCustomParser) {
				return StringTools::htmlEscape($this->_nodeValue, null);
			} else {
				return $this->_nodeValue;
			}
		}
		$s = "";
		if((is_object($_t2 = $this->nodeType) && !($_t2 instanceof Enum) ? $_t2 === Xml::$Element : $_t2 == Xml::$Element)) {
			$s .= "<";
			$s .= _hx_string_or_null($this->_nodeName);
			if(null == $this->_attributes) throw new HException('null iterable');
			$__hx__it = $this->_attributes->keys();
			while($__hx__it->hasNext()) {
				$k = $__hx__it->next();
				$s .= " ";
				$s .= _hx_string_or_null($k);
				$s .= "=\"";
				$s .= _hx_string_or_null($this->_attributes->get($k));
				$s .= "\"";
			}
			if($this->_children->length === 0) {
				$s .= "/>";
				return $s;
			}
			$s .= ">";
		} else {
			if((is_object($_t3 = $this->nodeType) && !($_t3 instanceof Enum) ? $_t3 === Xml::$CData : $_t3 == Xml::$CData)) {
				return "<![CDATA[" . _hx_string_or_null($this->_nodeValue) . "]]>";
			} else {
				if((is_object($_t4 = $this->nodeType) && !($_t4 instanceof Enum) ? $_t4 === Xml::$Comment : $_t4 == Xml::$Comment)) {
					return "<!--" . _hx_string_or_null($this->_nodeValue) . "-->";
				} else {
					if((is_object($_t5 = $this->nodeType) && !($_t5 instanceof Enum) ? $_t5 === Xml::$DocType : $_t5 == Xml::$DocType)) {
						return "<!DOCTYPE " . _hx_string_or_null($this->_nodeValue) . ">";
					} else {
						if((is_object($_t6 = $this->nodeType) && !($_t6 instanceof Enum) ? $_t6 === Xml::$ProcessingInstruction : $_t6 == Xml::$ProcessingInstruction)) {
							return "<?" . _hx_string_or_null($this->_nodeValue) . "?>";
						}
					}
				}
			}
		}
		if(null == $this) throw new HException('null iterable');
		$__hx__it = $this->iterator();
		while($__hx__it->hasNext()) {
			$x = $__hx__it->next();
			$s .= _hx_string_or_null($x->toString());
		}
		if((is_object($_t3 = $this->nodeType) && !($_t3 instanceof Enum) ? $_t3 === Xml::$Element : $_t3 == Xml::$Element)) {
			$s .= "</";
			$s .= _hx_string_or_null($this->_nodeName);
			$s .= ">";
		}
		return $s;
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
	static $Element;
	static $PCData;
	static $CData;
	static $Comment;
	static $DocType;
	static $ProcessingInstruction;
	static $Document;
	static $build;
	static function __start_element_handler($parser, $name, $attribs) {
		$node = Xml::createElement($name);
		foreach($attribs as $k => $v) $node->set($k, $v);
		Xml::$build->addChild($node);
		Xml::$build = $node;
	}
	static function __end_element_handler($parser, $name) {
		Xml::$build = Xml::$build->_parent;
	}
	static function __decodeattr($value) {
		return str_replace("'", "&apos;", htmlspecialchars($value, ENT_COMPAT, "UTF-8"));
	}
	static function __decodeent($value) {
		return str_replace("'", "&apos;", htmlentities($value, ENT_COMPAT, "UTF-8"));
	}
	static function __character_data_handler($parser, $data) {
		$d = Xml::__decodeent($data);
		if(strlen($data) === 1 && $d !== $data || $d === $data) {
			$last = Xml::$build->_children[Xml::$build->_children->length - 1];
			if(null !== $last && (is_object($_t = $last->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$PCData : $_t == Xml::$PCData)) {
				$_g = $last;
				$_g->set_nodeValue(_hx_string_or_null($_g->get_nodeValue()) . _hx_string_or_null($d));
			} else {
				Xml::$build->addChild(Xml::createPCData($d));
			}
		} else {
			Xml::$build->addChild(Xml::createCData($data));
		}
	}
	static function __default_handler($parser, $data) {
		if($data === "<![CDATA[") {
			return;
		}
		if($data === "]]>") {
			return;
		}
		if("<!--" === _hx_substr($data, 0, 4)) {
			Xml::$build->addChild(Xml::createComment(_hx_substr($data, 4, strlen($data) - 7)));
		} else {
			Xml::$build->addChild(Xml::createPCData($data));
		}
	}
	static $reHeader;
	static function parse($str) {
		Xml::$build = Xml::createDocument();
		$xml_parser = xml_parser_create();
		xml_set_element_handler($xml_parser, (isset(Xml::$__start_element_handler) ? Xml::$__start_element_handler: array("Xml", "__start_element_handler")), (isset(Xml::$__end_element_handler) ? Xml::$__end_element_handler: array("Xml", "__end_element_handler")));
		xml_set_character_data_handler($xml_parser, (isset(Xml::$__character_data_handler) ? Xml::$__character_data_handler: array("Xml", "__character_data_handler")));
		xml_set_default_handler($xml_parser, (isset(Xml::$__default_handler) ? Xml::$__default_handler: array("Xml", "__default_handler")));
		xml_parser_set_option($xml_parser, XML_OPTION_CASE_FOLDING, 0);
		xml_parser_set_option($xml_parser, XML_OPTION_SKIP_WHITE, 0);
		Xml::$reHeader->match($str);
		$str = "<doc>" . _hx_string_or_null(Xml::$reHeader->matchedRight()) . "</doc>";
		if(1 !== xml_parse($xml_parser, $str, true)) {
			throw new HException("Xml parse error (" . _hx_string_or_null((_hx_string_or_null(xml_error_string(xml_get_error_code($xml_parser))) . ") line #" . _hx_string_or_null(xml_get_current_line_number($xml_parser)))));
		}
		xml_parser_free($xml_parser);
		Xml::$build = Xml::$build->_children[0];
		Xml::$build->_parent = null;
		Xml::$build->_nodeName = null;
		Xml::$build->nodeType = Xml::$Document;
		$doctype = Xml::$reHeader->matched(2);
		if(null !== $doctype) {
			Xml::$build->insertChild(Xml::createDocType($doctype), 0);
		}
		$ProcessingInstruction = Xml::$reHeader->matched(1);
		if(null !== $ProcessingInstruction) {
			Xml::$build->insertChild(Xml::createProcessingInstruction($ProcessingInstruction), 0);
		}
		return Xml::$build;
	}
	static function createElement($name) {
		$r = new Xml(null);
		$r->nodeType = Xml::$Element;
		$r->_children = new _hx_array(array());
		$r->_attributes = new haxe_ds_StringMap();
		$r->set_nodeName($name);
		return $r;
	}
	static function createPCData($data) {
		$r = new Xml(null);
		$r->nodeType = Xml::$PCData;
		$r->set_nodeValue($data);
		return $r;
	}
	static function createCData($data) {
		$r = new Xml(null);
		$r->nodeType = Xml::$CData;
		$r->set_nodeValue($data);
		return $r;
	}
	static function createComment($data) {
		$r = new Xml(null);
		$r->nodeType = Xml::$Comment;
		$r->set_nodeValue($data);
		return $r;
	}
	static function createDocType($data) {
		$r = new Xml(null);
		$r->nodeType = Xml::$DocType;
		$r->set_nodeValue($data);
		return $r;
	}
	static function createProcessingInstruction($data) {
		$r = new Xml(null);
		$r->nodeType = Xml::$ProcessingInstruction;
		$r->set_nodeValue($data);
		return $r;
	}
	static function createDocument() {
		$r = new Xml(null);
		$r->nodeType = Xml::$Document;
		$r->_children = new _hx_array(array());
		return $r;
	}
	static $__properties__ = array("set_nodeValue" => "set_nodeValue","get_nodeValue" => "get_nodeValue","set_nodeName" => "set_nodeName","get_nodeName" => "get_nodeName");
	function __toString() { return $this->toString(); }
}
{
	Xml::$Element = "element";
	Xml::$PCData = "pcdata";
	Xml::$CData = "cdata";
	Xml::$Comment = "comment";
	Xml::$DocType = "doctype";
	Xml::$ProcessingInstruction = "processingInstruction";
	Xml::$Document = "document";
}
Xml::$reHeader = new EReg("\\s*(?:<\\?(.+?)\\?>)?(?:<!DOCTYPE ([^>]+)>)?", "mi");
function Xml_0($child) {
	{
		return (is_object($_t = $child->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$Element : $_t == Xml::$Element);
	}
}
function Xml_1(&$name, $child) {
	{
		return (is_object($_t = $child->nodeType) && !($_t instanceof Enum) ? $_t === Xml::$Element : $_t == Xml::$Element) && $child->get_nodeName() === $name;
	}
}
