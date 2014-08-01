<?php

class sys_FileSystem {
	public function __construct(){}
	static function readDirectory($path) {
		$l = array();
		$dh = opendir($path);
        while (($file = readdir($dh)) !== false) if("." != $file && ".." != $file) $l[] = $file;
        closedir($dh);;
		return new _hx_array($l);
	}
	function __toString() { return 'sys.FileSystem'; }
}
