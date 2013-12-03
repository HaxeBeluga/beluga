package ;

/**
 * ...
 * @author Masadow
 */
class Setup
{
	private static var projectName : String = null;
	private static var all : Bool = false;
	private static var modules : List<String> = new List<String>();
	
	private static function checkArgs(userArgs : Array<String>) : Bool {
		//loop through args to find [-all] or [-module name] parameters
		var isNextModule = false;
		for (arg in userArgs) {
			if (isNextModule) {
				modules.push(arg);
				isNextModule = false;
				continue ;
			}
			switch (arg) {
				case "-all":
					all = true;
				case "-module":
					isNextModule = true;
				default:
					if (projectName == null) {
						projectName = arg;
					}
					else {
						Sys.println("Warning: Extra or invalid parameter \"" + arg + "\" will be ignored");
					}
			}
		}
		return projectName != null;
	}
	
	public static function run(libDir : String, userArgs : Array<String>) : String
	{
		if (checkArgs(userArgs)) {
			Sys.println("Now try to create the project \"" + projectName + "\" in the folder:\n\"" + libDir + projectName + "\"\n");
			if (all) {
				Sys.println("All availables modules will be configured");
			}
			else {
				Sys.println("The following modules will be configured:\n" + modules);
			}
			
			
			
			Sys.println("\nDone");
			return null;
		}
		return "Setup usage: setup project_name [-all] [-module name]";
	}
	
}