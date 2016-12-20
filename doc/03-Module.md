@(Beluga)[ModuleDoc, En]
# Module

In here we will go throughout everything that covers the modules of Beluga. First, we will see what they _are_ and _how_ they are organized. Then, we will look at how they integrate inside Beluga. Once this will be covered, we will learn how to add your owns.

## Philosophy

Modules, in Beluga, are the containers of the features the developer wants to provide his users. Those features are grouped around their dependency.
>  **e.g:** The two functionnalities `login user` and `register user` are gathered in the `account`module.

This modular structure allows developers to always compile with the slightiest Beluga sources possible. As only used modules are detected and compiled within your modules.

## Prerequisites

Before starting this tutorial, you need to make sure you have a proper Beluga setup and you know how to use it: [getting started](01-Getting%20started.md#first-use).

## Structure

In Beluga, we chose to make it easier for developers to add modules. For this reason, we follow the _convention over configuration_ paradigm. Concretly, it means some folders, files and functions are needed for beluga to recognize modules and load them. Furthermore, we try to follow a very strict convention to make it easier to go from a module to another. To help you make the difference between *simple* convention and _necessary_ convention, required things will be preceed by a strong typed **word**.

> **Note**: the only inconvenient is that it makes it harder, at first, to find why your new module is not recognized by Beluga. To solve this, we made a [script](#add-your-own-module) and integrated it to the haxelib access command in order to generate new modules automaticaly.

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

Here, every module **must** provide 

#### Locale

#### View

All content relatives to the different widgets contained in each module is *usually* placed in in the `view` folder
- `css`: all css files.
- `locale`: all language files (regarding only widgets)
- `tpl`: all template(.mtt) files describing each widget's html.

#### Widget

## Mecanisms

### Triggers

### Widget

### Errors

When errors are raised inside module are all handled the same way. They are brought back to the developer using both the trigger system and the language system. Instead of entirely breaking his website with an exception or force him to have a heavy try/catch code everywhere.
Once captured, those triggers give a `enum` code corresponding to the error. This `enum` is *usually* named: name of module + "Error" + "Kind".
All modules *should* also provide a method allowing the developer to turn this `enum` into a human readable `string`.
*e.g.:*

```haxe
    private function getErrorString(error: ModuleErrorKind): String {
        return switch (error) {
            case ErrorTrigger1: BelugaI18n.getKey(i18n, "erreur1");
    }
```
## Add your own module

Beluga also provide a neko binary (run.n) allowing it's integration within `haxelib`. This tool provide, amongs other things, a way to entirely generate a module with all minimal requirements and default architecture.
It can be used thw following way:

> haxeliv run beluga create_module "module_name"

It will meet all minimal requirements explained throughouth this file and will install the newly created module directly under `beluga/module` folder.