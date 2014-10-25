// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.module;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
import beluga.core.macro.ConfigLoader;

class ModuleBuilder
{

    macro public static function build() : Array<Field>
    {
        return Context.getBuildFields();
    }
}