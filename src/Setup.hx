package ;
import neko.Lib;
import neko.zip.Compress;
import neko.zip.Uncompress;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Masadow
 */
class Setup
{
	private static var projectName : String = null;
	
	private static function checkArgs(userArgs : Array<String>) : Bool {
		//loop through args to find [-all] or [-module name] parameters
		for (arg in userArgs) {
			if (projectName == null) {
				projectName = arg;
			}
			else {
				Sys.println("Warning: Extra or invalid parameter \"" + arg + "\" will be ignored");
			}
		}
		return projectName != null;
	}
	
	public static function cpDirectory(src : String, dst : String)
	{
		if (FileSystem.isDirectory(src))
		{
			for (file in FileSystem.readDirectory(src))
			{
				file = "/" + file;
				if (FileSystem.isDirectory(src + file))
				{
					FileSystem.createDirectory(dst + file);
					cpDirectory(src + file, dst + file);
				}
				else
					File.copy(src + file, dst + file);
			}
		}
	}
	
	public static function run(libDir : String, userArgs : Array<String>) : String
	{
		if (checkArgs(userArgs)) {
			Sys.println("Generate project \"" + projectName + "\" in :\n\"" + libDir + projectName + "\"\n");
			
			if (FileSystem.exists(libDir + projectName)) {
				return "the folder " + libDir + projectName + " already exists";
			}

			FileSystem.createDirectory(libDir + projectName);

			//Copy the whole template directory
			cpDirectory("template", libDir + projectName);
			
			//Rename the config file
			FileSystem.rename(libDir + projectName + "/template.hxml", libDir + projectName + "/" + projectName + ".hxml");

			Sys.println("\nDone");
			return null;
		}
		return "Setup usage: setup project_name [-all] [-module name]";
	}
	
}