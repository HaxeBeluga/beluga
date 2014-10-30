// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.module;

import beluga.core.Beluga;
import beluga.core.BelugaException;
import beluga.core.Widget;
import beluga.core.macro.CssBuilder;
import haxe.Resource;
import haxe.xml.Fast;
import sys.io.File;

@:autoBuild(beluga.core.metadata.Session.build())
@:autoBuild(beluga.core.module.ModuleBuilder.registerModule())
@:autoBuild(beluga.core.macro.CssBuilder.readCssMetadata())
class Module
{
#if !macro
    //Hold the instance of the Beluga object that created this module
    private var beluga : Beluga;

    public function new() : Void
    {
    }

    public function _loadConfig(beluga : Beluga) : Void {
        this.beluga = beluga;
    }

    public function initialize(beluga : Beluga) : Void {}


    public function getWidget(name : String) : Widget {
        //First retrieve the class path
        var module = Type.getClassName(Type.getClass(this)).split(".")[2];
        return new Widget(module, name);
    }
#end
}
