#Settings

Here we are gonna focus on beluga.xml configuration file. All the available tag are listed here.

##module
```html
<module name="modulename"/>
```

##database
```html
<database>
  <host>localhost</host>
	<port>3306</port>
	<user>root</user>
	<pass>root</pass>
	<database>belugaTest</database>
</database>
```

##include
```html
<include path="config/myconfig.xml" />
```

##url
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

