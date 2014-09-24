// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload;

import beluga.core.trigger.Trigger;
import beluga.core.trigger.TriggerVoid;

import sys.db.Types;

class FileuploadTrigger {
    public var send = new TriggerVoid();
    public var delete = new Trigger<{id: Int}>();
    public var deleteFail = new Trigger<{reason: String}>();
    public var deleteSuccess = new TriggerVoid();
    public var uploadFail = new Trigger<{reason: String}>();
    public var uploadSuccess = new Trigger<{title: String, text: String, user_id: SId}>();

    public var addExtensionSuccess = new TriggerVoid();
    public var addExtensionFail = new TriggerVoid();
    public var deleteExtensionSuccess = new TriggerVoid();
    public var deleteExtensionFail = new TriggerVoid();

    public function new() {}

}