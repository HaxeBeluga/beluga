package ;

import haxe.io.BufferInput;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Compiler;
import haxe.Resource;
import sys.FileSystem;
import sys.io.File;
using StringTools;

/**
 * ...
 * @author Masadow
 */
class Assets
{
	private static function deepCopy(src : String, dest : String)
	{
		for (file in FileSystem.readDirectory(src))
		{
			if (file.charAt(0) == ".") //Ignore every hidden files
				continue ;
			var path = src + file;
			if (FileSystem.isDirectory(path))
			{
				var newdest = dest + file + "/";
				FileSystem.createDirectory(newdest);
				deepCopy(path + "/", newdest);
			}
			else
				File.copy(path, dest + file);
		}
	}
	
	private static function deepDelete(src : String)
	{
		for (file in FileSystem.readDirectory(src))
		{
			if (file.charAt(0) == ".")
				continue ;
			var path = src + "/" + file;
			if (FileSystem.isDirectory(path))
				deepDelete(path);
			else
				FileSystem.deleteFile(path);
		}
		FileSystem.deleteDirectory(src);
	}
	
	macro public static function build() : Expr
	{
		var dest = Compiler.getOutput();
		var src = "assets/";
		
		//Remove file from output if neko
		if (dest.endsWith(".n"))
			dest = dest.substr(0, dest.lastIndexOf("/"));

		//Create the output folder, if it does not exists
		var currentFolder = "";
		for (folder in dest.split("/"))
		{
			currentFolder += folder + "/";
			if (!FileSystem.exists(currentFolder))
				FileSystem.createDirectory(currentFolder);
		}

		//Clean assets
		for (file in FileSystem.readDirectory(dest))
		{
			if (file.charAt(0) == "." || ["dominax", "lib", "res", "temp"].indexOf(file) >= 0)
				continue ;
			if (FileSystem.isDirectory(dest + "/" + file))
				deepDelete(dest + "/" + file);
		}

		//Copy new files
		deepCopy(src, dest + "/");

		//Embed resources
		Context.addResource("html_body", File.getBytes("src/main_view/tpl/htmlbody.mtt"));

		//#----Template----#
		Context.addResource("template_default_layout", File.getBytes("src/main_view/tpl/layout.mtt"));
		Context.addResource("template_default_header", File.getBytes("src/main_view/tpl/header.mtt"));
		Context.addResource("template_default_footer", File.getBytes("src/main_view/tpl/footer.mtt"));

		//#----AccountDemo Pages----#
		Context.addResource("page_accueil", File.getBytes("src/modules/account_demo/tpl/accueil.mtt"));
		Context.addResource("page_subscribe", File.getBytes("src/modules/account_demo/tpl/subscribe.mtt"));
		Context.addResource("page_login", File.getBytes("src/modules/account_demo/tpl/login.mtt"));

		//#----TicketDemo Pages----#
		Context.addResource("page_ticket_widget", File.getBytes("src/modules/ticket_demo/tpl/ticket_widget.mtt"));

		//#----SurveyDemo Pages----#
		Context.addResource("page_survey", File.getBytes("src/modules/survey_demo/tpl/survey_page.mtt"));

		//#----FileUploadDemo Pages----#
		Context.addResource("page_fileupload_widget", File.getBytes("src/modules/fileupload_demo/tpl/fileupload_widget.mtt"));

		//#----NotificationDemo Pages----#
		Context.addResource("page_notification", File.getBytes("src/modules/notification_demo/tpl/notification_page.mtt"));

		//#----ForumDemo Pages----#
		Context.addResource("page_forum_widget", File.getBytes("src/modules/forum_demo/tpl/forum_widget.mtt"));

		//#----NewsDemo Pages----#
		Context.addResource("page_news", File.getBytes("src/modules/news_demo/tpl/news_page.mtt"));

		//#----WalletDemo Pages----#
		Context.addResource("page_wallet_widget", File.getBytes("src/modules/wallet_demo/tpl/wallet_widget.mtt"));


		//#----MailDemo Pages----#
		Context.addResource("page_mail", File.getBytes("src/modules/mail_demo/tpl/mail_page.mtt"));

		//#----WalletDemo Pages----#
		Context.addResource("page_market_widget", File.getBytes("src/modules/market_demo/tpl/market_widget.mtt"));
		Context.addResource("page_market_admin_widget", File.getBytes("src/modules/market_demo/tpl/market_admin_widget.mtt"));

		return macro "Done";
	}
	
}