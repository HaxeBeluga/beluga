package ;

/**
 * Supported commands:
	* setup project_name
 * Future commands:
	 * install module_name //Should download the module and install it in beluga
	 * uninstall module_name //Should delete the module from the filesystem
 * @author Masadow
 */
class Main
{

	//Return beluga's repository URL
	private static function getLibDir() : String {
		var args = Sys.args();
		return args[args.length-1];
	}

	public static function displayUsage() {
		Sys.println("Usage:");
		Sys.println("\t* help");
		Sys.println("\t* setup project_name");
		Sys.println("\t\t* Must be run inside a beluga's project folder");
	}

	static function main() {
		var args = Sys.args();
		var errorMessage : String = null;
		var libDir : String = getLibDir();

		//Call the associate function to the command
		var cmdName: String = args.length > 1 ? args[0] : "";
		var cmd: Dynamic = Reflect.field(Main, cmdName);
		if (Reflect.isFunction(cmd)) {
			//arg array is sent without the first and last parameter (cmd name && lib directory)
			errorMessage = Reflect.callMethod(Main, cmd, [libDir, args.splice(1, args.length - 2)]);
		}
		else if (cmdName.length > 0) {
			errorMessage = "Invalid command: " + cmdName;
		}
		else
			displayUsage();

		if (errorMessage != null)
			Sys.println(errorMessage);
	}

	public static function help(_unused : String, _unused2 : Array<String>) : String {
		displayUsage();
		return null;
	}

	public static function setup_project(libDir : String, userArgs : Array<String>) : String {
		return Setup.run(libDir, userArgs);
	}

}
