# Getting Started

## Prerequisite

* haxe 3.1.3
* mysql
* php
* apache
* git

## Beluga installation

To install beluga simply run this command:
> haxelib git beluga https://github.com/HaxeBeluga/Beluga

## Generate project
To generate a default working project run:
> haxelib run beluga setup_project TestProject

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
You need to edit beluga.xml cofiguration file to set your database configuration.

## Run project
Compile haxe by running
