package beluga.module.forum.api;

import haxe.web.Dispatch;

import beluga.Beluga;

import beluga.BelugaException;

import beluga.module.forum.Forum;
import beluga.module.account.model.User;

class ForumApi {
    public var beluga : Beluga;
    public var module : Forum;

    public function new(beluga : Beluga, module) {
        this.beluga = beluga;
        this.module = module;
    }

    public function doDisplayChannel(args : {
        channel_key : String
    }): Void {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_display", [args]);
    }

    public function doDisplayAddChannel(args : {
        parent_key : String
    }) {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_add_display", [args]);
    }

    public function doDisplayModifyChannel(args : {
        channel_key : String
    }) {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_modify_display", [args]);
    }

    public function doDisplayDeleteChannel(args : {
        channel_key : String
    }) {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_delete_display", [args]);
    }

    public function doAddChannel(args : {
        label : String,
        parent_key : String
    }) {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_add", [args]);
    }

    public function doModifyChannel(args : {
        label : String,
        channel_key : String
    }) {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_modify", [args]);
    }

    public function doDeleteChannel(args : {
        channel_key : String
    }) {
        // beluga.triggerDispatcher.dispatch("beluga_forum_channel_delete", [args]);
    }

    public function doDefault() {
        trace("Forum default page");
    }
}
