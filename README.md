Beluga
======

Main repository of the Haxe Beluga framework.

## Haxelib ##

Beluga will be part of haxelib, for that reason, please consider [this link](http://haxe.org/doc/haxelib/using_haxelib#creating-a-haxelib-package "haxelib") before any structure edition.

## Installation ##

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
	<install path="../../../lib/beluga/0,1/beluga">
	<!-- Relative to this file -->
		<templo bin="temploc2.exe" output="bin/views/" />
	</install>

	<!-- List of active modules -->
	<module name="account"/>
