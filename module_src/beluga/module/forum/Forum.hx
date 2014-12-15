// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package beluga.module.forum;

import sys.db.Manager;
import haxe.xml.Fast;
import haxe.ds.Option;

import beluga.module.Module;
import beluga.Beluga;
import beluga.I18n;

import beluga.module.account.Account;
import beluga.module.account.model.User;
import beluga.module.forum.api.ForumApi;
import beluga.module.forum.ForumTrigger;
import beluga.module.forum.ForumErrorKind;
import beluga.module.forum.model.Message;
import beluga.module.forum.model.CategoryModel;
import beluga.module.forum.model.Topic;
import beluga.module.forum.api.ForumApi;

class Forum extends Module {
    public var triggers = new ForumTrigger();

    // Intern variables for contexts
    public var success_msg : String;
    public var error_id : ForumErrorKind;
    public var message_id : Option<Int>;
    public var topic_id : Option<Int>;
    public var category_id : Option<Int>;

    // Saved values in case of create FAQ error
    public var title : String;
    public var answer : String;
    public var description : String;

    public var widgets: ForumWidget;
    public var i18n = BelugaI18n.loadI18nFolder("/beluga/module/forum/locale/");

    public function new() {
        super();
        success_msg = "";
        title = "";
        answer = "";
        description = "";
        topic_id = None;
        category_id = None;
        error_id = None;
    }

    override public function initialize(beluga : Beluga) : Void {
        this.widgets = new ForumWidget();
        beluga.api.register("forum", new ForumApi(beluga, this));
    }

    // Passing None as parameter will return the main category
    public function getCategory(category_id : Option<Int>) : CategoryModel {
        var id = switch (category_id) {
            case None: -1;
            case Some(id): id;
        };

        for (category in CategoryModel.manager.dynamicSearch( {id: id} )) {
            return category;
        }
        return null;
    }

    // Passing None as parameter will return the main category
    public function getTopic(topic_id : Int) : Topic {
        for (topic in Topic.manager.dynamicSearch( {id: topic_id} )) {
            return topic;
        }
        return null;
    }

    public function getMessage(message_id : Int) : Message {
        for (msg in Message.manager.dynamicSearch( {id: message_id} )) {
            return msg;
        }
        return null;
    }

    // Passing None as parameter will return the main category's content
    public function getAllFromCategory(category_id: Option<Int>) : CategoryData {
        var topic_array = new Array<Topic>();
        var category_array = new Array<CategoryModel>();
        var id = switch (category_id) {
            case Some(id) : id;
            case None : -1;
        };

        for (topic in Topic.manager.dynamicSearch( {category_id: id} )) {
            topic_array.push(topic);
        }
        for (category in CategoryModel.manager.dynamicSearch( {parent_id: id} )) {
            category_array.push(category);
        }
        return new CategoryData(topic_array, category_array);
    }

    // returns all messages for a given topic
    public function getAllFromTopic(topic_id: Int) : Array<Message> {
        var msg_array = new Array<Message>();
        var msgs = Manager.cnx.request("SELECT * from beluga_frm_message ORDER BY date");

        for (msg in msgs) {
            // this "loop" fills news structs
            for (filled_message in Message.manager.dynamicSearch({id : msg.id})) {
                for (user in User.manager.dynamicSearch({id: filled_message.author_id})) {
                    filled_message.author = user;
                    break;
                }
                msg_array.push(filled_message);
                break;
            }
        }
        return msg_array;
    }

