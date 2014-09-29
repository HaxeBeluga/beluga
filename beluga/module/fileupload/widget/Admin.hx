// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.fileupload.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.fileupload.Fileupload;
import beluga.core.BelugaI18n;

class Admin extends MttWidget<FileuploadImpl> {

    public function new (mttfile = "beluga_fileupload_admin.mtt") {
        super(Fileupload, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/fileupload/view/locale/admin/", mod.i18n);
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