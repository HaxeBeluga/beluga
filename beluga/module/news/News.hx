package beluga.module.news;

import beluga.core.module.Module;

import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;

interface News extends Module {
    public var triggers: NewsTrigger;

    // get context methods
    public function getDefaultContext() : Dynamic;
    public function getCreateContext() : Dynamic;
    public function getEditContext(news_id: Int) : Dynamic;
    public function getPrintContext(news_id: Int) : Dynamic;

    public function print(args : {news_id : Int}) : Void;
    public function create(args : {title : String, text : String}) : Void;
    public function delete(args : {news_id : Int}) : Void;
    public function edit(args : {news_id : Int, title : String, text : String}) : Void;
    public function addComment(args : {news_id : Int, text : String}) : Void;
    public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void;

    // function which make some operations easier
    public function canEdit(news_id: Int, user_id: Int) : Bool;
    public function canPrint(news_id: Int) : Bool;
    public function getAllNews() : Array<NewsModel>;
    public function getNewsFromUser(user_id : Int) : Array<NewsModel>;
    public function getComments(news_id : Int) : Array<CommentModel>;
}