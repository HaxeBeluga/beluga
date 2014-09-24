// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.core.module;
import beluga.core.Beluga;
import haxe.xml.Fast;
import beluga.core.macro.ConfigLoader.ModuleConfig;

interface ModuleInternal extends Module
{
    public function _loadConfig(beluga : Beluga, config : ModuleConfig) : Void;
    public function initialize(beluga : Beluga) : Void;
}