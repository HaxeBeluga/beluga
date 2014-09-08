# Getting Started

## Prerequisite

* haxe 3.1.3
* mysql
* php
* apache
* git

## Beluga installation

To install beluga simply run this command:
```Shell
> haxelib git beluga https://github.com/HaxeBeluga/Beluga
```

## Generate project
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

## Configure project
You need to edit beluga.xml file to set your database configuration.

## Run project
Compile haxe by running from inside TestProject folder:
```Shell
> haxe TestSetupProject.hxml
```

Point your document root to TestProject/bin folder

You can now access to your website with a working login form !
