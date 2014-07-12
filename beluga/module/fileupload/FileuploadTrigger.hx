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