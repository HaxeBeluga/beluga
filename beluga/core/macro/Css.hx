package beluga.core.macro;

import sys.io.File;
import haxe.macro.Expr;
import haxe.macro.Compiler;
import sys.FileSystem;
import beluga.tool.Html;

using StringTools;

/**
 * ...
 * @author Alexis Brissard
 */
class Css
{

    private static var cssList : Array<String> = [
        "//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css",
        "//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css",
        ConfigLoader.getBaseUrl() + "/beluga/css/beluga.css"
    ];

    macro public static function compile() : Expr {
        ConfigLoader.forceBuild();
        var realOutput = Compiler.getOutput();
        if (realOutput.endsWith(".n")) { //Trick for neko output
            realOutput = realOutput.substr(0, realOutput.lastIndexOf("/"));
        }
        Sys.println("Generating " + realOutput + "/beluga/css/beluga.css");
        var writer = File.write(realOutput + "/beluga/css/beluga.css");
        for (module in ConfigLoader.modules) {
            var cssFolder = ConfigLoader.installPath + "/module/" + module.name + "/view/css";
            if (FileSystem.exists(cssFolder))
                for (file in FileSystem.readDirectory(cssFolder))
                    if (file.endsWith(".css")) {
                        writer.writeString(File.getContent(cssFolder + "/" + file));
                    }
        }
        writer.close();
        return macro null;
    }

    public static function getHtmlInclude() : String {
        var html = "";
        for (css in Css.cssList) {
            html += Html.tag("link", ["rel" => "stylesheet", "href" => css]);
        }
        return html;
    }
}