package beluga.module.forum.impl.message;

import beluga.core.Beluga;
import beluga.tool.IDGenerator;

import beluga.module.account.AccountImpl;
import beluga.module.forum.model.Status;
import beluga.module.account.model.User;
import beluga.module.forum.model.Tag;
import beluga.module.forum.model.Channel;
import beluga.module.forum.model.Message;
import beluga.module.account.Account;

class Logic {
    public static function add(args : {
        title : String,
        content : String,
        channel_key : String,
        status_key : String,
        tag_key : String,
    }) : Void {
        var status = Status.manager.select($key == args.status_key);
        var tag = Tag.manager.select($key == args.tag_key);
        var channel = Channel.manager.select($key == args.channel_key);

        var mess = new Message();
        mess.key = IDGenerator.generate(32);
        mess.title = args.title;
        mess.content = args.content;
        mess.creation_time = Date.now();
        mess.user = Beluga.getInstance().getModuleInstance(AccountImpl).loggedUser;
        mess.status = status;
        mess.tag = tag;
        mess.parent = null;
        mess.channel = channel;

        mess.insert();
    }

    public static function modify(args : {
        title : String,
        content : String,
        message_key : String,
        status_key : String,
        tag_key : String
    }) : Void {
        var mess = Message.manager.select($key == args.message_key);
        var tag = Tag.manager.select($key == args.tag_key);

        mess.title = args.title;
        mess.content = args.content;
        mess.user = Beluga.getInstance().getModuleInstance(AccountImpl).loggedUser;
        mess.edition_time = Date.now();

        mess.update();
    }

    public static function delete(args : {
        message_key : String
    }) : Void {
        var mess = Message.manager.select($key == args.message_key);

        mess.delete();
    }

    public static function move(args : {
        channel_key : String,
        message_key : String
    }) : Void {
        var channel = Channel.manager.select($key == args.channel_key);
        var mess = Message.manager.select($key == args.message_key);

        mess.channel = channel;

        mess.update();
    }

    public static function changeStatus(args : {
      status_key : String,
      message_key : String
    }) : Void {
        var status = Status.manager.select($key == args.status_key);
        var mess = Message.manager.select($key == args.message_key);

        mess.status = status;

        mess.update();
    }

    public static function changeTag(args : {
        tag_key : String,
        message_key : String
    }) : Void {
        var tag = Tag.manager.select($key == args.tag_key);
        var mess = Message.manager.select($key == args.message_key);

        mess.tag = tag;

        mess.update();
    }
}