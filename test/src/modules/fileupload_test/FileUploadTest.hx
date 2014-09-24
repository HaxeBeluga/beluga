// Copyright 2014 The Beluga Project Developers. See the LICENCE.md
// file at the top-level directory of this distribution and at
// http://haxebeluga.github.io/licence.html.
//
// Licensed under the MIT License.
// This file may not be copied, modified, or distributed
// except according to those terms.

package modules.fileupload_test;

// Beluga
import beluga.core.Beluga;
import beluga.core.Widget;
import beluga.module.fileupload.Fileupload;
import beluga.module.account.Account;
import beluga.module.notification.Notification;
import beluga.module.fileupload.FileUploadErrorKind;

// BelugaTest
import main_view.Renderer;

// haxe web
import haxe.web.Dispatch;
import haxe.Resource;

// Haxe PHP specific resource
#if php
import php.Web;
#end

class FileUploadTest {
    public var beluga(default, null) : Beluga;
    public var file_upload(default, null) : Fileupload;

    public function new(beluga : Beluga) {
        this.beluga = beluga;
        this.file_upload = beluga.getModuleInstance(Fileupload);
        this.file_upload.triggers.uploadFail.add(this.doFailUploadPage);
        this.file_upload.triggers.deleteSuccess.add(this.doAllPage);
        this.file_upload.triggers.deleteFail.add(this.doFailRemovePage);
        this.file_upload.triggers.uploadSuccess.add(this.doNotifyUploadSuccess);
        this.file_upload.triggers.addExtensionSuccess.add(this.doAdminPage);
        this.file_upload.triggers.deleteExtensionSuccess.add(this.doAdminPage);
        this.file_upload.triggers.addExtensionFail.add(this.doAdminPageFail);
        this.file_upload.triggers.deleteExtensionFail.add(this.doAdminPageFail);
    }

    public function doBrowsePage() {
        var html = Renderer.renderDefault("page_fileupload_widget", "Browse files", {
            context_message: "",
            browseWidget: file_upload.widgets.browse.render(),
            fileUploadWidget: ""
        });
        Sys.print(html);
    }

    public function doSendPage() {
        var html = Renderer.renderDefault("page_fileupload_widget", "Send file", {
            context_message: "",
            browseWidget: "",
            fileUploadWidget: file_upload.widgets.send.render()
        });
        Sys.print(html);
    }

    private function createErrorMsg(msg: String) {
        return "<div class=\"alert alert-danger alert-dismissable ticket-alert-error\">
                <strong>Error!</strong> " + msg + "</div>";
    }

    public function doFailRemovePage(args: { error: FileUploadErrorKind}) {
        var contextMsg = "fail remove";
        var browseWidget = "";
        var fileUploadWidget = "";
        var html = Renderer.renderDefault("page_fileupload_widget", "Default page Fail", {
            context_message: contextMsg,
            browseWidget: browseWidget,
            fileUploadWidget: fileUploadWidget
        });
        Sys.print(html);
    }

    public function doAllPage() {
        var contextMsg = "";
        var browseWidget = "";
        var fileUploadWidget = "";
        if (this.beluga.getModuleInstance(Account).isLogged) {
            contextMsg = "<h2>Gestion des fichiers de <strong>" + this.beluga.getModuleInstance(Account).loggedUser.login + "</strong></h2>";
            browseWidget = file_upload.widgets.browse.render();
            fileUploadWidget = file_upload.widgets.send.render();
        }
        var html = Renderer.renderDefault("page_fileupload_widget", "Default page", {
            context_message: contextMsg,
            browseWidget: browseWidget,
            fileUploadWidget: fileUploadWidget
        });
        Sys.print(html);
    }

    public function doDefault() {
        var contextMsg = this.createErrorMsg("Vous devez vous logger pour acceder a cette page !");
        var browseWidget = "";
        var fileUploadWidget = "";
        if (this.beluga.getModuleInstance(Account).isLogged) {
            contextMsg = "<h2>Gestion des fichiers de <strong>" + this.beluga.getModuleInstance(Account).loggedUser.login + "</strong></h2>";
            browseWidget = file_upload.widgets.browse.render();
            fileUploadWidget = file_upload.widgets.send.render();
        }
        var html = Renderer.renderDefault("page_fileupload_widget", "Default page", {
            context_message: contextMsg,
            browseWidget: browseWidget,
            fileUploadWidget: fileUploadWidget
        });
        Sys.print(html);
    }

    public function doAdminPage() {
        var contextMsg = this.createErrorMsg("Vous ne devriez pas etre ici!");
        var adminWidget = "";
        if (this.beluga.getModuleInstance(Account).isLogged) {
            contextMsg = "<h2>Manage authorized file extensions for file upload module</h2>";
            adminWidget = file_upload.widgets.admin.render();
        }
        var html = Renderer.renderDefault("page_fileupload_widget", "Admin page", {
            context_message: contextMsg,
            browseWidget: adminWidget,
            fileUploadWidget: ""
        });
        Sys.print(html);
    }

    public function doAdminPageFail(args: {error: FileUploadErrorKind}) {
        var contextMsg = this.createErrorMsg("Vous ne devriez pas etre ici!");
        var adminWidget = "";
        if (this.beluga.getModuleInstance(Account).isLogged) {
            contextMsg = "<h2>Manage authorized file extensions for file upload module</h2>";
            adminWidget = file_upload.widgets.admin.render();
        }
        var html = Renderer.renderDefault("page_fileupload_widget", "Admin page", {
            context_message: contextMsg,
            browseWidget: adminWidget,
            fileUploadWidget: ""
        });
        Sys.print(html);
    }


    public function doFailUploadPage(args: { error: FileUploadErrorKind }) {
        var contextMsg = this.createErrorMsg("Vous ne devriez pas etre ici!");
        var browseWidget = "";
        var fileUploadWidget = "";

        if (this.beluga.getModuleInstance(Account).isLogged) {
            contextMsg = "<h2>Manage authorized file extensions for file upload module</h2>" + this.createErrorMsg("fail upload");
            browseWidget = file_upload.widgets.browse.render();
            fileUploadWidget = file_upload.widgets.send.render();
        }

        var html = Renderer.renderDefault("page_fileupload_widget", "Admin page", {
            context_message: contextMsg,
            browseWidget: browseWidget,
            fileUploadWidget: fileUploadWidget
        });
        Sys.print(html);
    }

    public function doNotifyUploadSuccess() {
        // var notification = Beluga.getInstance().getModuleInstance(Notification);
        // notification.create(args);
        this.doAllPage();
    }
}