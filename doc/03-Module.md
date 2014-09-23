@(Beluga)[create_module]

# Module

In here we will go throughout everything that covers the modules of Beluga. First, we will see what they _are_ and how they organize themseves. Then, we will look at how they integrate inside Beluga. Once this will be covered, we will learn how to add 

## Prerequisites

Before starting this tutorial, you need to make sure you have a proper Beluga setup and you know how to use it: [getting started](01-Getting%20started.md#first-use).

## Structure

### Filesystem

Modules can be found under the `beluga/module` folder. They **have** to respect the following folder organisation since some are required for Beluga to load and use them properly.

``` 
module_root
|
|---api       : `required` contains the file used by 
|---exception : `optional`
|---js        : `required`
|---locale    : `required`
|---model     : `optional`
|---view      : `optional`
     |---css
     |---js
     |---locale
     |---tpl
|---widget    : `required`
```
