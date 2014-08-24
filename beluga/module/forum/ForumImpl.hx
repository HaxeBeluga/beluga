package beluga.module.forum;

import haxe.xml.Fast;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.core.macro.MetadataReader;

import beluga.module.forum.impl.channel.Display;
import beluga.module.forum.impl.channel.Logic;

// TODO: create a system of action depending on right / user level. add channel == admin || post message == user, admin

class ForumImpl extends ModuleImpl implements ForumInternal implements MetadataReader {

    private var key : Null<String> = null;

    public function new() {
      super();
    }

	override public function initialize(beluga : Beluga) : Void {
		
	}
	
    @bTrigger("beluga_forum_channel_display")
    public static function _displayChannel(args : {
        channel_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).displayChannel(args);
    }

    public function displayChannel(args : {
        channel_key : String
    }) : Void {
        this.key = (args.channel_key.length > 0 ? args.channel_key : null);
        beluga.triggerDispatcher.dispatch("request_beluga_forum_channel_display", [args]);
    }

    public function getChannelContext() : Dynamic {
        return (Display.getChannelContext(this.key));
    }

    @bTrigger("beluga_forum_channel_add_display")
    public static function _displayAddChannel(args : {
      parent_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).displayAddChannel(args);
    }

    public function displayAddChannel(args : {
        parent_key : String
    }) : Void {
        this.key = (args.parent_key.length > 0 ? args.parent_key : null);
        beluga.triggerDispatcher.dispatch("request_beluga_forum_add_channel_display", [args]);
    }

    public function getAddChannelContext() : Dynamic {
        return (Display.getAddChannelContext(this.key));
    }

    @bTrigger("beluga_forum_channel_modify_display")
    public static function _displayModifyChannel(args : {
        channel_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).displayModifyChannel(args);
    }

    public function displayModifyChannel(args : {
        channel_key : String
    }) : Void {
        this.key = (args.channel_key.length > 0 ? args.channel_key : null);
        beluga.triggerDispatcher.dispatch("request_beluga_forum_modify_channel_display", [args]);
    }

    public function getModifyChannelContext() : Dynamic {
        return (Display.getModifyChannelContext(this.key));
    }

    @bTrigger("beluga_forum_channel_delete_display")
    public static function _displayDeleteChannel(args : {
        channel_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).displayDeleteChannel(args);
    }

    public function displayDeleteChannel(args : {
        channel_key : String
    }) : Void {
        this.key = (args.channel_key.length > 0 ? args.channel_key : null);
        beluga.triggerDispatcher.dispatch("request_beluga_forum_delete_channel_display", [args]);
    }

    public function getDeleteChannelContext() : Dynamic {
        return (Display.getDeleteChannelContext(this.key));
    }

    @bTrigger("beluga_forum_channel_add")
    public static function _addChannel(args : {
        label : String,
        parent_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).addChannel(args);
    }

    public function addChannel(args : {
      label : String,
      parent_key : String
    }) : Void {
        Logic.add(args);
        beluga.triggerDispatcher.dispatch("beluga_forum_channel_display", [{channel_key : args.parent_key}]);
    }

    @bTrigger("beluga_forum_channel_modify")
    public static function _modifyChannel(args : {
        label : String,
        channel_key : String,
        parent_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).modifyChannel(args);
    }

    public function modifyChannel(args : {
        label : String,
        channel_key : String,
        parent_key : String
    }) : Void {
        Logic.modify(args);
        beluga.triggerDispatcher.dispatch("beluga_forum_channel_display", [{channel_key : args.parent_key}]);
    }

    @bTrigger("beluga_forum_channel_delete")
    public static function _deleteChannel(args : {
        channel_key : String,
        parent_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).deleteChannel(args);
    }

    public function deleteChannel(args : {
        channel_key : String,
        parent_key : String
    }) : Void {
        Logic.delete(args);
        beluga.triggerDispatcher.dispatch("beluga_forum_channel_display", [{channel_key : args.parent_key}]);
    }

    public static function _addMessage(args : {
        title : String,
        content : String,
        channel_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).addMessage(args);
    }

    public function addMessage(args : {
        title : String,
        content : String,
        channel_key : String
    }) : Void {

    }

    public static function _modifyMessage(args : {
        title : String,
        content : String,
        message_key : String
    }) : Void {
      Beluga.getInstance().getModuleInstance(Forum).modifyMessage(args);
    }

    public function modifyMessage(args : {
        title : String,
        content : String,
        message_key : String
    }) : Void {

    }

    public static function _deleteMessage(args : {
        message_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).deleteMessage(args);
    }

    public function deleteMessage(args : {
      message_key : String
    }) : Void {

    }

    public static function _moveMessage(args : {
        message_key : String,
        channel_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).moveMessage(args);
    }

    public function moveMessage(args : {
        message_key : String,
        channel_key : String
    }) : Void {

    }

    public static function _addUserToGroup(args : {
        login : String,
        group_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).addUserToGroup(args);
    }

    public function addUserToGroup(args : {
        login : String,
        group_key : String
    }) : Void {

    }

    public static function _removeUserFromGroup(args : {
        login : String,
        group_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).removeUserFromGroup(args);
    }

    public function removeUserFromGroup(args : {
        login : String,
        group_key : String
    }) : Void {

    }

    public static function _addGroupToChannel(args : {
        group_key : String,
        channel_key : String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).addGroupToChannel(args);
    }

    public function addGroupToChannel(args : {
        group_key : String,
        channel_key : String
    }) : Void {

    }

    public static function _removeGroupFromChannel(args : {
        group_key : String,
        channel_key: String
    }) : Void {
        Beluga.getInstance().getModuleInstance(Forum).removeGroupFromChannel(args);
    }

    public function removeGroupFromChannel(args : {
        group_key : String,
        channel_key: String
    }) : Void {

    }
}