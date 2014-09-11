How to have the project on the computer
==================================

You need to have :

* [git](http://git-scm.com/)
* [github](https://windows.github.com) appropriate to your OS
* [Haxe3](http://haxe.org/download)


**If you want to have *git* functional, look for the environement variables on your system and modify the variable **Path** adding this to the end :
« ;C:\Program Files (x86)\Git\cmd » (or any path if you changed the default one)**

![Variables d'environnement](http://imagizer.imageshack.us/v2/150x100q90/743/eG5CwO.jpg)

You also need to have :

* a web server (Apache)

**Tip : download the pack "wamp"**

* a database (MySQL)

Our project "Beluga" is actually hosted on github.
You can follow this link :
https://github.com/HaxeBeluga/Beluga

![Github](http://imagizer.imageshack.us/v2/150x100q90/913/3apqko.jpg)

To contribute, you have to **fork** the project and **clone** it on your desktop :

**Click on "fork" and choose your account.
Then go to the fork and click on "Clone in Desktop".
This will open github on your desktop and you will have to choose a path to install the cloned repository.**

How to contribute
===============

You have to integrate your modifications (new/change file/code) on the principal repository of Beluga and consequently, use **pull requests**.

For example, to add a file, you have to :

* Copy your file into your local repository
* Open a command line and type "git add file_name"
* Then type "git commit -m "description_of_the_commit" file_name"
* Finally type "git push origin BRANCHNAME"
* Go back to your fork on github and choose your branch
* Click on the button "Compare, review, create a pull request" to create a pull request that will be examinated !