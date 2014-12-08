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
import beluga.module.account.Account;
import beluga.widget.Layout;

class Browse extends MttWidget<Fileupload> {

    public function new (?layout : Layout) {
        if(layout == null) layout = MttWidget.bootstrap.wrap("/beluga/module/fileupload/view/tpl/browse.mtt");
        super(Fileupload, layout);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/fileupload/view/locale/browse/", mod.i18n);
    }

    override private function getContext(): Dynamic {
        var files: List<Dynamic> = new List<Dynamic>();
        var user_id: Int = 0;

        if (Beluga.getInstance().getModuleInstance(Account).isLogged) {
            user_id = Beluga.getInstance().getModuleInstance(Account).loggedUser.id;
            files = mod.getUserFileList(user_id);
        }

        return {
            error: this.getErrorString(mod.error),
            files_list: files,
            module_name: "Browse personal files"
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
            case FileUploadNone: null;
        };
    }
}