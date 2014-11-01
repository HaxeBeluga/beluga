// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload;

import beluga.module.fileupload.widget.Admin;
import beluga.module.fileupload.widget.Browse;
import beluga.module.fileupload.widget.Send;

class FileuploadWidget {
    public var send = new Send();
    public var browse = new Browse();
    public var admin = new Admin();

    public function new() {}
}