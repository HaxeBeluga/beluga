package beluga.resource ;

import haxe.macro.Compiler;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import haxe.macro.Context;
import beluga.tool.Html;

using StringTools;

/**
 * ...
 * @author Masadow
 */
class JavascriptBuilder
{

    private static var entryPoint = "BelugaTmpMainJavascript";

    private static var jsList : Array<String> = {
        ConfigLoader.forceBuild();
        [
            "https://code.jquery.com/jquery-2.1.1.min.js",
            "https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js",
            ConfigLoader.getBaseUrl() + "/beluga/js/beluga.js"
        ];
    }
    
    //List all classes to build to JS target
    private static var files : Array<String> = [];

    macro public static function buildScript() : Array<Field>
    {
        files.push(Context.getLocalModule());
        return Context.getBuildFields();
    }

    macro public static function compile() : Expr {
        ConfigLoader.forceBuild();

        var realOutput = Compiler.getOutput();
        if (realOutput.endsWith(".n")) //Trick for neko output
            realOutput = realOutput.substr(0, realOutput.lastIndexOf("/"));

        Sys.println("Generating " + realOutput + "/beluga/js/beluga.js");

        var fileContent = "package ;\nclass "+ entryPoint +" {\n    public static function main() {\n		var o = new Array<beluga.resource.Javascript>();";
        var classes : Array<String> = [];

        //Build all js objects
        for (js in files) {
            fileContent += "           o.push(new " + js + "());\n"; //Remove the file extension ".hx"
        }

        fileContent += "js.JQuery.JQueryHelper.JTHIS.ready(function (_) for (i in o) { i.ready(); });";

        //Create a temporary file to compile our javascript
        File.saveContent(Context.resolvePath("/beluga/") + entryPoint + ".hx", fileContent + "    }\n}\n");

        //Make sure the output dir exists for our js file
        FileSystem.createDirectory(realOutput + "/beluga/js");

        //Compile the actual javascript
        Sys.stderr().writeInput(new Process("haxe", [
            "-lib", "beluga",
            "-cp", Context.resolvePath("/beluga/"),
            "-main", entryPoint,
            "-js", realOutput + "/beluga/js/beluga.js",
            "-D", "no_conf"]).stderr);


        //Remove the temporary file
        FileSystem.deleteFile(Context.resolvePath("/beluga/" + entryPoint + ".hx"));

        return macro null;
    }

    /*
     * Return a string containing the HTML code to include all js file specified in JS.jsList like:
     * <script src="js1"></script>
     * <script src="js2"></script>
     * etc...
     */
    public static function getHtmlInclude() : String {
        var html = "";
        for (js in JavascriptBuilder.jsList) { 
            html += Html.tag("script", ["src" => js], "");
        }
        return html;
    }	
}