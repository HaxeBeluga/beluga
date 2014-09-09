# Getting Started

##First use

### Prerequisite
You should have those following program already installed on your computer:
* haxe 3.1.3
* mysql
* php
* apache
* git

### Beluga installation

To install beluga simply run this command:
```Shell
> haxelib git beluga https://github.com/HaxeBeluga/Beluga
```

### Generate project
To generate a default working project run:
```Shell
> haxelib run beluga setup_project TestProject
```

Several files are generated:
```
TestProject
|
│───.htaccess : Default htaccess
│───beluga.xml : Beluga configuration file
│───TestSetupProject.hxml : Haxe compilation file
│
└───src
     |───Main.hx : Program entry point
```

### Configure project
You need to edit beluga.xml file to set your database configuration.
```
<database>
	<host>localhost</host>
	<!-- <port></port> -->
	<user>root</user>
	<pass></pass>
	<database>belugaTest</database>
</database>
```

In mysql create a database called "belugaTest"

### Run project
Compile haxe by running from inside TestProject folder:
```Shell
> haxe TestSetupProject.hxml
```

- Point your document root to TestProject/bin folder
- Don't forget to activate the apache module rewrite.
- And put the provided .htaccess into the bin folder.

You can now access to your website with a working login form !

##Source code analysis

Open the src/Main.hx

```haxe
var beluga = Beluga.getInstance();//1
Dispatch.run(beluga.getDispatchUri(), Web.getParams(), beluga.api);//2
Sys.print(beluga.getModuleInstance(Account).widgets.loginForm.render());//3
beluga.cleanup();//4
```
1. First we get a beluga instance
2. Dispatch the request to beluga. This is where beluga handle widget all post request and all the data is processed.
3. Print your widget. The widget change according to what happened when the request is dispatched in beluga.
4. Because destructor don't exist in haxe a cleanup fonction is required

##Display custom page on login fail/success
To customize your application beluga provide a trigger system. Each module as a list of trigger. When the request is dispatch to beluga several trigger may be dispatch.

For exemple we are gonna configure the application to display a custom page when the user is logged. The application must be configured before the dispatch.
```
var beluga = Beluga.getInstance();
var acc = beluga.getModuleInstance(Account);

acc.triggers.loginSuccess.add(function() {
	trace("You are successfully logged !");
});

Dispatch.run(beluga.getDispatchUri(), Web.getParams(), beluga.api);

Sys.print(acc.widgets.loginForm.render());

beluga.cleanup();

```

but the widget always display, so a simple solution is to use a boolean to see if the default page must display.
```
var beluga = Beluga.getInstance();
var acc = beluga.getModuleInstance(Account);
var defaultPage = true;
acc.triggers.loginSuccess.add(function() {
	trace("You are successfully logged !");
	defaultPage = false;
});
Dispatch.run(beluga.getDispatchUri(), Web.getParams(), beluga.api);
if (defaultPage) {
	Sys.print(acc.widgets.loginForm.render());		
}
beluga.cleanup();
```

Now if you successfully log in your message is displayed instead of the widget.

You've now learned the basis of how to use beluga.
