Ticket module - documentation
=============================

The __ticket__ module allow you to create a fully autonomous widget to create, comment and manages yout ticket system on your platform.

To exploit the full power of the __ticket__ module you should use it with the __account__ module provided by __Beluga__. Indeed, the use of the account is automated inside the __ticket__ module.

This module offers a few numbers of method to easily integrate the widget inside your project.

Here is the list of methods:

```Haxe
public function browse(): Void
public function create(): Void
public function show(args: { id: Int }): Void
```

These functions are handle by the Beluga webdispatcher, and throw respectively these triggers:

* `beluga_ticket_show_browse`
* `beluga_ticket_show_create`
* `beluga_ticket_show_show`

which suggest to the developper to display the corresponding widget.

e.g, for a __Ticket__ instance `my_ticket`, `my_ticket.getWidget("browse");` can be use to retrieve the __ticket's__ `browse` widget when the `beluga_ticket_show_browse` trigger is found.

```Haxe
public function reopen(args: { id: Int }): Void
public function close(args: { id: Int }): Void
public function comment(args: { id: Int, message: String }): Void
```

These two methods are available to respectively reopen / close ore comment on an existing __ticket__, they are handle too by the __Beluga__ webdispatcher, or can be called directly from user code.

They take a unique parameter which is a Dynamic variable wich allow the function to be called by both beluga and the user of Beluga.

The parameter itself contains the identifier of the id to update.

```Haxe
public function submit(args: { title: String, message: String }): Void
```
This function is used to create a new ticket in the database. It can be called both by the user or directly by Beluga too.

It takes a Dynamic variable as param too, with a title and a message field, who are used to create the new Ticket.


These four previouse function, throw custome trigger to specify to the user that some data have been updated, then the user can choose to redirect to a new page to display the new changes.


```Haxe
public function getBrowseContext(): Dynamic
public function getCreateContext(): Dynamic
public function getShowContext(): Dynamic
```

Finally these function are use to get the information to fullfill the view of the __ticket__widget, they give respectively access the context for the `browse`, `create` and `show` widget.

Here is an example which show how to use them to fullfill a widget.

```Haxe
var ticket = Beluga.getInstance().getModuleInstance(Ticket); // Obtains an instance of Ticket from Beluga
var createWidget = ticket.getWidget("create"); // Get the create widget from the ticket module
createWidget.context = ticket.getCreateContext(); // Then fill the widget context using the appropriate method.
// now you just need to print your page.
```
