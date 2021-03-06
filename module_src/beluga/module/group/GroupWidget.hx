// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.group;

import beluga.module.group.widget.Show;
import beluga.module.group.widget.Edit;
import beluga.module.group.widget.Error;

class GroupWidget {
    public var show = new Show();
    public var edit = new Edit();
    public var error = new Error();

    public function new() {}
}