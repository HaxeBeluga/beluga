// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package ;

import sys.FileSystem;
import sys.io.File;

class ModuleFactory
{
    private static var USAGE : String = "Setup usage: create_module module_name [-path module_path] [-force] [-package packageName]";
    private static var MODULE_TEMPLATE_DIR : String = "moduleTemplate";

    private static var moduleName : String;
    private static var packageName : String;
    private static var modulePath : String = "beluga/module/";
    private static var isForce = false;

    private static function checkArgs(userArgs : Array<String>) : Bool {
        var isNextModulePath = false;
        var isNextPackageName = false;

        for (arg in userArgs) {
            if (isNextModulePath) {
                isNextModulePath = false;
                modulePath = arg;
            }
            if (isNextPackageName) {
                isNextPackageName = false;
                packageName = arg;
            }
            else switch (arg) {
                case "-package":
                    isNextPackageName = true;
                case "-path":
                    isNextModulePath = true;
                case "-force":
                    isForce = true;
                default:
                    if (moduleName == null) {
                        moduleName = arg.charAt(0).toUpperCase() + arg.substring(1);
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

    private static function replaceTemplate(path: String) {
        var content = File.getContent(path);
        var template = new haxe.Template(content);
        var output = template.execute({
            className: moduleName,
            packageName: packageName,
            helloWorldMsg: "::helloWorldMsg::"
        });
        FileSystem.deleteFile(path);
        //rename mtt file to corresponding hx file. +7 is to skip "module" word.
        var newName = moduleName + path.substr(path.lastIndexOf("/") + 7);
        newName = newName.substr(0, newName.lastIndexOf(".mtt"));
        File.saveContent(path.substr(0, path.lastIndexOf("/")) + "/" + newName, output);
    }

    private static function recurseReplaceTemplates(currentFolder: String) {
        for (item in FileSystem.readDirectory(currentFolder)) {
            var path = currentFolder + "/" + item;
            if (FileSystem.exists(path)) {
                //recurse on any directoy
                if (FileSystem.isDirectory(path))
                    recurseReplaceTemplates(path);
                //replace any template file
                else if (item.lastIndexOf(".mtt") != -1)
                    replaceTemplate(path);
            }
        }
    }

    public static function run(libDir : String, userArgs : Array<String>) : String
    {
        if (checkArgs(userArgs)) {
            packageName = packageName != null ? packageName : moduleName.toLowerCase();
            var fullModulePath = modulePath + packageName;

            Sys.println("Creating module \"" + moduleName + "\" in the folder:\n\"" + fullModulePath + "\"\n");

            if (FileSystem.exists(fullModulePath)) {
                if (isForce)
                    Sys.println("the folder " + fullModulePath + " already exists and will be overwritten along with its content.");
                else
                    return "the folder " + fullModulePath + " already exists";
            } else {
                FileSystem.createDirectory(fullModulePath);
            }

            //Copy the whole module directory
            Sys.println(fullModulePath);
            cpDirectory(MODULE_TEMPLATE_DIR, fullModulePath);

            //Remplace and fill all template files
            recurseReplaceTemplates(fullModulePath);
            Sys.println("\nDone");
            return null;
        }
        return USAGE;
    }
}