    // only admin users can do that for the moment
    public function createCategory(args : {name : String, description : String, can_create_topic: Bool, parent_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null || !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.createCategoryFail.dispatch({error : error_id});
            return ;
        }
        //  Let's save values in case something goes wrong
        title = args.name;
        description = args.description;

        if (args.name == "") {
            error_id = MissingName;
            this.triggers.createCategoryFail.dispatch({error: error_id});
            return;
        }
        // check if the parent category exists
        if (args.parent_id != -1) {
            if (getCategory(Some(args.parent_id)) == null) {
                error_id = UnknownCategory;
                this.triggers.createCategoryFail.dispatch({error: error_id});
                return;
            }
        }
        category_id = Some(args.parent_id);

        // check if another category has the same name
        for (category in CategoryModel.manager.dynamicSearch( { id: args.parent_id } )) {
            if (category.name == args.name) {
                error_id = CategoryAlreadyExist;
                this.triggers.createCategoryFail.dispatch({error: error_id});
                return;
            }
        }
        var entry = new CategoryModel();

        entry.name = args.name;
        entry.description = args.description;
        entry.parent_id = args.parent_id;
        entry.creator_id = user.id;
        entry.can_create_topic = args.can_create_topic;
        entry.insert();
        success_msg = "entry_create_success";
        this.triggers.createCategorySuccess.dispatch();
    }

    // can not be created in main category (the parent of all categories)
    public function createTopic(args : {title : String, text : String, can_post_message: Bool, category_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.createTopicFail.dispatch({error : error_id});
            return ;
        }
        category_id = Some(args.category_id);
        title = args.title;
        answer = args.text;

        // check if the category exist
        var cat = getCategory(Some(args.category_id));
        if (cat == null) {
            error_id = UnknownCategory;
            this.triggers.createTopicFail.dispatch({error: error_id});
            return;
        }
        if (cat.can_create_topic == false && user.isAdmin == false) {
            error_id = NotAllowed;
            this.triggers.createTopicFail.dispatch({error : error_id});
            return ;
        }
        if (args.title == "") {
            error_id = MissingTitle;
            this.triggers.createTopicFail.dispatch({error: error_id});
            return;
        }
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.createTopicFail.dispatch({error: error_id});
            return;
        }

        var entry = new Topic();

        entry.title = args.title;
        entry.category_id = args.category_id;
        entry.creator_id = user.id;
        entry.is_solved = false;
        entry.date = Date.now();
        entry.can_post_message = args.can_post_message;
        entry.insert();

        var first_msg = new Message();

        first_msg.text = args.text;
        first_msg.date = entry.date;
        first_msg.author_id = entry.creator_id;
        first_msg.topic_id = entry.id;
        first_msg.insert();

