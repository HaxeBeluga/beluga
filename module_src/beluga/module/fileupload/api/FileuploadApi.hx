// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload.api;

// Haxe
import haxe.web.Dispatch;

// Beluga core
import beluga.Beluga;
import beluga.BelugaException;

// Beluga mods
import beluga.module.fileupload.Fileupload;

class FileuploadApi {
    public var beluga : Beluga;
    public var module : Fileupload;

    public function new(beluga : Beluga, module) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doBrowse(): Void {}

    public function doSend(): Void {
        module.send();
    }

    public function doDefault(): Void {
        trace("FileUpload default page");
    }

    public function doDelete(args: { id: Int }): Void {
        module.delete(args);
    }

    public function doAddextension(args: { name: String }): Void {
        module.addextension(args);
    }

    public function doDeleteextension(args: { id: Int }): Void {
        module.deleteextension(args);
    }
}
