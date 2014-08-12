<?php

class sys_db_RecordType extends Enum {
	public static $DBigId;
	public static $DBigInt;
	public static $DBinary;
	public static $DBool;
	public static function DBytes($n) { return new sys_db_RecordType("DBytes", 19, array($n)); }
	public static $DData;
	public static $DDate;
	public static $DDateTime;
	public static $DEncoded;
	public static function DEnum($name) { return new sys_db_RecordType("DEnum", 31, array($name)); }
	public static function DFlags($flags, $autoSize) { return new sys_db_RecordType("DFlags", 23, array($flags, $autoSize)); }
	public static $DFloat;
	public static $DId;
	public static $DInt;
	public static $DInterval;
	public static $DLongBinary;
	public static $DMediumInt;
	public static $DMediumUInt;
	public static $DNekoSerialized;
	public static $DNull;
	public static $DSerialized;
	public static $DSingle;
	public static $DSmallBinary;
	public static $DSmallInt;
	public static $DSmallText;
	public static $DSmallUInt;
	public static function DString($n) { return new sys_db_RecordType("DString", 9, array($n)); }
	public static $DText;
	public static $DTimeStamp;
	public static $DTinyInt;
	public static $DTinyText;
	public static $DTinyUInt;
	public static $DUId;
	public static $DUInt;
	public static $__constructors = array(4 => 'DBigId', 5 => 'DBigInt', 18 => 'DBinary', 8 => 'DBool', 19 => 'DBytes', 30 => 'DData', 10 => 'DDate', 11 => 'DDateTime', 20 => 'DEncoded', 31 => 'DEnum', 23 => 'DFlags', 7 => 'DFloat', 0 => 'DId', 1 => 'DInt', 32 => 'DInterval', 17 => 'DLongBinary', 28 => 'DMediumInt', 29 => 'DMediumUInt', 22 => 'DNekoSerialized', 33 => 'DNull', 21 => 'DSerialized', 6 => 'DSingle', 16 => 'DSmallBinary', 26 => 'DSmallInt', 14 => 'DSmallText', 27 => 'DSmallUInt', 9 => 'DString', 15 => 'DText', 12 => 'DTimeStamp', 24 => 'DTinyInt', 13 => 'DTinyText', 25 => 'DTinyUInt', 2 => 'DUId', 3 => 'DUInt');
	}
sys_db_RecordType::$DBigId = new sys_db_RecordType("DBigId", 4);
sys_db_RecordType::$DBigInt = new sys_db_RecordType("DBigInt", 5);
sys_db_RecordType::$DBinary = new sys_db_RecordType("DBinary", 18);
sys_db_RecordType::$DBool = new sys_db_RecordType("DBool", 8);
sys_db_RecordType::$DData = new sys_db_RecordType("DData", 30);
sys_db_RecordType::$DDate = new sys_db_RecordType("DDate", 10);
sys_db_RecordType::$DDateTime = new sys_db_RecordType("DDateTime", 11);
sys_db_RecordType::$DEncoded = new sys_db_RecordType("DEncoded", 20);
sys_db_RecordType::$DFloat = new sys_db_RecordType("DFloat", 7);
sys_db_RecordType::$DId = new sys_db_RecordType("DId", 0);
sys_db_RecordType::$DInt = new sys_db_RecordType("DInt", 1);
sys_db_RecordType::$DInterval = new sys_db_RecordType("DInterval", 32);
sys_db_RecordType::$DLongBinary = new sys_db_RecordType("DLongBinary", 17);
sys_db_RecordType::$DMediumInt = new sys_db_RecordType("DMediumInt", 28);
sys_db_RecordType::$DMediumUInt = new sys_db_RecordType("DMediumUInt", 29);
sys_db_RecordType::$DNekoSerialized = new sys_db_RecordType("DNekoSerialized", 22);
sys_db_RecordType::$DNull = new sys_db_RecordType("DNull", 33);
sys_db_RecordType::$DSerialized = new sys_db_RecordType("DSerialized", 21);
sys_db_RecordType::$DSingle = new sys_db_RecordType("DSingle", 6);
sys_db_RecordType::$DSmallBinary = new sys_db_RecordType("DSmallBinary", 16);
sys_db_RecordType::$DSmallInt = new sys_db_RecordType("DSmallInt", 26);
sys_db_RecordType::$DSmallText = new sys_db_RecordType("DSmallText", 14);
sys_db_RecordType::$DSmallUInt = new sys_db_RecordType("DSmallUInt", 27);
sys_db_RecordType::$DText = new sys_db_RecordType("DText", 15);
sys_db_RecordType::$DTimeStamp = new sys_db_RecordType("DTimeStamp", 12);
sys_db_RecordType::$DTinyInt = new sys_db_RecordType("DTinyInt", 24);
sys_db_RecordType::$DTinyText = new sys_db_RecordType("DTinyText", 13);
sys_db_RecordType::$DTinyUInt = new sys_db_RecordType("DTinyUInt", 25);
sys_db_RecordType::$DUId = new sys_db_RecordType("DUId", 2);
sys_db_RecordType::$DUInt = new sys_db_RecordType("DUInt", 3);
