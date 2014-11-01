package beluga.module.forum.impl.channel;

import beluga.module.forum.model.Channel;

class Display {
    public static function getChannelContext(key : Null<String>) {
        var chan_objs : List<Channel>;
        var parent_chan : Channel = null;
        var previous_chan : Channel = null;
        if (key != null) {
            parent_chan = Channel.manager.select($key == key);
            chan_objs = Channel.manager.search($parent == parent_chan);
        }
        else {
            chan_objs = Channel.manager.search($parent_id == null);
        }

        var channels : List<Dynamic> = new List<Dynamic>();
        for (chan in chan_objs) {
            channels.push({
                channel_label: chan.label,
                channel_key: chan.key
            });
        }

        return ({
            channel_list: channels,
            parent_channel_key : (parent_chan == null ? "" : parent_chan.key),
            previous_channel_key : (parent_chan == null || parent_chan.parent == null ? "" : parent_chan.parent.key)
        });
    }

    public static function getAddChannelContext(key : Null<String>) {
      // TODO: Load tag and status

      return ({
          parent_channel_key : key
      });
    }

    public static function getModifyChannelContext(key : String) {
      var chan = Channel.manager.select($key == key);

      // TODO Load tag and status

      if (chan == null) {
          return ({
              channel_label : "",
              channel_key : "",
              parent_channel_key : ""
          });
      }

      return ({
          channel_label : chan.label,
          channel_key : chan.key,
          parent_channel_key : (chan.parent == null ? "" : chan.parent.key)
      });
    }

    public static function getDeleteChannelContext(key : String) {
      var chan = Channel.manager.select($key == key);

      // TODO Get all info (number of deleted message, etc, etc...)

      if (chan == null) {
          return ({
              channel_label : "",
              channel_key : "",
              parent_channel_key : ""
          });
      }

      return ({
          channel_label : chan.label,
          channel_key : chan.key,
          parent_channel_key : (chan.parent == null ? "" : chan.parent.key)
      });
    }
}