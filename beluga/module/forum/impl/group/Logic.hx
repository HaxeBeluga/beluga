package beluga.module.forum.impl.group;

import beluga.module.account.model.User;
import beluga.module.forum.model.Group;
import beluga.module.forum.model.UserGroup;

class Logic
{
  // Add a group

  public static function addUser(args : {
    login : String,
    group_key : String,
  }) : Void
  {
    var user = User.manager.select($login == args.login);
    var group = Group.manager.select($key == args.group_key);

    var user_group = new UserGroup();

    user_group.user = user;
    user_group.group = group;

    user_group.insert();
  }

  public static function removeUser(args : {
    login : String,
    group_key : String,
  }) : Void
  {
    var user = User.manager.select($login == args.login);
    var group = Group.manager.select($key == args.group_key);

    var user_group = UserGroup.manager.select($user == user && $group == group);

    user_group.delete();
  }
}