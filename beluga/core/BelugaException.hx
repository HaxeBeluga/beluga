package beluga.core;

/**
 * ...
 * @author Masadow
 */
enum ErrorLevel {
	WARNING;
	NORMAL;
	CRITIC;
}

class BelugaException 
{
	public var message(default, null) : String;
	public var errorLevel(default, null) : ErrorLevel;

	public function new(msg : String, error_level : Null<ErrorLevel> = null) {
		this.message = msg;
		this.errorLevel = error_level != null ? error_level : NORMAL;
	}
}