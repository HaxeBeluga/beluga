package ;

import sys.FileSystem;
import sys.io.File;

class ModuleFactory
{
	private static var USAGE : String = "Setup usage: create_module module_name [-path module_path] [-force]";
    private static var MODULE_TEMPLATE_DIR : String = "moduleTemplate";

	private static var moduleName : String;
	private static var modulePath : String = "beluga\\module\\";
	private static var isDefaultPath = true;
    private static var isForce = false;

	private static function checkArgs(userArgs : Array<String>) : Bool {
		var isNextModulePath = false;

		for (arg in userArgs) {
			if (isNextModulePath) {
				isNextModulePath = false;
				modulePath = arg;
                isDefaultPath = false;
			}
			else switch (arg) {
				case "-path":
					isNextModulePath = true;
                case "-force":
                    isForce = true;
				default:
					if (moduleName == null) {
						moduleName = arg;
					}
					else {
						Sys.println("Warning: Extra or invalid parameter \"" + arg + "\" will be ignored.");
					}
			}
		}
		return moduleName != null;
	}

    private static function cpDirectory(src : String, dst : String)
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

    private static function replaceTemplate(path: String, moduleName: String) {
        var content = File.getContent(path);
        var template = new haxe.Template(content);
        var output = template.execute({
            className: moduleName.charAt(0).toUpperCase() + moduleName.substring(1),
            moduleName: moduleName.charAt(0).toLowerCase() + moduleName.substring(1)}
        );
        FileSystem.deleteFile(path);
        //rename mtt file to corresponding hx file. +7 is to skip "module" word.
        File.saveContent(path.substr(0, path.lastIndexOf("\\")) + "\\" + moduleName +
                         path.substr(path.lastIndexOf("\\") + 7).split(".mtt")[0], output);
    }

    private static function recurseReplaceTemplates(currentFolder: String, moduleName: String) {
        for (item in FileSystem.readDirectory(currentFolder)) {
            var path = currentFolder + "\\" + item;
            if (FileSystem.exists(path)) {
                //recurse on any directoy
                if (FileSystem.isDirectory(path))
                    recurseReplaceTemplates(path, moduleName);
                //replace any template file
                else if (item.lastIndexOf(".mtt") != -1)
                    replaceTemplate(path, moduleName);
            } else {

                Sys.println("something's wrong: " + path);
            }
        }
    }

	public static function run(libDir : String, userArgs : Array<String>) : String
	{
		if (checkArgs(userArgs)) {
            var fullModulePath = (isDefaultPath ? libDir : "") + modulePath + moduleName;

			Sys.println("Creating module \"" + moduleName + "\" in the folder:\n\"" + fullModulePath + "\"\n");

			if (FileSystem.exists(fullModulePath)) {
                if (isForce)
                    Sys.println("the folder " + fullModulePath + " already exists and will be overwritten along with its content.");
                else
				    return "the folder " + fullModulePath + " already exists";
			} else {
                FileSystem.createDirectory(fullModulePath + "/api");
            }

            //Copy the whole module directory
            cpDirectory(MODULE_TEMPLATE_DIR, fullModulePath);

            //Remplace and fill all template files
            recurseReplaceTemplates(fullModulePath, moduleName);
			Sys.println("\nDone");
			return null;
		}
		return USAGE;
	}
}
