How to have the project on the computer
==================================

You need to have :

* [git](http://git-scm.com/)
* [github](https://windows.github.com) appropriate to your OS
* [Haxe3](http://haxe.org/download)


*If you want to have *git* functional, look for the environement variables on your system and modify the variable **Path** adding this to the end :
« ;C:\Program Files (x86)\Git\cmd » (or any path if you changed the default one)*

![Environement variables](http://img4.hostingpics.net/pics/996143Variablesenvironnement.jpg)

You also need to have :

* a web server (Apache)

**Tip : download the pack "Wamp" if you use Windows or "Mamp" if you use MAC OSX for example**

* a database (MySQL)

Our project "Beluga" is actually hosted by Github.
You can follow this link :
https://github.com/HaxeBeluga/Beluga

To contribute, you have to **fork** the project and **clone** it on your desktop computer :

![Buttons](http://img4.hostingpics.net/pics/438065Github.jpg)

*Click on "fork" and choose your account.
Then go to the fork and click on "Clone in Desktop".
This will open github on your desktop computer and you will have to choose a path to install the cloned repository.*

How to contribute
===============

You have to integrate your modifications (new/change file/code) on the principal repository of Beluga and consequently, use **pull requests**.
For sure, don't do it if you didn't test your files before.

For example, to add a file, you have to :

* Copy your file into your local repository
* Open a command line and type "git add file_name"
* Then type "git commit -m "description_of_the_commit" file_name"
* Finally type "git push origin YOUR_LOCAL_BRANCHNAME"
* Go back to your fork on github and choose your local branch
* Click on the button "Compare, review, create a pull request" to create a pull request that will be examinated.

![Button to create a PR](http://img4.hostingpics.net/pics/33405076PR.jpg)

It is necessary to choose a base fork and a head fork for the comparison :

The head fork has to be *your_account/your_fork* and the branch has to be *your_local_branch*.

The base fork has to be *HaxeBeluga/Beluga* and the branch has to be the **dev** branch (not the master).

![Repository](http://img4.hostingpics.net/pics/839284ForkPR.jpg)