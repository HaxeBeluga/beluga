package beluga.module.news;

import beluga.core.module.Module;

import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;

interface News extends Module {
    public var triggers: NewsTrigger;

    public function print(args : {news_id : Int}) : Void;
    public function create(args : {title : String, text : String}) : Void;
    public function delete(args : {news_id : Int}) : Void;
    public function edit(args : {news_id : Int, title : String, text : String}) : Void;
    public function addComment(args : {news_id : Int, text : String}) : Void;
    public function deleteComment(args : {news_id : Int, comment_id : Int}) : Void;
    public function getAllNews() : Array<NewsModel>;
    public function getNews(args : {user_id : Int}) : Array<NewsModel>;
    public function getComments(args : {news_id : Int}) : Array<CommentModel>;
}