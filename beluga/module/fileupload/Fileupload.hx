package beluga.module.fileupload;

import beluga.core.module.Module;

interface Fileupload extends Module {
    public var triggers: FileuploadTrigger;
    public var widgets: FileuploadWidget;

    public function send(): Void;
    public function delete(args: { id: Int }): Void;
    public function addextension(args: { name: String }): Void;
    public function deleteextension(args: { id: Int }): Void;
    public function getAdminContext(): Dynamic;
    public function getBrowseContext(): Dynamic;
    public function getSendContext(): Dynamic;
    public function getUserFileList(user_id: Int): List<Dynamic>;
    public function extensionIsValid(name: String): Bool;
}