#Settings

Here we are gonna focuse on the beluga.xml configuration file. All the available tag are listed here.

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

