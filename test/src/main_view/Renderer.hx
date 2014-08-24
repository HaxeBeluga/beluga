package main_view;

import beluga.core.macro.ConfigLoader;
import haxe.macro.Context;
import haxe.Resource;
import beluga.module.account.Account;
import beluga.core.Beluga;

/**
 * ...
 * @author brissa_A
 */
class Renderer
{

	public function new() 
	{
		
	}

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
			header: templateheader,
			footer: templatefooter,
			content: body
		});
		var bodyhtml = (new haxe.Template(Resource.getString("html_body"))).execute({
			base_url: ctx.base_url,
			content: templatelayout,
			title: title
		});
		return bodyhtml;
	}
	
}