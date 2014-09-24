// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload;

import beluga.core.module.Module;

interface Fileupload extends Module {
    public var triggers: FileuploadTrigger;
    public var widgets: FileuploadWidget;

    public function send(): Void;
    public function delete(args: { id: Int }): Void;
    public function addextension(args: { name: String }): Void;
    public function deleteextension(args: { id: Int }): Void;
    public function getUserFileList(user_id: Int): List<Dynamic>;
    public function extensionIsValid(name: String): Bool;
}