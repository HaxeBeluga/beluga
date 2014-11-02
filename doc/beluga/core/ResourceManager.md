#Resouces manager
The ResourceManager class was created in order to make easier haxe.Resource usage.

###Usage
First you need to register your file. It causes at compilation time your file will be added to resources if not already done. The function also return an id auto-generated from the path given.
```haxe
var resource_id = ResourceManager.register("mybelugafile.mtt");
```

Then you can get the content from several way:

Thanks to the path
```haxe
var myfilecontent = ResourceManager.dynGetStringFromPath("mybelugafile.mtt");
```

Or Thanks to the id
```haxe
var myfilecontent2 = ResourceManager.dynGetStringFromId(resource_id);
```

You better use id because *ResourceManager.dynGetStringFromPath("mybelugafile.mtt")* is just an equivalent to 
*ResourceManager.dynGetStringFromId(getId("mybelugafile.mtt"))*

###Shorcut
If you dont want to worry about registering you can also use:
```haxe
var myfilecontent = ResourceManager.getString("mybelugafile.mtt");
```
It will automaticly register the file and then return its content.

###Content types

The file content can be returned as different type.

The Basic one provided by haxe.Resource:
```haxe
var myfilecontent : String = ResourceManager.getString("mybelugafile.mtt");
var myfilecontent : Bytes = ResourceManager.getBytes("mybelugafile.mtt");
```

But also as haxe.Template object:
```haxe
var myfilecontent : Template = ResourceManager.getTpl("mybelugafile.mtt");
```
