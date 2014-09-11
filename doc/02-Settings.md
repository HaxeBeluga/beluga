#Settings

Here we are gonna focus on beluga.xml configuration file. It has to be in your project root folder.

##Tags
All available tag are listed here.

###module

If you want to use a module you need to declare it here. It's required to properly initialize the module, like generating its entry in the Beluga api.
```html
<module name="modulename"/>
```

###database

You can specify your database configuration here. Beluga support only mysql for now.
```html
<database>
  	<host>localhost</host>
	<port>3306</port>
	<user>root</user>
	<pass>root</pass>
	<database>belugaTest</database>
</database>
```

###include

You may want to split your configuration file, for this you can use the include tag.

```html
<include path="config/myconfig.xml" />
```

###url

Beluga use default url to call action exemple "/beluga/mymodule/myaction", but sometimes you need to add a prefix to it to make it working properly, for exemple when your compiled project is in a subfolder of your web server document root.
You can configure this prefix with the base url configuration.
```html
<url>
	<base value="/mysubfolder/"/>
</url>
```

##Conditional configuration
You can specify a configuration for each different haxe target (php and neko for now).
On any tag put the attribut "if" and the value corresponding to the target.

exemple:
```html
<url>
	<base value="/myphpfolder/" if="php" />
	<base value="/mynekofolder/" if="neko" />
</url>
```
or even:
```html
<url if="php">
	<base value="/myphpfolder/"  />
</url>
<url  if="neko">
	<base value="/mynekofolder/" />
</url>
```
**Warning**: If several same configuration exist the first one is concidered

