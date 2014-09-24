# Module

In here we will go throughout everything that covers the modules of Beluga. First, we will see what they _are_ and how they are organized. Then, we will look at how they integrate inside Beluga. Once this will be covered, we will learn how to add your owns.

## Prerequisites

Before starting this tutorial, you need to make sure you have a proper Beluga setup and you know how to use it: [getting started](01-Getting%20started.md#first-use).

## Structure

In Beluga, we chose to make it easier for developers to add modules. For this reason, we follow the _convention over configuration_ paradigm and we try to make it as simple as possible to implement new modules. Concretly, it means some folders, files and functions are needed for beluga to recognize modules and load them. Furthermore, we try to follow a very strict convention to make it easier to go from a module to another. To help you make the difference between simple convention and _necessary_ convention, required things will be preceed by a strong typed **word**.

The only inconvenient is that it makes it harder, at first, to find why your new module is not recognized by Beluga. To solve this, we made a [script](#add-your-own-module) to generate new modules automaticaly. 

### Filesystem

Modules can be found under the `beluga/module` folder. They **have** to respect the following minimum folder organisation since they are required for Beluga to load and use them properly.

``` 
module_root/
│
│─── api/          : API used by Beluga dispatcher
│─── js/           : Javascript files
│─── locale/       : JSon files for localization 
│─── view/         : All files related to the html output
     │─── css/
     │─── js/
     │─── locale/
     └─── tpl/
└─── widget/       : Widgets class files
```
Other commonly used folders, like `exception` and `model`, are purely esthetical.

### Folder content walkthrough

#### Module root

At the root of the module, **must** be exposed its interface (simply named with the module name) and its implementation (name + Impl). Those two files **must** respectively extend `Module` and `ModuleImpl`.
e.g.:
```
    interface Account extends Module {}
    [...]
    class AccountImpl extends ModuleImpl {}
```
Your module _should_ also provide two container classes:
- name + Triggers: contains all triggers that can be dispatched
- name + Widgets: contains all widgets provided

Those two classes are then exposed publicaly from the interface, e.g.:
```
interface Account extends Module {
    public var triggers : AccountTrigger;
    public var widgets : AccountWidget;
}
[...]
// Then widgets and triggers are easily and logicaly accessible through:
beluga.getModuleInstance(Account).widgets.loginForm
```

#### Api

In the `api` folder, there **must** be a file providing an api for the dispatcher of Beluga (named with module name + Api). Since it _is_ a web api file, redirecting function **must** begin with "do" (see [Haxe Web Dispatcher](http://old.haxe.org/manual/dispatch#why-actions-are-prefixed-with-do)). 

#### Js

#### Locale

#### View

#### Widget

## Mecanisms

### Triggers

### Widget

### Errors

//TODO: speak about enums + triggers

## Add your own module
