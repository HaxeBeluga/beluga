// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.tool;

class URI
{
    public static function getDispatchUri() : String {
        #if php
        //Get the index file location
        var src : String = untyped __var__('_SERVER', 'SCRIPT_NAME');
        //Remove server subfolders from URI
        return StringTools.replace(php.Web.getURI(), src.substr(0, src.length - "/index.php".length), "");
        #elseif neko
        return neko.Web.getURI();
        #end
    }

}