Beluga
======

Main repository of the Haxe Beluga framework.

### [Beluga demo](https://github.com/HaxeBeluga/BelugaDemo "belugademo") ###

## Travis status ##

[![Build Status](https://travis-ci.org/HaxeBeluga/Beluga.png?branch=master)](https://travis-ci.org/HaxeBeluga/Beluga)

## Haxelib ##

Beluga will be part of haxelib, for that reason, please consider [this link](http://haxe.org/doc/haxelib/using_haxelib#creating-a-haxelib-package "haxelib") before any structure edition.

## Installation ##

To install this library from github, you just need to run `haxelib git https://github.com/HaxeBeluga/Beluga`

> Note: If you are to use Beluga as a contributor, you need to `haxelib dev beluga $HAXE_HOME/lib/beluga/git`
> Haxelib can complain that beluga dev version is not install. If so, you must edit the `.dev` file under `$HAME_HOME/lib/beluga` and remove the trailing slash

To install this library from source, take the following steps :

1. Clone or download this repository
2. Using command line, type `haxelib convertxml beluga.xml` from projet folder
3. Create a .zip archive containing the following <br />
	`/beluga`<br />
	`/beluga.json`
4. Run the command `haxelib local beluga.zip`

> Note: Beluga is not an official haxelib repository yet, that's why installation is painfull. It will be part of haxelib repositories when it will be publicly released.

## Dependencies ##

Beluga highly depends on [templo](http://haxe.org/com/libs/mtwin/templo "templo") library (which will be automaticly installed) and [hss](http://ncannasse.fr/projects/hss "hss")

It is necessary to provide both hss and templo executable to Beluga in your project folder.

## Project setup ##

To set up a new project, you just have to include `-lib beluga` to your project compilation.

### Beluga.xml ###

The only requirement is a file called beluga.xml in your project's root folder.

It must contains (at least) the following


	<!-- Beluga general config -->

	<!-- List of active modules -->
	<module name="account"/>


### Credits ###
Thanks to Jonathan Pellet for our wonderful logo.
