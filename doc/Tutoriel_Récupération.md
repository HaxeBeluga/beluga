Comment récupérer le projet
========================

Il vous faudra tout d'abord des outils :

* un client [git](http://git-scm.com/)
* un client [github](https://windows.github.com) approprié à votre OS (Windows, Linux ...)
* [Haxe3](http://haxe.org/download)

*Pour que le client git soit fonctionnel, recherchez les variables d’environnement de votre système avec la fonction *recherche* et modifiez la variable **Path** en ajoutant ceci à la fin :
« ;C:\Program Files (x86)\Git\cmd » (ou le chemin d’installation de git si vous ne l’avez pas laissé par défaut)*

![Environement variables](C:\Users\UTILISATEUR\Pictures\Beluga\Tutoriels\Variables_environnement.jpg)

Il vous faudra d'autres outils pour faire des tests :

* un serveur web (comme Apache)

*Je vous conseille de télécharger un pack comme "Wamp" (pour Windows), "Samp" (pour Solaris), "Lama" (pour Linux) ou "Mamp" (pour Mac OSX) qui contient principalement le serveur Apache ainsi que la base de données MySQL qui est aussi un requis.*

* une base de données « MySQL »

*(allez sur http://dev.mysql.com/downloads/windows/ et cliquez sur « MySQL Installer » pour les utilisateurs de Windows par exemple)*

Notre projet « Beluga » est actuellement hébergé sur Github, accessible à l’adresse suivante: https://github.com/HaxeBeluga/Beluga

Pour contribuer, il vous faut donc **forker** (faire une copie pour vous) le projet et le **cloner** sur votre poste de travail :

![Buttons](C:\Users\UTILISATEUR\Pictures\Beluga\Tutoriels\Github.jpg)

*Pour cela, cliquez sur l’option « Fork » en haut à droite de la page web et choisissez votre compte.
Allez ensuite sur le fork et cliquez sur « Clone in Desktop ». Cela va ouvrir votre client Github et vous demander l’endroit où installer le dépôt cloné.*

Comment contribuer
=================


Ensuite il faut intégrer vos modifications (ajout/modification de fichier/code) sur le dépôt principal de Beluga et donc utiliser les **pull requests**.
Bien sûr, inutile de proposer des fichiers de code non testés.

Par exemple pour ajouter un fichier, voici la marche à suivre :
* Copiez votre fichier dans votre dépôt local
* Ouvrez une ligne de commande et tapez "git add nom_du_fichier"
* Tapez ensuite "git commit -m "description_du_commit" nom_du_fichier"
* Tapez enfin "git push origin nom_de_votre_branche_locale_de_travail"
* Allez sur votre fork sur github et choississez votre branche de travail
* Cliquez sur le bouton à droite nommé "Compare, review, create a pull request" pour créer votre pull request qui sera ensuite examiné et validé/refusé !

![Button to create a PR](C:\Users\UTILISATEUR\Pictures\Beluga\Tutoriels\PR.jpg)

Vous devez choisir un répertoire de base et un répertoire de destination quand vous créez votre *pull request*.

Le répertoire de base sera votre fork sur github et la branche associée sera celle où vous travaillez en local.

Le répertoire de destination sera *HaxeBeluga/Beluga* et la branche associée sera la branche **dev** (et surtout pas la branche master).

![Repository](C:\Users\UTILISATEUR\Pictures\Beluga\Tutoriels\Fork_PR.jpg)