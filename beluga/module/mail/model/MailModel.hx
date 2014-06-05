package beluga.module.mail.model;

import sys.db.Object;
import sys.db.Types;

import beluga.module.account.model.User;

@:table("beluga_mail_mail")
@:id(id)
class MailModel extends Object {
    public var id : SId;
    public var subject : STinyText;
    public var text : SText;
    public var user_id : SInt;
    public var receiver : STinyText;
    public var sentDate : SDateTime;
    public var hasBeenSent : SBool;
    @:relation(user_id) public var user : User;
}