package beluga.core;

import haxe.CallStack;

/**
 * ...
 * @author Masadow
 */

class BelugaException 
{
	public var message(default, null) : String;

	public function new(msg : String) {
		this.message = msg;
	}

	public function toString() : String {
		for (it in CallStack.callStack()) {
			switch (it) {
				case FilePos(s, file, line): return this.message;
				default:
			}
		}
		return this.message;
	}
}