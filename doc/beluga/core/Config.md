# Configuration in module

# Config class
First you need to create a config class for your module. It needs to be available in js and other server target.
```haxe
class ModuleConfig
{

    public static var path = Config.autoCreateFile("/beluga/module_conf.json");

    public static var get = Config.get.bind(path, {
        //my default configuration
    });

}
```
#PHP target
Then in php target you can get your configuration as follow:
```haxe
  var config = AccountConfig.get();
```

#Js target
And in js target you can get your configuration as follow:
```haxe
  AccountConfig.get(function (conf : Dynamic) {
    //Use your config !
  });
```
