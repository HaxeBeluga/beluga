Beluga
======

Beluga is a framework helping the creation of browser game websites. Based on Haxe technology, it allows any developer to define the environment of its project.

Acting as a toolbox, Beluga provides different services such as account system, forum, guild, market, survey and so on. Absolutely non-intrusive, the developer is free to choose and use any of them which suits the best to her/his needs. Moreover, Beluga offers a flexible and modular API allowing the developer to add her/his own services.

Beluga is also open-source and communal, contributors are encouraged to participate to its development. Then, thanks to its powerful architecture, developers have the opportunity to contributes without removing the compatibility with previous versions of the project.

## Projects using it ##

* [Dominax](https://github.com/HaxeBeluga/Dominax "dominax")

## Travis status ##

[![Build Status](https://travis-ci.org/HaxeBeluga/Beluga.png?branch=master)](https://travis-ci.org/HaxeBeluga/Beluga)

## Installation ##

To install this library from github, you just need to run `haxelib git beluga https://github.com/HaxeBeluga/Beluga`

> Note: If you were to use Beluga as a contributor, you need to run the following command `haxelib dev beluga $HAXE_HOME/lib/beluga/git`
> 
> Haxelib can complain that beluga dev version is not installed. If so, you must edit the `.dev` file under `$HAXE_HOME/lib/beluga` and remove the trailing slash

## Project setup ##

To setup a new project, you can use the tool provided with haxelib.

`haxelib run beluga setup project_name`

You can get more tool's commands with `haxelib run beluga help`

## Supported platforms ##

The following targets are currently supported

* Php
* Neko

### Credits ###
Thanks to [Jonathan Pellen](http://fr.viadeo.com/fr/profile/jonathan.pellen) for our wonderful logo.
