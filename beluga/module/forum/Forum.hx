package beluga.module.forum;

import beluga.core.module.Module;

interface Forum extends Module {

    public function displayChannel(args : {
        channel_key : String
    }) : Void;

    public function getChannelContext() : Dynamic;

    public function displayAddChannel(args : {
        parent_key : String
    }) : Void;

    public function getAddChannelContext() : Dynamic;

    public function displayModifyChannel(args : {
        channel_key : String
    }) : Void;

    public function getModifyChannelContext() : Dynamic;

    public function displayDeleteChannel(args : {
        channel_key : String
    }) : Void;

    public function getDeleteChannelContext() : Dynamic;

    public function addChannel(args : {
        label : String,
        parent_key : String
    }) : Void;

    public function modifyChannel(args : {
        label : String,
        channel_key : String,
        parent_key : String
    }) : Void;

    public function deleteChannel(args : {
        channel_key : String,
        parent_key : String
    }) : Void;

    public function addMessage(args : {
        title : String,
        content : String,
        channel_key : String
    }) : Void;

    public function modifyMessage(args : {
        title : String,
        content : String,
        message_key : String
    }) : Void;

    public function deleteMessage(args : {
        message_key : String
    }) : Void;

    public function moveMessage(args : {
        message_key : String,
        channel_key : String
    }) : Void;

    public function addUserToGroup(args : {
        login : String,
        group_key : String
    }) : Void;

    public function removeUserFromGroup(args : {
        login : String,
        group_key : String
    }) : Void;

    public function addGroupToChannel(args : {
        group_key : String,
        channel_key : String
    }) : Void;

    public function removeGroupFromChannel(args : {
        group_key : String,
        channel_key: String
    }) : Void;
}