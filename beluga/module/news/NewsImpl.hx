package beluga.module.news;

import beluga.core.Beluga;
import beluga.core.macro.MetadataReader;

import beluga.module.account.Account;
import beluga.core.module.ModuleImpl;
import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;

import haxe.xml.Fast;
import sys.db.Manager;

class NewsImpl extends ModuleImpl implements NewsInternal implements MetadataReader {

	public function new() {
		super();
	}

	override public function loadConfig(data : Fast) {
	}

	public function getAllNews() : Array<NewsModel> {
		var ret = new Array<NewsModel>();

		var row = Manager.cnx.request("SELECT * from beluga_news_news ORDER BY creationDate DESC");
		for (tmp in row)
			ret.push(tmp);
		return ret;
	}

	public function getNews(args : {user_id : Int}) : Array<NewsModel> {
		var ret = new Array<NewsModel>();

		for (tmp in NewsModel.manager.dynamicSearch( {user_id : args.user_id} ))
			ret.push(tmp);
		return ret;
	}

	public function getComments(args : {news_id : Int}) : Array<CommentModel> {
		var ret = new Array<CommentModel>();

		for (tmp in CommentModel.manager.dynamicSearch( {news_id : args.news_id} ))
			ret.push(tmp);
		return ret;
	}

	public static function _edit(args : {news_id : Int, title : String, text : String}) : Void {
		Beluga.getInstance().getModuleInstance(News).edit(args);
	}

	public function edit(args : {news_id : Int, title : String, text : String}) : Void {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user == null) {
			beluga.triggerDispatcher.dispatch("beluga_news_edit_fail", [{news_id : args.news_id, error : "Please login before edit this news"}]);
			return;
		}
		for (tmp in NewsModel.manager.dynamicSearch( {user_id : user.id, id : args.news_id} )) {
			tmp.title = args.title;
			tmp.text = args.text;
			tmp.update();
			beluga.triggerDispatcher.dispatch("beluga_news_edit_success", [{news_id : args.news_id}]);
			return;
		}
		beluga.triggerDispatcher.dispatch("beluga_news_edit_fail", [{news_id : args.news_id, error : "You can't edit this news"}]);
	}

	public static function _addComment(args : {news_id : Int, text : String}) : Void {
		Beluga.getInstance().getModuleInstance(News).addComment(args);
	}

	public function addComment(args : {news_id : Int, text : String}) : Void {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id} )) {
				var com = new CommentModel();

				com.text = args.text;
				com.news_id = args.news_id;
				com.user_id = user.id;
				com.creationDate = Date.now();
				com.insert();
				beluga.triggerDispatcher.dispatch("beluga_news_addComment_success", [{news_id : args.news_id}]);
				return;
			}
		}
		beluga.triggerDispatcher.dispatch("beluga_news_addComment_fail", [{news_id : args.news_id}]);
	}

	public static function _deleteComment(args : {news_id : Int, comment_id : Int}) : Void {
		Beluga.getInstance().getModuleInstance(News).deleteComment(args);
	}

	public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id, user_id : user.id} )) {
				for (tmp_c in CommentModel.manager.dynamicSearch( {id : args.comment_id, news_id : args.news_id} )) {
					tmp_c.delete();
					beluga.triggerDispatcher.dispatch("beluga_news_deleteComment_success", [{news_id : args.news_id}]);
					return;
				}
				beluga.triggerDispatcher.dispatch("beluga_news_deleteComment_fail", [{news_id : args.news_id, error : "This comment doesn't exist"}]);
				return;
			}
			for (tmp in CommentModel.manager.dynamicSearch( {id : args.comment_id, news_id : args.news_id, user_id : user.id} )) {
				tmp.delete();
				beluga.triggerDispatcher.dispatch("beluga_news_deleteComment_success", [{news_id : args.news_id}]);
				return;
			}
		}
		beluga.triggerDispatcher.dispatch("beluga_news_deleteComment_fail", [{news_id : args.news_id, error : "You can't delete this comment"}]);
	}

	public static function _print(args : {news_id : Int}) {
		Beluga.getInstance().getModuleInstance(News).print(args);
	}

	public function print(args : {news_id : Int}) {
		beluga.triggerDispatcher.dispatch("beluga_news_print", [args]);
	}

	@bTrigger("beluga_news_delete")
	public static function _delete(args : {news_id : Int}) {
		Beluga.getInstance().getModuleInstance(News).delete(args);
	}

	public function delete(args : {news_id : Int}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user != null) {
			for (tmp in NewsModel.manager.dynamicSearch( {id : args.news_id, user_id : user.id} )) {
				for (tmp_c in CommentModel.manager.dynamicSearch({news_id : tmp.id})) {
					tmp_c.delete();
				}
				tmp.delete();
				beluga.triggerDispatcher.dispatch("beluga_news_delete_success", []);
				return;
			}
		}
		beluga.triggerDispatcher.dispatch("beluga_news_delete_fail", []);
	}

	@bTrigger("beluga_news_create")
	public static function _create(args : {title : String, text : String}) {
		Beluga.getInstance().getModuleInstance(News).create(args);
	}

	public function create(args : {title : String, text : String}) {
		var user = Beluga.getInstance().getModuleInstance(Account).getLoggedUser();

		if (user == null || args.title == "" || args.text == "") {
			if (user == null)
				beluga.triggerDispatcher.dispatch("beluga_news_create_fail", [{title : args.title, data : args.text, error : "Please log in to create a news"}]);
			else if (args.title == "")
				beluga.triggerDispatcher.dispatch("beluga_news_create_fail", [{title : args.title, data : args.text, error : "Please enter a title"}]);
			else
				beluga.triggerDispatcher.dispatch("beluga_news_create_fail", [{title : args.title, data : args.text, error : "Please enter the news"}]);
			return;
		}
		var news = new NewsModel();

		news.title = args.title;
		news.text = args.text;
		news.user_id = user.id;
		news.creationDate = Date.now();
		news.insert();
		beluga.triggerDispatcher.dispatch("beluga_news_create_success", []);
	}
}