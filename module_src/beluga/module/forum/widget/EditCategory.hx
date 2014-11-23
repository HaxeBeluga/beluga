// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum.widget;

import sys.db.Types;

import beluga.Beluga;
import beluga.widget.MttWidget;
import beluga.ConfigLoader;
import beluga.I18n;

import beluga.module.forum.Forum;
import beluga.module.forum.CategoryData;
import beluga.module.account.Account;
import beluga.resource.ResourceManager;

class EditCategory extends MttWidget<Forum> {

    public function new (?mttfile : String) {
        if(mttfile == null) mttfile = ResourceManager.getString("/beluga/module/forum/view/tpl/edit_category.mtt");
        super(Forum, mttfile);
        i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/view/locale/edit_category/", mod.i18n);
    }

    override private function getContext() : Dynamic {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        // check the user's rights
        if (!user.isAdmin) {
            mod.error_id = NotAllowed;
            var ret = mod.widgets.forum.getContext();

            ret.other = mod.widgets.forum.render();
            return ret;
        }
        var category = mod.getCategory(mod.category_id);
        
        // if category doesn't exist, we display default page
        if (category == null) {
            mod.error_id = UnknownCategory;
            var ret = mod.widgets.forum.getContext();

            ret.other = mod.widgets.forum.render();
            return ret;
        }
        return {
            category: category,
            error : mod.getErrorString(mod.error_id),
            success : (mod.success_msg != "" ? BelugaI18n.getKey(this.i18n, mod.success_msg) : mod.success_msg),
            path : "/beluga/forum/",
            user: user
        };
    }
}