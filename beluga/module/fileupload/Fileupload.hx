package beluga.module.fileupload;

import beluga.core.module.Module;

interface Fileupload extends Module {
    public function browse(): Void;
    public function send(): Void;
    public function delete(args: { id: Int }): Void;
    public function admin(): Void;
    public function addextension(args: { name: String }): Void;
    public function deleteextension(args: { id: Int }): Void;
    public function getAdminContext(): Dynamic;
    public function getBrowseContext(): Dynamic;
    public function getSendContext(): Dynamic;
    public function getUserFileList(user_id: Int): List<Dynamic>;
}