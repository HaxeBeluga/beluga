// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package main_view;

import beluga.ConfigLoader;
import haxe.macro.Context;
import haxe.Resource;
import beluga.module.account.Account;
import beluga.Beluga;
import beluga.resource.JavascriptBuilder;
import beluga.resource.CssBuilder;

class Renderer {

    public function new()  {}

    /*
     * Render a page with the default template
     */
    public static function renderDefault(page : String, title: String, ctx : Dynamic) {
        ctx.base_url = ConfigLoader.getBaseUrl();
        var body = (new haxe.Template(Resource.getString(page))).execute(ctx);
        var templateheader = (new haxe.Template(Resource.getString("template_default_header"))).execute( {
            base_url: ctx.base_url,
            user : Beluga.getInstance().getModuleInstance(Account).loggedUser
        });
        var templatefooter = (new haxe.Template(Resource.getString("template_default_footer"))).execute( {
            base_url: ctx.base_url,
        });
        var templatelayout = (new haxe.Template(Resource.getString("template_default_layout"))).execute( {
            base_url: ctx.base_url,
            footer: templatefooter,
            content: body
        });
        var bodyhtml = (new haxe.Template(Resource.getString("html_body"))).execute({
            base_url: ctx.base_url,
            header: templateheader,
            content: templatelayout,
            title: title,
            js: JavascriptBuilder.getHtmlInclude(),
            css: CssBuilder.getHtmlInclude()
        });
        return bodyhtml;
    }

}