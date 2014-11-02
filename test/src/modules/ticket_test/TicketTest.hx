// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.ticket_test;

// Beluga
import beluga.Beluga;
import beluga.module.ticket.Ticket;
import beluga.module.notification.Notification;
import beluga.module.ticket.TicketErrorKind;

// BelugaTest
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class TicketTest {
    public var beluga(default, null) : Beluga;
    public var ticket(default, null) : Ticket;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.ticket = beluga.getModuleInstance(Ticket);
        this.ticket.triggers.show.add(this.doShowPage);
        this.ticket.triggers.create.add(this.doCreatePage);
        this.ticket.triggers.browse.add(this.doBrowsePage);
        this.ticket.triggers.admin.add(this.doAdminPage);
        this.ticket.triggers.addLabelSuccess.add(this.doAdminPage);
        this.ticket.triggers.deleteLabelSuccess.add(this.doAdminPage);
        this.ticket.triggers.addLabelFail.add(this.doAdminFailPage);
        this.ticket.triggers.deleteLabelFail.add(this.doAdminFailPage);
        this.ticket.triggers.assignNotify.add(this.doNotifyAssign);
        this.ticket.triggers.submitFail.add(this.doSubmitFailPage);
        this.ticket.triggers.submitSuccess.add(this.doSubmitSuccessPage);
        this.ticket.triggers.commentFail.add(this.doCommentFailPage);
        this.ticket.triggers.commentSuccess.add(this.doCommentSuccessPage);
    }

    public function doBrowsePage() {
        var html = Renderer.renderDefault("page_ticket_widget", "Browse tickets", {
            ticketWidget: ticket.widgets.browse.render()
        });
        Sys.print(html);
    }

    public function doCreatePage() {
        var html = Renderer.renderDefault("page_ticket_widget", "Create tickets", {
            ticketWidget: ticket.widgets.create.render()
        });
        Sys.print(html);
    }

    public function doShowPage() {
        var html = Renderer.renderDefault("page_ticket_widget", "Show ticket", {
            ticketWidget: ticket.widgets.show.render()
        });
        Sys.print(html);
    }

    public function doDefault(d : Dispatch) {
        Web.setHeader("Content-Type", "text/plain");
        Sys.println("No action available for: " + d.parts[0]);
        Sys.println("Available actions are:");
        Sys.println("browsePage");
        Sys.println("createPage");
        Sys.println("showPage");
    }

    public function doAdminPage() {
        var html = Renderer.renderDefault("page_ticket_widget", "Admin page", {
            ticketWidget: ticket.widgets.admin.render()
        });
        Sys.print(html);
    }

    public function doAdminFailPage(args: {error: TicketErrorKind}) {
        this.doAdminPage();
    }

    public function doCommentFailPage(args: {error: TicketErrorKind}) {
        this.doShowPage();
    }

    public function doSubmitFailPage(args: {error: TicketErrorKind}) {
        this.doCreatePage();
    }

    public function doCommentSuccessPage(args: {id: Int}) {
        this.doShowPage();
    }

    public function doSubmitSuccessPage(args: {id: Int}) {
        this.doShowPage();
    }

    public function doNotifyAssign(args : {title : String, text : String, user_id: Int}) {
        var notification = Beluga.getInstance().getModuleInstance(Notification);
        notification.create(args);
    }
}