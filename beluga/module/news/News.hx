// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.news;

import beluga.core.module.Module;

import beluga.module.news.model.NewsModel;
import beluga.module.news.model.CommentModel;
import beluga.module.news.NewsWidget;

interface News extends Module {
    public var triggers: NewsTrigger;
    public var widgets : NewsWidget;

    // context method
    public function setActualNewsId(news_id : Int) : Void;

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