// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.forum_test;

// Haxe
import haxe.web.Dispatch;
import haxe.Resource;

// Website
import main_view.Renderer;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.forum.Forum;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class ChannelTest
{
  public var beluga(default, null) : Beluga;
  public var frm(default, null) : Forum;

  public function new(beluga : Beluga)
  {
    this.beluga = beluga;
    this.frm = beluga.getModuleInstance(Forum);
  }

  @bTrigger("request_beluga_forum_channel_display")
  public static function _doDisplayChannelPage()
  {
    new ChannelTest(Beluga.getInstance()).doDisplayChannelPage();
  }

  public function doDisplayChannelPage()
  {
    var forumWidget = this.frm.getWidget("display_channel");
    forumWidget.context = this.frm.getChannelContext();

    var html = Renderer.renderDefault("page_forum_widget", "Forum", {
      forumWidget : forumWidget.render()
    });
    Sys.print(html);
  }

  @bTrigger("request_beluga_forum_add_channel_display")
  public static function _doDisplayAddChannelPage()
  {
    new ChannelTest(Beluga.getInstance()).doDisplayAddChannelPage();
  }

  public function doDisplayAddChannelPage()
  {
    var forumWidget = this.frm.getWidget("add_channel");
    forumWidget.context = this.frm.getAddChannelContext();

    var html = Renderer.renderDefault("page_forum_widget", "Add a Channel", {
      forumWidget : forumWidget.render()
    });
    Sys.print(html);
  }

  @bTrigger("request_beluga_forum_modify_channel_display")
  public static function _doDisplayModifyChannelPage()
  {
    new ChannelTest(Beluga.getInstance()).doDisplayModifyChannelPage();
  }

  public function doDisplayModifyChannelPage()
  {
    var forumWidget = this.frm.getWidget("modify_channel");
    forumWidget.context = this.frm.getModifyChannelContext();

    var html = Renderer.renderDefault("page_forum_widget", "Modify a Channel", {
      forumWidget : forumWidget.render()
    });
    Sys.print(html);
  }

  @bTrigger("request_beluga_forum_delete_channel_display")
  public static function _doDisplayDeleteChannelPage()
  {
    new ChannelTest(Beluga.getInstance()).doDisplayDeleteChannelPage();
  }

  public function doDisplayDeleteChannelPage()
  {
    var forumWidget = this.frm.getWidget("delete_channel");
    forumWidget.context = this.frm.getDeleteChannelContext();

    var html = Renderer.renderDefault("page_forum_widget", "Delete a Channel", {
      forumWidget : forumWidget.render()
    });
    Sys.print(html);
  }

  public function doDefault(d : Dispatch) {
    Web.setHeader("Content-Type", "text/plain");
    Sys.println("No action available for: " + d.parts[0]);
    Sys.println("Available actions are:");
    Sys.println("addChannel");
    Sys.println("modifyChannel");
    Sys.println("deleteChannel");
  }
}