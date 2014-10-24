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
import haxe.Resource;
import haxe.xml.Fast;
import sys.io.File;
import beluga.core.widget.Widget;

@:autoBuild(beluga.core.metadata.Session.build())
@:autoBuild(beluga.core.module.ModuleBuilder.build())
class Module implements IModule
{
    //Hold the instance of the Beluga object that created this module
    private var beluga : Beluga;
    
    @:allow(beluga.core.Beluga)
    private function new() : Void
    {
    }

    @:allow(beluga.core.Beluga) //Only Beluga object can call this method
    private function initialize(beluga : Beluga) : Void {}

}
