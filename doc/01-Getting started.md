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

##Source code Analysis

```haxe
var beluga = Beluga.getInstance();//1
Dispatch.run(beluga.getDispatchUri(), Web.getParams(), beluga.api);//2
Sys.print(beluga.getModuleInstance(Account).widgets.loginForm.render());//3
beluga.cleanup();//4
```
1. First we get a beluga instance
2. Dispatch the request to beluga. Handle widget post request
3. Print your widget
4. Because destructor don't exist in haxe a cleanup fonction is required


