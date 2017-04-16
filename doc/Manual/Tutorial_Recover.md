## How to have the project on your computer

Here are the steps to get our project from the website where it is hosted (github.com) to put it on your computer, in **local**.

There are several methods and I will present one that requires a *github* client because it is a good tool and it will help you to become familiar with command lines which you have to know (do not use the GUI) :

First, you will need to download some tools :

* [git](http://git-scm.com/)
* [github](https://windows.github.com) appropriate to your OS (Windows, Linux ...)
* [Haxe3](http://haxe.org/download) --> *I remind you that it is the basic computer programming language of our project*


*If you want to have git functional, look for the environment variables on your system and modify the variable "Path" adding this to the end :*

> ;C:\Program Files (x86)\Git\cmd

*(or any path if you changed the default one)*

![Environment variables](img/Variables_environnement.jpg)

Then, you will have to download some other tools if you plan to test the project :

* a web server (Apache)

*Tip : you can donload some packs like "Wamp" (for Windows), "Samp" (for Solaris), "Lama" (for Linux) or "Mamp" (for Mac OSX) mainly constituting of Apache and MySQL that you will need too (see below).*

* a database (MySQL)

*You have not to download it if you dowloaded a pack in the step before this one.*

Our project "Beluga" is actually hosted by Github.
You can follow this link :
https://github.com/HaxeBeluga/Beluga

To contribute, you have to **fork** the project (copy it) and **clone** it on your desktop computer (to be available in **local**) :

![Buttons](img\Github.jpg)

*To do that, click on "fork" (top right on the web site) and choose your account (that you need to create if you did not have one before, it is easy, fast and free !).
Then go to the fork (https://github.com/your_account_name/Beluga) and click on "Clone in Desktop".
This will open github on your desktop computer and you will have to choose a path to install the cloned repository.*

Finished, you have now the project on your machine (in **local**) !

## How to contribute

To contribute, you have to integrate your modifications (new/change file/code) on the principal repository of Beluga and consequently, use **pull requests**.
For sure, don't do it if you didn't test your files before.

For example, to add a file using a "pull request", you have to :

* Copy your file into your local repository.
* Open a command line and type

> git add file_name

* Then type

> git commit -m "description_of_the_changes"

* Finally type

> git push origin YOUR_LOCAL_BRANCHNAME

(that you had to create in order to work on your personnal repository)
* After entering the name of your account and your password for github, go back to your fork on github and choose your local branch.
* Click on the button "Compare, review, create a pull request" to create a pull request that will be accepted/refused by our team !

![Button to create a PR](img\PR.jpg)

When you create a **pull request**, it is necessary to choose a base fork and a head fork for the comparison :

The head fork has to be *your_account/your_fork* and the branch has to be *your_local_branch* (that it is in **local**.

The base fork has to be *HaxeBeluga/Beluga* and the branch has to be the **master** branch.

![Repository](img\Fork_PR.jpg)