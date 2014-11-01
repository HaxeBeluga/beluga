// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload.widget;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.module.fileupload.Fileupload;
import beluga.I18n;
import beluga.resource.ResourceManager;

class Admin extends MttWidget<Fileupload> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/fileupload/view/tpl/admin.mtt");
        super(Fileupload, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/fileupload/view/locale/admin/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var extensions = mod.getExtensionsList();
        return {
            extensions_list: extensions,
            admin_error: this.getErrorString(mod.error)
        };
    }

    private function getErrorString(error: FileUploadErrorKind) {
        return switch (error) {
            case FileUploadUserNotLogged: BelugaI18n.getKey(this.i18n, "user_not_logged");
            case FileUploadInvalidFileExtension: BelugaI18n.getKey(this.i18n, "invalid_ext");
            case FileUploadInvalidAccess: BelugaI18n.getKey(this.i18n, "invalid_access");
            case FileUploadEmptyField: BelugaI18n.getKey(this.i18n, "empty_field");
            case FileUploadExtensionExist: BelugaI18n.getKey(this.i18n, "extension_already_exist");
            case FileUploadExtensionDontExist: BelugaI18n.getKey(this.i18n, "ext_dont_exist");
            case FileUploadNone: "";
        };
    }
}