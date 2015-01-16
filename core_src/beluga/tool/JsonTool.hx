// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.tool ;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;

enum JsonToolExceptionKind {
    JTFileNotFoundException(error: String);
    JTParseError(error: String);
    JTStringifyError(error : String);
    JTReadOnlyException(error : String);
}

class JsonToolException {
    public var error_kind: JsonToolExceptionKind;

    public function new(error: JsonToolExceptionKind) { this.error_kind = error; }
}

class JsonTool {
    #if macro
    public static function exprLoad(path : String) : Expr {
        var json = Json.parse(File.getContent(Context.resolvePath(path)));
        return Context.makeExpr(json, Context.currentPos());
    }
    #else
    macro public static function staticLoad(path : String) : Expr {
        return exprLoad(Context.resolvePath(path));
    }
    #end

    public static function load(path : String) : Dynamic {
        var content: String;
        var json: Dynamic;

        try { // handle filesystem error, not critic, maybe we don't to fail for a non existing lang
            content = File.getContent(path);
        } catch (e: Dynamic) {
            throw new JsonToolException(JTFileNotFoundException(e));
        }

        try { // here we try to parse the json file, this is more critic, we launch a different exception
            json = Json.parse(content);
        } catch (e: Dynamic) {
            throw new JsonToolException(JTParseError(e));
        }
        return json;
    }
    
    public static function save(path : String, json : Dynamic) {
        var content: String;

        try { // here we try to parse the json file, this is more critic, we launch a different exception
           content = Json.stringify(json, null, "   ");
        } catch (e: Dynamic) {
            throw new JsonToolException(JTStringifyError(e));
        }

        try { // handle filesystem error, not critic, maybe we don't to fail for a non existing lang
            File.saveContent(path, content);
        } catch (e: Dynamic) {
            throw new JsonToolException(JTReadOnlyException(e));
        }
    }
}