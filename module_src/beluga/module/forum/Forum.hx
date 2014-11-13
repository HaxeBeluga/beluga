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
        var msgs = Manager.cnx.request("SELECT * from beluga_for_message ORDER BY date");

        for (msg in msgs) {
            // this "loop" fills news structs
            for (filled_message in Message.manager.dynamicSearch({id : msg.id})) {
                msg_array.push(filled_message);
                break;
            }
        }
        return msg_array;
    }

    // only admin users can do that
    public function createCategory(args : {name : String, description : String, parent_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null || !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.createCategoryFail.dispatch({error : NotAllowed});
            return ;
        }
        //  Let's save values in case something goes wrong
        title = args.name;
        description = args.description;

        if (args.name == "") {
            error_id = MissingName;
            this.triggers.createCategoryFail.dispatch({error: MissingName});
            return;
        }
        // check if the parent category exists
        if (args.parent_id != -1) {
            if (getCategory(Some(args.parent_id)) == null) {
                error_id = UnknownCategory;
                this.triggers.createCategoryFail.dispatch({error: UnknownCategory});
                return;
            }
        }
        category_id = Some(args.parent_id);

        for (category in CategoryModel.manager.dynamicSearch( { category_id: args.parent_id } )) {
            if (category.name == args.name) {
                error_id = CategoryAlreadyExist;
                this.triggers.createCategoryFail.dispatch({error: CategoryAlreadyExist});
                return;
            }
        }
        var entry = new CategoryModel();

        entry.name = args.name;
        entry.description = args.description;
        entry.parent_id = args.parent_id;
        entry.creator_id = user.id;
        entry.insert();
        success_msg = "entry_create_success";
        this.triggers.createCategorySuccess.dispatch();
    }

    // can not be created in main category (the parent of off categories)
    public function createTopic(args : {title : String, text : String, category_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.createTopicFail.dispatch({error : MissingLogin});
            return ;
        }
        category_id = Some(args.category_id);
        title = args.title;
        answer = args.text;

        // if the category id is the parent of all categories
        if (args.category_id == -1) {
            error_id = UnknownCategory;
            this.triggers.createTopicFail.dispatch({error: UnknownCategory});
            return;
        }
        if (args.title == "") {
            error_id = MissingTitle;
            this.triggers.createTopicFail.dispatch({error: MissingTitle});
            return;
        }
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.createTopicFail.dispatch({error: MissingMessage});
            return;
        }

        // check if the category exist
        if (getCategory(Some(args.category_id)) == null) {
            error_id = UnknownCategory;
            this.triggers.createTopicFail.dispatch({error: UnknownCategory});
            return;
        }

        var entry = new Topic();

        entry.title = args.title;
        entry.category_id = args.category_id;
        entry.creator_id = user.id;
        entry.is_solved = false;
        entry.date = Date.now();
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
    public function postMessage(args : {topic_id : Int, category_id : Int, text : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.postMessageFail.dispatch({error : MissingLogin});
            return ;
        }
        answer = args.text;
        if (args.text == "") {
            error_id = MissingMessage;
            this.triggers.postMessageFail.dispatch({error: MissingMessage});
            return;
        }

        //check if the category exists
        if (getCategory(Some(args.category_id)) == null) {
            error_id = UnknownTopic;
            this.triggers.postMessageFail.dispatch({error: UnknownTopic});
            return;
        }
        // check if the topic exists in the category
        var topic = getTopic(args.topic_id);

        if (topic == null) {
            error_id = UnknownTopic;
            this.triggers.postMessageFail.dispatch({error: UnknownTopic});
            return;
        }
        if (topic.category_id != args.category_id) {
            error_id = UnknownTopic;
            this.triggers.postMessageFail.dispatch({error: UnknownTopic});
            return;
        }

        var msg = new Message();

        msg.text = args.text;
        msg.date = Date.now();
        msg.topic_id = args.topic_id;
        msg.author_id = user.id;
        msg.insert();

        success_msg = "message_post_success";
        this.triggers.postMessageSuccess.dispatch();
    }

    public function solveTopic(args : {topic_id : Int, category_id : Int}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = NotAllowed;
            this.triggers.solveTopicFail.dispatch({error : NotAllowed});
            return ;
        }
        //check if the category exists
        if (getCategory(Some(args.category_id)) == null) {
            error_id = UnknownTopic;
            this.triggers.solveTopicFail.dispatch({error: UnknownTopic});
            return;
        }
        // check if the topic exists in the category
        var topic = getTopic(args.topic_id);

        if (topic == null) {
            error_id = UnknownTopic;
            this.triggers.solveTopicFail.dispatch({error: UnknownTopic});
            return;
        }
        if (topic.category_id != args.category_id) {
            error_id = UnknownTopic;
            this.triggers.solveTopicFail.dispatch({error: UnknownTopic});
            return;
        }
        topic.is_solved = true;
        topic.update();
        success_msg = "solve_topic_success";
        this.triggers.solveTopicSuccess.dispatch();
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
        // delete recursively all inside categories
        for (category in CategoryModel.manager.dynamicSearch({id: category_id})) {
            internDeleteCategory(category.id, user);
        }
        // now remove all inside topics
        for (topic in Topic.manager.dynamicSearch({category_id: category_id})) {
            //ignore all internal errors
            internDeleteTopic(topic.id, category_id, user, true);
        }
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
            this.triggers.deleteCategoryFail.dispatch({error : MissingLogin});
            return ;
        }
        // check if parent exists
        if (getCategory(Some(args.parent_id)) == null) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: UnknownCategory});
            return;
        }
        // check if category exists
        var category = getCategory(Some(args.category_id));

        if (category == null) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: UnknownCategory});
            return;
        }
        if (category.parent_id != args.parent_id) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: UnknownCategory});
            return;
        }
        // check if it is its parent category
        if (args.category_id == -1) {
            error_id = UnknownCategory;
            this.triggers.deleteCategoryFail.dispatch({error: UnknownCategory});
            return;
        }
        // check if the user can delete it
        if (category.creator_id != user.id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.deleteCategoryFail.dispatch({error: NotAllowed});
            return;
        }
        internDeleteCategory(args.category_id, user);
        success_msg = "delete_category_success";
        this.triggers.deleteCategorySuccess.dispatch();
    }

    public function editCategory(args : {category_id : Int, name : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.editCategoryFail.dispatch({error : MissingLogin});
            return ;
        }
        // check if category exists
        var category = getCategory(Some(args.category_id));

        if (category == null) {
            error_id = UnknownCategory;
            this.triggers.editCategoryFail.dispatch({error: UnknownCategory});
            return;
        }
        if (user.id != category.creator_id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.editCategoryFail.dispatch({error: NotAllowed});
            return;
        }
        category.name = args.name;
        category.update();
        success_msg = "edit_category_success";
        this.triggers.editCategorySuccess.dispatch();
    }

    // topic_id parameter is just a security
    public function editMessage(args : {topic_id: Int, msg_id: Int, text : String}) {
        var user = Beluga.getInstance().getModuleInstance(Account).loggedUser;

        if (user == null) {
            error_id = MissingLogin;
            this.triggers.editMessageFail.dispatch({error : MissingLogin});
            return ;
        }
        // check if topic exists
        if (getTopic(args.topic_id) == null) {
            error_id = UnknownTopic;
            this.triggers.editMessageFail.dispatch({error: UnknownTopic});
            return;
        }
        // check if message exists
        var msg = getMessage(args.msg_id);

        if (msg == null) {
            error_id = UnknownMessage;
            this.triggers.editMessageFail.dispatch({error: UnknownMessage});
            return;
        }
        if (msg.topic_id != args.topic_id) {
            error_id = UnknownMessage;
            this.triggers.editMessageFail.dispatch({error: UnknownMessage});
            return;
        }

        if (user.id != msg.author_id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.editMessageFail.dispatch({error: NotAllowed});
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
            this.triggers.moveTopicFail.dispatch({error : MissingLogin});
            return ;
        }
        if (args.to_category_id == -1) {
            error_id = NotAllowed;
            this.triggers.moveTopicFail.dispatch({error : NotAllowed});
            return ;
        }
        // check if topic exist
        var topic = getTopic(args.topic_id);

        if (topic == null) {
            error_id = UnknownTopic;
            this.triggers.moveTopicFail.dispatch({error : UnknownTopic});
            return ;
        }
        // chef if categories exist
        var category = getCategory(Some(args.from_category_id));

        if (category == null || getCategory(Some(args.to_category_id)) == null) {
            error_id = UnknownCategory;
            this.triggers.moveTopicFail.dispatch({error : UnknownCategory});
            return ;
        }
        if (category.creator_id != user.id && !user.isAdmin) {
            error_id = NotAllowed;
            this.triggers.moveTopicFail.dispatch({error : NotAllowed});
            return ;
        }
        if (topic.category_id != args.from_category_id) {
            error_id = UnknownTopic;
            this.triggers.moveTopicFail.dispatch({error : UnknownTopic});
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