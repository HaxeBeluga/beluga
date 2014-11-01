// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.api ;

import beluga.module.account.api.AccountApi;
import beluga.Beluga;

/**
 * This class is needed to trigger autoBuild.
 * @author Masadow
 */
@:autoBuild(beluga.api.APIBuilder.build())
interface IAPI<Module> {
    public var beluga : Beluga;
    public var module : Module;
}