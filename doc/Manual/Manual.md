# Beluga

Hello everyone ! Welcome to the Beluga Manual. This will introduce you to our "Beluga" project and you will learn how to handle it.

First, I will present the project and give you some details to retrieve, modify and test it from your machine. Then, I will show you a few things to program in **Haxe** - because our project was done with this language - and talk about some technical terms.

## What is Beluga ?

Beluga is a framework for browsers (like *Internet Explorer*, *Mozilla Firefox* or *Google Chrome*).

## But what is a framework ?

A framework is a set of structural software components (we will call them **modules**) used to create the software environment. A framework is a universal, reusable software environment that provides particular functionality as part of a larger software platform to facilitate development of software applications, products and solutions.

So Beluga is a framework that will create different modules (forum, market, tickets to contact support, account to login / logout, mails, news ...) around a web application (browser application).

It is **open source**, that means everyone can access to the source code of the project. An average user will not necessarily be interested contrary to a developer.

As I said before, the project was done with the Haxe language.

## Recovery of the project and contribution

See the tutorial : https://github.com/FassiClement/Beluga/blob/documentation/doc/Manual/Tutorial_Recover.md

## Modules

https://github.com/regnarock/Beluga/blob/doc/create_module/doc/03-Module.md

## Hello World

The following program prints "Hello World" after being compiled and run :

>     class HelloWorld {
>      static public function main():Void {
>       trace("Hello World");
>      }
>     }

This can be tested by saving the above code to a file named *HelloWorld.hx* and invoking the Haxe Compiler like so : *haxe -main HelloWorld --interp*. It then generates the following output:

>     HelloWorld.hx:3: Hello world.

There are several things to learn from this :

* Haxe programs are saved in files with an extension of *.hx*.
* The Haxe Compiler is a command-line tool which can be invoked with parameters such as *-main HelloWorld and --interp*.
* Haxe programs have classes (HelloWorld, upper-case), which have functions (main, lower-case).

## Technical Part