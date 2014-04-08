package beluga.module.forum;

import beluga.core.Beluga;
import beluga.core.module.ModuleImpl;
import beluga.module.forum.model.Channel;

// TODO: create a system of action depending on right / user level. add channel == admin || post message == user, admin

class ForumImpl extends ModuleImpl implements ForumInternal
{
  public function new()
  {
    super();
  }

  override public function loadConfig(data : Fast) 
  {

  }

  /**
  * CHANNEL
  */

  public static function _addChannel(args : {
    label : String,
    parent_key : String 
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).addChannel(args);
  }

  public function addChannel(args : {
    label : String,
    parent_key : String 
  }) : Void
  {

  }

  public static function _modifyChannel(args : {
    label : String,
    channel_key : String,
    parent_key : String 
  }) : Void;
  {
    Beluga.getInstance().getModuleInstance(Forum).modifyChannel(args);
  }

  public function modifyChannel(args : {
    label : String,
    channel_key : String,
    parent_key : String 
  }) : Void;
  {

  }

  public static function deleteChannel(args : {
    channel_key : String
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).deleteChannel(args);
  }

  public function deleteChannel(args : {
    channel_key : String
  }) : Void
  {

  }

  /**
  * MESSAGE
  */

  public static function _addMessage(args : {
    title : String,
    content : String,
    channel_key : String
  }) : Void
  {
    
  }

  public function addMessage(args : {
    title : String,
    content : String,
    channel_key : String
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).addMessage(args);
  }

  public static function _modifyMessage(args : {
    title : String,
    content : String,
    message_key : String,
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).modifyMessage(args);
  }

  public function modifyMessage(args : {
    title : String,
    content : String,
    message_key : String,
  }) : Void
  {
    
  }

  public static function _deleteMessage(args : {
    message_key : String
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).deleteMessage(args);
  }

  public function deleteMessage(args : {
    message_key : String
  }) : Void
  {
    
  }

  public static function _moveMessage(args : {
    message_key : String,
    channel_key : String,
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).moveMessage(args);
  }

  public function moveMessage(args : {
    message_key : String,
    channel_key : String,
  }) : Void
  {
    
  }

  /**
  * PERMISSION
  */

  public static function _addUserToGroup(args : {
    login : String,
    group_key : String,
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).addUserToGroup(args);
  }

  public function addUserToGroup(args : {
    login : String,
    group_key : String,
  }) : Void
  {
    
  }

  public static function _removeUserFromGroup(args : {
    login : String,
    group_key : String,
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).removeUserFromGroup(args);
  }

  public function removeUserFromGroup(args : {
    login : String,
    group_key : String,
  }) : Void
  {
    
  }

  public static function _addGroupToChannel(args : {
    group_key : String,
    channel_key : String,
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).addGroupToChannel(args);
  }

  public function addGroupToChannel(args : {
    group_key : String,
    channel_key : String,
  }) : Void
  {
    
  }

  public static function _removeGroupFromChannel(args : {
    group_key : String,
    channel_key: String,
  }) : Void
  {
    Beluga.getInstance().getModuleInstance(Forum).removeGroupFromChannel(args);
  }
  
  public function removeGroupFromChannel(args : {
    group_key : String,
    channel_key: String,
  }) : Void
  {
    
  }
}