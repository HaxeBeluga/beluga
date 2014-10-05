// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.macro;

import haxe.macro.Compiler;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

using StringTools;

class Javascript
{

    private static var entryPoint = "BelugaTmpMainJavascript";

    macro public static function compile() : Expr
    {
        ConfigLoader.forceBuild();

        var realOutput = Compiler.getOutput();
        if (realOutput.endsWith(".n")) //Trick for neko output
            realOutput = realOutput.substr(0, realOutput.lastIndexOf("/"));

        Sys.println("Generating Beluga javascript");

        var fileContent = "package ;\nclass "+ entryPoint +" {\n    public static function main() {\n";
        var classes : Array<String> = [];

        //First get all classes containing a "public static function init()" method
        //for (module in ConfigLoader.modules) {
            //var jsFolder = ConfigLoader.installPath + "/module/" + module.name + "/js";
            //if (FileSystem.exists(jsFolder))
                //for (file in FileSystem.readDirectory(jsFolder))
                    //if (haveInit(jsFolder + "/" + file))
                        //fileContent += "           " + module.path + ".js." + file.substr(0, file.length - 3) + ".init();\n"; //Remove the file extension ".hx"
        //}

        //Create a temporary file to compile our javascript
        File.saveContent(ConfigLoader.installPath + "/../" + entryPoint + ".hx", fileContent + "    }\n}\n");

        //Make sure the output dir exists for our js file
        FileSystem.createDirectory(realOutput + "/js");

        //Compile the actual javascript
        Sys.stderr().writeInput(new Process("haxe", [
            "-cp", ConfigLoader.installPath + "/../",
            "-main", entryPoint,
            "-js", realOutput + "/js/beluga.js"]).stderr);


        //Remove the temporary file
        FileSystem.deleteFile(ConfigLoader.installPath + "/../" + entryPoint + ".hx");

        return macro "Done !";
    }

    public static function haveInit(file : String)
    {
        var content = File.getContent(file);
        return content.indexOf("public static function init()") != -1;
    }

}