        success_msg = "topic_create_success";
        this.triggers.createTopicSuccess.dispatch();
    }

    // the category's id is just used as a security in here
    public function postMessage(args : {text : String, topic_id : Int, category_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.postMessageFail.dispatch({error : error_id});
            return ;
        }
        answer = args.text;

        //check if the category exists
        var category = getCategory(Some(args.category_id));
        if (category == null) {
            error_id = UnknownTopic;
            this.triggers.postMessageFail.dispatch({error: error_id});
            return;
        }
        // check if the topic exists in the category
        var topic = getTopic(args.topic_id);

        if (topic == null) {
            error_id = UnknownTopic;
            this.triggers.postMessageFail.dispatch({error: error_id});
            return;
        }
        if (topic.category_id != args.category_id) {
            error_id = UnknownTopic;
            this.triggers.postMessageFail.dispatch({error: error_id});
            return;
        }
        if (topic.can_post_message == false && user.isAdmin == false) {
            error_id = NotAllowed;
            this.triggers.postMessageFail.dispatch({error: error_id});
            return;
        }
        this.topic_id = Some(args.topic_id);
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.postMessageFail.dispatch({error: error_id});
            return;
        }

        var msg = new Message();

        msg.text = args.text;
        msg.date = Date.now();
        msg.topic_id = args.topic_id;
        msg.author_id = user.id;
        msg.insert();

        topic.last_message_id = msg.id;
        topic.update();
        category.last_message_id = msg.id;
        category.update();
        success_msg = "message_post_success";
        this.triggers.postMessageSuccess.dispatch();
    }

    public function internChangeTopicStatus(args : {topic_id : Int, category_id : Int}, new_status : Bool) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = NotAllowed;
            return ;
        }
        //check if the category exists
        if (getCategory(Some(args.category_id)) == null) {
            error_id = UnknownTopic;
            return;
        }
        // check if the topic exists in the category
        var topic = getTopic(args.topic_id);

        if (topic == null) {
            error_id = UnknownTopic;
            return;
        }
        if (topic.category_id != args.category_id) {
            error_id = UnknownTopic;
            return;
        }
        this.topic_id = Some(args.topic_id);
        topic.is_solved = new_status;
        topic.update();
        success_msg = "solve_topic_success";
    }

    public function solveTopic(args : {topic_id : Int, category_id : Int}) {
        internChangeTopicStatus(args, true);
        if (error_id != None) {
            this.triggers.solveTopicFail.dispatch({error: error_id});
        } else {
            this.triggers.solveTopicSuccess.dispatch();
        }
    }

    public function unsolveTopic(args : {topic_id : Int, category_id : Int}) {
        internChangeTopicStatus(args, false);
        if (error_id != None) {
            this.triggers.unsolveTopicFail.dispatch({error: error_id});
        } else {
            this.triggers.unsolveTopicSuccess.dispatch();
        }
    }

    // never set force to true unless you know what you do !
    private function internDeleteTopic(topic_id: Int, category_id: Int, user: User, force: Bool) : ForumErrorKind {
        if (user == null) {
            return MissingLogin;
        }
        //check if the category exists
        if (getCategory(Some(category_id)) == null) {
            return UnknownCategory;
        }
        this.category_id = Some(category_id);
        // check if the topic exists in the category
        var topic = getTopic(topic_id);

        if (topic == null) {
            return UnknownTopic;
        }
        if (topic.category_id != category_id) {
            return UnknownTopic;
        }
        if (user.id != topic.creator_id && !user.isAdmin && !force) {
            return NotAllowed;
        }
        for (msg in Message.manager.dynamicSearch({topic_id: topic_id})) {
            msg.delete();
        }
        topic.delete();
        return None;
    }

    // call this function only from inside this class code ! Very dangerous !
    private function internDeleteCategory(category_id: Int, user: User) {
        var category = getCategory(Some(category_id));

        if (category == null) {
            return;
        }
        // delete recursively all inside categories
        for (category in CategoryModel.manager.dynamicSearch({parent_id: category.id})) {
            internDeleteCategory(category.id, user);
        }
        // now remove all inside topics
        for (topic in Topic.manager.dynamicSearch({category_id: category.id})) {
            //ignore all internal errors
            internDeleteTopic(topic.id, category_id, user, true);
        }
        category.delete();
    }

    public function deleteTopic(args : {topic_id : Int, category_id : Int}) {
        var ret = internDeleteTopic(args.topic_id, args.category_id, Beluga.getInstance().getModuleInstance(Account).loggedUser, false);

        if (ret != None) {
            error_id = ret;
            this.triggers.deleteTopicFail.dispatch({error: ret});
        } else {
            category_id = Some(args.category_id);
            success_msg = "topic_delete_success";
            this.triggers.deleteTopicSuccess.dispatch();
        }
    }

    // parent_id parameter is just here as security
    public function deleteCategory(args : {category_id : Int, parent_id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.deleteCategoryFail.dispatch({error : error_id});
            return ;
        }
        // check if parent exists
        if (args.parent_id != -1 && getCategory(Some(args.parent_id)) == null) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: error_id});
            return;
        }
        // check if category exists
        var category = getCategory(Some(args.category_id));

        if (category == null) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: error_id});
            return;
        }
        if (category.parent_id != args.parent_id) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: error_id});
            return;
        }
        // check if it is its parent category
        if (args.category_id == -1) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: error_id});
            return;
        }
        // check if the user can delete it
        if (category.creator_id != user.id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.deleteCategoryFail.dispatch({error: error_id});
            return;
        }
        internDeleteCategory(args.category_id, user);
        this.category_id = Some(args.parent_id);
        success_msg = "delete_category_success";
        this.triggers.deleteCategorySuccess.dispatch();
    }

    public function editCategory(args : {name : String, description : String, category_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.editCategoryFail.dispatch({error : error_id});
            return ;
        }
        // check if category exists
        var category = getCategory(Some(args.category_id));

        if (category == null) {
            error_id = UnknownCategory;
            this.triggers.editCategoryFail.dispatch({error: error_id});
            return;
        }
        if (user.id != category.creator_id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.editCategoryFail.dispatch({error: error_id});
            return;
        }
        category.name = args.name;
        category.description = args.description;
        category.update();
        success_msg = "edit_category_success";
        this.triggers.editCategorySuccess.dispatch();
    }

    // topic_id parameter is just a security
    public function editMessage(args : {text : String, topic_id: Int, message_id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.editMessageFail.dispatch({error : MissingLogin});
            return ;
        }
        // check if topic exists
        if (getTopic(args.topic_id) == null) {
            error_id = UnknownTopic;
            this.triggers.editMessageFail.dispatch({error: error_id});
            return;
        }
        this.topic_id = Some(args.topic_id);
        // check if message exists
        var msg = getMessage(args.message_id);

        if (msg == null) {
            error_id = UnknownMessage;
            this.triggers.editMessageFail.dispatch({error: error_id});
            return;
        }
        if (msg.topic_id != args.topic_id) {
            error_id = UnknownMessage;
            this.triggers.editMessageFail.dispatch({error: error_id});
            return;
        }

        if (user.id != msg.author_id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.editMessageFail.dispatch({error: error_id});
            return;
        }
        msg.text = args.text;
        msg.update();
        success_msg = "edit_message_success";
        this.triggers.editMessageSuccess.dispatch();
    }

    // from_category_id parameter is just used as security
    public function moveTopic(args : {topic_id: Int, from_category_id: Int, to_category_id: Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.moveTopicFail.dispatch({error : error_id});
            return ;
        }
        if (args.to_category_id == -1) {
            error_id = NotAllowed;
            this.triggers.moveTopicFail.dispatch({error : error_id});
            return ;
        }
        // check if topic exists
        var topic = getTopic(args.topic_id);

        if (topic == null) {
            error_id = UnknownTopic;
            this.triggers.moveTopicFail.dispatch({error : error_id});
            return ;
        }
        // chef if categories exist
        var category = getCategory(Some(args.from_category_id));

        if (category == null || getCategory(Some(args.to_category_id)) == null) {
            error_id = UnknownCategory;
            this.triggers.moveTopicFail.dispatch({error : error_id});
            return ;
        }
        if (category.creator_id != user.id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.moveTopicFail.dispatch({error : error_id});
            return ;
        }
        if (topic.category_id != args.from_category_id) {
            error_id = UnknownTopic;
            this.triggers.moveTopicFail.dispatch({error : error_id});
            return ;
        }
        topic.category_id = args.to_category_id;
        topic.update();
        success_msg = "move_topic_succes";
        this.triggers.moveTopicSuccess.dispatch();
    }

    public function getErrorString(error: ForumErrorKind) {
        return switch(error) {
            case MissingLogin: BelugaI18n.getKey(this.i18n, "missing_login");
            case MissingMessage: BelugaI18n.getKey(this.i18n, "missing_message");
            case MissingTitle: BelugaI18n.getKey(this.i18n, "missing_title");
            case MissingName: BelugaI18n.getKey(this.i18n, "missing_name");
            case UnknownMessage: BelugaI18n.getKey(this.i18n, "message_not_found");
            case UnknownCategory: BelugaI18n.getKey(this.i18n, "category_not_found");
            case UnknownTopic: BelugaI18n.getKey(this.i18n, "topic_not_found");
            case NotAllowed: BelugaI18n.getKey(this.i18n, "not_allowed");
            case CategoryAlreadyExist: BelugaI18n.getKey(this.i18n, "category_already_exist");
            case None: "";
        };
    }
}